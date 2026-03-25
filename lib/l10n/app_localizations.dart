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

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @devicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Nearby Devices'**
  String get devicesTitle;

  /// No description provided for @devicesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'LAN chats, live peers, and transfer activity'**
  String get devicesSubtitle;

  /// No description provided for @onlineLabel.
  ///
  /// In en, this message translates to:
  /// **'online'**
  String get onlineLabel;

  /// No description provided for @offlineLabel.
  ///
  /// In en, this message translates to:
  /// **'offline'**
  String get offlineLabel;

  /// No description provided for @listeningPortLabel.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get listeningPortLabel;

  /// No description provided for @inboxLabel.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get inboxLabel;

  /// No description provided for @serverReadyLabel.
  ///
  /// In en, this message translates to:
  /// **'Transfer server ready'**
  String get serverReadyLabel;

  /// No description provided for @serverStartingLabel.
  ///
  /// In en, this message translates to:
  /// **'Transfer server starting...'**
  String get serverStartingLabel;

  /// No description provided for @emptyPeersBody.
  ///
  /// In en, this message translates to:
  /// **'No nearby device has replied yet. Tap the radar button to probe again.'**
  String get emptyPeersBody;

  /// No description provided for @emptyChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a device'**
  String get emptyChatTitle;

  /// No description provided for @emptyChatBody.
  ///
  /// In en, this message translates to:
  /// **'Your nearby devices and recent transfer conversations will appear here.'**
  String get emptyChatBody;

  /// No description provided for @transferIdleTitle.
  ///
  /// In en, this message translates to:
  /// **'No transfer yet'**
  String get transferIdleTitle;

  /// No description provided for @transferIdleBody.
  ///
  /// In en, this message translates to:
  /// **'This conversation is ready for file transfer. Send a file path to start the first task.'**
  String get transferIdleBody;

  /// No description provided for @chatIdleTitle.
  ///
  /// In en, this message translates to:
  /// **'Start the conversation'**
  String get chatIdleTitle;

  /// No description provided for @chatIdleBody.
  ///
  /// In en, this message translates to:
  /// **'The TCP chat link will open when you enter this device conversation. Send a text or a file to begin.'**
  String get chatIdleBody;

  /// No description provided for @chatIdleLabel.
  ///
  /// In en, this message translates to:
  /// **'Chat idle'**
  String get chatIdleLabel;

  /// No description provided for @chatConnectingLabel.
  ///
  /// In en, this message translates to:
  /// **'Chat connecting'**
  String get chatConnectingLabel;

  /// No description provided for @chatConnectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Chat connected'**
  String get chatConnectedLabel;

  /// No description provided for @chatFailedLabel.
  ///
  /// In en, this message translates to:
  /// **'Chat failed'**
  String get chatFailedLabel;

  /// No description provided for @chatInputHint.
  ///
  /// In en, this message translates to:
  /// **'Send a quick message...'**
  String get chatInputHint;

  /// No description provided for @sendTextAction.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get sendTextAction;

  /// No description provided for @messageSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Text message failed to send.'**
  String get messageSendFailed;

  /// No description provided for @sendFileAction.
  ///
  /// In en, this message translates to:
  /// **'Send File'**
  String get sendFileAction;

  /// No description provided for @enterPathTitle.
  ///
  /// In en, this message translates to:
  /// **'Send a file'**
  String get enterPathTitle;

  /// No description provided for @filePathLabel.
  ///
  /// In en, this message translates to:
  /// **'Local file path'**
  String get filePathLabel;

  /// No description provided for @filePathHint.
  ///
  /// In en, this message translates to:
  /// **'/Users/you/Desktop/demo.zip'**
  String get filePathHint;

  /// No description provided for @cancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelAction;

  /// No description provided for @pathRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid local file path.'**
  String get pathRequiredMessage;

  /// No description provided for @sendQueuedMessage.
  ///
  /// In en, this message translates to:
  /// **'Transfer task queued.'**
  String get sendQueuedMessage;

  /// No description provided for @statusQueued.
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get statusQueued;

  /// No description provided for @statusConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting'**
  String get statusConnecting;

  /// No description provided for @statusSending.
  ///
  /// In en, this message translates to:
  /// **'Sending'**
  String get statusSending;

  /// No description provided for @statusReceiving.
  ///
  /// In en, this message translates to:
  /// **'Receiving'**
  String get statusReceiving;

  /// No description provided for @statusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get statusDone;

  /// No description provided for @statusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get statusFailed;

  /// No description provided for @speedShortLabel.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speedShortLabel;

  /// No description provided for @etaShortLabel.
  ///
  /// In en, this message translates to:
  /// **'ETA'**
  String get etaShortLabel;
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
