import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hyy_drop/core/logging/app_talker.dart';

import '../common/lan_peer.dart';
import '../common/net_env.dart';
import '../common/net_ports.dart';

class DiscoveryService {
  DiscoveryService();

  RawDatagramSocket? _socket;
  StreamSubscription<RawSocketEvent>? _sub;
  LanPeer? _self;
  void Function(LanPeer peer)? _onPeer;

  Future<void> start({
    required LanPeer self,
    required void Function(LanPeer peer) onPeer,
  }) async {
    if (_socket != null) {
      return;
    }

    await NetEnv.instance.prepareDiscovery();

    final socket = await RawDatagramSocket.bind(
      InternetAddress.anyIPv4,
      NetPorts.discovery,
      reuseAddress: true,
      reusePort: true,
    );

    socket.broadcastEnabled = true;
    socket.readEventsEnabled = true;

    _socket = socket;
    _self = self;
    _onPeer = onPeer;
    _sub = socket.listen(
      _onEvent,
      onError: (Object error, StackTrace stack) {
        appTalker.handle(error, stack, 'Discovery socket stream failed');
      },
    );
  }

  Future<void> probe() async {
    await _send('probe');
  }

  Future<void> announce([InternetAddress? target]) async {
    await _send('hello', target: target);
  }

  Future<void> beat(InternetAddress target) async {
    await _send('beat', target: target);
  }

  Future<void> close() async {
    await _sub?.cancel();
    _socket?.close();
    _socket = null;
    _self = null;
    _onPeer = null;
    await NetEnv.instance.releaseDiscovery();
  }

  void _onEvent(RawSocketEvent event) {
    if (event != RawSocketEvent.read) {
      return;
    }

    final socket = _socket;
    final self = _self;
    final onPeer = _onPeer;
    if (socket == null || self == null || onPeer == null) {
      return;
    }

    Datagram? datagram;
    while ((datagram = socket.receive()) != null) {
      final packet = datagram!;
      final payload = utf8.decode(packet.data, allowMalformed: true);
      appTalker.debug(
        'Discovery recv <- ${packet.address.address}:${packet.port} $payload',
      );
      final peer = LanPeer.fromPacketJson(
        payload,
        host: packet.address.address,
        seenAt: DateTime.now(),
      );

      if (peer == null || peer.id == self.id) {
        continue;
      }

      onPeer(peer);

      if (_kindOf(payload) == 'probe') {
        unawaited(announce(packet.address));
      }
    }
  }

  Future<void> _send(String kind, {InternetAddress? target}) async {
    final socket = _socket;
    final self = _self;
    if (socket == null || self == null) {
      return;
    }

    final payload = self.toPacketJson(kind);
    final data = utf8.encode(payload);
    final host = target ?? InternetAddress('255.255.255.255');
    appTalker.debug(
      'Discovery send -> ${host.address}:${NetPorts.discovery} $payload',
    );
    final bytes = socket.send(data, host, NetPorts.discovery);
    appTalker.debug(
      'Discovery sent bytes=$bytes kind=$kind target=${host.address}:${NetPorts.discovery}',
    );
  }

  String? _kindOf(String payload) {
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) {
        final kind = decoded['kind'];
        return kind is String ? kind : null;
      }
    } catch (_) {
      return null;
    }

    return null;
  }
}
