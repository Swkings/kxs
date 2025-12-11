import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kxs/core/theme/app_theme.dart';
import 'package:kxs/core/theme/theme_mode.dart';
import 'package:kxs/core/theme/theme_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:kxs/l10n/app_localizations.dart';

import 'package:kxs/features/home/views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1280, 800),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const ProviderScope(child: KxsApp()));
}

class KxsApp extends ConsumerWidget {
  const KxsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    final brightness = MediaQuery.of(context).platformBrightness;
    
    ThemeData getTheme() {
      switch (themeMode) {
        case AppThemeMode.light:
          return AppThemes.lightTheme;
        case AppThemeMode.dark:
          return AppThemes.darkTheme;
        case AppThemeMode.system:
          return brightness == Brightness.dark 
            ? AppThemes.darkTheme 
            : AppThemes.lightTheme;
        case AppThemeMode.cyberpunk:
          return AppThemes.cyberpunkTheme;
        case AppThemeMode.ocean:
          return AppThemes.oceanTheme;
      }
    }
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'kxs',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: getTheme(),
      home: const HomeView(),
    );
  }
}
