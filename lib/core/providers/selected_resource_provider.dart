import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_resource_provider.g.dart';

@riverpod
class SelectedResourceIndex extends _$SelectedResourceIndex {
  @override
  int build() => 0;
  
  void select(int index) => state = index;
  void moveUp() => state = state > 0 ? state - 1 : state;
  void moveDown(int maxIndex) => state = state < maxIndex ? state + 1 : state;
  void reset() => state = 0;
}
