// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'self_peer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(selfPeer)
final selfPeerProvider = SelfPeerProvider._();

final class SelfPeerProvider
    extends $FunctionalProvider<AsyncValue<LanPeer>, LanPeer, FutureOr<LanPeer>>
    with $FutureModifier<LanPeer>, $FutureProvider<LanPeer> {
  SelfPeerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selfPeerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selfPeerHash();

  @$internal
  @override
  $FutureProviderElement<LanPeer> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<LanPeer> create(Ref ref) {
    return selfPeer(ref);
  }
}

String _$selfPeerHash() => r'b390ddb6d71734a9bf2db8c6eecc9983885c917f';
