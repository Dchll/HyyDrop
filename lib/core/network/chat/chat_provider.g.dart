// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatHub)
final chatHubProvider = ChatHubProvider._();

final class ChatHubProvider extends $AsyncNotifierProvider<ChatHub, ChatState> {
  ChatHubProvider._()
    : super(
        from: null,
        argument: null,
        retry: netRetry,
        name: r'chatHubProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatHubHash();

  @$internal
  @override
  ChatHub create() => ChatHub();
}

String _$chatHubHash() => r'be402cd5af0ab6cb00db94e310946e7043826578';

abstract class _$ChatHub extends $AsyncNotifier<ChatState> {
  FutureOr<ChatState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ChatState>, ChatState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ChatState>, ChatState>,
              AsyncValue<ChatState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
