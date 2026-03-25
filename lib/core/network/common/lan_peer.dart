import 'dart:convert';

import 'net_ports.dart';

class LanPeer {
  const LanPeer({
    required this.id,
    required this.name,
    required this.host,
    required this.chatPort,
    required this.transferPort,
    required this.app,
    required this.version,
    required this.platform,
    required this.lastSeen,
  });

  final String id;
  final String name;
  final String host;
  final int chatPort;
  final int transferPort;
  final String app;
  final String version;
  final String platform;
  final DateTime lastSeen;

  int get port => transferPort;

  Map<String, Object?> toPacket() {
    return {
      'id': id,
      'name': name,
      'chatPort': chatPort,
      'transferPort': transferPort,
      'port': transferPort,
      'app': app,
      'version': version,
      'platform': platform,
    };
  }

  String toPacketJson(String kind) {
    return jsonEncode({'kind': kind, 'peer': toPacket()});
  }

  LanPeer copyWith({
    String? id,
    String? name,
    String? host,
    int? chatPort,
    int? transferPort,
    String? app,
    String? version,
    String? platform,
    DateTime? lastSeen,
  }) {
    return LanPeer(
      id: id ?? this.id,
      name: name ?? this.name,
      host: host ?? this.host,
      chatPort: chatPort ?? this.chatPort,
      transferPort: transferPort ?? this.transferPort,
      app: app ?? this.app,
      version: version ?? this.version,
      platform: platform ?? this.platform,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  static LanPeer? fromPacketJson(
    String source, {
    required String host,
    required DateTime seenAt,
  }) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, dynamic>) {
      return null;
    }

    final peer = decoded['peer'];
    if (peer is! Map<String, dynamic>) {
      return null;
    }

    final id = peer['id'];
    final name = peer['name'];
    final chatPort = peer['chatPort'];
    final transferPort = peer['transferPort'] ?? peer['port'];
    final app = peer['app'];
    final version = peer['version'];
    final platform = peer['platform'];

    if (id is! String ||
        name is! String ||
        transferPort is! num ||
        app is! String ||
        version is! String ||
        platform is! String) {
      return null;
    }

    return LanPeer(
      id: id,
      name: name,
      host: host,
      chatPort: chatPort is num ? chatPort.toInt() : NetPorts.chat,
      transferPort: transferPort.toInt(),
      app: app,
      version: version,
      platform: platform,
      lastSeen: seenAt,
    );
  }
}
