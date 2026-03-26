import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hyy_drop/core/network/chat/chat_provider.dart';
import 'package:hyy_drop/core/network/discovery/discovery_provider.dart';
import 'package:hyy_drop/core/router/app_router.dart';
import 'package:hyy_drop/core/network/transfer/transfer_provider.dart';
import 'package:hyy_drop/l10n/app_localizations.dart';

import 'core/locale/app_locale.dart';
import 'core/locale/locale_prefs.dart';
import 'core/locale/locale_state.dart';
import 'core/logging/app_riverpod_observer.dart';
import 'core/logging/app_talker.dart';
import 'core/storage/hive_server.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_prefs.dart';
import 'core/theme/theme_state.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (details) {
        appTalker.handle(
          details.exception,
          details.stack ?? StackTrace.current,
          'Flutter framework error',
        );
        FlutterError.presentError(details);
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        appTalker.handle(error, stack, 'Platform dispatcher error');
        return true;
      };

      await HiveServer.instance.init();

      await ThemePrefs.instance.init();

      await LocalePrefs.instance.init();

      runApp(ProviderScope(observers: [appRiverpodObserver], child: MyApp()));
      appTalker.info('Application started');
    },
    (error, stack) {
      appTalker.handle(error, stack, 'runZonedGuarded error');
    },
  );
}

class MyApp extends ConsumerWidget {
  final _appRouter = AppRouter();

  MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocale = ref.watch(appLocaleProvider);

    return _AppBootstrap(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
        themeMode: ref.watch(themeStateProvider),
        locale: appLocale.locale,
        supportedLocales: AppLocale.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: _appRouter.config(),
      ),
    );
  }
}

class _AppBootstrap extends ConsumerWidget {
  const _AppBootstrap({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(chatHubProvider, (previous, next) {});
    ref.listen(transferHubProvider, (previous, next) {});
    ref.listen(discoveryHubProvider, (previous, next) {});
    return child;
  }
}
