import 'package:flutter/material.dart';
import 'package:hyy_drop/l10n/app_localizations.dart';

enum AppLocale {
  system('system', null),
  zhHans(
    'zh_Hans',
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
  ),
  zhHant(
    'zh_Hant',
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ),
  en('en', Locale('en'));

  const AppLocale(this.storageValue, this.locale);

  final String storageValue;
  final Locale? locale;

  static const supportedLocales = [
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    Locale('en'),
  ];

  static AppLocale fromStorage(String? value) {
    return AppLocale.values.firstWhere(
      (item) => item.storageValue == value,
      orElse: () => AppLocale.system,
    );
  }

  String label(AppLocalizations l10n) {
    return switch (this) {
      AppLocale.system => l10n.localeSystem,
      AppLocale.zhHans => l10n.localeSimplifiedChinese,
      AppLocale.zhHant => l10n.localeTraditionalChinese,
      AppLocale.en => l10n.localeEnglish,
    };
  }
}
