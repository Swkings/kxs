
import 'dart:io';
import 'dart:isolate';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('inspect package', () async {
    final uri = Uri.parse('package:kubernetes/kubernetes.dart');
    final fileUri = await Isolate.resolvePackageUri(uri);
    if (fileUri != null) {
      final file = File.fromUri(fileUri);
      if (await file.exists()) {
        final content = await file.readAsString();
        print('File content length: ${content.length}');
        
        // Find classes ending with Api
        final apiRegex = RegExp(r'class \w+Api');
        final matches = apiRegex.allMatches(content);
        print('Found API classes:');
        for (final m in matches) {
           print(m.group(0));
        }

        // Find classes starting with V1Node
        final nodeRegex = RegExp(r'class V1Node\w*');
        final nodeMatches = nodeRegex.allMatches(content);
        print('Found Node classes:');
        for (final m in nodeMatches.take(10)) {
           print(m.group(0));
        }
      } else {
        print('File not found at $fileUri');
      }
    } else {
      print('Could not resolve URI');
    }
  });
}
