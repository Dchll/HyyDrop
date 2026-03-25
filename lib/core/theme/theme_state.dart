import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../logging/app_talker.dart';
import 'theme_prefs.dart';

part 'theme_state.g.dart';

@riverpod
class ThemeState extends _$ThemeState {
  @override
  ThemeMode build() {
    return ThemePrefs.instance.getThemeMode();
  }

  void setMode(ThemeMode mode) {
    if (state == mode) {
      return;
    }

    state = mode;
    appTalker.info('Theme mode changed to ${mode.name}');
    unawaited(
      ThemePrefs.instance
          .setThemeMode(mode)
          .then((_) {
            appTalker.info('Theme mode persisted as ${mode.name}');
          })
          .catchError((error, stack) {
            appTalker.handle(error, stack, 'Failed to persist theme mode');
          }),
    );
  }

  void setSystem() {
    setMode(ThemeMode.system);
  }

  void setLight() {
    setMode(ThemeMode.light);
  }

  void setDark() {
    setMode(ThemeMode.dark);
  }
}
