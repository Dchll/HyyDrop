import 'dart:async';
import 'dart:io';

import '../common/lan_peer.dart';
import 'discovery_service.dart';

class DiscoveryRepo {
  DiscoveryRepo(this._service);

  static const staleAfter = Duration(seconds: 12);
  static const heartbeatEvery = Duration(seconds: 3);

  final DiscoveryService _service;
  final _peersCtrl = StreamController<List<LanPeer>>.broadcast();
  final _peers = <String, LanPeer>{};
  final _heartbeats = <String, Timer>{};

  Stream<List<LanPeer>> get peers => _peersCtrl.stream;

  List<LanPeer> get snapshot => _sortedPeers();

  Future<void> start(LanPeer self) async {
    await _service.start(
      self: self,
      onPeer: (peer) {
        _peers[peer.id] = peer;
        _ensureHeartbeat(peer.id);
        _emit();
      },
    );
  }

  Future<void> probe() async {
    await _service.probe();
    await _service.announce();
  }

  void prune() {
    final cutoff = DateTime.now().subtract(staleAfter);
    final stale = _peers.entries
        .where((entry) => entry.value.lastSeen.isBefore(cutoff))
        .map((entry) => entry.key)
        .toList(growable: false);

    if (stale.isEmpty) {
      return;
    }

    for (final id in stale) {
      _peers.remove(id);
      _cancelHeartbeat(id);
    }

    _emit();
  }

  Future<void> close() async {
    for (final timer in _heartbeats.values) {
      timer.cancel();
    }
    _heartbeats.clear();
    await _service.close();
    await _peersCtrl.close();
  }

  void _ensureHeartbeat(String peerId) {
    if (_heartbeats.containsKey(peerId)) {
      return;
    }

    _heartbeats[peerId] = Timer.periodic(heartbeatEvery, (_) {
      final peer = _peers[peerId];
      if (peer == null) {
        _cancelHeartbeat(peerId);
        return;
      }

      unawaited(_service.beat(InternetAddress(peer.host)));
    });
  }

  void _cancelHeartbeat(String peerId) {
    _heartbeats.remove(peerId)?.cancel();
  }

  void _emit() {
    if (_peersCtrl.isClosed) {
      return;
    }

    _peersCtrl.add(_sortedPeers());
  }

  List<LanPeer> _sortedPeers() {
    final list = _peers.values.toList(growable: false)
      ..sort((a, b) {
        final seen = b.lastSeen.compareTo(a.lastSeen);
        if (seen != 0) {
          return seen;
        }
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });

    return list;
  }
}
