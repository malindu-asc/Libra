import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../widgets/main_shell.dart';

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
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    // MainShell still owns its own IndexedStack and tab-index provider for
    // now — it becomes a StatefulShellRoute in a later step.
    GoRoute(path: '/home', builder: (context, state) => const MainShell()),
  ],
);
