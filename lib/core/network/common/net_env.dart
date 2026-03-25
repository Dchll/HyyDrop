import 'dart:io';

import 'package:flutter/services.dart';
import 'package:hyy_drop/core/logging/app_talker.dart';

class NetEnv {
  NetEnv._();

  static final NetEnv instance = NetEnv._();
  static const _channel = MethodChannel('hyy_drop/network');

  Future<void> prepareDiscovery() async {
    if (!Platform.isAndroid) {
      return;
    }

    try {
      final held = await _channel.invokeMethod<bool>('acquireMulticastLock');
      appTalker.info('Android multicast lock active=${held == true}');
    } catch (error, stack) {
      appTalker.handle(
        error,
        stack,
        'Failed to acquire Android multicast lock',
      );
    }
  }

  Future<void> releaseDiscovery() async {
    if (!Platform.isAndroid) {
      return;
    }

    try {
      await _channel.invokeMethod<void>('releaseMulticastLock');
      appTalker.info('Android multicast lock released');
    } catch (error, stack) {
      appTalker.handle(
        error,
        stack,
        'Failed to release Android multicast lock',
      );
    }
  }
}
