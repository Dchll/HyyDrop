import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyy_drop/core/locale/app_locale.dart';
import 'package:hyy_drop/core/theme/app_theme.dart';

void main() {
  test('OLED dark theme keeps the background black', () {
    expect(AppTheme.dark.scaffoldBackgroundColor, Colors.black);
    expect(AppTheme.dark.colorScheme.surface, Colors.black);
  });

  test('supported locales stay stable', () {
    expect(AppLocale.supportedLocales, const [
      Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
      Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
      Locale('en'),
    ]);
  });
}
