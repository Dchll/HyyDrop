import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:hyy_drop/core/network/transfer/transfer_live_update.dart';
import 'package:hyy_drop/core/theme/app_theme_extension.dart';
import 'package:hyy_drop/l10n/app_localizations.dart';

@RoutePage()
class LiveUpdatePage extends StatefulWidget {
  const LiveUpdatePage({super.key});

  @override
  State<LiveUpdatePage> createState() => _LiveUpdatePageState();
}

class _LiveUpdatePageState extends State<LiveUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  final _subTextCtrl = TextEditingController();
  final _shortCriticalTextCtrl = TextEditingController();
  final _progressCtrl = TextEditingController();

  List<String> _previewSegments = const [];
  bool _sending = false;
  int _previewRequestId = 0;
  double _shortTextRotationSeconds = 5;

  @override
  void initState() {
    super.initState();
    _shortCriticalTextCtrl.addListener(_handleShortTextChanged);
    _refreshShortTextPreview();
  }

  @override
  void dispose() {
    _shortCriticalTextCtrl.removeListener(_handleShortTextChanged);
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    _subTextCtrl.dispose();
    _shortCriticalTextCtrl.dispose();
    _progressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0B1118)
          : const Color(0xFFF7FBFF),
      appBar: AppBar(
        title: Text(l10n.liveUpdatePageTitle),
        backgroundColor: isDark
            ? const Color(0xFF0B1118)
            : const Color(0xFFF7FBFF),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [Color(0xFF101A25), Color(0xFF0B1118)]
                : const [Color(0xFFE8F4FF), Color(0xFFF7FBFF)],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            children: [
              _PanelCard(
                child: Text(
                  l10n.liveUpdatePageSubtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _PanelCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _titleCtrl,
                        label: l10n.liveUpdateTitleLabel,
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _bodyCtrl,
                        label: l10n.liveUpdateBodyLabel,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _subTextCtrl,
                        label: l10n.liveUpdateSubTextLabel,
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _progressCtrl,
                        label: l10n.liveUpdateProgressLabel,
                        hint: l10n.liveUpdateProgressHint,
                        keyboardType: TextInputType.number,
                        validator: _progressValidator,
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _shortCriticalTextCtrl,
                        label: l10n.liveUpdateShortCriticalTextLabel,
                        minLines: 3,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 18),
                      _RotationIntervalSlider(
                        seconds: _shortTextRotationSeconds,
                        onChanged: (value) {
                          setState(() {
                            _shortTextRotationSeconds = value;
                          });
                        },
                      ),
                      const SizedBox(height: 14),
                      _ShortTextPreviewCard(segments: _previewSegments),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _sending ? null : _sendNotification,
                icon: _sending
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.notifications_active_rounded),
                label: Text(l10n.liveUpdateSendAction),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? minLines,
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: appColors.panelMuted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: appColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: appColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
        ),
      ),
      keyboardType: keyboardType,
      minLines: minLines,
      maxLines: maxLines,
      validator: validator,
    );
  }

  void _handleShortTextChanged() {
    _refreshShortTextPreview();
  }

  Future<void> _refreshShortTextPreview() async {
    final requestId = ++_previewRequestId;
    final segments = await TransferLiveUpdateBridge.instance
        .previewShortCriticalTextSegments(_shortCriticalTextCtrl.text);

    if (!mounted || requestId != _previewRequestId) {
      return;
    }

    setState(() {
      _previewSegments = segments;
    });
  }

  Future<void> _sendNotification() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _sending = true;
    });

    final success = await TransferLiveUpdateBridge.instance
        .showCustomNotification(
          taskId: TransferLiveUpdateBridge.instance.manualLiveUpdateTaskId,
          title: _resolvedTitle(),
          body: _bodyCtrl.text.trim(),
          subText: _nullableText(_subTextCtrl),
          progress: _resolvedProgress(),
          shortCriticalText: _nullableText(_shortCriticalTextCtrl),
          shortTextRotationSeconds: _shortTextRotationSeconds.round(),
          successToastMessage: l10n.liveUpdateToastSuccess,
        );

    if (!mounted) {
      return;
    }

    setState(() {
      _sending = false;
    });

    if (success) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.unableLoadDiagnostics)));
  }

  String _resolvedTitle() {
    final title = _titleCtrl.text.trim();
    if (title.isNotEmpty) {
      return title;
    }

    return _shortCriticalTextCtrl.text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .join(' ');
  }

  int? _resolvedProgress() {
    final value = _progressCtrl.text.trim();
    return value.isEmpty ? null : int.tryParse(value);
  }

  String? _progressValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final parsed = int.tryParse(value.trim());
    if (parsed == null || parsed < 0 || parsed > 100) {
      return AppLocalizations.of(context)!.liveUpdateProgressInvalid;
    }

    return null;
  }

  String? _nullableText(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }
}

class _PanelCard extends StatelessWidget {
  const _PanelCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: appColors.panel,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: appColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.28)
                : const Color(0x140084FF),
            blurRadius: isDark ? 24 : 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _RotationIntervalSlider extends StatelessWidget {
  const _RotationIntervalSlider({
    required this.seconds,
    required this.onChanged,
  });

  final double seconds;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      decoration: BoxDecoration(
        color: appColors.panelMuted,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: appColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.liveUpdateShortTextRefreshLabel,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                l10n.liveUpdateShortTextRefreshValue(seconds.round()),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            l10n.liveUpdateShortTextRefreshHint,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Slider(
            min: 1,
            max: 10,
            divisions: 9,
            value: seconds.clamp(1, 10),
            label: l10n.liveUpdateShortTextRefreshValue(seconds.round()),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ShortTextPreviewCard extends StatelessWidget {
  const _ShortTextPreviewCard({required this.segments});

  final List<String> segments;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: appColors.panelMuted,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: appColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.liveUpdateShortTextPreviewTitle,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          if (segments.isEmpty)
            Text(
              l10n.liveUpdateShortTextPreviewEmpty,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else
            for (var index = 0; index < segments.length; index++) ...[
              Text(
                '${index + 1}. ${segments[index]}',
                style: theme.textTheme.bodyMedium,
              ),
              if (index < segments.length - 1) const SizedBox(height: 8),
            ],
        ],
      ),
    );
  }
}
