import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'HyyDrop'**
  String get appTitle;

  /// No description provided for @runtimeDiagnostics.
  ///
  /// In en, this message translates to:
  /// **'Runtime Diagnostics'**
  String get runtimeDiagnostics;

  /// No description provided for @appAndDeviceInfo.
  ///
  /// In en, this message translates to:
  /// **'App & Device Info'**
  String get appAndDeviceInfo;

  /// No description provided for @themeModeSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeModeSectionTitle;

  /// No description provided for @languageSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSectionTitle;

  /// No description provided for @themeModeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeModeSystem;

  /// No description provided for @themeModeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeModeLight;

  /// No description provided for @themeModeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeModeDark;

  /// No description provided for @localeSystem.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get localeSystem;

  /// No description provided for @localeEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get localeEnglish;

  /// No description provided for @localeSimplifiedChinese.
  ///
  /// In en, this message translates to:
  /// **'简中'**
  String get localeSimplifiedChinese;

  /// No description provided for @localeTraditionalChinese.
  ///
  /// In en, this message translates to:
  /// **'繁中'**
  String get localeTraditionalChinese;

  /// No description provided for @packageDetails.
  ///
  /// In en, this message translates to:
  /// **'Package Details'**
  String get packageDetails;

  /// No description provided for @deviceDetails.
  ///
  /// In en, this message translates to:
  /// **'Device Details'**
  String get deviceDetails;

  /// No description provided for @fieldsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} fields'**
  String fieldsCount(int count);

  /// No description provided for @application.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get application;

  /// No description provided for @packageInfoPlusTitle.
  ///
  /// In en, this message translates to:
  /// **'Package Info Plus'**
  String get packageInfoPlusTitle;

  /// No description provided for @deviceInfoPlusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Device Info Plus · Live platform snapshot'**
  String get deviceInfoPlusSubtitle;

  /// No description provided for @versionShortLabel.
  ///
  /// In en, this message translates to:
  /// **'VERSION'**
  String get versionShortLabel;

  /// No description provided for @deviceShortLabel.
  ///
  /// In en, this message translates to:
  /// **'DEVICE'**
  String get deviceShortLabel;

  /// No description provided for @physicalShortLabel.
  ///
  /// In en, this message translates to:
  /// **'PHYSICAL'**
  String get physicalShortLabel;

  /// No description provided for @yesLabel.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesLabel;

  /// No description provided for @noLabel.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noLabel;

  /// No description provided for @packageMetricLabel.
  ///
  /// In en, this message translates to:
  /// **'Package'**
  String get packageMetricLabel;

  /// No description provided for @deviceMetricLabel.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get deviceMetricLabel;

  /// No description provided for @languageMetricLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageMetricLabel;

  /// No description provided for @loadingDiagnostics.
  ///
  /// In en, this message translates to:
  /// **'Collecting package and device details...'**
  String get loadingDiagnostics;

  /// No description provided for @unableLoadDiagnostics.
  ///
  /// In en, this message translates to:
  /// **'Unable to load diagnostics'**
  String get unableLoadDiagnostics;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @overviewTab.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overviewTab;

  /// No description provided for @packageTab.
  ///
  /// In en, this message translates to:
  /// **'Package'**
  String get packageTab;

  /// No description provided for @deviceTab.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get deviceTab;

  /// No description provided for @themeTab.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeTab;

  /// No description provided for @appNameField.
  ///
  /// In en, this message translates to:
  /// **'App Name'**
  String get appNameField;

  /// No description provided for @packageNameField.
  ///
  /// In en, this message translates to:
  /// **'Package Name'**
  String get packageNameField;

  /// No description provided for @versionField.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get versionField;

  /// No description provided for @buildNumberField.
  ///
  /// In en, this message translates to:
  /// **'Build Number'**
  String get buildNumberField;

  /// No description provided for @buildSignatureField.
  ///
  /// In en, this message translates to:
  /// **'Build Signature'**
  String get buildSignatureField;

  /// No description provided for @installerStoreField.
  ///
  /// In en, this message translates to:
  /// **'Installer Store'**
  String get installerStoreField;

  /// No description provided for @installTimeField.
  ///
  /// In en, this message translates to:
  /// **'Install Time'**
  String get installTimeField;

  /// No description provided for @updateTimeField.
  ///
  /// In en, this message translates to:
  /// **'Update Time'**
  String get updateTimeField;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @platformWeb.
  ///
  /// In en, this message translates to:
  /// **'Web'**
  String get platformWeb;

  /// No description provided for @platformAndroid.
  ///
  /// In en, this message translates to:
  /// **'Android'**
  String get platformAndroid;

  /// No description provided for @platformIos.
  ///
  /// In en, this message translates to:
  /// **'iOS'**
  String get platformIos;

  /// No description provided for @platformMacos.
  ///
  /// In en, this message translates to:
  /// **'macOS'**
  String get platformMacos;

  /// No description provided for @platformWindows.
  ///
  /// In en, this message translates to:
  /// **'Windows'**
  String get platformWindows;

  /// No description provided for @platformLinux.
  ///
  /// In en, this message translates to:
  /// **'Linux'**
  String get platformLinux;

  /// No description provided for @platformFuchsia.
  ///
  /// In en, this message translates to:
  /// **'Fuchsia'**
  String get platformFuchsia;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
