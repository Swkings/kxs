import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

@Riverpod(keepAlive: true)
class Settings extends _$Settings {
  @override
  bool build() {
    // Default: useKubectl = false (Usage of Kubernetes Client API)
    return false;
  }

  void setUseKubectl(bool value) {
    print('Toggling Use Kubectl to: $value');
    state = value;
  }
}
