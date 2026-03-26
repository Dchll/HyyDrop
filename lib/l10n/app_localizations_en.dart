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

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsExploreTitle => 'More';

  @override
  String get settingsExploreSubtitle => 'Open dedicated detail pages';

  @override
  String get settingsAboutTitle => 'About';

  @override
  String get settingsAboutSubtitle => 'Project and font information';

  @override
  String get settingsAboutBody =>
      'This page records the app\'s visual and technical attribution used in the current build.';

  @override
  String get settingsAboutFontSectionTitle => 'Default Font';

  @override
  String get settingsAboutFontNotice =>
      'This app uses MiSans VF from `assets/fonts/MiSans VF.ttf` as the global default font.';

  @override
  String get settingsAboutFontSample =>
      'MiSans VF Sample: HyyDrop 传输体验 / Transfer Experience';

  @override
  String get packageInfoPageTitle => 'Package Info';

  @override
  String get packageInfoPageSubtitle =>
      'Detailed package metadata for the current app build.';

  @override
  String get deviceInfoPageTitle => 'Device Info';

  @override
  String get deviceInfoPageSubtitle =>
      'Detailed runtime device snapshot for this device.';

  @override
  String get homePageHeadline => 'Notifications & LAN Transfer';

  @override
  String get homePageSubtitle =>
      'Jump into the notification composer or nearby device sessions from a home screen that now follows the same light card language.';

  @override
  String get dailySentenceTitle => 'Daily Sentence';

  @override
  String get dailySentenceHint => 'Tap the card to refresh it.';

  @override
  String get dailySentenceFallback => 'Nothing is available to show right now.';

  @override
  String get loadingLabel => 'Loading...';

  @override
  String get openDevicesAction => 'Open Device List';

  @override
  String get devicesTitle => 'Nearby Devices';

  @override
  String get devicesSubtitle => 'LAN chats, live peers, and transfer activity';

  @override
  String get onlineLabel => 'online';

  @override
  String get offlineLabel => 'offline';

  @override
  String get listeningPortLabel => 'Port';

  @override
  String get inboxLabel => 'Inbox';

  @override
  String get serverReadyLabel => 'Transfer server ready';

  @override
  String get serverStartingLabel => 'Transfer server starting...';

  @override
  String get emptyPeersBody =>
      'No nearby device has replied yet. Tap the radar button to probe again.';

  @override
  String get emptyChatTitle => 'Choose a device';

  @override
  String get emptyChatBody =>
      'Your nearby devices and recent transfer conversations will appear here.';

  @override
  String get transferIdleTitle => 'No transfer yet';

  @override
  String get transferIdleBody =>
      'This conversation is ready for file transfer. Send a file path to start the first task.';

  @override
  String get chatIdleTitle => 'Start the conversation';

  @override
  String get chatIdleBody =>
      'The TCP chat link will open when you enter this device conversation. Send a text or a file to begin.';

  @override
  String get chatIdleLabel => 'Chat idle';

  @override
  String get chatConnectingLabel => 'Chat connecting';

  @override
  String get chatConnectedLabel => 'Chat connected';

  @override
  String get chatFailedLabel => 'Chat failed';

  @override
  String get chatInputHint => 'Send a quick message...';

  @override
  String get sendTextAction => 'Send';

  @override
  String get messageSendFailed => 'Text message failed to send.';

  @override
  String get sendFileAction => 'Send File';

  @override
  String get enterPathTitle => 'Send a file';

  @override
  String get filePathLabel => 'Local file path';

  @override
  String get filePathHint => '/Users/you/Desktop/demo.zip';

  @override
  String get cancelAction => 'Cancel';

  @override
  String get pathRequiredMessage => 'Please enter a valid local file path.';

  @override
  String get sendQueuedMessage => 'Transfer task queued.';

  @override
  String get statusQueued => 'Queued';

  @override
  String get statusConnecting => 'Connecting';

  @override
  String get statusSending => 'Sending';

  @override
  String get statusReceiving => 'Receiving';

  @override
  String get statusDone => 'Done';

  @override
  String get statusFailed => 'Failed';

  @override
  String get speedShortLabel => 'Speed';

  @override
  String get etaShortLabel => 'ETA';

  @override
  String get liveUpdateOpenComposerAction => 'Send Notification';

  @override
  String get liveUpdatePageTitle => 'Live Update Composer';

  @override
  String get liveUpdatePageSubtitle =>
      'Customize the live update payload and send it straight to the Android notification bridge.';

  @override
  String get liveUpdateStyleSectionTitle => 'Notification Style';

  @override
  String get liveUpdateStyleBigText => 'BigTextStyle';

  @override
  String get liveUpdateStyleCall => 'CallStyle';

  @override
  String get liveUpdateStyleProgress => 'ProgressStyle';

  @override
  String get liveUpdateStyleMetric => 'MetricStyle';

  @override
  String get liveUpdateStyleBigTextHint =>
      'Expanded text layout for longer title-and-body updates.';

  @override
  String get liveUpdateStyleCallHint =>
      'Call-focused layout for incoming, ongoing, or screening call cards.';

  @override
  String get liveUpdateStyleProgressHint =>
      'Progress bar layout. On unsupported Android versions it falls back automatically.';

  @override
  String get liveUpdateStyleMetricHint =>
      'Metric card layout. On unsupported Android versions it falls back automatically.';

  @override
  String get liveUpdateTitleLabel => 'Title';

  @override
  String get liveUpdateBodyLabel => 'Body';

  @override
  String get liveUpdateSubTextLabel => 'Subtext';

  @override
  String get liveUpdateCallPersonLabel => 'Caller Name';

  @override
  String get liveUpdateCallBodyLabel => 'Call Note';

  @override
  String get liveUpdateCallVerificationLabel => 'Verification Text';

  @override
  String get liveUpdateCallTypeSectionTitle => 'Call Type';

  @override
  String get liveUpdateCallTypeIncoming => 'Incoming';

  @override
  String get liveUpdateCallTypeOngoing => 'Ongoing';

  @override
  String get liveUpdateCallTypeScreening => 'Screening';

  @override
  String get liveUpdateCallVideoLabel => 'Video Call';

  @override
  String get liveUpdateCallBodyFallback => 'Call in progress';

  @override
  String get liveUpdateMetricBodyLabel => 'Summary';

  @override
  String get liveUpdateMetricPrimaryTitle => 'Primary Metric';

  @override
  String get liveUpdateMetricSecondaryTitle => 'Secondary Metric';

  @override
  String get liveUpdateMetricTertiaryTitle => 'Tertiary Metric';

  @override
  String get liveUpdateMetricLabelField => 'Metric Label';

  @override
  String get liveUpdateMetricValueField => 'Metric Value';

  @override
  String get liveUpdateMetricBodyFallback => 'Metric update';

  @override
  String get liveUpdateMetricPairIncomplete =>
      'Each optional metric needs both a label and a value.';

  @override
  String get liveUpdateShortCriticalTextLabel => 'Short Critical Text';

  @override
  String get liveUpdateProgressLabel => 'Progress';

  @override
  String get liveUpdateProgressHint => 'Enter an integer from 0 to 100';

  @override
  String liveUpdateFieldRequired(Object fieldLabel) {
    return 'Please enter $fieldLabel.';
  }

  @override
  String get liveUpdateProgressRequired => 'Please enter progress.';

  @override
  String get liveUpdateProgressInvalid =>
      'Progress must be an integer from 0 to 100.';

  @override
  String get liveUpdateSendAction => 'Send Live Update';

  @override
  String get liveUpdateToastSuccess => 'Notification updated';

  @override
  String get liveUpdateShortTextRefreshLabel => 'Short Text Refresh Interval';

  @override
  String get liveUpdateShortTextRefreshHint =>
      'Use the slider to set the short text rotation interval from 1 to 10 seconds.';

  @override
  String liveUpdateShortTextRefreshValue(Object seconds) {
    return '${seconds}s';
  }

  @override
  String get liveUpdateShortTextPreviewTitle => 'Short Text Preview';

  @override
  String get liveUpdateShortTextPreviewEmpty =>
      'Enter short text to preview how it will be split and rotated.';
}
