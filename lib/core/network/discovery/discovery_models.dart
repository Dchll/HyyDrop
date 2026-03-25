import 'package:flutter/foundation.dart';

import '../common/lan_peer.dart';

enum DiscoveryStatus { ready, stopped }

@immutable
class DiscoveryState {
  const DiscoveryState({
    required this.status,
    required this.self,
    required this.peers,
    required this.startedAt,
    this.lastProbeAt,
    this.lastEventAt,
  });

  final DiscoveryStatus status;
  final LanPeer self;
  final List<LanPeer> peers;
  final DateTime startedAt;
  final DateTime? lastProbeAt;
  final DateTime? lastEventAt;

  DiscoveryState copyWith({
    DiscoveryStatus? status,
    LanPeer? self,
    List<LanPeer>? peers,
    DateTime? startedAt,
    DateTime? lastProbeAt,
    DateTime? lastEventAt,
  }) {
    return DiscoveryState(
      status: status ?? this.status,
      self: self ?? this.self,
      peers: peers ?? this.peers,
      startedAt: startedAt ?? this.startedAt,
      lastProbeAt: lastProbeAt ?? this.lastProbeAt,
      lastEventAt: lastEventAt ?? this.lastEventAt,
    );
  }
}
