import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hyy_drop/core/network/chat/chat_models.dart';
import 'package:hyy_drop/core/network/chat/chat_provider.dart';
import 'package:hyy_drop/core/network/common/lan_peer.dart';
import 'package:hyy_drop/core/network/common/net_ports.dart';
import 'package:hyy_drop/core/network/discovery/discovery_models.dart';
import 'package:hyy_drop/core/network/discovery/discovery_provider.dart';
import 'package:hyy_drop/core/network/transfer/transfer_models.dart';
import 'package:hyy_drop/core/network/transfer/transfer_provider.dart';
import 'package:hyy_drop/core/router/app_router.gr.dart';
import 'package:hyy_drop/core/sentence/sentence.dart';
import 'package:hyy_drop/core/theme/app_theme_extension.dart';
import 'package:hyy_drop/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

@RoutePage()
class DevicesPage extends ConsumerStatefulWidget {
  const DevicesPage({super.key});

  @override
  ConsumerState<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends ConsumerState<DevicesPage> {
  String? _selectedPeerId;
  String? _openedPeerId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chatAsync = ref.watch(chatHubProvider);
    final discoveryAsync = ref.watch(discoveryHubProvider);
    final transferAsync = ref.watch(transferHubProvider);
    final peers = _mergePeers(
      discoveryAsync.asData?.value.peers ?? const [],
      chatAsync.asData?.value.messages ?? const [],
      transferAsync.asData?.value.tasks ?? const [],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 980;
        final activePeer = _resolveActivePeer(peers, isWide: isWide);
        _syncChatPeer(activePeer);
        final isDark = theme.brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF111B21)
              : const Color(0xFFEDEDED),
          body: SafeArea(
            child: isWide
                ? Row(
                    children: [
                      SizedBox(
                        width: 350,
                        child: _PeerRail(
                          peers: peers,
                          selectedPeerId: activePeer?.id,
                          discoveryAsync: discoveryAsync,
                          transferAsync: transferAsync,
                          onSelect: _selectPeer,
                          onProbe: _probe,
                          onSettings: _openSettings,
                        ),
                      ),
                      VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : const Color(0xFFD8D8D8),
                      ),
                      Expanded(
                        child: _ChatStage(
                          peer: activePeer,
                          link: activePeer == null
                              ? null
                              : _linkFor(
                                  chatAsync.asData?.value.links ?? const [],
                                  activePeer.id,
                                ),
                          messages: activePeer == null
                              ? const []
                              : _messagesFor(
                                  chatAsync.asData?.value.messages ?? const [],
                                  activePeer.id,
                                ),
                          tasks: activePeer == null
                              ? const []
                              : _tasksFor(
                                  transferAsync.asData?.value.tasks ?? const [],
                                  activePeer.id,
                                ),
                          chatAsync: chatAsync,
                          transferAsync: transferAsync,
                          onSend: activePeer == null
                              ? null
                              : () => _sendTo(activePeer),
                          onSendText: activePeer == null
                              ? null
                              : (text) => _sendTextTo(activePeer, text),
                        ),
                      ),
                    ],
                  )
                : activePeer == null
                ? _PeerRail(
                    peers: peers,
                    selectedPeerId: null,
                    discoveryAsync: discoveryAsync,
                    transferAsync: transferAsync,
                    onSelect: _selectPeer,
                    onProbe: _probe,
                    onSettings: _openSettings,
                  )
                : _ChatStage(
                    peer: activePeer,
                    link: _linkFor(
                      chatAsync.asData?.value.links ?? const [],
                      activePeer.id,
                    ),
                    messages: _messagesFor(
                      chatAsync.asData?.value.messages ?? const [],
                      activePeer.id,
                    ),
                    tasks: _tasksFor(
                      transferAsync.asData?.value.tasks ?? const [],
                      activePeer.id,
                    ),
                    chatAsync: chatAsync,
                    transferAsync: transferAsync,
                    onBack: _clearSelection,
                    onSend: () => _sendTo(activePeer),
                    onSendText: (text) => _sendTextTo(activePeer, text),
                  ),
          ),
        );
      },
    );
  }

  _PeerItem? _resolveActivePeer(List<_PeerItem> peers, {required bool isWide}) {
    if (peers.isEmpty) {
      return null;
    }

    if (_selectedPeerId != null) {
      for (final peer in peers) {
        if (peer.id == _selectedPeerId) {
          return peer;
        }
      }
    }

    return isWide ? peers.first : null;
  }

  void _selectPeer(String peerId) {
    setState(() {
      _selectedPeerId = peerId;
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedPeerId = null;
    });
  }

  Future<void> _probe() async {
    await ref.read(discoveryHubProvider.notifier).probe();
  }

  Future<void> _openSettings() async {
    await context.pushRoute(const SettingsRoute());
  }

  void _syncChatPeer(_PeerItem? peer) {
    if (peer == null || _openedPeerId == peer.id) {
      return;
    }

    _openedPeerId = peer.id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      ref.read(chatHubProvider.notifier).open(peer.toLanPeer());
    });
  }

  Future<void> _sendTo(_PeerItem peer) async {
    final l10n = AppLocalizations.of(context)!;
    final path = await _askFilePath(context, l10n);
    if (!mounted || path == null || path.isEmpty) {
      return;
    }

    final file = File(path);
    if (!await file.exists()) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.pathRequiredMessage)));
      return;
    }

    final taskId = ref
        .read(transferHubProvider.notifier)
        .sendFile(peer: peer.toLanPeer(), path: path);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          taskId == null ? l10n.serverStartingLabel : l10n.sendQueuedMessage,
        ),
      ),
    );
  }

  Future<void> _sendTextTo(_PeerItem peer, String text) async {
    final l10n = AppLocalizations.of(context)!;
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final sent = await ref
        .read(chatHubProvider.notifier)
        .sendText(peer: peer.toLanPeer(), text: trimmed);

    if (!mounted || sent) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.messageSendFailed)));
  }
}

class _PeerRail extends StatelessWidget {
  const _PeerRail({
    required this.peers,
    required this.selectedPeerId,
    required this.discoveryAsync,
    required this.transferAsync,
    required this.onSelect,
    required this.onProbe,
    required this.onSettings,
  });

  final List<_PeerItem> peers;
  final String? selectedPeerId;
  final AsyncValue<DiscoveryState> discoveryAsync;
  final AsyncValue<TransferState> transferAsync;
  final ValueChanged<String> onSelect;
  final Future<void> Function() onProbe;
  final Future<void> Function() onSettings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final transfer = transferAsync.asData?.value;
    final onlineCount = peers.where((peer) => peer.online).length;
    final isDark = theme.brightness == Brightness.dark;

    return ColoredBox(
      color: isDark ? const Color(0xFF202C33) : const Color(0xFFF7F7F7),
      child: Column(
        children: [
          Container(
            color: isDark ? const Color(0xFF2A3942) : const Color(0xFFF0F2F5),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.devicesTitle,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onProbe,
                      icon: const Icon(Icons.radar_rounded),
                    ),
                    IconButton(
                      onPressed: onSettings,
                      icon: const Icon(Icons.settings_outlined),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.devicesSubtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _HeaderChip(
                      icon: Icons.wifi_tethering_rounded,
                      label: '$onlineCount ${l10n.onlineLabel}',
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _HeaderChip(
                        icon: Icons.cable_rounded,
                        label: transfer == null
                            ? l10n.serverStartingLabel
                            : '${l10n.listeningPortLabel} ${transfer.port}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _WorkspacePanel(onSettings: onSettings),
                if (transfer != null) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${l10n.inboxLabel}: ${transfer.inboxPath}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
                if (discoveryAsync.hasError) ...[
                  const SizedBox(height: 12),
                  _InlineBanner(
                    label: discoveryAsync.error.toString(),
                    tone: BannerTone.error,
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: peers.isEmpty
                ? _EmptyPeersCard(label: l10n.emptyPeersBody)
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: peers.length,
                    separatorBuilder: (_, _) =>
                        Divider(height: 1, color: theme.dividerColor),
                    itemBuilder: (context, index) {
                      final peer = peers[index];
                      return _PeerTile(
                        peer: peer,
                        selected: peer.id == selectedPeerId,
                        onTap: () => onSelect(peer.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _WorkspacePanel extends ConsumerWidget {
  const _WorkspacePanel({required this.onSettings});

  final Future<void> Function() onSettings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final sentence = ref.watch(sentenceProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? const Color(0xFF182229)
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.brightness == Brightness.dark
              ? Colors.white.withValues(alpha: 0.05)
              : const Color(0xFFE2E5E9),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.homePageHeadline,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.homePageSubtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (Platform.isAndroid)
                FilledButton.icon(
                  onPressed: () {
                    context.pushRoute(const LiveUpdateRoute());
                  },
                  icon: const Icon(Icons.notifications_active_rounded),
                  label: Text(l10n.liveUpdateOpenComposerAction),
                ),
              OutlinedButton.icon(
                onPressed: onSettings,
                icon: const Icon(Icons.settings_outlined),
                label: Text(l10n.settingsTitle),
              ),
            ],
          ),
          const SizedBox(height: 14),
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => ref.refresh(sentenceProvider),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? const Color(0xFF202C33)
                    : const Color(0xFFF7F9FB),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.dailySentenceTitle,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.dailySentenceHint,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  sentence.when(
                    data: (data) => Text(
                      (data?.trim().isNotEmpty ?? false)
                          ? data!.trim()
                          : l10n.dailySentenceFallback,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.4,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    error: (error, stackTrace) => Text(
                      l10n.dailySentenceFallback,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    loading: () => Text(
                      l10n.loadingLabel,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatStage extends StatelessWidget {
  const _ChatStage({
    required this.peer,
    required this.link,
    required this.messages,
    required this.tasks,
    required this.chatAsync,
    required this.transferAsync,
    this.onBack,
    this.onSend,
    this.onSendText,
  });

  final _PeerItem? peer;
  final ChatLink? link;
  final List<ChatMessage> messages;
  final List<TransferTask> tasks;
  final AsyncValue<ChatState> chatAsync;
  final AsyncValue<TransferState> transferAsync;
  final VoidCallback? onBack;
  final VoidCallback? onSend;
  final Future<void> Function(String text)? onSendText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final timeline = _timelineFor(messages, tasks);
    final isDark = theme.brightness == Brightness.dark;

    return ColoredBox(
      color: isDark ? const Color(0xFF0B141A) : const Color(0xFFE9E3D9),
      child: peer == null
          ? _EmptyChat(title: l10n.emptyChatTitle, body: l10n.emptyChatBody)
          : Column(
              children: [
                Container(
                  color: isDark
                      ? const Color(0xFF202C33)
                      : const Color(0xFFF0F2F5),
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                  child: Row(
                    children: [
                      if (onBack != null)
                        IconButton(
                          onPressed: onBack,
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                      _PeerAvatar(name: peer!.name, online: peer!.online),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              peer!.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${_chatStatusText(link?.status, l10n)} · ${peer!.host}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: onSend,
                        icon: const Icon(Icons.attach_file_rounded),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: timeline.isEmpty
                      ? _EmptyChat(
                          title: l10n.chatIdleTitle,
                          body: l10n.chatIdleBody,
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(14, 16, 14, 12),
                          itemCount: timeline.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final item = timeline[index];
                            final outgoing = item.isOutgoing;
                            return Align(
                              alignment: outgoing
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: switch (item) {
                                _ChatTextEntry(:final message) => _ChatBubble(
                                  message: message,
                                ),
                                _ChatTransferEntry(:final task) =>
                                  _TransferBubble(task: task),
                              },
                            );
                          },
                        ),
                ),
                const Divider(height: 1),
                Container(
                  color: isDark
                      ? const Color(0xFF202C33)
                      : const Color(0xFFF0F2F5),
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              transferAsync.asData?.value == null
                                  ? l10n.serverStartingLabel
                                  : '${l10n.serverReadyLabel} · ${transferAsync.asData!.value.port}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (chatAsync.hasError) ...[
                        const SizedBox(height: 10),
                        _InlineBanner(
                          label: chatAsync.error.toString(),
                          tone: BannerTone.error,
                        ),
                      ],
                      const SizedBox(height: 10),
                      _ChatComposer(
                        enabled: onSendText != null,
                        hintText: l10n.chatInputHint,
                        sendLabel: l10n.sendTextAction,
                        onSend: onSendText,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _TransferBubble extends StatelessWidget {
  const _TransferBubble({required this.task});

  final TransferTask task;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final l10n = AppLocalizations.of(context)!;
    final outgoing = task.direction == TransferDirection.send;

    return Container(
      width: 420,
      constraints: const BoxConstraints(maxWidth: 420),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: outgoing ? const Color(0xFFDCF8C6) : Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                outgoing ? Icons.upload_file_rounded : Icons.download_rounded,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  task.fileName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _StatusTag(label: _statusText(task.status, l10n)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: task.progress.clamp(0, 1),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              _MetaText(
                label:
                    '${_prettyBytes(task.doneBytes)} / ${_prettyBytes(task.totalBytes)}',
              ),
              if (task.bytesPerSecond > 0)
                _MetaText(
                  label:
                      '${l10n.speedShortLabel} ${_prettyBytes(task.bytesPerSecond.round())}/s',
                ),
              if (task.eta != null)
                _MetaText(
                  label: '${l10n.etaShortLabel} ${_prettyDuration(task.eta!)}',
                ),
              _MetaText(label: DateFormat.Hm().format(task.updatedAt)),
            ],
          ),
          if (task.error != null && task.error!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              task.error!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: appColors.danger,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outgoing = message.direction == ChatDirection.outgoing;

    return Container(
      width: 420,
      constraints: const BoxConstraints(maxWidth: 420),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: outgoing ? const Color(0xFFDCF8C6) : Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.text,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat.Hm().format(message.sentAt),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatComposer extends StatefulWidget {
  const _ChatComposer({
    required this.enabled,
    required this.hintText,
    required this.sendLabel,
    required this.onSend,
  });

  final bool enabled;
  final String hintText;
  final String sendLabel;
  final Future<void> Function(String text)? onSend;

  @override
  State<_ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<_ChatComposer> {
  late final TextEditingController _controller;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A3942) : Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: TextField(
              controller: _controller,
              enabled: widget.enabled && !_sending,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        FilledButton(
          style: FilledButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(14),
            minimumSize: const Size(0, 0),
          ),
          onPressed: widget.enabled && !_sending ? _submit : null,
          child: const Icon(Icons.send_rounded),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.onSend == null) {
      return;
    }

    setState(() {
      _sending = true;
    });

    try {
      await widget.onSend!(text);
      _controller.clear();
    } finally {
      if (mounted) {
        setState(() {
          _sending = false;
        });
      }
    }
  }
}

class _PeerTile extends StatelessWidget {
  const _PeerTile({
    required this.peer,
    required this.selected,
    required this.onTap,
  });

  final _PeerItem peer;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.zero,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.primary.withValues(alpha: 0.10)
              : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: selected ? colorScheme.primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            _PeerAvatar(name: peer.name, online: peer.online),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          peer.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat.Hm().format(peer.lastSeen),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    peer.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _SmallTag(label: peer.online ? 'ON' : 'OFF'),
                      if (peer.activeCount > 0)
                        _SmallTag(label: '${peer.activeCount}X'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PeerAvatar extends StatelessWidget {
  const _PeerAvatar({required this.name, required this.online});

  final String name;
  final bool online;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final seed = name.isEmpty ? '?' : name.characters.first.toUpperCase();

    return Stack(
      children: [
        CircleAvatar(
          radius: 27,
          backgroundColor: appColors.heroStart,
          child: Text(
            seed,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Positioned(
          right: 2,
          bottom: 2,
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: online ? appColors.success : appColors.iconMuted,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderChip extends StatelessWidget {
  const _HeaderChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: appColors.panelMuted,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 16), const SizedBox(width: 8), Text(label)],
      ),
    );
  }
}

enum BannerTone { error }

class _InlineBanner extends StatelessWidget {
  const _InlineBanner({required this.label, required this.tone});

  final String label;
  final BannerTone tone;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: appColors.danger.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label),
    );
  }
}

class _EmptyPeersCard extends StatelessWidget {
  const _EmptyPeersCard({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}

class _EmptyChat extends StatelessWidget {
  const _EmptyChat({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.forum_rounded,
              size: 52,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallTag extends StatelessWidget {
  const _SmallTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: appColors.panelMuted,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}

class _StatusTag extends StatelessWidget {
  const _StatusTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: appColors.panelMuted,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

Future<String?> _askFilePath(
  BuildContext context,
  AppLocalizations l10n,
) async {
  final controller = TextEditingController();
  final result = await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(l10n.enterPathTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: l10n.filePathLabel,
            hintText: l10n.filePathHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancelAction),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: Text(l10n.sendFileAction),
          ),
        ],
      );
    },
  );
  controller.dispose();
  return result;
}

List<_PeerItem> _mergePeers(
  List<LanPeer> peers,
  List<ChatMessage> messages,
  List<TransferTask> tasks,
) {
  final map = <String, _PeerItem>{};

  for (final peer in peers) {
    map[peer.id] = _PeerItem(
      id: peer.id,
      name: peer.name,
      host: peer.host,
      chatPort: peer.chatPort,
      transferPort: peer.transferPort,
      online: true,
      lastSeen: peer.lastSeen,
      subtitle: '${peer.app} ${peer.version}',
      app: peer.app,
      version: peer.version,
      platform: peer.platform,
      lastTask: null,
      activeCount: 0,
    );
  }

  for (final message in messages) {
    final current = map[message.peerId];
    final next =
        (current ??
                _PeerItem(
                  id: message.peerId,
                  name: message.peerName,
                  host: '',
                  chatPort: NetPorts.chat,
                  transferPort: NetPorts.transfer,
                  online: false,
                  lastSeen: message.sentAt,
                  subtitle: message.text,
                  app: '',
                  version: '',
                  platform: '',
                  lastTask: null,
                  activeCount: 0,
                ))
            .copyWith(
              name: message.peerName,
              lastSeen: message.sentAt.isAfter(current?.lastSeen ?? DateTime(0))
                  ? message.sentAt
                  : current?.lastSeen,
              subtitle: message.text,
            );
    map[message.peerId] = next;
  }

  for (final task in tasks) {
    final current = map[task.peerId];
    final next =
        (current ??
                _PeerItem(
                  id: task.peerId,
                  name: task.peerName,
                  host: task.peerHost,
                  chatPort: NetPorts.chat,
                  transferPort: NetPorts.transfer,
                  online: false,
                  lastSeen: task.updatedAt,
                  subtitle: task.fileName,
                  app: '',
                  version: '',
                  platform: '',
                  lastTask: task,
                  activeCount: 0,
                ))
            .copyWith(
              name: task.peerName,
              host: task.peerHost,
              lastSeen: task.updatedAt.isAfter(current?.lastSeen ?? DateTime(0))
                  ? task.updatedAt
                  : current?.lastSeen,
              subtitle: task.fileName,
              lastTask:
                  current?.lastTask == null ||
                      task.updatedAt.isAfter(current!.lastTask!.updatedAt)
                  ? task
                  : current.lastTask,
              activeCount: (current?.activeCount ?? 0) + _isActive(task.status),
            );
    map[task.peerId] = next;
  }

  final list = map.values.toList(growable: false)
    ..sort((a, b) => b.lastSeen.compareTo(a.lastSeen));
  return list;
}

List<TransferTask> _tasksFor(List<TransferTask> tasks, String peerId) {
  final list =
      tasks.where((task) => task.peerId == peerId).toList(growable: false)
        ..sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
  return list;
}

List<ChatMessage> _messagesFor(List<ChatMessage> messages, String peerId) {
  final list =
      messages
          .where((message) => message.peerId == peerId)
          .toList(growable: false)
        ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
  return list;
}

ChatLink? _linkFor(List<ChatLink> links, String peerId) {
  for (final link in links) {
    if (link.peerId == peerId) {
      return link;
    }
  }

  return null;
}

int _isActive(TransferStatus status) {
  return switch (status) {
    TransferStatus.queued => 1,
    TransferStatus.connecting => 1,
    TransferStatus.sending => 1,
    TransferStatus.receiving => 1,
    TransferStatus.done => 0,
    TransferStatus.failed => 0,
  };
}

String _statusText(TransferStatus status, AppLocalizations l10n) {
  return switch (status) {
    TransferStatus.queued => l10n.statusQueued,
    TransferStatus.connecting => l10n.statusConnecting,
    TransferStatus.sending => l10n.statusSending,
    TransferStatus.receiving => l10n.statusReceiving,
    TransferStatus.done => l10n.statusDone,
    TransferStatus.failed => l10n.statusFailed,
  };
}

String _chatStatusText(ChatLinkStatus? status, AppLocalizations l10n) {
  return switch (status) {
    ChatLinkStatus.connected => l10n.chatConnectedLabel,
    ChatLinkStatus.connecting => l10n.chatConnectingLabel,
    ChatLinkStatus.failed => l10n.chatFailedLabel,
    ChatLinkStatus.idle || null => l10n.chatIdleLabel,
  };
}

String _prettyBytes(int value) {
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  var size = value.toDouble();
  var index = 0;
  while (size >= 1024 && index < units.length - 1) {
    size /= 1024;
    index++;
  }

  final digits = size >= 100 || index == 0 ? 0 : 1;
  return '${size.toStringAsFixed(digits)} ${units[index]}';
}

String _prettyDuration(Duration value) {
  final hours = value.inHours;
  final minutes = value.inMinutes.remainder(60);
  final seconds = value.inSeconds.remainder(60);

  if (hours > 0) {
    return '${hours}h ${minutes}m';
  }
  if (minutes > 0) {
    return '${minutes}m ${seconds}s';
  }
  return '${seconds}s';
}

List<_ChatEntry> _timelineFor(
  List<ChatMessage> messages,
  List<TransferTask> tasks,
) {
  final list = <_ChatEntry>[
    ...messages.map(_ChatTextEntry.new),
    ...tasks.map(_ChatTransferEntry.new),
  ]..sort((a, b) => a.time.compareTo(b.time));
  return list;
}

sealed class _ChatEntry {
  const _ChatEntry();

  DateTime get time;

  bool get isOutgoing;
}

class _ChatTextEntry extends _ChatEntry {
  const _ChatTextEntry(this.message);

  final ChatMessage message;

  @override
  DateTime get time => message.sentAt;

  @override
  bool get isOutgoing => message.direction == ChatDirection.outgoing;
}

class _ChatTransferEntry extends _ChatEntry {
  const _ChatTransferEntry(this.task);

  final TransferTask task;

  @override
  DateTime get time => task.updatedAt;

  @override
  bool get isOutgoing => task.direction == TransferDirection.send;
}

class _PeerItem {
  const _PeerItem({
    required this.id,
    required this.name,
    required this.host,
    required this.chatPort,
    required this.transferPort,
    required this.online,
    required this.lastSeen,
    required this.subtitle,
    required this.app,
    required this.version,
    required this.platform,
    required this.lastTask,
    required this.activeCount,
  });

  final String id;
  final String name;
  final String host;
  final int chatPort;
  final int transferPort;
  final bool online;
  final DateTime lastSeen;
  final String subtitle;
  final String app;
  final String version;
  final String platform;
  final TransferTask? lastTask;
  final int activeCount;

  _PeerItem copyWith({
    String? id,
    String? name,
    String? host,
    int? chatPort,
    int? transferPort,
    bool? online,
    DateTime? lastSeen,
    String? subtitle,
    String? app,
    String? version,
    String? platform,
    TransferTask? lastTask,
    int? activeCount,
  }) {
    return _PeerItem(
      id: id ?? this.id,
      name: name ?? this.name,
      host: host ?? this.host,
      chatPort: chatPort ?? this.chatPort,
      transferPort: transferPort ?? this.transferPort,
      online: online ?? this.online,
      lastSeen: lastSeen ?? this.lastSeen,
      subtitle: subtitle ?? this.subtitle,
      app: app ?? this.app,
      version: version ?? this.version,
      platform: platform ?? this.platform,
      lastTask: lastTask ?? this.lastTask,
      activeCount: activeCount ?? this.activeCount,
    );
  }

  LanPeer toLanPeer() {
    return LanPeer(
      id: id,
      name: name,
      host: host,
      chatPort: chatPort,
      transferPort: transferPort,
      app: app,
      version: version,
      platform: platform,
      lastSeen: lastSeen,
    );
  }
}
