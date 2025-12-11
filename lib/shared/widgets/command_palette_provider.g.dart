// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'command_palette_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CommandPaletteVisible)
const commandPaletteVisibleProvider = CommandPaletteVisibleProvider._();

final class CommandPaletteVisibleProvider
    extends $NotifierProvider<CommandPaletteVisible, bool> {
  const CommandPaletteVisibleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'commandPaletteVisibleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$commandPaletteVisibleHash();

  @$internal
  @override
  CommandPaletteVisible create() => CommandPaletteVisible();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$commandPaletteVisibleHash() =>
    r'a26de4136458ec854932933e910258f1050e4552';

abstract class _$CommandPaletteVisible extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
