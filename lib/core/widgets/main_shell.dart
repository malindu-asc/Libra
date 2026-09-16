import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The bottom-nav shell every tab lives inside.
///
/// The selected tab is owned by go_router's [StatefulNavigationShell] 
class MainShell extends StatelessWidget {
  const MainShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: navigationShell,
    bottomNavigationBar: NavigationBar(
      selectedIndex: navigationShell.currentIndex,
      // `initialLocation: true` when re-tapping the current tab pops that
      // branch back to its root — the standard bottom-nav behaviour.
      onDestinationSelected: (index) => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      ),
      // Colors/labels/indicator come from navigationBarTheme in app_theme.dart
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.menu_book_outlined),
          selectedIcon: Icon(Icons.menu_book),
          label: 'Books',
        ),
        NavigationDestination(
          icon: Icon(Icons.compare_arrows_outlined),
          selectedIcon: Icon(Icons.compare_arrows),
          label: 'Borrowings',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    ),
  );
}
