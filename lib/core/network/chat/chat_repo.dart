import 'dart:async';
import 'dart:math';

import '../common/lan_peer.dart';
import 'chat_models.dart';
import 'chat_service.dart';

class ChatRepo {
  ChatRepo(this._service);

  final ChatService _service;
  final _stateCtrl = StreamController<ChatState>.broadcast();
  final _links = <String, ChatLink>{};
  final _messages = <ChatMessage>[];
  ChatState? _state;
  LanPeer? _self;

  Stream<ChatState> get stream => _stateCtrl.stream;

  ChatState get state {
    final current = _state;
    if (current == null) {
      throw StateError('ChatRepo has not been started.');
    }
    return current;
  }

  Future<void> start(LanPeer self) async {
    if (_state != null) {
      return;
    }

    _self = self;
    _state = ChatState.ready();
    _emit();

    await _service.startServer(
      self: self,
      onReady: _onReady,
      onDown: _onDown,
      onText: _onText,
    );
  }

  Future<void> open(LanPeer peer) async {
    final self = _self;
    if (self == null) {
      throw StateError('ChatRepo has not been started.');
    }

    _links[peer.id] = (_links[peer.id] ?? ChatLink.idle(peer)).copyWith(
      peerName: peer.name,
      peerHost: peer.host,
      status: ChatLinkStatus.connecting,
      updatedAt: DateTime.now(),
      clearError: true,
    );
    _emit();

    try {
      await _service.open(
        self: self,
        peer: peer,
        onReady: _onReady,
        onDown: _onDown,
        onText: _onText,
      );
    } catch (error) {
      _links[peer.id] = (_links[peer.id] ?? ChatLink.idle(peer)).copyWith(
        peerName: peer.name,
        peerHost: peer.host,
        status: ChatLinkStatus.failed,
        updatedAt: DateTime.now(),
        error: error.toString(),
      );
      _emit();
    }
  }

  Future<bool> sendText({required LanPeer peer, required String text}) async {
    final self = _self;
    if (self == null) {
      throw StateError('ChatRepo has not been started.');
    }

    await open(peer);

    final now = DateTime.now();
    final message = ChatMessage(
      id: _newId(),
      peerId: peer.id,
      peerName: peer.name,
      text: text,
      direction: ChatDirection.outgoing,
      sentAt: now,
    );

    final sent = await _service.sendText(
      peerId: peer.id,
      selfId: self.id,
      selfName: self.name,
      messageId: message.id,
      text: text,
      sentAt: now,
    );
    if (!sent) {
      _links[peer.id] = (_links[peer.id] ?? ChatLink.idle(peer)).copyWith(
        peerName: peer.name,
        peerHost: peer.host,
        status: ChatLinkStatus.failed,
        updatedAt: DateTime.now(),
        error: 'Unable to send text message',
      );
      _emit();
      return false;
    }

    _messages.add(message);
    _emit();
    return true;
  }

  Future<void> close() async {
    await _service.close();
    await _stateCtrl.close();
  }

  void _onReady(LanPeer peer) {
    _links[peer.id] = (_links[peer.id] ?? ChatLink.idle(peer)).copyWith(
      peerName: peer.name,
      peerHost: peer.host,
      status: ChatLinkStatus.connected,
      updatedAt: DateTime.now(),
      clearError: true,
    );
    _emit();
  }

  void _onDown(String peerId, Object? error) {
    final current = _links[peerId];
    if (current == null) {
      return;
    }

    _links[peerId] = current.copyWith(
      status: error == null ? ChatLinkStatus.idle : ChatLinkStatus.failed,
      updatedAt: DateTime.now(),
      error: error?.toString(),
    );
    _emit();
  }

  void _onText(String peerId, String peerName, String text, DateTime sentAt) {
    _messages.add(
      ChatMessage(
        id: _newId(),
        peerId: peerId,
        peerName: peerName,
        text: text,
        direction: ChatDirection.incoming,
        sentAt: sentAt,
      ),
    );
    _emit();
  }

  void _emit() {
    final current = _state;
    if (current == null || _stateCtrl.isClosed) {
      return;
    }

    _state = current.copyWith(
      links: _sortedLinks(),
      messages: _sortedMessages(),
    );
    _stateCtrl.add(_state!);
  }

  List<ChatLink> _sortedLinks() {
    final list = _links.values.toList(growable: false)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list;
  }

  List<ChatMessage> _sortedMessages() {
    final list = _messages.toList(growable: false)
      ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
    return list;
  }

  String _newId() {
    final millis = DateTime.now().millisecondsSinceEpoch;
    final random = Random.secure().nextInt(1 << 16);
    return '${millis.toRadixString(16)}-${random.toRadixString(16)}';
  }
}
