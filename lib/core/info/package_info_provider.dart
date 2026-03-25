import 'package:hyy_drop/core/logging/app_talker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'package_info_provider.g.dart';

class AppPackageInfoSnapshot {
  const AppPackageInfoSnapshot({
    required this.packageInfo,
    required this.fieldCount,
  });

  final PackageInfo packageInfo;
  final int fieldCount;
}

@riverpod
Future<AppPackageInfoSnapshot> appPackageInfo(Ref ref) async {
  try {
    final packageInfo = await PackageInfo.fromPlatform();
    const fieldCount = 8;

    appTalker.info('Loaded package diagnostics: $fieldCount package fields');

    return AppPackageInfoSnapshot(
      packageInfo: packageInfo,
      fieldCount: fieldCount,
    );
  } catch (error, stack) {
    appTalker.handle(error, stack, 'Failed to load package info');
    rethrow;
  }
}
