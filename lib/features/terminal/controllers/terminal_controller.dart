import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kxs/features/terminal/models/terminal_settings.dart';

part 'terminal_controller.g.dart';

@riverpod
class TerminalSettingsController extends _$TerminalSettingsController {
  @override
  TerminalSettings build() {
    // Fire and forget shell detection
    _detectShell();
    return const TerminalSettings();
  }

  Future<void> _detectShell() async {
    if (Platform.isMacOS || Platform.isLinux) {
      if (await File('/bin/zsh').exists()) {
        state = state.copyWith(shellPath: '/bin/zsh');
      } else if (await File('/bin/bash').exists()) {
        state = state.copyWith(shellPath: '/bin/bash');
      }
    } else if (Platform.isWindows) {
      state = state.copyWith(shellPath: 'powershell.exe');
    }
  }

  void updateShellPath(String path) {
    state = state.copyWith(shellPath: path);
  }
  
  void updateFontSize(double size) {
    state = state.copyWith(fontSize: size);
  }

  Future<List<String>> getAvailableShells() async {
    final List<String> shells = [];
    if (Platform.isMacOS || Platform.isLinux) {
      final candidates = ['/bin/zsh', '/bin/bash', '/bin/sh', '/usr/local/bin/fish'];
      for (final s in candidates) {
        if (await File(s).exists()) shells.add(s);
      }
    } else if (Platform.isWindows) {
      shells.addAll(['powershell.exe', 'cmd.exe']);
    }
    return shells;
  }
}
