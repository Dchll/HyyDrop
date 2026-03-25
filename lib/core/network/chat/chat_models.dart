import 'package:flutter/foundation.dart';

import '../common/lan_peer.dart';
import '../common/net_ports.dart';

enum ChatServerStatus { ready, stopped }

enum ChatLinkStatus { idle, connecting, connected, failed }

enum ChatDirection { incoming, outgoing }

@immutable
class ChatLink {
  const ChatLink({
    required this.peerId,
    required this.peerName,
    required this.peerHost,
    required this.status,
    required this.updatedAt,
    this.error,
  });

  factory ChatLink.idle(LanPeer peer) {
    return ChatLink(
      peerId: peer.id,
      peerName: peer.name,
      peerHost: peer.host,
      status: ChatLinkStatus.idle,
      updatedAt: DateTime.now(),
    );
  }

  final String peerId;
  final String peerName;
  final String peerHost;
  final ChatLinkStatus status;
  final DateTime updatedAt;
  final String? error;

  ChatLink copyWith({
    String? peerId,
    String? peerName,
    String? peerHost,
    ChatLinkStatus? status,
    DateTime? updatedAt,
    String? error,
    bool clearError = false,
  }) {
    return ChatLink(
      peerId: peerId ?? this.peerId,
      peerName: peerName ?? this.peerName,
      peerHost: peerHost ?? this.peerHost,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

@immutable
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.peerId,
    required this.peerName,
    required this.text,
    required this.direction,
    required this.sentAt,
  });

  final String id;
  final String peerId;
  final String peerName;
  final String text;
  final ChatDirection direction;
  final DateTime sentAt;
}

@immutable
class ChatState {
  const ChatState({
    required this.serverStatus,
    required this.port,
    required this.links,
    required this.messages,
    required this.startedAt,
  });

  factory ChatState.ready({
    DateTime? startedAt,
    List<ChatLink> links = const [],
    List<ChatMessage> messages = const [],
  }) {
    return ChatState(
      serverStatus: ChatServerStatus.ready,
      port: NetPorts.chat,
      links: links,
      messages: messages,
      startedAt: startedAt ?? DateTime.now(),
    );
  }

  final ChatServerStatus serverStatus;
  final int port;
  final List<ChatLink> links;
  final List<ChatMessage> messages;
  final DateTime startedAt;

  ChatState copyWith({
    ChatServerStatus? serverStatus,
    int? port,
    List<ChatLink>? links,
    List<ChatMessage>? messages,
    DateTime? startedAt,
  }) {
    return ChatState(
      serverStatus: serverStatus ?? this.serverStatus,
      port: port ?? this.port,
      links: links ?? this.links,
      messages: messages ?? this.messages,
      startedAt: startedAt ?? this.startedAt,
    );
  }
}
