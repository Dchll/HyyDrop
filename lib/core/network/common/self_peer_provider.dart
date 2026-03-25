import 'dart:io';

import 'package:hyy_drop/core/info/device_info_provider.dart';
import 'package:hyy_drop/core/info/package_info_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'lan_peer.dart';
import 'net_ports.dart';
import 'node_id_store.dart';

part 'self_peer_provider.g.dart';

@Riverpod(keepAlive: true)
Future<LanPeer> selfPeer(Ref ref) async {
  final package = await ref.watch(appPackageInfoProvider.future);
  final device = await ref.watch(appDeviceInfoProvider.future);
  final nodeId = await NodeIdStore.instance.getOrCreate();

  return LanPeer(
    id: nodeId,
    name: device.deviceTitle,
    host: await _resolveHost(),
    chatPort: NetPorts.chat,
    transferPort: NetPorts.transfer,
    app: package.packageInfo.appName,
    version: package.packageInfo.version,
    platform: Platform.operatingSystem,
    lastSeen: DateTime.now(),
  );
}

Future<String> _resolveHost() async {
  final interfaces = await NetworkInterface.list(
    type: InternetAddressType.IPv4,
    includeLoopback: false,
  );

  for (final interface in interfaces) {
    for (final address in interface.addresses) {
      if (!address.isLoopback && address.address.isNotEmpty) {
        return address.address;
      }
    }
  }

  return InternetAddress.loopbackIPv4.address;
}
