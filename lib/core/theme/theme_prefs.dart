import 'package:flutter/material.dart';
import 'package:hyy_drop/core/logging/app_talker.dart';

import '../storage/hive_box.dart';
import '../storage/hive_key.dart';
import '../storage/hive_server.dart';

class ThemePrefs {
  ThemePrefs._();

  static final ThemePrefs instance = ThemePrefs._();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) {
      return;
    }

    await HiveServer.instance.openBox(HiveBox.settings);
    _initialized = true;
    appTalker.info('Theme preferences initialized');
  }

  ThemeMode getThemeMode() {
    _ensureInitialized();

    final stored = HiveServer.instance
        .box(HiveBox.settings)
        .get(HiveKey.themeMode.value);

    if (stored is! String) {
      return ThemeMode.system;
    }

    return switch (stored) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _ensureInitialized();
    await HiveServer.instance.put<String>(HiveKey.themeMode, mode.name);
  }

  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError(
        'ThemePrefs is not initialized. Call ThemePrefs.instance.init() first.',
      );
    }
  }
}
