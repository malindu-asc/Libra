import 'package:go_router/go_router.dart';

import '../../features/splash/presentation/screens/splash_screen.dart';

/// Every route in the app, declared in one place — the folder `plan.md` §3
/// always reserved for this.
///
/// Being migrated screen-by-screen: anything not registered here still
/// navigates with `Navigator.push` and keeps working, because go_router is
/// built on Navigator underneath. The only difference is that unregistered
/// screens have no URL of their own.
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
  ],
);
