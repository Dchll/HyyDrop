import 'dart:async';

import 'package:hyy_drop/core/logging/app_talker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../common/lan_peer.dart';
import '../common/net_retry.dart';
import '../common/self_peer_provider.dart';
import '../transfer/transfer_provider.dart';
import 'discovery_models.dart';
import 'discovery_repo.dart';
import 'discovery_service.dart';

part 'discovery_provider.g.dart';

@Riverpod(keepAlive: true, retry: netRetry)
class DiscoveryHub extends _$DiscoveryHub {
  DiscoveryRepo? _repo;
  StreamSubscription<List<LanPeer>>? _sub;
  Timer? _pruneTimer;

  @override
  Future<DiscoveryState> build() async {
    await ref.watch(transferHubProvider.future);
    final self = await ref.watch(selfPeerProvider.future);

    final repo = DiscoveryRepo(DiscoveryService());
    _repo = repo;

    ref.onDispose(() {
      _pruneTimer?.cancel();
      unawaited(_sub?.cancel() ?? Future<void>.value());
      unawaited(repo.close());
    });

    _sub = repo.peers.listen(
      (peers) {
        final current = state.asData?.value;
        if (current == null) {
          return;
        }

        state = AsyncData(
          current.copyWith(peers: peers, lastEventAt: DateTime.now()),
        );
      },
      onError: (Object error, StackTrace stack) {
        appTalker.handle(error, stack, 'Discovery repo stream failed');
      },
    );

    await repo.start(self);
    _pruneTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      repo.prune();
    });

    final now = DateTime.now();
    return DiscoveryState(
      status: DiscoveryStatus.ready,
      self: self,
      peers: repo.snapshot,
      startedAt: now,
      lastProbeAt: now,
      lastEventAt: now,
    );
  }

  Future<void> probe() async {
    if (_repo == null) {
      appTalker.info('Discovery probe waiting for startup');
      await future;
    }

    final repo = _repo;
    if (repo == null) {
      appTalker.warning(
        'Discovery probe skipped because service is unavailable',
      );
      return;
    }

    appTalker.info('Manual discovery probe requested');
    await repo.probe();

    final current = state.asData?.value;
    if (current != null) {
      state = AsyncData(current.copyWith(lastProbeAt: DateTime.now()));
    }
  }

  Future<void> stop() async {
    final repo = _repo;
    final current = state.asData?.value;
    if (repo == null || current == null) {
      return;
    }

    await repo.close();
    _repo = null;
    state = AsyncData(current.copyWith(status: DiscoveryStatus.stopped));
  }
}
