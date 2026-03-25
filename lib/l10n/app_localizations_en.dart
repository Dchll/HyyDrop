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
}
