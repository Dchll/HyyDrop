// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DiscoveryHub)
final discoveryHubProvider = DiscoveryHubProvider._();

final class DiscoveryHubProvider
    extends $AsyncNotifierProvider<DiscoveryHub, DiscoveryState> {
  DiscoveryHubProvider._()
    : super(
        from: null,
        argument: null,
        retry: netRetry,
        name: r'discoveryHubProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discoveryHubHash();

  @$internal
  @override
  DiscoveryHub create() => DiscoveryHub();
}

String _$discoveryHubHash() => r'3843e3332cc55645ab603586baf3c004e7060c1c';

abstract class _$DiscoveryHub extends $AsyncNotifier<DiscoveryState> {
  FutureOr<DiscoveryState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<DiscoveryState>, DiscoveryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DiscoveryState>, DiscoveryState>,
              AsyncValue<DiscoveryState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
