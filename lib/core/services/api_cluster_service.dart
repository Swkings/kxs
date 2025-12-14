import 'dart:convert';
import 'package:kxs/core/interfaces/cluster_service.dart';
import 'package:kxs/shared/models/node_model.dart';
import 'package:kxs/shared/models/namespace_model.dart';
import 'package:kxs/shared/models/pod_model.dart';
import 'package:kxs/shared/models/service_model.dart';
import 'package:kxs/shared/models/deployment_model.dart';
import 'package:kubernetes/kubernetes.dart';
import 'package:kubernetes/core_v1.dart';


import 'package:http/http.dart';

class ApiClusterService implements ClusterService {
  final KubernetesClient? _client;
  final Client? _httpClient;

  ApiClusterService(this._client, {Client? httpClient}) : _httpClient = httpClient;

  @override
  Future<List<NodeModel>> getNodes() async {
    if (_client == null) throw Exception('API Client not initialized');
    
    try {
      // Try using generated client
      final result = await _client!.listCoreV1Node();
      return _mapNodeList(result);
    } catch (e) {
      // Fallback to manual JSON parsing if generated client fails on type casting
      // This is common with dart-kubernetes package on some K8s versions where nullable ints are not handled
      if (_httpClient == null || _client?.serverUrl == null) {
        rethrow;
      }

      try {
        final uri = Uri.parse('${_client!.serverUrl}/api/v1/nodes');
        final response = await _httpClient!.get(uri);
        
        if (response.statusCode != 200) {
           throw Exception('Failed to fetch nodes manually: Status ${response.statusCode}');
        }

        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final items = (json['items'] as List).cast<Map<String, dynamic>>();
        
        return items.map((node) {
          final metadata = node['metadata'];
          final status = node['status'];
          
          // Role
          String role = 'worker';
          final labels = metadata['labels'] as Map<String, dynamic>?;
          if (labels != null) {
             if (labels.containsKey('node-role.kubernetes.io/control-plane') || 
                 labels.containsKey('node-role.kubernetes.io/master')) {
               role = 'master';
             }
          }

          // Status and addresses logic similar to main flow
          String nodeStatus = 'Unknown';
          final conditions = status['conditions'] as List?;
          if (conditions != null) {
            for (final c in conditions) {
              if (c['type'] == 'Ready') {
                nodeStatus = c['status'] == 'True' ? 'Ready' : 'NotReady';
                break;
              }
            }
          }

          String? internalIP;
          String? externalIP;
          final addresses = status['addresses'] as List?;
          if (addresses != null) {
            for (final addr in addresses) {
              if (addr['type'] == 'InternalIP') internalIP = addr['address'];
              if (addr['type'] == 'ExternalIP') externalIP = addr['address'];
            }
          }

          return NodeModel(
            name: metadata['name'] ?? 'Unknown',
            status: nodeStatus,
            version: status['nodeInfo']?['kubeletVersion'] ?? 'Unknown',
            creationTimestamp: metadata['creationTimestamp'] != null 
                ? DateTime.tryParse(metadata['creationTimestamp']) 
                : null,
            role: role,
            internalIP: internalIP,
            externalIP: externalIP,
            cpuCapacity: status['capacity']?['cpu'],
            memoryCapacity: status['capacity']?['memory'],
          );
        }).toList();

      } catch (fallbackError) {
         throw Exception('Failed to fetch nodes: $e (Fallback also failed: $fallbackError)');
      }
    }
  }

  List<NodeModel> _mapNodeList(NodeList list) {
    return list.items.map((node) {
      final metadata = node.metadata;
      final status = node.status;
      
      // Determine Role
      String role = 'worker';
      final labels = metadata?.labels;
      if (labels != null) {
         if (labels.containsKey('node-role.kubernetes.io/control-plane') || 
             labels.containsKey('node-role.kubernetes.io/master')) {
           role = 'master';
         }
      }

      // Determine Status
      String nodeStatus = 'Unknown';
      final conditions = status?.conditions;
      if (conditions != null) {
        for (final c in conditions) {
          if (c.type == 'Ready') {
            nodeStatus = c.status == 'True' ? 'Ready' : 'NotReady';
            break;
          }
        }
      }

      // Addresses
      String? internalIP;
      String? externalIP;
      final addresses = status?.addresses;
      if (addresses != null) {
        for (var addr in addresses) {
          if (addr.type == 'InternalIP') internalIP = addr.address;
          if (addr.type == 'ExternalIP') externalIP = addr.address;
        }
      }

      return NodeModel(
        name: metadata?.name ?? 'Unknown',
        status: nodeStatus,
        version: status?.nodeInfo?.kubeletVersion ?? 'Unknown',
        creationTimestamp: metadata?.creationTimestamp,
        role: role,
        internalIP: internalIP,
        externalIP: externalIP,
        cpuCapacity: status?.capacity?['cpu'],
        memoryCapacity: status?.capacity?['memory'],
      );
    }).toList();
  }

  @override
  Future<List<NamespaceModel>> getNamespaces() async {
    if (_client == null) throw Exception('API Client not initialized');

    final result = await _client!.listCoreV1Namespace();
    
    return result.items.map((ns) {
      return NamespaceModel(
        name: ns.metadata?.name ?? 'Unknown',
        status: ns.status?.phase ?? 'Unknown',
        creationTimestamp: ns.metadata?.creationTimestamp,
      );
    }).toList();
  }

  @override
  Future<List<PodModel>> getPods(String namespace) async {
    if (_client == null) throw Exception('API Client not initialized');

    dynamic result;
    
    if (namespace == 'all') {
      result = await _client!.listCoreV1PodForAllNamespaces();
    } else {
      result = await _client!.listCoreV1NamespacedPod(namespace: namespace);
    }

    // items is usually List<Pod>
    final items = result.items as List;
    
    return items.map((item) {
      final dynamic pod = item;
      
      final dynamic metadata = pod.metadata;
      final dynamic status = pod.status;
      final dynamic spec = pod.spec;
      
      int restarts = 0;
      final dynamic containerStatuses = status?.containerStatuses;
      if (containerStatuses != null) {
        for (var container in containerStatuses) {
          restarts += (container.restartCount as int? ?? 0);
        }
      }

      String age = '';
      final timestamp = metadata?.creationTimestamp;
      if (timestamp != null) {
        final DateTime created = timestamp as DateTime;
        final duration = DateTime.now().difference(created);
        if (duration.inDays > 0) {
           age = '${duration.inDays}d';
        } else if (duration.inHours > 0) {
           age = '${duration.inHours}h';
        } else {
           age = '${duration.inMinutes}m';
        }
      }

      return PodModel(
        name: (metadata?.name as String?) ?? 'Unknown',
        namespace: (metadata?.namespace as String?) ?? 'Unknown',
        status: (status?.phase as String?) ?? 'Unknown',
        nodeName: spec?.nodeName as String?, 
        creationTimestamp: timestamp as DateTime?,
        restarts: restarts,
        age: age,
        cpu: null, 
        memory: null,
      );
    }).toList();
  }

  @override
  Future<String> getPodYaml(String namespace, String name) async {
    if (_client == null) throw Exception('API Client not initialized');
    
    // We fetch the object and return it as JSON string since we don't have YAML serializer readily available.
    // K9s feature allows viewing YAML, but JSON is structurally equivalent for inspection.
    final result = await _client!.readCoreV1NamespacedPod(namespace: namespace, name: name);
    
    // Provided Kubernetes package models usually support toJson or we need to rely on dynamic casting
    // If result is dynamic, we try jsonEncode(result)
    // If result is typed, it usually has toJson().
    try {
      // Trying to cast to dynamic to check for toJson or Map access
      final dynamic dynResult = result;
      // Most generated clients have toJson() method
      // Note: We need dart:convert for jsonEncode
      // Currently we return toString() if JSON fails, but assume models work with jsonEncode
      return jsonEncode(dynResult); 
    } catch (e) {
      return result.toString();
    }
  }

  @override
  Future<String> getPodLogs(String namespace, String name, {String? container}) async {
    if (_client == null) throw Exception('API Client not initialized');
    
    final result = await _client!.readCoreV1NamespacedPodLog(
      namespace: namespace, 
      name: name,
      container: container,
    );
    
    return result;
  }

  @override
  Future<List<ServiceModel>> getServices(String namespace) async {
    if (_client == null) throw Exception('API Client not initialized');

    final result = await _client!.listCoreV1NamespacedService(namespace: namespace);
    
    return result.items.map((svc) {
      final metadata = svc.metadata;
      final spec = svc.spec;
      
      final ports = spec?.ports?.map((p) => p.port).toList() ?? <int>[];

      return ServiceModel(
        name: metadata?.name ?? 'Unknown',
        namespace: metadata?.namespace ?? 'Unknown',
        type: spec?.type ?? 'ClusterIP',
        clusterIP: spec?.clusterIP ?? '-',
        ports: ports,
        selector: spec?.selector?.cast<String, String>() ?? {},
        creationTimestamp: metadata?.creationTimestamp,
      );
    }).toList();
  }

  @override
  Future<List<DeploymentModel>> getDeployments(String namespace) async {
    if (_client == null) throw Exception('API Client not initialized');

    final result = await _client!.listAppsV1NamespacedDeployment(namespace: namespace);
    
    return result.items.map((deploy) {
      final metadata = deploy.metadata;
      final status = deploy.status;
      
      final created = metadata?.creationTimestamp;
      String age = '';
      if (created != null) {
        final duration = DateTime.now().difference(created);
        if (duration.inDays > 0) {
           age = '${duration.inDays}d';
        } else if (duration.inHours > 0) {
           age = '${duration.inHours}h';
        } else {
           age = '${duration.inMinutes}m';
        }
      }

      return DeploymentModel(
        name: metadata?.name ?? 'Unknown',
        namespace: metadata?.namespace ?? 'Unknown',
        replicas: status?.replicas ?? 0,
        readyReplicas: status?.readyReplicas ?? 0,
        upToDateReplicas: status?.updatedReplicas ?? 0,
        availableReplicas: status?.availableReplicas ?? 0,
        age: age,
      );
    }).toList();
  }

  @override
  Future<void> deletePod(String namespace, String name) async {
    if (_client == null) throw Exception('API Client not initialized');
    
    try {
      await _client!.deleteCoreV1NamespacedPod(
        name: name,
        namespace: namespace,
      );
    } catch (e) {
      if (_httpClient != null && _client?.serverUrl != null) {
         // Fallback manual delete
         try {
           final uri = Uri.parse('${_client!.serverUrl}/api/v1/namespaces/$namespace/pods/$name');
           final response = await _httpClient!.delete(uri);
           if (response.statusCode != 200 && response.statusCode != 202) {
             throw Exception('Failed to delete pod manually: ${response.statusCode}');
           }
           return;
         } catch (manualErr) {
             throw Exception('Failed to delete pod: $e (Manual: $manualErr)');
         }
      }
      rethrow;
    }
  }
}
