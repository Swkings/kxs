
import 'dart:io';

void main() async {
  final paths = [
    '/Users/swking/.pub-cache/hosted/pub.dev/kubernetes-1.26.0+5/lib/core_v1.dart',
  ];



  final f = File('/Users/swking/.pub-cache/hosted/pub.dev/kubernetes-1.26.0+5/lib/src/client.dart');
  if (await f.exists()) {
     print('Reading client.dart');
     final content = await f.readAsString();
     
     // Check for Deployment methods
     final regex = RegExp(r'list\w*Deployment\w*');
     final matches = regex.allMatches(content);
     for (final m in matches) {
         print(m.group(0));
     }

     // Check for Service methods
     final regexSvc = RegExp(r'list\w*Service\w*');
     final matchesSvc = regexSvc.allMatches(content);
     for (final m in matchesSvc) {
         print(m.group(0));
     }
  }

}
