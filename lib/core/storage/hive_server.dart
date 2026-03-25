import 'dart:io';
import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'hive_box.dart';
import 'hive_key.dart';

class HiveServer {
  HiveServer._();

  static final HiveServer instance = HiveServer._();

  static const _defaultDirectoryName = 'hive_boxes';

  bool _initialized = false;
  String? _homePath;

  bool get isInitialized => _initialized;

  String get homePath {
    final path = _homePath;
    if (path == null) {
      throw StateError('HiveServer has not been initialized.');
    }
    return path;
  }

  Future<void> init({String directoryName = _defaultDirectoryName}) async {
    if (_initialized) {
      return;
    }

    final baseDirectory = await getApplicationSupportDirectory();
    final hiveDirectory = Directory('${baseDirectory.path}/$directoryName');

    if (!await hiveDirectory.exists()) {
      await hiveDirectory.create(recursive: true);
    }

    Hive.init(hiveDirectory.path);

    _homePath = hiveDirectory.path;
    _initialized = true;
  }

  void registerAdapter<T>(TypeAdapter<T> adapter, {bool override = false}) {
    _ensureInitialized();

    if (!Hive.isAdapterRegistered(adapter.typeId) || override) {
      Hive.registerAdapter<T>(adapter, override: override);
    }
  }

  Future<Box<dynamic>> openBox(
    HiveBox box, {
    HiveCipher? encryptionCipher,
    CompactionStrategy compactionStrategy = _defaultCompactionStrategy,
    bool crashRecovery = true,
    Uint8List? bytes,
    String? collection,
  }) async {
    _ensureInitialized();

    return Hive.openBox<dynamic>(
      box.value,
      encryptionCipher: encryptionCipher,
      compactionStrategy: compactionStrategy,
      crashRecovery: crashRecovery,
      bytes: bytes,
      collection: collection,
    );
  }

  Box<dynamic> box(HiveBox box) {
    _ensureInitialized();
    return Hive.box<dynamic>(box.value);
  }

  bool isBoxOpen(HiveBox box) {
    _ensureInitialized();
    return Hive.isBoxOpen(box.value);
  }

  Future<bool> boxExists(HiveBox box) async {
    _ensureInitialized();
    return Hive.boxExists(box.value);
  }

  Future<E?> get<E>(HiveKey key, {E? defaultValue}) async {
    final openedBox = await openBox(key.box);
    final value = openedBox.get(key.value, defaultValue: defaultValue);
    return value as E?;
  }

  Future<Iterable<dynamic>> keys(HiveBox box) async {
    final openedBox = await openBox(box);
    return openedBox.keys;
  }

  Future<List<E>> values<E>(HiveBox box) async {
    final openedBox = await openBox(box);
    return openedBox.values.cast<E>().toList(growable: false);
  }

  Future<void> put<E>(HiveKey key, E value) async {
    final openedBox = await openBox(key.box);
    await openedBox.put(key.value, value);
  }

  Future<int> add<E>(HiveBox box, E value) async {
    final openedBox = await openBox(box);
    return openedBox.add(value);
  }

  Future<void> putAll<E>(HiveBox box, Map<dynamic, E> entries) async {
    final openedBox = await openBox(box);
    await openedBox.putAll(entries);
  }

  Future<void> delete(HiveKey key) async {
    final openedBox = await openBox(key.box);
    await openedBox.delete(key.value);
  }

  Future<void> clear(HiveBox box) async {
    final openedBox = await openBox(box);
    await openedBox.clear();
  }

  Future<void> closeBox(HiveBox box) async {
    _ensureInitialized();

    if (Hive.isBoxOpen(box.value)) {
      await Hive.box<dynamic>(box.value).close();
    }
  }

  Future<void> deleteBoxFromDisk(HiveBox box) async {
    _ensureInitialized();
    await Hive.deleteBoxFromDisk(box.value);
  }

  Future<void> close() async {
    _ensureInitialized();
    await Hive.close();
  }

  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError(
        'HiveServer is not initialized. Call HiveServer.instance.init() first.',
      );
    }
  }

  static bool _defaultCompactionStrategy(int entries, int deletedEntries) {
    return deletedEntries > 20 && deletedEntries / entries > 0.2;
  }
}
