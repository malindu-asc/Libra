import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'l10n/l10n.dart';

void main() {
  runApp(const ProviderScope(child: LibzoApp()));
}

class LibzoApp extends StatelessWidget {
  const LibzoApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    themeMode: ThemeMode.light,
    theme: AppTheme.light,
    supportedLocales: L10n.supportedLocales,
    localizationsDelegates: L10n.localizationsDelegates,
    onGenerateTitle: (context) => L10n.of(context).appTitle,
    home: const SplashScreen(),
  );
}
