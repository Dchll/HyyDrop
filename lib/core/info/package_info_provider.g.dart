// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appPackageInfo)
final appPackageInfoProvider = AppPackageInfoProvider._();

final class AppPackageInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<AppPackageInfoSnapshot>,
          AppPackageInfoSnapshot,
          FutureOr<AppPackageInfoSnapshot>
        >
    with
        $FutureModifier<AppPackageInfoSnapshot>,
        $FutureProvider<AppPackageInfoSnapshot> {
  AppPackageInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appPackageInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appPackageInfoHash();

  @$internal
  @override
  $FutureProviderElement<AppPackageInfoSnapshot> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AppPackageInfoSnapshot> create(Ref ref) {
    return appPackageInfo(ref);
  }
}

String _$appPackageInfoHash() => r'e58dd03cb36e7ca8a594e696984435094ecac33c';
