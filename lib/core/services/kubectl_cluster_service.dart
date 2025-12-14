import 'dart:convert';
import 'package:kxs/core/interfaces/cluster_service.dart';
import 'package:kxs/shared/models/node_model.dart';
import 'package:kxs/shared/models/namespace_model.dart';
import 'package:kxs/shared/models/pod_model.dart';
import 'package:kxs/shared/models/service_model.dart';
import 'package:kxs/shared/models/deployment_model.dart';
import 'package:kxs/core/services/k8s_provider.dart';

class KubectlClusterService implements ClusterService {
  final K8sController _k8sController;

  KubectlClusterService(this._k8sController);

  @override
  Future<List<NodeModel>> getNodes() async {
    final result = await _k8sController.runKubectl(['get', 'nodes', '-o', 'json']);
    
    if (result.exitCode != 0) {
      throw Exception('Failed to get nodes: ${result.stderr}');
    }

    final Map<String, dynamic> data = jsonDecode(result.stdout as String) as Map<String, dynamic>;
    final List<dynamic> items = data['items'] as List<dynamic>;

    return items.map((item) {
      final metadata = item['metadata'] as Map<String, dynamic>;
      final status = item['status'] as Map<String, dynamic>;
      final conditions = (status['conditions'] as List<dynamic>?) ?? [];
      
      final readyCondition = conditions.firstWhere(
        (c) => c['type'] == 'Ready', 
        orElse: () => {'status': 'Unknown'}
      );
      final isReady = readyCondition['status'] == 'True';
      
      final nodeInfo = status['nodeInfo'] as Map<String, dynamic>?;

      return NodeModel(
        name: metadata['name'] as String? ?? 'Unknown',
        status: isReady ? 'Ready' : 'NotReady',
        version: nodeInfo?['kubeletVersion'] as String? ?? 'Unknown',
        creationTimestamp: metadata['creationTimestamp'] != null 
            ? DateTime.tryParse(metadata['creationTimestamp'] as String) 
            : null,
      );
    }).toList();
  }

  @override
  Future<List<NamespaceModel>> getNamespaces() async {
    final result = await _k8sController.runKubectl(['get', 'namespaces', '-o', 'json']);
    if (result.exitCode != 0) {
      throw Exception('Failed to get namespaces: ${result.stderr}');
    }
    
    final Map<String, dynamic> data = jsonDecode(result.stdout as String) as Map<String, dynamic>;
    final List<dynamic> items = data['items'] as List<dynamic>;
    
    return items.map((item) {
      final metadata = item['metadata'] as Map<String, dynamic>;
      final status = item['status'] as Map<String, dynamic>;
      return NamespaceModel(
        name: metadata['name'] as String? ?? 'Unknown',
        status: status['phase'] as String? ?? 'Unknown',
        creationTimestamp: DateTime.tryParse(metadata['creationTimestamp'] as String? ?? ''),
      );
    }).toList();
  }

  @override
  Future<List<PodModel>> getPods(String namespace) async {
    final args = ['get', 'pods', '-o', 'json'];
    if (namespace != 'all') {
      args.addAll(['-n', namespace]);
    } else {
      args.add('--all-namespaces');
    }

    final result = await _k8sController.runKubectl(args);
    if (result.exitCode != 0) {
      throw Exception('Failed to get pods: ${result.stderr}');
    }

    final Map<String, dynamic> data = jsonDecode(result.stdout as String) as Map<String, dynamic>;
    final List<dynamic> items = data['items'] as List<dynamic>;
    
    return items.map((item) {
      final metadata = item['metadata'] as Map<String, dynamic>;
      final status = item['status'] as Map<String, dynamic>;
      
      // Calculate Restarts
      int restarts = 0;
      if (status['containerStatuses'] != null) {
        for (var container in (status['containerStatuses'] as List<dynamic>)) {
          restarts += (container['restartCount'] as int? ?? 0);
        }
      }

      return PodModel(
        name: metadata['name'] as String? ?? 'Unknown',
        namespace: metadata['namespace'] as String? ?? 'Unknown',
        status: status['phase'] as String? ?? 'Unknown',
        restarts: restarts,
        age: metadata['creationTimestamp'] as String? ?? '', 
        cpu: '0m', 
        memory: '0Mi', 
      );
    }).toList();
  }

  @override
  Future<String> getPodYaml(String namespace, String name) async {
    final result = await _k8sController.runKubectl(['get', 'pod', name, '-n', namespace, '-o', 'yaml']);
    if (result.exitCode != 0) {
      throw Exception('Failed to get pod yaml: ${result.stderr}');
    }
    return result.stdout as String;
  }

  @override
  Future<String> getPodLogs(String namespace, String name, {String? container}) async {
    final args = ['logs', name, '-n', namespace];
    if (container != null) {
      args.addAll(['-c', container]);
    }
    
    final result = await _k8sController.runKubectl(args);
    if (result.exitCode != 0) {
      throw Exception('Failed to get pod logs: ${result.stderr}');
    }
    return result.stdout as String;
  }

  @override
  Future<void> deletePod(String namespace, String name) async {
    final result = await _k8sController.runKubectl(['delete', 'pod', name, '-n', namespace]);
    if (result.exitCode != 0) {
      throw Exception('Failed to delete pod: ${result.stderr}');
    }
  }

  @override
  Future<List<ServiceModel>> getServices(String namespace) async {
    final args = ['get', 'services', '-o', 'json'];
    if (namespace != 'all') {
      args.addAll(['-n', namespace]);
    } else {
      args.add('--all-namespaces');
    }

    final result = await _k8sController.runKubectl(args);
    if (result.exitCode != 0) {
      throw Exception('Failed to get services: ${result.stderr}');
    }

    final Map<String, dynamic> data = jsonDecode(result.stdout as String) as Map<String, dynamic>;
    final List<dynamic> items = data['items'] as List<dynamic>;

    return items.map((item) {
      final metadata = item['metadata'] as Map<String, dynamic>;
      final spec = item['spec'] as Map<String, dynamic>;
      
      final ports = (spec['ports'] as List<dynamic>?)
          ?.map((p) => p['port'] as int)
          .toList() ?? [];

      return ServiceModel(
        name: metadata['name'] as String? ?? 'Unknown',
        namespace: metadata['namespace'] as String? ?? 'Unknown',
        type: spec['type'] as String? ?? 'ClusterIP',
        clusterIP: spec['clusterIP'] as String? ?? '-',
        ports: ports,
        selector: (spec['selector'] as Map<String, dynamic>?)?.cast<String, String>() ?? {},
        creationTimestamp: metadata['creationTimestamp'] != null 
            ? DateTime.tryParse(metadata['creationTimestamp'] as String) 
            : null,
      );
    }).toList();
  }

  @override
  Future<List<DeploymentModel>> getDeployments(String namespace) async {
    final args = ['get', 'deployments', '-o', 'json'];
    if (namespace != 'all') {
      args.addAll(['-n', namespace]);
    } else {
      args.add('--all-namespaces');
    }

    final result = await _k8sController.runKubectl(args);
    if (result.exitCode != 0) {
      throw Exception('Failed to get deployments: ${result.stderr}');
    }

    final Map<String, dynamic> data = jsonDecode(result.stdout as String) as Map<String, dynamic>;
    final List<dynamic> items = data['items'] as List<dynamic>;

    return items.map((item) {
      final metadata = item['metadata'] as Map<String, dynamic>;
      final status = item['status'] as Map<String, dynamic>;
      
      return DeploymentModel(
        name: metadata['name'] as String? ?? 'Unknown',
        namespace: metadata['namespace'] as String? ?? 'Unknown',
        replicas: (item['spec']?['replicas'] as int?) ?? 0,
        readyReplicas: (status['readyReplicas'] as int?) ?? 0,
        upToDateReplicas: (status['updatedReplicas'] as int?) ?? 0,
        availableReplicas: (status['availableReplicas'] as int?) ?? 0,
        age: metadata['creationTimestamp'] as String? ?? '', 
      );
    }).toList();
  }
}
