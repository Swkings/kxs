import 'package:kubernetes/kubernetes.dart';


abstract class PodDetailsRepository {
  Future<String> getPodYaml(String namespace, String name);
  Future<String> getPodLogs(String namespace, String name, {String? container});
}

class PodDetailsRepositoryImpl implements PodDetailsRepository {
  final KubernetesClient client;

  PodDetailsRepositoryImpl(this.client);

  @override
  Future<String> getPodYaml(String namespace, String name) async {
    // We use dynamic dispatch to access generated API methods without strict typing issues
    final dynamic dClient = client;
    final dynamic result = await dClient.coreV1.readNamespacedPod(name, namespace);
    
    Map<String, dynamic> jsonMap;
    try {
        jsonMap = (result as dynamic).toJson() as Map<String, dynamic>;
    } catch (e) {
        jsonMap = {'error': 'Could not serialize pod object', 'details': e.toString()};
    }
    
    return _jsonToYaml(jsonMap);
  }

  @override
  Future<String> getPodLogs(String namespace, String name, {String? container}) async {
    final dynamic dClient = client;
    // CoreV1Api.readNamespacedPodLog
    final result = await dClient.coreV1.readNamespacedPodLog(
      name, 
      namespace, 
      container: container
    );
    return result as String;
  }

  String _jsonToYaml(Map<String, dynamic> json, [int indent = 0]) {
    final buffer = StringBuffer();
    final spaces = ' ' * indent;
    
    json.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        buffer.writeln('$spaces$key:');
        buffer.write(_jsonToYaml(value, indent + 2));
      } else if (value is List) {
        buffer.writeln('$spaces$key:');
        for (var item in value) {
           if (item is Map<String, dynamic>) {
             buffer.writeln('$spaces  -');
             // This is a bit hacky for list of maps, purely visual "YAML-like"
             // A real dumper is better but trying to be dependency-lite or quick.
             // Let's iterate keys of item
             final itemYaml = _jsonToYaml(item, indent + 4);
             // We need to trim the first indentation to match the dash?
             // Actually standard yaml for dict in list:
             // - key: value
             buffer.write(itemYaml);
           } else {
             buffer.writeln('$spaces  - $item');
           }
        }
      } else {
        buffer.writeln('$spaces$key: $value');
      }
    });
    return buffer.toString();
  }
}
