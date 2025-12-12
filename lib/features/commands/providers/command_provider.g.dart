// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'command_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for command history

@ProviderFor(CommandHistory)
const commandHistoryProvider = CommandHistoryProvider._();

/// Provider for command history
final class CommandHistoryProvider
    extends $NotifierProvider<CommandHistory, List<String>> {
  /// Provider for command history
  const CommandHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'commandHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$commandHistoryHash();

  @$internal
  @override
  CommandHistory create() => CommandHistory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$commandHistoryHash() => r'619d8a7cdb792106d62c1b3b790716db80f996be';

/// Provider for command history

abstract class _$CommandHistory extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
