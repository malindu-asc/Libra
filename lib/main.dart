import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/l10n.dart';

void main() {
  runApp(const ProviderScope(child: LibzoApp()));
}

class LibzoApp extends StatelessWidget {
  const LibzoApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    debugShowCheckedModeBanner: false,
    themeMode: ThemeMode.light,
    theme: AppTheme.light,
    supportedLocales: L10n.supportedLocales,
    localizationsDelegates: L10n.localizationsDelegates,
    onGenerateTitle: (context) => L10n.of(context).appTitle,
    routerConfig: appRouter,
  );
}
