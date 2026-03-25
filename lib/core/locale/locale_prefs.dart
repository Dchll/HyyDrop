import '../storage/hive_box.dart';
import '../storage/hive_key.dart';
import '../storage/hive_server.dart';
import 'app_locale.dart';

class LocalePrefs {
  LocalePrefs._();

  static final LocalePrefs instance = LocalePrefs._();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) {
      return;
    }

    await HiveServer.instance.openBox(HiveBox.settings);
    _initialized = true;
  }

  AppLocale getLocale() {
    _ensureInitialized();

    final stored = HiveServer.instance
        .box(HiveBox.settings)
        .get(HiveKey.locale.value);

    if (stored is! String) {
      return AppLocale.system;
    }

    return AppLocale.fromStorage(stored);
  }

  Future<void> setLocale(AppLocale locale) async {
    _ensureInitialized();
    await HiveServer.instance.put<String>(HiveKey.locale, locale.storageValue);
  }

  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError(
        'LocalePrefs is not initialized. Call LocalePrefs.instance.init() first.',
      );
    }
  }
}
