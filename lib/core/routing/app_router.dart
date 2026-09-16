import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/books/presentation/screens/book_details_screen.dart';
import '../../features/members/presentation/screens/change_password_screen.dart';
import '../../features/members/presentation/screens/edit_profile_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
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
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    // MainShell still owns its own IndexedStack and tab-index provider for
    // now — it becomes a StatefulShellRoute in a later step.
    GoRoute(path: '/home', builder: (context, state) => const MainShell()),
    GoRoute(
      path: '/books/:id',
      builder: (context, state) =>
          BookDetailsScreen(bookId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/profile/edit',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/profile/password',
      builder: (context, state) => const ChangePasswordScreen(),
    ),
  ],
);
