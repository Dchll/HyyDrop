import 'package:talker/talker.dart';

final Talker appTalker = Talker(
  settings: TalkerSettings(
    enabled: true,
    useConsoleLogs: true,
    useHistory: true,
    maxHistoryItems: 500,
  ),
);
