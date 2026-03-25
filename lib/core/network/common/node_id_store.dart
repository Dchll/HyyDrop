import 'dart:math';

import 'package:hyy_drop/core/storage/hive_key.dart';
import 'package:hyy_drop/core/storage/hive_server.dart';

class NodeIdStore {
  NodeIdStore._();

  static final NodeIdStore instance = NodeIdStore._();
  static const _alphabet = '0123456789abcdef';

  Future<String> getOrCreate() async {
    final stored = await HiveServer.instance.get<String>(HiveKey.localNodeId);
    if (stored != null && stored.isNotEmpty) {
      return stored;
    }

    final created = _newId();
    await HiveServer.instance.put<String>(HiveKey.localNodeId, created);
    return created;
  }

  String _newId() {
    final random = Random.secure();
    final chars = List.generate(
      24,
      (_) => _alphabet[random.nextInt(_alphabet.length)],
      growable: false,
    );

    return chars.join();
  }
}
