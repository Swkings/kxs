
import 'package:kubernetes/kubernetes.dart';
import 'package:test/test.dart';
import 'dart:mirrors';

void main() {
  test('mirror probe', () {
    final m = reflectClass(KubernetesClient);
    print('Class: ${m.simpleName}');
    print('Declarations:');
    m.declarations.forEach((s, d) {
      print(SymbolHelper.getName(s));
    });
  });
}

class SymbolHelper {
  static String getName(Symbol s) {
    return s.toString().split('"')[1];
  }
}
