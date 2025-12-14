// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cluster_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(clusterService)
const clusterServiceProvider = ClusterServiceProvider._();

final class ClusterServiceProvider
    extends $FunctionalProvider<ClusterService, ClusterService, ClusterService>
    with $Provider<ClusterService> {
  const ClusterServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clusterServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clusterServiceHash();

  @$internal
  @override
  $ProviderElement<ClusterService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ClusterService create(Ref ref) {
    return clusterService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClusterService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClusterService>(value),
    );
  }
}

String _$clusterServiceHash() => r'908155a177741f5417608903bf5056dde201b524';
