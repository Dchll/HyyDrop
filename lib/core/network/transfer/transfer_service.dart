import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:hyy_drop/core/logging/app_talker.dart';
import 'package:path_provider/path_provider.dart';

import '../common/lan_peer.dart';
import '../common/net_ports.dart';
import 'transfer_models.dart';

class TransferService {
  TransferService();

  static const _headerLimit = 16 * 1024;
  static const _magic = 'HYD1';

  ServerSocket? _server;
  StreamSubscription<Socket>? _serverSub;

  Future<String> openInbox() async {
    final root = await getApplicationSupportDirectory();
    final dir = Directory('${root.path}/transfer_inbox');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir.path;
  }

  Future<void> startServer({
    required void Function(TransferTask task) onTask,
    required String inboxPath,
  }) async {
    if (_server != null) {
      return;
    }

    final server = await ServerSocket.bind(
      InternetAddress.anyIPv4,
      NetPorts.transfer,
      shared: true,
    );

    _server = server;
    _serverSub = server.listen(
      (socket) {
        unawaited(_recv(socket, inboxPath: inboxPath, onTask: onTask));
      },
      onError: (Object error, StackTrace stack) {
        appTalker.handle(error, stack, 'Transfer server stream failed');
      },
    );
  }

  Future<void> send({
    required LanPeer self,
    required LanPeer peer,
    required TransferTask task,
    required void Function(TransferTask task) onTask,
  }) async {
    final file = File(task.path);

    try {
      final socket = await Socket.connect(peer.host, peer.transferPort);
      var current = task.copyWith(
        status: TransferStatus.connecting,
        updatedAt: DateTime.now(),
        clearError: true,
      );
      onTask(current);

      final header = _WireHead(
        taskId: task.id,
        peerId: self.id,
        peerName: self.name,
        fileName: task.fileName,
        totalBytes: task.totalBytes,
      );

      final encodedHeader = _encodeHeader(header);
      appTalker.debug(
        'Transfer head -> ${peer.host}:${peer.port} ${jsonEncode(header.toJson())}',
      );
      socket.add(encodedHeader);
      await socket.flush();
      appTalker.debug(
        'Transfer head sent bytes=${encodedHeader.length} task=${task.id}',
      );

      final meter = _RateMeter();
      var chunkIndex = 0;
      current = current.copyWith(
        status: TransferStatus.sending,
        updatedAt: DateTime.now(),
      );
      onTask(current);

      await for (final chunk in file.openRead()) {
        chunkIndex++;
        appTalker.debug(
          'Transfer chunk -> ${peer.host}:${peer.port} '
          '#$chunkIndex size=${chunk.length} preview=${_previewBytes(chunk)}',
        );
        socket.add(chunk);
        current = current.copyWith(
          doneBytes: current.doneBytes + chunk.length,
          bytesPerSecond: meter.next(current.doneBytes + chunk.length),
          updatedAt: DateTime.now(),
        );
        onTask(current);
      }

      await socket.flush();
      await socket.close();

      onTask(
        current.copyWith(
          doneBytes: current.totalBytes,
          status: TransferStatus.done,
          updatedAt: DateTime.now(),
        ),
      );
    } catch (error, stack) {
      appTalker.handle(error, stack, 'Transfer send failed');
      onTask(
        task.copyWith(
          status: TransferStatus.failed,
          error: error.toString(),
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  Future<void> close() async {
    await _serverSub?.cancel();
    await _server?.close();
    _server = null;
  }

  Future<void> _recv(
    Socket socket, {
    required String inboxPath,
    required void Function(TransferTask task) onTask,
  }) async {
    final parser = _HeadParser();
    IOSink? sink;
    TransferTask? current;
    final meter = _RateMeter();

    try {
      await for (final chunk in socket) {
        var body = chunk;

        if (!parser.isReady) {
          body = parser.push(chunk);
          if (!parser.isReady) {
            continue;
          }

          final head = parser.head!;
          appTalker.debug(
            'Transfer head recv <- ${socket.remoteAddress.address}:${socket.remotePort} '
            '${jsonEncode(head.toJson())}',
          );
          final targetPath = await _nextPath(inboxPath, head.fileName);
          current = TransferTask.incoming(
            id: head.taskId,
            peerId: head.peerId,
            peerName: head.peerName,
            peerHost: socket.remoteAddress.address,
            fileName: head.fileName,
            path: targetPath,
            totalBytes: head.totalBytes,
          );
          onTask(current);

          final target = File(targetPath);
          await target.parent.create(recursive: true);
          sink = target.openWrite();
        }

        if (current == null || sink == null || body.isEmpty) {
          continue;
        }

        final left = current.totalBytes - current.doneBytes;
        final take = min(left, body.length);
        if (take <= 0) {
          continue;
        }

        appTalker.debug(
          'Transfer chunk recv <- ${socket.remoteAddress.address}:${socket.remotePort} '
          'size=$take preview=${_previewBytes(body, maxBytes: min(take, 12))}',
        );
        sink.add(body.sublist(0, take));
        final done = current.doneBytes + take;
        current = current.copyWith(
          doneBytes: done,
          bytesPerSecond: meter.next(done),
          updatedAt: DateTime.now(),
        );
        onTask(current);
      }

      await sink?.flush();
      await sink?.close();

      if (current == null) {
        return;
      }

      if (current.doneBytes == current.totalBytes) {
        onTask(
          current.copyWith(
            status: TransferStatus.done,
            updatedAt: DateTime.now(),
          ),
        );
      } else {
        onTask(
          current.copyWith(
            status: TransferStatus.failed,
            error: 'Socket closed before transfer completed',
            updatedAt: DateTime.now(),
          ),
        );
      }
    } catch (error, stack) {
      appTalker.handle(error, stack, 'Transfer receive failed');
      await sink?.close();

      if (current != null) {
        onTask(
          current.copyWith(
            status: TransferStatus.failed,
            error: error.toString(),
            updatedAt: DateTime.now(),
          ),
        );
      }
    } finally {
      await socket.close();
    }
  }

  Uint8List _encodeHeader(_WireHead head) {
    final json = utf8.encode(jsonEncode(head.toJson()));
    final len = ByteData(4)..setUint32(0, json.length, Endian.big);

    return Uint8List.fromList([
      ...ascii.encode(_magic),
      ...len.buffer.asUint8List(),
      ...json,
    ]);
  }

  Future<String> _nextPath(String inboxPath, String fileName) async {
    final cleanName = _safeName(fileName);
    final normalized = cleanName.isEmpty ? 'file.bin' : cleanName;
    final dot = normalized.lastIndexOf('.');
    final base = dot <= 0 ? normalized : normalized.substring(0, dot);
    final ext = dot <= 0 ? '' : normalized.substring(dot);
    var index = 0;

    while (true) {
      final suffix = index == 0 ? '' : '_$index';
      final path = '$inboxPath/$base$suffix$ext';
      if (!await File(path).exists()) {
        return path;
      }
      index++;
    }
  }

  String _safeName(String input) {
    return input.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_').trim();
  }

  String _previewBytes(List<int> data, {int maxBytes = 12}) {
    final preview = data
        .take(maxBytes)
        .map((byte) {
          return byte.toRadixString(16).padLeft(2, '0');
        })
        .join(' ');

    return data.length <= maxBytes ? preview : '$preview ...';
  }
}

class _WireHead {
  const _WireHead({
    required this.taskId,
    required this.peerId,
    required this.peerName,
    required this.fileName,
    required this.totalBytes,
  });

  final String taskId;
  final String peerId;
  final String peerName;
  final String fileName;
  final int totalBytes;

  Map<String, Object?> toJson() {
    return {
      'taskId': taskId,
      'peerId': peerId,
      'peerName': peerName,
      'fileName': fileName,
      'totalBytes': totalBytes,
    };
  }

  static _WireHead fromJson(Map<String, dynamic> json) {
    final taskId = json['taskId'];
    final peerId = json['peerId'];
    final peerName = json['peerName'];
    final fileName = json['fileName'];
    final totalBytes = json['totalBytes'];

    if (taskId is! String ||
        peerId is! String ||
        peerName is! String ||
        fileName is! String ||
        totalBytes is! num) {
      throw const FormatException('Invalid transfer header');
    }

    return _WireHead(
      taskId: taskId,
      peerId: peerId,
      peerName: peerName,
      fileName: fileName,
      totalBytes: totalBytes.toInt(),
    );
  }
}

class _HeadParser {
  List<int> _buffer = <int>[];
  _WireHead? head;

  bool get isReady => head != null;

  Uint8List push(Uint8List chunk) {
    if (isReady) {
      return chunk;
    }

    _buffer = [..._buffer, ...chunk];
    final magicLen = TransferService._magic.length;
    if (_buffer.length < magicLen + 4) {
      return Uint8List(0);
    }

    final magic = ascii.decode(_buffer.sublist(0, magicLen));
    if (magic != TransferService._magic) {
      throw const FormatException('Unknown transfer protocol');
    }

    final lenData = ByteData.sublistView(
      Uint8List.fromList(_buffer.sublist(magicLen, magicLen + 4)),
    );
    final headerLen = lenData.getUint32(0, Endian.big);
    if (headerLen <= 0 || headerLen > TransferService._headerLimit) {
      throw const FormatException('Transfer header is invalid');
    }

    final bodyStart = magicLen + 4 + headerLen;
    if (_buffer.length < bodyStart) {
      return Uint8List(0);
    }

    final payload = utf8.decode(_buffer.sublist(magicLen + 4, bodyStart));
    final decoded = jsonDecode(payload);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Transfer header payload is invalid');
    }

    head = _WireHead.fromJson(decoded);
    final body = Uint8List.fromList(_buffer.sublist(bodyStart));
    _buffer = const <int>[];
    return body;
  }
}

class _RateMeter {
  DateTime? _lastAt;
  int _lastBytes = 0;

  double next(int totalBytes) {
    final now = DateTime.now();
    final lastAt = _lastAt;
    final lastBytes = _lastBytes;

    _lastAt = now;
    _lastBytes = totalBytes;

    if (lastAt == null) {
      return 0;
    }

    final elapsedMs = now.difference(lastAt).inMilliseconds;
    if (elapsedMs <= 0) {
      return 0;
    }

    final delta = totalBytes - lastBytes;
    return delta * 1000 / elapsedMs;
  }
}
