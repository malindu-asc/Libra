import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/books/presentation/screens/books_screen.dart';
import '../../features/borrowings/presentation/screens/my_borrowings_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../providers/main_shell_providers.dart';
import '../../features/members/presentation/screens/profile_screen.dart';

/// The bottom-nav shell every tab lives inside. Selected tab lives in
/// mainShellTabIndexProvider (not local State) so anything in the tree —
/// like Home's search bar — can switch tabs without a callback threaded
/// all the way down.
class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(mainShellTabIndexProvider);

    const tabs = [
      HomeScreen(),
      BooksScreen(),
      MyBorrowingsScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      // IndexedStack keeps each tab's state alive when switching away from it.
      body: IndexedStack(index: currentIndex, children: tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) =>
            ref.read(mainShellTabIndexProvider.notifier).select(index),
        // Colors/labels/indicator come from navigationBarTheme in
        // app_theme.dart
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
}

