// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DashboardController)
const dashboardControllerProvider = DashboardControllerProvider._();

final class DashboardControllerProvider
    extends $NotifierProvider<DashboardController, DashboardTab> {
  const DashboardControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardControllerHash();

  @$internal
  @override
  DashboardController create() => DashboardController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DashboardTab value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DashboardTab>(value),
    );
  }
}

String _$dashboardControllerHash() =>
    r'd474567b573b887ce7d05f6eedaef6e22e5d0c42';

abstract class _$DashboardController extends $Notifier<DashboardTab> {
  DashboardTab build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DashboardTab, DashboardTab>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DashboardTab, DashboardTab>,
              DashboardTab,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
