// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terminal_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TerminalSettingsController)
const terminalSettingsControllerProvider =
    TerminalSettingsControllerProvider._();

final class TerminalSettingsControllerProvider
    extends $NotifierProvider<TerminalSettingsController, TerminalSettings> {
  const TerminalSettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'terminalSettingsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$terminalSettingsControllerHash();

  @$internal
  @override
  TerminalSettingsController create() => TerminalSettingsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TerminalSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TerminalSettings>(value),
    );
  }
}

String _$terminalSettingsControllerHash() =>
    r'b53ef538ddcca85f463bf8d1053b68c9576816c3';

abstract class _$TerminalSettingsController
    extends $Notifier<TerminalSettings> {
  TerminalSettings build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<TerminalSettings, TerminalSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TerminalSettings, TerminalSettings>,
              TerminalSettings,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
