# HYY Drop Agent Guide

All AI agents must read this file before making changes in this repository.

If a user instruction conflicts with this file, follow the user instruction first.

## Purpose

This project is a Flutter app for LAN file transfer.

This file is the single root-level source of truth for project conventions, architecture expectations, and validation commands. Treat it as the default entry point for agent work in this repo.

## Stack Summary

- Flutter
- Material 3
- Riverpod with code generation
- AutoRoute
- Hive
- Talker
- Flutter localization with ARB files

## Project Layout

- `lib/main.dart`
  App startup and global initialization only. Keep it thin.
- `lib/core/`
  Cross-feature infrastructure and shared foundations.
- `lib/core/logging/`
  Global logging setup based on Talker.
- `lib/core/storage/`
  Hive access layer, box enums, key enums.
- `lib/core/router/`
  AutoRoute router definition and generated route file.
- `lib/core/theme/`
  Color system, theme building, theme persistence, theme state.
- `lib/core/locale/`
  Locale model, locale persistence, locale state.
- `lib/features/<feature>/presentation/`
  Feature UI layer. The current repo uses `home/presentation`.
- `lib/l10n/`
  ARB localization files.

## Startup Rules

- Keep initialization order stable in `lib/main.dart`.
- Initialize Flutter bindings inside the same zone used by `runApp`.
- Register global error handling before running the app.
- Initialize `HiveServer` before any preference or storage access.
- Initialize `ThemePrefs` and `LocalePrefs` before any provider reads them.
- The app must stay wrapped with `ProviderScope(observers: [appRiverpodObserver])`.

Current startup sequence is:

1. `WidgetsFlutterBinding.ensureInitialized()`
2. Wire `FlutterError.onError`
3. Wire `PlatformDispatcher.instance.onError`
4. `HiveServer.instance.init()`
5. `ThemePrefs.instance.init()`
6. `LocalePrefs.instance.init()`
7. `runApp(...)`

## Logging Rules

Use Talker as the only application logging entry point.

- Global logger: `lib/core/logging/app_talker.dart`
- Riverpod observer: `lib/core/logging/app_riverpod_observer.dart`

Rules:

- Use `appTalker.info`, `debug`, `warning`, and `error` for business and lifecycle logs.
- Use `appTalker.handle(error, stack, message)` for exceptions and async failures.
- Do not add `print` or `debugPrint` for normal project logging.
- Riverpod provider lifecycle logging is already connected through `appRiverpodObserver`; do not duplicate the same provider change logs manually.
- Log meaningful state changes such as theme, locale, startup, storage initialization, and recoverable failures.

## Persistence Rules

Use Hive only through the storage layer under `lib/core/storage/`.

Files:

- `lib/core/storage/hive_server.dart`
- `lib/core/storage/hive_box.dart`
- `lib/core/storage/hive_key.dart`

Rules:

- Never hardcode box names as strings.
- Never hardcode storage keys as strings.
- Always use `HiveBox` and `HiveKey`.
- Prefer `HiveServer.instance.get`, `put`, `delete`, `values`, and related helpers.
- Open boxes through `HiveServer.instance.openBox(...)`.
- Do not create ad hoc Hive setup in features.
- Shared preferences-like data belongs in the `settings` box unless there is a clear reason to separate it.
- New persisted entries must be added to `HiveKey`.
- New boxes must be added to `HiveBox`.

Current boxes:

- `HiveBox.settings`
- `HiveBox.devices`
- `HiveBox.transfers`

Current keys:

- `HiveKey.themeMode`
- `HiveKey.locale`
- `HiveKey.lastConnectedDeviceId`
- `HiveKey.lastTransferTaskId`

## Theme Rules

Theme infrastructure lives in `lib/core/theme/`.

Files:

- `lib/core/theme/app_color_scheme.dart`
- `lib/core/theme/app_theme.dart`
- `lib/core/theme/app_theme_extension.dart`
- `lib/core/theme/theme_prefs.dart`
- `lib/core/theme/theme_state.dart`

Rules:

- Use `AppTheme.light` and `AppTheme.dark` as the only app themes.
- Shared semantic custom colors must go into `AppThemeExtension`.
- Core Material color tokens must go into `AppColorScheme`.
- Do not scatter raw brand colors through feature pages.
- Dark theme must preserve the OLED strategy already used in this repo, including true black surfaces where appropriate.
- Theme mode persistence must go through `ThemePrefs`, not directly through widgets.
- UI reads theme mode from `themeStateProvider`.

## Localization Rules

Localization resources live in `lib/l10n/`, and locale state lives in `lib/core/locale/`.

Files:

- `lib/core/locale/app_locale.dart`
- `lib/core/locale/locale_prefs.dart`
- `lib/core/locale/locale_state.dart`
- `lib/l10n/*.arb`
- `l10n.yaml`

Rules:

- Current target languages are Simplified Chinese, Traditional Chinese, and English.
- Add user-facing strings to ARB files, not inline in widgets.
- Keep `AppLocale` in sync with supported languages.
- Locale persistence must go through `LocalePrefs`.
- UI reads locale state from `appLocaleProvider`.
- When adding a new language, update ARB files, locale definitions, and generated localization output together.

Note:

- The repo already contains localization scaffolding, but agents should validate `gen-l10n` output after locale-related changes instead of assuming localization is already fully healthy.

## Routing Rules

Routing uses AutoRoute.

Files:

- `lib/core/router/app_router.dart`
- `lib/core/router/app_router.gr.dart`

Rules:

- Define application routes in `app_router.dart`.
- Annotate route pages with `@RoutePage()`.
- Do not manually edit `app_router.gr.dart`.
- Run code generation after route changes.
- Keep `main.dart` routing setup simple and centralized through `AppRouter`.

## Riverpod Rules

State management uses Riverpod, and this repo already uses generated providers for some core state.

Rules:

- Prefer Riverpod for app state and app-level coordination.
- Put business state in providers, not in widgets.
- Keep persistence side effects inside dedicated preference/storage services plus provider notifiers.
- UI widgets should trigger provider methods, not write to Hive directly.
- For annotated providers, keep class names short and domain-based because Riverpod generates provider names from them.
- Do not manually edit generated Riverpod files such as `*.g.dart`.

Current examples:

- `ThemeState` in `lib/core/theme/theme_state.dart`
- `appLocaleProvider` in `lib/core/locale/locale_state.dart`

## File And Editing Rules

- Keep `main.dart` focused on bootstrapping.
- Put shared infrastructure in `lib/core/`.
- Put feature UI under `lib/features/<feature>/presentation/`.
- Prefer one clear responsibility per file.
- Generated files must not be edited manually.
- Current generated files include:
  - `lib/core/router/app_router.gr.dart`
  - `lib/core/theme/theme_state.g.dart`
- When a file is generated, edit the source file with annotations instead.
- Keep public APIs small and intention-revealing.
- Reuse existing abstractions before introducing new service layers.

## Commands

Use these commands after relevant changes:

- Install dependencies:
  `flutter pub get`
- Format Dart files:
  `dart format .`
- Regenerate Riverpod and AutoRoute files:
  `flutter pub run build_runner build --delete-conflicting-outputs`
- Regenerate localization output:
  `flutter gen-l10n`
- Static analysis:
  `flutter analyze`
- Tests:
  `flutter test`

Recommended validation order after code changes:

1. `dart format .`
2. `flutter pub run build_runner build --delete-conflicting-outputs` if annotations or routes changed
3. `flutter gen-l10n` if localization changed
4. `flutter analyze`
5. `flutter test`

## Agent Expectations

- Read this file before editing anything.
- Prefer small, targeted changes that follow existing project structure.
- Do not introduce a second logging system.
- Do not bypass `HiveBox` and `HiveKey`.
- Do not bypass AutoRoute with ad hoc navigation architecture changes unless the user asks for it.
- Do not bypass Riverpod for app state.
- If you change routes, providers, or localization resources, regenerate code before finishing.
