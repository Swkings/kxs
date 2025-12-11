// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_resource_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedResourceIndex)
const selectedResourceIndexProvider = SelectedResourceIndexProvider._();

final class SelectedResourceIndexProvider
    extends $NotifierProvider<SelectedResourceIndex, int> {
  const SelectedResourceIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedResourceIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedResourceIndexHash();

  @$internal
  @override
  SelectedResourceIndex create() => SelectedResourceIndex();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$selectedResourceIndexHash() =>
    r'1da3c77f285388faa894281dbfc5594bda39e709';

abstract class _$SelectedResourceIndex extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
