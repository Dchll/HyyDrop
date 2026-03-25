import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../logging/app_talker.dart';
import 'app_locale.dart';
import 'locale_prefs.dart';

final appLocaleProvider = NotifierProvider<AppLocaleNotifier, AppLocale>(
  AppLocaleNotifier.new,
);

class AppLocaleNotifier extends Notifier<AppLocale> {
  @override
  AppLocale build() {
    return LocalePrefs.instance.getLocale();
  }

  void setLocale(AppLocale locale) {
    if (state == locale) {
      return;
    }

    state = locale;
    appTalker.info('App locale changed to ${locale.storageValue}');
    unawaited(
      LocalePrefs.instance.setLocale(locale).then((_) {
        appTalker.info('App locale persisted as ${locale.storageValue}');
      }).catchError((error, stack) {
        appTalker.handle(error, stack, 'Failed to persist app locale');
      }),
    );
  }
}
