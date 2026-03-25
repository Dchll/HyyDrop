// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'HyyDrop';

  @override
  String get runtimeDiagnostics => 'Runtime Diagnostics';

  @override
  String get appAndDeviceInfo => 'App & Device Info';

  @override
  String get themeModeSectionTitle => 'Theme Mode';

  @override
  String get languageSectionTitle => 'Language';

  @override
  String get themeModeSystem => 'System';

  @override
  String get themeModeLight => 'Light';

  @override
  String get themeModeDark => 'Dark';

  @override
  String get localeSystem => 'Auto';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeSimplifiedChinese => '简中';

  @override
  String get localeTraditionalChinese => '繁中';

  @override
  String get packageDetails => 'Package Details';

  @override
  String get deviceDetails => 'Device Details';

  @override
  String fieldsCount(int count) {
    return '$count fields';
  }

  @override
  String get application => 'Application';

  @override
  String get packageInfoPlusTitle => 'Package Info Plus';

  @override
  String get deviceInfoPlusSubtitle =>
      'Device Info Plus · Live platform snapshot';

  @override
  String get versionShortLabel => 'VERSION';

  @override
  String get deviceShortLabel => 'DEVICE';

  @override
  String get physicalShortLabel => 'PHYSICAL';

  @override
  String get yesLabel => 'Yes';

  @override
  String get noLabel => 'No';

  @override
  String get packageMetricLabel => 'Package';

  @override
  String get deviceMetricLabel => 'Device';

  @override
  String get languageMetricLabel => 'Language';

  @override
  String get loadingDiagnostics => 'Collecting package and device details...';

  @override
  String get unableLoadDiagnostics => 'Unable to load diagnostics';

  @override
  String get retry => 'Retry';

  @override
  String get overviewTab => 'Overview';

  @override
  String get packageTab => 'Package';

  @override
  String get deviceTab => 'Device';

  @override
  String get themeTab => 'Theme';

  @override
  String get appNameField => 'App Name';

  @override
  String get packageNameField => 'Package Name';

  @override
  String get versionField => 'Version';

  @override
  String get buildNumberField => 'Build Number';

  @override
  String get buildSignatureField => 'Build Signature';

  @override
  String get installerStoreField => 'Installer Store';

  @override
  String get installTimeField => 'Install Time';

  @override
  String get updateTimeField => 'Update Time';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get platformWeb => 'Web';

  @override
  String get platformAndroid => 'Android';

  @override
  String get platformIos => 'iOS';

  @override
  String get platformMacos => 'macOS';

  @override
  String get platformWindows => 'Windows';

  @override
  String get platformLinux => 'Linux';

  @override
  String get platformFuchsia => 'Fuchsia';
}
