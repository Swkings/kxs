import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kxs/core/theme/theme_mode.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeController extends _$ThemeController {
  @override
  AppThemeMode build() {
    // In a real app, load from shared_preferences
    return AppThemeMode.dark;
  }

  void setTheme(AppThemeMode mode) {
    state = mode;
  }
}
