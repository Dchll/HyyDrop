import 'package:flutter/foundation.dart';

import '../common/lan_peer.dart';
import '../common/net_ports.dart';

enum TransferStatus { queued, connecting, sending, receiving, done, failed }

enum TransferDirection { send, receive }

enum TransferServerStatus { ready, stopped }

@immutable
class TransferTask {
  const TransferTask({
    required this.id,
    required this.peerId,
    required this.peerName,
    required this.peerHost,
    required this.fileName,
    required this.path,
    required this.totalBytes,
    required this.doneBytes,
    required this.bytesPerSecond,
    required this.direction,
    required this.status,
    required this.startedAt,
    required this.updatedAt,
    this.error,
  });

  factory TransferTask.outgoing({
    required String id,
    required LanPeer peer,
    required String fileName,
    required String path,
    required int totalBytes,
  }) {
    final now = DateTime.now();
    return TransferTask(
      id: id,
      peerId: peer.id,
      peerName: peer.name,
      peerHost: peer.host,
      fileName: fileName,
      path: path,
      totalBytes: totalBytes,
      doneBytes: 0,
      bytesPerSecond: 0,
      direction: TransferDirection.send,
      status: TransferStatus.queued,
      startedAt: now,
      updatedAt: now,
    );
  }

  factory TransferTask.incoming({
    required String id,
    required String peerId,
    required String peerName,
    required String peerHost,
    required String fileName,
    required String path,
    required int totalBytes,
  }) {
    final now = DateTime.now();
    return TransferTask(
      id: id,
      peerId: peerId,
      peerName: peerName,
      peerHost: peerHost,
      fileName: fileName,
      path: path,
      totalBytes: totalBytes,
      doneBytes: 0,
      bytesPerSecond: 0,
      direction: TransferDirection.receive,
      status: TransferStatus.receiving,
      startedAt: now,
      updatedAt: now,
    );
  }

  final String id;
  final String peerId;
  final String peerName;
  final String peerHost;
  final String fileName;
  final String path;
  final int totalBytes;
  final int doneBytes;
  final double bytesPerSecond;
  final TransferDirection direction;
  final TransferStatus status;
  final DateTime startedAt;
  final DateTime updatedAt;
  final String? error;

  double get progress {
    if (totalBytes <= 0) {
      return 0;
    }

    return doneBytes / totalBytes;
  }

  Duration? get eta {
    if (bytesPerSecond <= 0 || doneBytes >= totalBytes) {
      return null;
    }

    final left = totalBytes - doneBytes;
    final seconds = left / bytesPerSecond;
    return Duration(milliseconds: (seconds * 1000).round());
  }

  TransferTask copyWith({
    String? id,
    String? peerId,
    String? peerName,
    String? peerHost,
    String? fileName,
    String? path,
    int? totalBytes,
    int? doneBytes,
    double? bytesPerSecond,
    TransferDirection? direction,
    TransferStatus? status,
    DateTime? startedAt,
    DateTime? updatedAt,
    String? error,
    bool clearError = false,
  }) {
    return TransferTask(
      id: id ?? this.id,
      peerId: peerId ?? this.peerId,
      peerName: peerName ?? this.peerName,
      peerHost: peerHost ?? this.peerHost,
      fileName: fileName ?? this.fileName,
      path: path ?? this.path,
      totalBytes: totalBytes ?? this.totalBytes,
      doneBytes: doneBytes ?? this.doneBytes,
      bytesPerSecond: bytesPerSecond ?? this.bytesPerSecond,
      direction: direction ?? this.direction,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

@immutable
class TransferState {
  const TransferState({
    required this.serverStatus,
    required this.port,
    required this.inboxPath,
    required this.tasks,
    required this.startedAt,
  });

  factory TransferState.ready({
    required String inboxPath,
    DateTime? startedAt,
    List<TransferTask> tasks = const [],
  }) {
    return TransferState(
      serverStatus: TransferServerStatus.ready,
      port: NetPorts.transfer,
      inboxPath: inboxPath,
      tasks: tasks,
      startedAt: startedAt ?? DateTime.now(),
    );
  }

  final TransferServerStatus serverStatus;
  final int port;
  final String inboxPath;
  final List<TransferTask> tasks;
  final DateTime startedAt;

  TransferState copyWith({
    TransferServerStatus? serverStatus,
    int? port,
    String? inboxPath,
    List<TransferTask>? tasks,
    DateTime? startedAt,
  }) {
    return TransferState(
      serverStatus: serverStatus ?? this.serverStatus,
      port: port ?? this.port,
      inboxPath: inboxPath ?? this.inboxPath,
      tasks: tasks ?? this.tasks,
      startedAt: startedAt ?? this.startedAt,
    );
  }
}
