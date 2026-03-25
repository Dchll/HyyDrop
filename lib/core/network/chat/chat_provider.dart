import 'dart:async';

import 'package:hyy_drop/core/logging/app_talker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../common/lan_peer.dart';
import '../common/net_retry.dart';
import '../common/self_peer_provider.dart';
import 'chat_models.dart';
import 'chat_repo.dart';
import 'chat_service.dart';

part 'chat_provider.g.dart';

@Riverpod(keepAlive: true, retry: netRetry)
class ChatHub extends _$ChatHub {
  ChatRepo? _repo;
  StreamSubscription<ChatState>? _sub;

  @override
  Future<ChatState> build() async {
    final self = await ref.watch(selfPeerProvider.future);
    final repo = ChatRepo(ChatService());
    _repo = repo;

    ref.onDispose(() {
      unawaited(_sub?.cancel() ?? Future<void>.value());
      unawaited(repo.close());
    });

    _sub = repo.stream.listen(
      (next) {
        state = AsyncData(next);
      },
      onError: (Object error, StackTrace stack) {
        appTalker.handle(error, stack, 'Chat repo stream failed');
      },
    );

    await repo.start(self);
    return repo.state;
  }

  Future<void> open(LanPeer peer) async {
    if (_repo == null) {
      await future;
    }

    final repo = _repo;
    if (repo == null) {
      return;
    }

    await repo.open(peer);
  }

  Future<bool> sendText({required LanPeer peer, required String text}) async {
    if (_repo == null) {
      await future;
    }

    final repo = _repo;
    if (repo == null) {
      return false;
    }

    return repo.sendText(peer: peer, text: text);
  }

  Future<void> stop() async {
    final repo = _repo;
    final current = state.asData?.value;
    if (repo == null || current == null) {
      return;
    }

    await repo.close();
    _repo = null;
    state = AsyncData(current.copyWith(serverStatus: ChatServerStatus.stopped));
  }
}
