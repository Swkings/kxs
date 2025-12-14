import 'package:kubernetes/kubernetes.dart';
import 'package:http/http.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('probe', () {

    final client = KubernetesClient(serverUrl: 'https://kubernetes.docker.internal:6443', httpClient: null as dynamic, accessToken: '');
    dynamic d = client;
    try {
      print('Probing coreV1Api: ${d.coreV1Api}'); 
    } catch (e) { print('coreV1Api failed: $e'); }
    try {
      print('Probing coreV1: ${d.coreV1}'); 
    } catch (e) { print('coreV1 failed: $e'); }
    try {
      print('Probing apiClient: ${d.apiClient}'); 
    } catch (e) { print('apiClient failed: $e'); }
    try {
      print('Probing api: ${d.api}'); 
    } catch (e) { print('api failed: $e'); }
  });
}
