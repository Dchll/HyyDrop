import 'dart:async';

import 'package:hyy_drop/core/logging/app_talker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../common/lan_peer.dart';
import '../common/net_retry.dart';
import '../common/self_peer_provider.dart';
import 'transfer_live_update.dart';
import 'transfer_models.dart';
import 'transfer_repo.dart';
import 'transfer_service.dart';

part 'transfer_provider.g.dart';

@Riverpod(keepAlive: true, retry: netRetry)
class TransferHub extends _$TransferHub {
  TransferRepo? _repo;
  StreamSubscription<TransferState>? _sub;
  final _liveUpdate = TransferLiveUpdateBridge.instance;

  @override
  Future<TransferState> build() async {
    final self = await ref.watch(selfPeerProvider.future);
    final repo = TransferRepo(TransferService());
    _repo = repo;

    ref.onDispose(() {
      unawaited(_sub?.cancel() ?? Future<void>.value());
      unawaited(repo.close());
      unawaited(_liveUpdate.clear());
    });

    _sub = repo.stream.listen(
      (next) {
        state = AsyncData(next);
        unawaited(_liveUpdate.syncState(next));
      },
      onError: (Object error, StackTrace stack) {
        appTalker.handle(error, stack, 'Transfer repo stream failed');
      },
    );

    await repo.start(self);
    unawaited(_liveUpdate.syncState(repo.state));
    return repo.state;
  }

  String? sendFile({required LanPeer peer, required String path}) {
    final repo = _repo;
    if (repo == null) {
      return null;
    }

    return repo.sendFile(peer: peer, path: path);
  }

  Future<void> stop() async {
    final repo = _repo;
    final current = state.asData?.value;
    if (repo == null || current == null) {
      return;
    }

    await repo.close();
    await _liveUpdate.clear();
    _repo = null;
    state = AsyncData(
      current.copyWith(serverStatus: TransferServerStatus.stopped),
    );
  }
}
