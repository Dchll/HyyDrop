import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hyy_drop/core/info/device_info_provider.dart';
import 'package:hyy_drop/core/info/package_info_provider.dart';
import 'package:hyy_drop/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

@RoutePage()
class SettingsPackageInfoPage extends ConsumerWidget {
  const SettingsPackageInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final packageAsync = ref.watch(appPackageInfoProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      appBar: AppBar(
        title: Text(l10n.packageInfoPageTitle),
        backgroundColor: const Color(0xFFF7FBFF),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8F4FF), Color(0xFFF7FBFF)],
          ),
        ),
        child: SafeArea(
          child: packageAsync.when(
            loading: () => _StatePanel(label: l10n.loadingDiagnostics),
            error: (error, _) => _StatePanel(label: error.toString()),
            data: (snapshot) => ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              children: [
                _PageCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.packageInfoPageSubtitle,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 18),
                      ..._packageEntries(
                        snapshot.packageInfo,
                        l10n,
                        Localizations.localeOf(context),
                      ).map(_InfoRow.new),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.entry);

  final MapEntry<String, String> entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              entry.key,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 6,
            child: Text(
              entry.value,
              textAlign: TextAlign.right,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

@RoutePage()
class SettingsDeviceInfoPage extends ConsumerWidget {
  const SettingsDeviceInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final deviceAsync = ref.watch(appDeviceInfoProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      appBar: AppBar(
        title: Text(l10n.deviceInfoPageTitle),
        backgroundColor: const Color(0xFFF7FBFF),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8F4FF), Color(0xFFF7FBFF)],
          ),
        ),
        child: SafeArea(
          child: deviceAsync.when(
            loading: () => _StatePanel(label: l10n.loadingDiagnostics),
            error: (error, _) => _StatePanel(label: error.toString()),
            data: (snapshot) => ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              children: [
                _PageCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.deviceInfoPageSubtitle,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 18),
                      ..._flattenEntries(
                        snapshot.deviceData,
                        l10n,
                        Localizations.localeOf(context),
                      ).map(_InfoRow.new),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PageCard extends StatelessWidget {
  const _PageCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFD7E5F2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140084FF),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _StatePanel extends StatelessWidget {
  const _StatePanel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: _PageCard(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

List<MapEntry<String, String>> _packageEntries(
  PackageInfo info,
  AppLocalizations l10n,
  Locale locale,
) {
  return <MapEntry<String, String>>[
    MapEntry(l10n.appNameField, info.appName),
    MapEntry(l10n.packageNameField, info.packageName),
    MapEntry(l10n.versionField, info.version),
    MapEntry(l10n.buildNumberField, info.buildNumber),
    MapEntry(
      l10n.buildSignatureField,
      _displayValue(info.buildSignature, l10n),
    ),
    MapEntry(
      l10n.installerStoreField,
      _displayValue(info.installerStore, l10n),
    ),
    MapEntry(
      l10n.installTimeField,
      _formatDateTime(info.installTime, locale, l10n),
    ),
    MapEntry(
      l10n.updateTimeField,
      _formatDateTime(info.updateTime, locale, l10n),
    ),
  ];
}

List<MapEntry<String, String>> _flattenEntries(
  Map<String, dynamic> data,
  AppLocalizations l10n,
  Locale locale, [
  String prefix = '',
]) {
  final entries = <MapEntry<String, String>>[];
  final sortedKeys = data.keys.toList()..sort();

  for (final key in sortedKeys) {
    final value = data[key];
    final composedKey = prefix.isEmpty ? key : '$prefix.$key';

    if (value is Map) {
      entries.addAll(
        _flattenEntries(
          Map<String, dynamic>.from(value),
          l10n,
          locale,
          composedKey,
        ),
      );
      continue;
    }

    if (value is Iterable) {
      final values = value
          .map((item) => _displayValue(item, l10n, locale))
          .toList(growable: false)
          .join(', ');
      entries.add(MapEntry(_beautifyKey(composedKey), values));
      continue;
    }

    entries.add(
      MapEntry(_beautifyKey(composedKey), _displayValue(value, l10n, locale)),
    );
  }

  return entries;
}

String _beautifyKey(String input) {
  final normalized = input
      .replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (m) => '${m[1]} ${m[2]}')
      .replaceAll('.', ' / ')
      .replaceAll('_', ' ');

  return normalized
      .split(' ')
      .where((part) => part.isNotEmpty)
      .map(
        (part) => part.length <= 2 && !part.contains('/')
            ? part.toUpperCase()
            : '${part[0].toUpperCase()}${part.substring(1)}',
      )
      .join(' ');
}

String _displayValue(
  Object? value,
  AppLocalizations l10n, [
  Locale locale = const Locale('en'),
]) {
  if (value == null) {
    return l10n.unavailable;
  }

  if (value is DateTime) {
    return _formatDateTime(value, locale, l10n);
  }

  if (value is bool) {
    return value ? l10n.yesLabel : l10n.noLabel;
  }

  final text = value.toString().trim();
  return text.isEmpty ? l10n.unavailable : text;
}

String _formatDateTime(DateTime? value, Locale locale, AppLocalizations l10n) {
  if (value == null) {
    return l10n.unavailable;
  }

  final localeTag = locale.toLanguageTag();
  return DateFormat.yMd(localeTag).add_Hm().format(value.toLocal());
}
