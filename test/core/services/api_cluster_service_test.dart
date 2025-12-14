import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:kubernetes/kubernetes.dart';
import 'package:kubernetes/core_v1.dart';
// Import definition file directly (not part file)
import 'package:kubernetes/io_k8s_apimachinery_pkg_apis_meta_v1.dart';
import 'package:kxs/core/services/api_cluster_service.dart';
import 'package:kxs/shared/models/node_model.dart';
import 'package:kxs/shared/models/pod_model.dart';
import 'package:kxs/shared/models/namespace_model.dart';

import 'api_cluster_service_test.mocks.dart';

@GenerateMocks([KubernetesClient])
void main() {
  late MockKubernetesClient mockClient;
  late ApiClusterService service;

  setUp(() {
    mockClient = MockKubernetesClient();
    service = ApiClusterService(mockClient);
  });

  group('ApiClusterService.getNodes', () {
    test('returns list of NodeModel', () async {
      final node = Node(
        metadata: ObjectMeta(name: 'node-1'),
        status: NodeStatus(
          conditions: [NodeCondition(type: 'Ready', status: 'True')],
          addresses: [NodeAddress(type: 'InternalIP', address: '10.0.0.1')],
          capacity: {'cpu': '4', 'memory': '8Gi'},
        ),
      );
      
      final nodeList = NodeList(items: [node]);

      when(mockClient.listCoreV1Node()).thenAnswer((_) async => nodeList);

      final nodes = await service.getNodes();

      expect(nodes.length, 1);
      expect(nodes[0].name, 'node-1');
      expect(nodes[0].status, 'Ready');
      expect(nodes[0].internalIP, '10.0.0.1');
    });
  });
  
  group('ApiClusterService.getPods', () {
    test('returns list of PodModel', () async {
      final now = DateTime.now();
      final pod = Pod(
        metadata: ObjectMeta(
          name: 'pod-1', 
          namespace: 'default',
          creationTimestamp: now,
        ),
        status: PodStatus(
          phase: 'Running',
          containerStatuses: [ContainerStatus(restartCount: 0, name: 'c1', image: '', imageID: '', containerID: '', ready: true)],
          conditions: [],
        ),
      );
      
      final podList = PodList(items: [pod]);

      when(mockClient.listCoreV1NamespacedPod(namespace: 'default'))
          .thenAnswer((_) async => podList);

      final pods = await service.getPods('default');

      expect(pods.length, 1);
      expect(pods[0].name, 'pod-1');
      expect(pods[0].status, 'Running');
      expect(pods[0].restarts, 0);
    });
  });

  group('ApiClusterService.getPodLogs', () {
    test('returns logs as string', () async {
      when(mockClient.readCoreV1NamespacedPodLog(namespace: 'default', name: 'pod-1', container: null))
          .thenAnswer((_) async => 'Log content');

      final logs = await service.getPodLogs('default', 'pod-1');

      expect(logs, 'Log content');
    });
  });

  group('ApiClusterService.getPodYaml', () {
    test('returns JSON representation', () async {
      final pod = Pod(metadata: ObjectMeta(name: 'pod-1'));
      
      when(mockClient.readCoreV1NamespacedPod(namespace: 'default', name: 'pod-1'))
          .thenAnswer((_) async => pod);

      final yaml = await service.getPodYaml('default', 'pod-1');
      
      expect(yaml, contains('pod-1'));
      expect(() => jsonDecode(yaml), returnsNormally);
    });
  });

  group('ApiClusterService.getServices', () {
    test('returns list of ServiceModel', () async {
      final serviceObj = Service(
        metadata: ObjectMeta(name: 'svc-1', namespace: 'default'),
        spec: ServiceSpec(
          type: 'ClusterIP',
          clusterIP: '10.0.0.1',
          ports: [ServicePort(port: 80)],
        ),
      );
      
      final serviceList = ServiceList(items: [serviceObj]);

      when(mockClient.listCoreV1NamespacedService(namespace: 'default'))
          .thenAnswer((_) async => serviceList);

      final services = await service.getServices('default');

      expect(services.length, 1);
      expect(services[0].name, 'svc-1');
      expect(services[0].type, 'ClusterIP');
      expect(services[0].ports, [80]);
    });
  });
}
