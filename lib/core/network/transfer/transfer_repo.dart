import 'dart:async';
import 'dart:io';
import 'dart:math';

import '../common/lan_peer.dart';
import 'transfer_models.dart';
import 'transfer_service.dart';

class TransferRepo {
  TransferRepo(this._service);

  final TransferService _service;
  final _stateCtrl = StreamController<TransferState>.broadcast();
  final _tasks = <String, TransferTask>{};
  TransferState? _state;
  LanPeer? _self;

  Stream<TransferState> get stream => _stateCtrl.stream;

  TransferState get state {
    final current = _state;
    if (current == null) {
      throw StateError('TransferRepo has not been started.');
    }
    return current;
  }

  Future<void> start(LanPeer self) async {
    if (_state != null) {
      return;
    }

    _self = self;
    final inboxPath = await _service.openInbox();
    _state = TransferState.ready(inboxPath: inboxPath);
    _emit();

    await _service.startServer(inboxPath: inboxPath, onTask: _upsertTask);
  }

  String sendFile({required LanPeer peer, required String path}) {
    final self = _self;
    if (self == null) {
      throw StateError('TransferRepo has not been started.');
    }

    final file = File(path);
    final name = _basename(path);
    final totalBytes = file.existsSync() ? file.lengthSync() : 0;
    final task = TransferTask.outgoing(
      id: _newId(),
      peer: peer,
      fileName: name,
      path: path,
      totalBytes: totalBytes,
    );

    _upsertTask(task);
    unawaited(
      _service.send(self: self, peer: peer, task: task, onTask: _upsertTask),
    );
    return task.id;
  }

  Future<void> close() async {
    await _service.close();
    await _stateCtrl.close();
  }

  void _upsertTask(TransferTask task) {
    _tasks[task.id] = task;
    final current = _state;
    if (current == null) {
      return;
    }

    _state = current.copyWith(tasks: _sortedTasks());
    _emit();
  }

  void _emit() {
    final current = _state;
    if (current == null || _stateCtrl.isClosed) {
      return;
    }

    _stateCtrl.add(current);
  }

  List<TransferTask> _sortedTasks() {
    final list = _tasks.values.toList(growable: false)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list;
  }

  String _newId() {
    final millis = DateTime.now().millisecondsSinceEpoch;
    final random = Random.secure().nextInt(1 << 16);
    return '${millis.toRadixString(16)}-${random.toRadixString(16)}';
  }

  String _basename(String path) {
    final normalized = path.replaceAll('\\', '/');
    final parts = normalized.split('/');
    return parts.isEmpty ? path : parts.last;
  }
}
