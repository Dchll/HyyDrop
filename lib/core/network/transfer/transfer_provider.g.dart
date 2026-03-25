// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TransferHub)
final transferHubProvider = TransferHubProvider._();

final class TransferHubProvider
    extends $AsyncNotifierProvider<TransferHub, TransferState> {
  TransferHubProvider._()
    : super(
        from: null,
        argument: null,
        retry: netRetry,
        name: r'transferHubProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transferHubHash();

  @$internal
  @override
  TransferHub create() => TransferHub();
}

String _$transferHubHash() => r'ab135346038e920a9c28c02fb893fdfac7d81bad';

abstract class _$TransferHub extends $AsyncNotifier<TransferState> {
  FutureOr<TransferState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<TransferState>, TransferState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TransferState>, TransferState>,
              AsyncValue<TransferState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
