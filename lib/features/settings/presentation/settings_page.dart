import 'package:auto_route/annotations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hyy_drop/core/info/device_info_provider.dart';
import 'package:hyy_drop/core/info/package_info_provider.dart';
import 'package:hyy_drop/core/locale/app_locale.dart';
import 'package:hyy_drop/core/locale/locale_state.dart';
import 'package:hyy_drop/core/theme/app_theme_extension.dart';
import 'package:hyy_drop/core/theme/theme_state.dart';
import 'package:hyy_drop/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = context.appColors;
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              isDark ? Colors.black : const Color(0xFFEAF6FF),
              colorScheme.surface,
              colorScheme.surface,
            ],
            stops: const [0, 0.18, 1],
          ),
        ),
        child: const SafeArea(child: _DiagnosticsBody()),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: appColors.transferGlow,
              blurRadius: 24,
              spreadRadius: 1,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const _RefreshDiagnosticsButton(),
      ),
    );
  }
}

class _DiagnosticsBody extends StatelessWidget {
  const _DiagnosticsBody();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const _Header(),
              const SizedBox(height: 24),
              const _HeroSection(),
              const SizedBox(height: 26),
              const _MetricsRow(),
              const SizedBox(height: 30),
              const _PackageSection(),
              const SizedBox(height: 28),
              const _DeviceSection(),
            ]),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.runtimeDiagnostics,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.appAndDeviceInfo,
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.2,
                    ),
                  ),
                ],
              ),
            ),
            const Material(
              color: Colors.transparent,
              child: _RefreshDiagnosticsIconButton(),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          l10n.themeModeSectionTitle,
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _ThemeModeSelector(),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.languageSectionTitle,
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _LocaleSelector(),
        ),
      ],
    );
  }
}

class _RefreshDiagnosticsIconButton extends ConsumerWidget {
  const _RefreshDiagnosticsIconButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = context.appColors;

    void refreshAll() {
      ref.invalidate(appPackageInfoProvider);
      ref.invalidate(appDeviceInfoProvider);
    }

    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: refreshAll,
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [appColors.heroStart, appColors.heroEnd],
          ),
          boxShadow: [
            BoxShadow(
              color: appColors.transferGlow,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.refresh_rounded, color: Colors.white, size: 24),
      ),
    );
  }
}

class _RefreshDiagnosticsButton extends ConsumerWidget {
  const _RefreshDiagnosticsButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () {
        ref.invalidate(appPackageInfoProvider);
        ref.invalidate(appDeviceInfoProvider);
      },
      child: const Icon(Icons.refresh_rounded),
    );
  }
}

class _ThemeModeSelector extends ConsumerWidget {
  const _ThemeModeSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeStateProvider);

    return SegmentedButton<ThemeMode>(
      showSelectedIcon: false,
      segments: [
        ButtonSegment(
          value: ThemeMode.system,
          label: Text(l10n.themeModeSystem),
        ),
        ButtonSegment(value: ThemeMode.light, label: Text(l10n.themeModeLight)),
        ButtonSegment(value: ThemeMode.dark, label: Text(l10n.themeModeDark)),
      ],
      selected: {themeMode},
      onSelectionChanged: (selection) {
        ref.read(themeStateProvider.notifier).setMode(selection.first);
      },
    );
  }
}

class _LocaleSelector extends ConsumerWidget {
  const _LocaleSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final appLocale = ref.watch(appLocaleProvider);

    return SegmentedButton<AppLocale>(
      showSelectedIcon: false,
      segments: AppLocale.values
          .map(
            (locale) => ButtonSegment<AppLocale>(
              value: locale,
              label: Text(locale.label(l10n)),
            ),
          )
          .toList(growable: false),
      selected: {appLocale},
      onSelectionChanged: (selection) {
        ref.read(appLocaleProvider.notifier).setLocale(selection.first);
      },
    );
  }
}

class _HeroSection extends ConsumerWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final packageAsync = ref.watch(appPackageInfoProvider);
    final deviceAsync = ref.watch(appDeviceInfoProvider);

    if (packageAsync.isLoading || deviceAsync.isLoading) {
      return _LoadingPanel(label: l10n.loadingDiagnostics);
    }

    final error = packageAsync.asError?.error ?? deviceAsync.asError?.error;
    if (error != null) {
      return _ErrorPanel(
        title: l10n.unableLoadDiagnostics,
        message: error.toString(),
        actionLabel: l10n.retry,
        onRetry: () {
          ref.invalidate(appPackageInfoProvider);
          ref.invalidate(appDeviceInfoProvider);
        },
      );
    }

    final package = packageAsync.asData?.value;
    final device = deviceAsync.asData?.value;
    if (package == null || device == null) {
      return _ErrorPanel(
        title: l10n.unableLoadDiagnostics,
        message: l10n.unavailable,
        actionLabel: l10n.retry,
        onRetry: () {
          ref.invalidate(appPackageInfoProvider);
          ref.invalidate(appDeviceInfoProvider);
        },
      );
    }

    return _HeroInfoCard(
      package: package,
      device: device,
      platformLabel: _platformLabel(l10n),
      physicalLabel: device.isPhysicalDevice ? l10n.yesLabel : l10n.noLabel,
      versionLabel:
          '${package.packageInfo.version} (${package.packageInfo.buildNumber})',
      packageTitle: l10n.packageInfoPlusTitle,
      subtitle: l10n.deviceInfoPlusSubtitle,
      versionShortLabel: l10n.versionShortLabel,
      deviceShortLabel: l10n.deviceShortLabel,
      physicalShortLabel: l10n.physicalShortLabel,
    );
  }
}

class _PackageSection extends ConsumerWidget {
  const _PackageSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final packageAsync = ref.watch(appPackageInfoProvider);

    return packageAsync.when(
      loading: () => _LoadingPanel(label: l10n.loadingDiagnostics),
      error: (error, _) => _ErrorPanel(
        title: l10n.unableLoadDiagnostics,
        message: error.toString(),
        actionLabel: l10n.retry,
        onRetry: () => ref.invalidate(appPackageInfoProvider),
      ),
      data: (snapshot) => Column(
        children: [
          _SectionHeader(
            title: l10n.packageDetails,
            actionLabel: l10n.fieldsCount(snapshot.fieldCount),
            actionColor: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          _EntryCard(
            title: l10n.application,
            icon: Icons.apps_rounded,
            entries: _packageEntries(
              snapshot.packageInfo,
              l10n,
              Localizations.localeOf(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceSection extends ConsumerWidget {
  const _DeviceSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final deviceAsync = ref.watch(appDeviceInfoProvider);

    return deviceAsync.when(
      loading: () => _LoadingPanel(label: l10n.loadingDiagnostics),
      error: (error, _) => _ErrorPanel(
        title: l10n.unableLoadDiagnostics,
        message: error.toString(),
        actionLabel: l10n.retry,
        onRetry: () => ref.invalidate(appDeviceInfoProvider),
      ),
      data: (snapshot) => Column(
        children: [
          _SectionHeader(
            title: l10n.deviceDetails,
            actionLabel: l10n.fieldsCount(snapshot.fieldCount),
            actionColor: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          _EntryCard(
            title: snapshot.deviceTitle,
            icon: Icons.memory_rounded,
            entries: _flattenEntries(
              snapshot.deviceData,
              l10n,
              Localizations.localeOf(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroInfoCard extends StatelessWidget {
  const _HeroInfoCard({
    required this.package,
    required this.device,
    required this.platformLabel,
    required this.physicalLabel,
    required this.versionLabel,
    required this.packageTitle,
    required this.subtitle,
    required this.versionShortLabel,
    required this.deviceShortLabel,
    required this.physicalShortLabel,
  });

  final AppPackageInfoSnapshot package;
  final AppDeviceInfoSnapshot device;
  final String platformLabel;
  final String physicalLabel;
  final String versionLabel;
  final String packageTitle;
  final String subtitle;
  final String versionShortLabel;
  final String deviceShortLabel;
  final String physicalShortLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [appColors.heroStart, appColors.heroEnd],
        ),
        boxShadow: [
          BoxShadow(
            color: appColors.transferGlow,
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: DefaultTextStyle(
        style: theme.textTheme.bodyMedium!.copyWith(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                    ),
                  ),
                  child: const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        packageTitle,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.82),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    platformLabel.toUpperCase(),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            Text(
              package.packageInfo.appName,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              package.packageInfo.packageName,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.86),
              ),
            ),
            const SizedBox(height: 26),
            Row(
              children: [
                Expanded(
                  child: _HeroStat(
                    label: versionShortLabel,
                    value: versionLabel,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _HeroStat(
                    label: deviceShortLabel,
                    value: device.deviceTitle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _HeroStat(
                    label: physicalShortLabel,
                    value: physicalLabel,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 10,
                value: 1,
                backgroundColor: Colors.white.withValues(alpha: 0.18),
                valueColor: AlwaysStoppedAnimation(colorScheme.onPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.72),
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _MetricsRow extends StatelessWidget {
  const _MetricsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _PackageMetricCard()),
        SizedBox(width: 14),
        Expanded(child: _DeviceMetricCard()),
        SizedBox(width: 14),
        Expanded(child: _LocaleMetricCard()),
      ],
    );
  }
}

class _PackageMetricCard extends ConsumerWidget {
  const _PackageMetricCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final packageAsync = ref.watch(appPackageInfoProvider);

    return _MetricCard(
      icon: Icons.inventory_2_outlined,
      label: l10n.packageMetricLabel,
      value: packageAsync.maybeWhen(
        data: (snapshot) => l10n.fieldsCount(snapshot.fieldCount),
        orElse: () => l10n.loadingDiagnostics,
      ),
    );
  }
}

class _DeviceMetricCard extends ConsumerWidget {
  const _DeviceMetricCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final deviceAsync = ref.watch(appDeviceInfoProvider);

    return _MetricCard(
      icon: Icons.developer_board_rounded,
      label: l10n.deviceMetricLabel,
      value: deviceAsync.maybeWhen(
        data: (snapshot) => l10n.fieldsCount(snapshot.fieldCount),
        orElse: () => l10n.loadingDiagnostics,
      ),
    );
  }
}

class _LocaleMetricCard extends ConsumerWidget {
  const _LocaleMetricCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(appLocaleProvider);

    return _MetricCard(
      icon: Icons.language_rounded,
      label: l10n.languageMetricLabel,
      value: locale.label(l10n),
      emphasized: true,
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: emphasized ? appColors.panelStrong : appColors.panel,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: appColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: emphasized ? colorScheme.primary : appColors.iconMuted,
          ),
          const SizedBox(height: 18),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.actionColor,
  });

  final String title;
  final String actionLabel;
  final Color actionColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Text(
          actionLabel,
          style: theme.textTheme.titleMedium?.copyWith(
            color: actionColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({
    required this.title,
    required this.icon,
    required this.entries,
  });

  final String title;
  final IconData icon;
  final List<MapEntry<String, String>> entries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: appColors.panel,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: appColors.cardBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: appColors.panelStrong,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: colorScheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            for (var i = 0; i < entries.length; i++) ...[
              _EntryRow(entry: entries[i]),
              if (i != entries.length - 1)
                Divider(color: appColors.cardBorder, height: 18),
            ],
          ],
        ),
      ),
    );
  }
}

class _EntryRow extends StatelessWidget {
  const _EntryRow({required this.entry});

  final MapEntry<String, String> entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            entry.key,
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
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
    );
  }
}

class _LoadingPanel extends StatelessWidget {
  const _LoadingPanel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: appColors.panel,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: appColors.cardBorder),
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 18),
          Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onRetry,
  });

  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: appColors.panel,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: appColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(message, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 18),
          FilledButton(onPressed: onRetry, child: Text(actionLabel)),
        ],
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

String _platformLabel(AppLocalizations l10n) {
  if (kIsWeb) {
    return l10n.platformWeb;
  }

  return switch (defaultTargetPlatform) {
    TargetPlatform.android => l10n.platformAndroid,
    TargetPlatform.iOS => l10n.platformIos,
    TargetPlatform.macOS => l10n.platformMacos,
    TargetPlatform.windows => l10n.platformWindows,
    TargetPlatform.linux => l10n.platformLinux,
    TargetPlatform.fuchsia => l10n.platformFuchsia,
  };
}
