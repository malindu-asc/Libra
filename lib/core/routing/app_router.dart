import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/providers/current_member_provider.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/books/presentation/screens/book_details_screen.dart';
import '../../features/books/presentation/screens/books_screen.dart';
import '../../features/borrowings/presentation/screens/my_borrowings_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/members/presentation/screens/change_password_screen.dart';
import '../../features/members/presentation/screens/edit_profile_screen.dart';
import '../../features/members/presentation/screens/profile_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../widgets/main_shell.dart';

part 'app_router.g.dart';

/// Pushing onto this key puts a screen *above* the shell, so it covers the
/// bottom nav bar. Without it, Book Details and the profile sub-screens would
/// render inside their tab with the nav bar still showing.
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Reachable without being signed in.
const _publicRoutes = {
  '/onboarding',
  '/login',
  '/register',
  '/forgot-password',
};

/// Every route in the app, declared in one place — the folder `plan.md` §3
/// always reserved for this.
///
/// A provider rather than a top-level final so [redirect] can read
/// `currentMemberProvider`. `keepAlive` because rebuilding the router would
/// throw away the whole navigation stack.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) => GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',

  /// Runs on every navigation. Returning a path redirects there; null lets
  /// the requested route through. This is the only place that decides what
  /// requires a session — screens no longer each answer that themselves.
  redirect: (context, state) {
    final location = state.matchedLocation;

    // Splash owns the launch decision — it restores the session first, then
    // routes. Guarding it here would redirect before that ever runs.
    if (location == '/') return null;

    final signedIn = ref.read(currentMemberProvider) != null;
    final isPublic = _publicRoutes.contains(location);

    if (!signedIn && !isPublic) return '/login';
    if (signedIn && isPublic) return '/home';
    return null;
  },
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

    /// The four bottom-nav tabs. Each branch keeps its own navigation state,
    /// so switching tabs preserves where you were — what `IndexedStack` used
    /// to do by hand.
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/books',
              builder: (context, state) => const BooksScreen(),
              routes: [
                // Nested, so the URL stays /books/:id — but rendered on the
                // root navigator so it covers the nav bar.
                GoRoute(
                  path: ':id',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) =>
                      BookDetailsScreen(bookId: state.pathParameters['id']!),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/borrowings',
              builder: (context, state) => const MyBorrowingsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: 'edit',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const EditProfileScreen(),
                ),
                GoRoute(
                  path: 'password',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const ChangePasswordScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
