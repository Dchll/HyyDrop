import 'package:device_info_plus/device_info_plus.dart';
import 'package:hyy_drop/core/logging/app_talker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_info_provider.g.dart';

class AppDeviceInfoSnapshot {
  const AppDeviceInfoSnapshot({
    required this.deviceData,
    required this.fieldCount,
    required this.deviceTitle,
    required this.isPhysicalDevice,
  });

  final Map<String, dynamic> deviceData;
  final int fieldCount;
  final String deviceTitle;
  final bool isPhysicalDevice;
}

@riverpod
Future<AppDeviceInfoSnapshot> appDeviceInfo(Ref ref) async {
  try {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;
    final fieldCount = _countFlattenedEntries(deviceInfo.data);

    appTalker.info('Loaded device diagnostics: $fieldCount device fields');

    return AppDeviceInfoSnapshot(
      deviceData: Map<String, dynamic>.from(deviceInfo.data),
      fieldCount: fieldCount,
      deviceTitle: _resolveDeviceTitle(deviceInfo),
      isPhysicalDevice: _extractPhysicalDevice(deviceInfo.data),
    );
  } catch (error, stack) {
    appTalker.handle(error, stack, 'Failed to load device info');
    rethrow;
  }
}

int _countFlattenedEntries(Map<String, dynamic> data) {
  final sortedKeys = data.keys.toList()..sort();
  var count = 0;

  for (final key in sortedKeys) {
    final value = data[key];
    if (value is Map) {
      count += _countFlattenedEntries(Map<String, dynamic>.from(value));
    } else {
      count++;
    }
  }

  return count;
}

String _resolveDeviceTitle(BaseDeviceInfo info) {
  final data = info.data;

  final candidates = [
    data['name'],
    data['model'],
    data['computerName'],
    data['prettyName'],
    data['machine'],
    data['hostName'],
    data['brand'],
    data['browserName'],
  ];

  for (final candidate in candidates) {
    if (candidate is String && candidate.trim().isNotEmpty) {
      return candidate.trim();
    }
  }

  return 'Unknown';
}

bool _extractPhysicalDevice(Map<String, dynamic> data) {
  final value = data['isPhysicalDevice'];
  return value is bool ? value : true;
}
