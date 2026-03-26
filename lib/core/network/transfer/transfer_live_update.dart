import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hyy_drop/core/locale/locale_prefs.dart';
import 'package:hyy_drop/core/logging/app_talker.dart';
import 'package:hyy_drop/l10n/app_localizations.dart';

import 'transfer_models.dart';

class TransferLiveUpdateBridge {
  TransferLiveUpdateBridge._();

  static final TransferLiveUpdateBridge instance = TransferLiveUpdateBridge._();
  static const _channel = MethodChannel('hyy_drop/live_update');
  static const _minSyncGap = Duration(milliseconds: 750);
  static const _manualLiveUpdateTaskId = 'manual-live-update';

  String? _trackedTaskId;
  int? _trackedProgress;
  TransferStatus? _trackedStatus;
  DateTime? _lastSyncAt;

  Future<void> syncState(TransferState state) async {
    if (!Platform.isAndroid) {
      return;
    }

    try {
      final activeTask = _selectPrimaryActiveTask(state.tasks);
      if (activeTask != null) {
        await _syncActiveTask(activeTask);
        return;
      }

      await _finishTrackedTask(state.tasks);
    } catch (error, stack) {
      appTalker.handle(error, stack, 'Failed to sync Android live update');
    }
  }

  Future<void> clear() async {
    if (!Platform.isAndroid) {
      _resetTrackedState();
      return;
    }

    try {
      await _channel.invokeMethod<void>('stopTransferLiveUpdate');
    } catch (error, stack) {
      appTalker.handle(error, stack, 'Failed to clear Android live update');
    } finally {
      _resetTrackedState();
    }
  }

  Future<bool> areNotificationsEnabled() async {
    if (!Platform.isAndroid) {
      return false;
    }

    try {
      return await _channel.invokeMethod<bool>('areNotificationsEnabled') ??
          false;
    } catch (error, stack) {
      appTalker.handle(error, stack, 'Failed to check notification permission');
      return false;
    }
  }

  Future<bool> canPostPromotedNotifications() async {
    if (!Platform.isAndroid) {
      return false;
    }

    try {
      return await _channel.invokeMethod<bool>(
            'canPostPromotedNotifications',
          ) ??
          false;
    } catch (error, stack) {
      appTalker.handle(
        error,
        stack,
        'Failed to check promoted notification availability',
      );
      return false;
    }
  }

  Future<void> openPromotedNotificationSettings() async {
    if (!Platform.isAndroid) {
      return;
    }

    try {
      await _channel.invokeMethod<void>('openPromotedNotificationSettings');
    } catch (error, stack) {
      appTalker.handle(
        error,
        stack,
        'Failed to open promoted notification settings',
      );
    }
  }

  Future<List<String>> previewShortCriticalTextSegments(String? text) async {
    if (!Platform.isAndroid) {
      final value = text?.trim();
      return value == null || value.isEmpty ? const [] : [value];
    }

    try {
      final result = await _channel.invokeListMethod<String>(
        'previewShortCriticalTextSegments',
        {'text': text},
      );
      return result ?? const [];
    } catch (error, stack) {
      appTalker.handle(
        error,
        stack,
        'Failed to preview short critical text segments',
      );
      final value = text?.trim();
      return value == null || value.isEmpty ? const [] : [value];
    }
  }

  Future<bool> showCustomNotification({
    required String taskId,
    required String title,
    required String body,
    String? subText,
    int? progress,
    String? shortCriticalText,
    int? shortTextRotationSeconds,
    String? successToastMessage,
    String? styleType,
    String? callType,
    bool? callIsVideo,
    String? metricPrimaryLabel,
    String? metricPrimaryValue,
    String? metricSecondaryLabel,
    String? metricSecondaryValue,
    String? metricTertiaryLabel,
    String? metricTertiaryValue,
    TransferStatus? trackedStatus,
  }) async {
    if (!Platform.isAndroid) {
      return false;
    }

    final safeProgress = progress?.clamp(0, 100);
    try {
      final success = await _channel
          .invokeMethod<bool>('syncTransferLiveUpdate', {
            'taskId': taskId,
            'title': title,
            'body': body,
            'subText': subText,
            'progress': safeProgress,
            'shortCriticalText': shortCriticalText,
            'shortTextRotationSeconds': shortTextRotationSeconds,
            'successToastMessage': successToastMessage,
            'styleType': styleType,
            'callType': callType,
            'callIsVideo': callIsVideo,
            'metricPrimaryLabel': metricPrimaryLabel,
            'metricPrimaryValue': metricPrimaryValue,
            'metricSecondaryLabel': metricSecondaryLabel,
            'metricSecondaryValue': metricSecondaryValue,
            'metricTertiaryLabel': metricTertiaryLabel,
            'metricTertiaryValue': metricTertiaryValue,
          });
      if (success != true) {
        return false;
      }
      _trackedTaskId = taskId;
      _trackedProgress = safeProgress;
      _trackedStatus = trackedStatus;
      _lastSyncAt = DateTime.now();
      return true;
    } catch (error, stack) {
      appTalker.handle(error, stack, 'Failed to show custom live update');
      return false;
    }
  }

  Future<bool> showTextNotification({
    required String title,
    required String body,
    String? subText,
    String? shortCriticalText,
  }) async {
    return showCustomNotification(
      taskId: _manualLiveUpdateTaskId,
      title: title,
      body: body,
      subText: subText,
      shortCriticalText: shortCriticalText,
    );
  }

  String get manualLiveUpdateTaskId => _manualLiveUpdateTaskId;

  Future<void> _syncActiveTask(TransferTask task) async {
    final progress = (task.progress * 100).round().clamp(0, 100);
    final now = DateTime.now();
    final statusChanged =
        task.id != _trackedTaskId || task.status != _trackedStatus;
    final progressChanged = progress != _trackedProgress;
    final throttled =
        !statusChanged &&
        !progressChanged &&
        _lastSyncAt != null &&
        now.difference(_lastSyncAt!) < _minSyncGap;

    if (throttled) {
      return;
    }

    final l10n = _lookupLocalizations();
    await showCustomNotification(
      taskId: task.id,
      title: '${_statusLabel(l10n, task.status)} ${task.fileName}',
      body: _buildProgressBody(l10n, task, progress),
      subText: task.peerName,
      progress: progress,
      shortCriticalText: '$progress%',
      trackedStatus: task.status,
    );
    _lastSyncAt = now;
  }

  Future<void> _finishTrackedTask(List<TransferTask> tasks) async {
    final trackedTaskId = _trackedTaskId;
    if (trackedTaskId == null) {
      return;
    }

    final trackedTask = _findTask(tasks, trackedTaskId);
    if (trackedTask == null) {
      await clear();
      return;
    }

    final l10n = _lookupLocalizations();
    if (trackedTask.status == TransferStatus.done) {
      await _channel.invokeMethod<void>('completeTransferLiveUpdate', {
        'taskId': trackedTask.id,
        'title': '${l10n.statusDone} ${trackedTask.fileName}',
        'body': trackedTask.peerName,
        'subText': trackedTask.peerHost,
      });
    } else if (trackedTask.status == TransferStatus.failed) {
      await _channel.invokeMethod<void>('failTransferLiveUpdate', {
        'taskId': trackedTask.id,
        'title': '${l10n.statusFailed} ${trackedTask.fileName}',
        'body': trackedTask.error ?? trackedTask.peerName,
        'subText': trackedTask.peerName,
      });
    } else {
      await _channel.invokeMethod<void>('stopTransferLiveUpdate', {
        'taskId': trackedTask.id,
      });
    }

    _resetTrackedState();
  }

  TransferTask? _selectPrimaryActiveTask(List<TransferTask> tasks) {
    for (final task in tasks) {
      if (_isActive(task.status)) {
        return task;
      }
    }
    return null;
  }

  TransferTask? _findTask(List<TransferTask> tasks, String id) {
    for (final task in tasks) {
      if (task.id == id) {
        return task;
      }
    }
    return null;
  }

  bool _isActive(TransferStatus status) {
    return switch (status) {
      TransferStatus.queued ||
      TransferStatus.connecting ||
      TransferStatus.sending ||
      TransferStatus.receiving => true,
      TransferStatus.done || TransferStatus.failed => false,
    };
  }

  String _statusLabel(AppLocalizations l10n, TransferStatus status) {
    return switch (status) {
      TransferStatus.queued => l10n.statusQueued,
      TransferStatus.connecting => l10n.statusConnecting,
      TransferStatus.sending => l10n.statusSending,
      TransferStatus.receiving => l10n.statusReceiving,
      TransferStatus.done => l10n.statusDone,
      TransferStatus.failed => l10n.statusFailed,
    };
  }

  String _buildProgressBody(
    AppLocalizations l10n,
    TransferTask task,
    int progress,
  ) {
    final parts = <String>[
      '$progress%',
      '${l10n.speedShortLabel} ${_formatSpeed(task.bytesPerSecond)}',
    ];
    final eta = task.eta;
    if (eta != null) {
      parts.add('${l10n.etaShortLabel} ${_formatEta(eta)}');
    }
    return parts.join(' · ');
  }

  String _formatSpeed(double bytesPerSecond) {
    if (bytesPerSecond <= 0) {
      return '0 B/s';
    }

    const units = ['B/s', 'KB/s', 'MB/s', 'GB/s'];
    var value = bytesPerSecond;
    var unitIndex = 0;
    while (value >= 1024 && unitIndex < units.length - 1) {
      value /= 1024;
      unitIndex++;
    }

    final precision = value >= 100 ? 0 : (value >= 10 ? 1 : 2);
    return '${value.toStringAsFixed(precision)} ${units[unitIndex]}';
  }

  String _formatEta(Duration eta) {
    if (eta.inHours > 0) {
      final minutes = eta.inMinutes.remainder(60).toString().padLeft(2, '0');
      return '${eta.inHours}:$minutes';
    }

    if (eta.inMinutes > 0) {
      final seconds = eta.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '${eta.inMinutes}:$seconds';
    }

    return '${eta.inSeconds}s';
  }

  AppLocalizations _lookupLocalizations() {
    final preferredLocale = LocalePrefs.instance.getLocale().locale;
    final locale = preferredLocale ?? ui.PlatformDispatcher.instance.locale;
    try {
      return lookupAppLocalizations(locale);
    } catch (_) {
      return lookupAppLocalizations(const Locale('en'));
    }
  }

  void _resetTrackedState() {
    _trackedTaskId = null;
    _trackedProgress = null;
    _trackedStatus = null;
    _lastSyncAt = null;
  }
}
