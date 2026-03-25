import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hyy_drop/core/logging/app_talker.dart';

import '../common/lan_peer.dart';
import '../common/net_ports.dart';

typedef OnChatReady = void Function(LanPeer peer);
typedef OnChatDown = void Function(String peerId, Object? error);
typedef OnChatText =
    void Function(String peerId, String peerName, String text, DateTime sentAt);

class ChatService {
  ChatService();

  ServerSocket? _server;
  StreamSubscription<Socket>? _serverSub;
  final _links = <String, _ChatLink>{};
  final _pending = <String, Future<void>>{};

  Future<void> startServer({
    required LanPeer self,
    required OnChatReady onReady,
    required OnChatDown onDown,
    required OnChatText onText,
  }) async {
    if (_server != null) {
      return;
    }

    final server = await ServerSocket.bind(
      InternetAddress.anyIPv4,
      NetPorts.chat,
      shared: true,
    );

    _server = server;
    _serverSub = server.listen(
      (socket) {
        unawaited(
          _bindSocket(
            socket,
            self: self,
            onReady: onReady,
            onDown: onDown,
            onText: onText,
            sendHello: false,
          ),
        );
      },
      onError: (Object error, StackTrace stack) {
        appTalker.handle(error, stack, 'Chat server stream failed');
      },
    );
  }

  Future<void> open({
    required LanPeer self,
    required LanPeer peer,
    required OnChatReady onReady,
    required OnChatDown onDown,
    required OnChatText onText,
  }) async {
    final current = _links[peer.id];
    if (current != null && !current.isClosed) {
      return;
    }

    final pending = _pending[peer.id];
    if (pending != null) {
      return pending;
    }

    final future = _openImpl(
      self: self,
      peer: peer,
      onReady: onReady,
      onDown: onDown,
      onText: onText,
    );
    _pending[peer.id] = future;

    try {
      await future;
    } finally {
      unawaited(_pending.remove(peer.id));
    }
  }

  Future<bool> sendText({
    required String peerId,
    required String selfId,
    required String selfName,
    required String messageId,
    required String text,
    required DateTime sentAt,
  }) async {
    final link = _links[peerId];
    if (link == null || link.isClosed) {
      return false;
    }

    final payload = {
      'kind': 'text',
      'id': messageId,
      'peerId': selfId,
      'peerName': selfName,
      'text': text,
      'sentAt': sentAt.toIso8601String(),
    };

    try {
      final line = jsonEncode(payload);
      appTalker.debug('Chat send -> ${link.host}:${link.port} $line');
      link.socket.writeln(line);
      await link.socket.flush();
      return true;
    } catch (error, stack) {
      appTalker.handle(error, stack, 'Chat send failed');
      await _drop(peerId, error: error, onDown: null);
      return false;
    }
  }

  Future<void> close() async {
    await _serverSub?.cancel();
    await _server?.close();
    _server = null;

    final closing = _links.keys.toList(growable: false);
    for (final peerId in closing) {
      await _drop(peerId, onDown: null);
    }
  }

  Future<void> _openImpl({
    required LanPeer self,
    required LanPeer peer,
    required OnChatReady onReady,
    required OnChatDown onDown,
    required OnChatText onText,
  }) async {
    final socket = await Socket.connect(
      peer.host,
      peer.chatPort,
      timeout: const Duration(seconds: 4),
    );

    await _bindSocket(
      socket,
      self: self,
      onReady: onReady,
      onDown: onDown,
      onText: onText,
      sendHello: true,
    );
  }

  Future<void> _bindSocket(
    Socket socket, {
    required LanPeer self,
    required OnChatReady onReady,
    required OnChatDown onDown,
    required OnChatText onText,
    required bool sendHello,
  }) async {
    final channel = _SocketChannel(
      socket: socket,
      host: socket.remoteAddress.address,
      port: socket.remotePort,
    );

    if (sendHello) {
      final hello = jsonEncode({'kind': 'hello', 'peer': self.toPacket()});
      appTalker.debug('Chat send -> ${channel.host}:${channel.port} $hello');
      socket.writeln(hello);
      await socket.flush();
      channel.helloSent = true;
    }

    channel.sub = socket
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(
          (line) async {
            appTalker.debug(
              'Chat recv <- ${channel.host}:${channel.port} $line',
            );
            final payload = _decode(line);
            if (payload == null) {
              return;
            }

            final kind = payload['kind'];
            if (kind == 'hello') {
              final peer = LanPeer.fromPacketJson(
                line,
                host: channel.host,
                seenAt: DateTime.now(),
              );
              if (peer == null || peer.id == self.id) {
                return;
              }

              channel.peerId = peer.id;
              channel.peerName = peer.name;
              await _register(channel, peer: peer, onDown: onDown);
              onReady(peer);

              if (!channel.helloSent) {
                final hello = jsonEncode({
                  'kind': 'hello',
                  'peer': self.toPacket(),
                });
                appTalker.debug(
                  'Chat send -> ${channel.host}:${channel.port} $hello',
                );
                socket.writeln(hello);
                await socket.flush();
                channel.helloSent = true;
              }
              return;
            }

            if (kind == 'text') {
              final peerId = payload['peerId'];
              final peerName = payload['peerName'];
              final text = payload['text'];
              final sentAt = payload['sentAt'];
              if (peerId is! String ||
                  peerName is! String ||
                  text is! String ||
                  sentAt is! String) {
                return;
              }

              onText(
                peerId,
                peerName,
                text,
                DateTime.tryParse(sentAt) ?? DateTime.now(),
              );
            }
          },
          onError: (Object error, StackTrace stack) async {
            appTalker.handle(error, stack, 'Chat socket stream failed');
            final peerId = channel.peerId;
            if (peerId != null) {
              await _drop(peerId, error: error, onDown: onDown);
            }
          },
          onDone: () async {
            final peerId = channel.peerId;
            if (peerId != null) {
              await _drop(peerId, onDown: onDown);
            } else {
              await socket.close();
            }
          },
        );
  }

  Future<void> _register(
    _SocketChannel channel, {
    required LanPeer peer,
    required OnChatDown onDown,
  }) async {
    final previous = _links.remove(peer.id);
    if (previous != null && !identical(previous.socket, channel.socket)) {
      await previous.dispose();
    }

    _links[peer.id] = _ChatLink(
      socket: channel.socket,
      sub: channel.sub!,
      host: channel.host,
      port: channel.port,
    );
  }

  Future<void> _drop(String peerId, {Object? error, OnChatDown? onDown}) async {
    final link = _links.remove(peerId);
    if (link == null) {
      return;
    }

    await link.dispose();
    onDown?.call(peerId, error);
  }

  Map<String, dynamic>? _decode(String line) {
    try {
      final decoded = jsonDecode(line);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }
}

class _SocketChannel {
  _SocketChannel({
    required this.socket,
    required this.host,
    required this.port,
  });

  final Socket socket;
  final String host;
  final int port;
  String? peerId;
  String? peerName;
  bool helloSent = false;
  StreamSubscription<String>? sub;
}

class _ChatLink {
  _ChatLink({
    required this.socket,
    required this.sub,
    required this.host,
    required this.port,
  });

  final Socket socket;
  final StreamSubscription<String> sub;
  final String host;
  final int port;
  bool _disposed = false;

  bool get isClosed => _disposed;

  Future<void> dispose() async {
    if (_disposed) {
      return;
    }

    _disposed = true;
    await sub.cancel();
    await socket.close();
    socket.destroy();
  }
}
