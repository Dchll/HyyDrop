// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDeviceInfo)
final appDeviceInfoProvider = AppDeviceInfoProvider._();

final class AppDeviceInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<AppDeviceInfoSnapshot>,
          AppDeviceInfoSnapshot,
          FutureOr<AppDeviceInfoSnapshot>
        >
    with
        $FutureModifier<AppDeviceInfoSnapshot>,
        $FutureProvider<AppDeviceInfoSnapshot> {
  AppDeviceInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDeviceInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDeviceInfoHash();

  @$internal
  @override
  $FutureProviderElement<AppDeviceInfoSnapshot> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AppDeviceInfoSnapshot> create(Ref ref) {
    return appDeviceInfo(ref);
  }
}

String _$appDeviceInfoHash() => r'a100cb957f1b5536d0b9874b519fce99de776342';
