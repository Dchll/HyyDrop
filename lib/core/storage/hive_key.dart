import 'hive_box.dart';

enum HiveKey {
  themeMode(HiveBox.settings, 'theme_mode'),
  locale(HiveBox.settings, 'locale'),
  lastConnectedDeviceId(HiveBox.devices, 'last_connected_device_id'),
  lastTransferTaskId(HiveBox.transfers, 'last_transfer_task_id');

  const HiveKey(this.box, this.value);

  final HiveBox box;
  final String value;
}
