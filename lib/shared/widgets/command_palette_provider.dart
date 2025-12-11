import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'command_palette_provider.g.dart';

@riverpod
class CommandPaletteVisible extends _$CommandPaletteVisible {
  @override
  bool build() => false;
  
  void show() => state = true;
  void hide() => state = false;
  void toggle() => state = !state;
}
