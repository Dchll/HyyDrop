import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';

import 'app_talker.dart';

final TalkerRiverpodObserver appRiverpodObserver = TalkerRiverpodObserver(
  talker: appTalker,
  settings: const TalkerRiverpodLoggerSettings(
    enabled: true,
    printProviderAdded: true,
    printProviderUpdated: true,
    printProviderDisposed: true,
    printProviderFailed: true,
  ),
);
