import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../domain/entities/book.dart';
import '../providers/book_providers.dart';
import '../widgets/book_card.dart';
import 'book_details_screen.dart';

class BooksScreen extends ConsumerStatefulWidget {
  const BooksScreen({super.key});

  @override
  ConsumerState<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends ConsumerState<BooksScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  bool _availableOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Book> _filter(List<Book> books) {
    final query = _query.trim().toLowerCase();
    return books.where((book) {
      final matchesQuery =
          query.isEmpty ||
          book.title.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query);
      final matchesAvailability = !_availableOnly || book.availableCopies > 0;
      return matchesQuery && matchesAvailability;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final booksAsync = ref.watch(bookListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Books')),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Search books or authors...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.softSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                _FilterChip(
                  label: 'All',
                  selected: !_availableOnly,
                  onTap: () => setState(() => _availableOnly = false),
                ),
                const SizedBox(width: AppSpacing.sm),
                _FilterChip(
                  label: 'Available',
                  selected: _availableOnly,
                  onTap: () => setState(() => _availableOnly = true),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: booksAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator.adaptive()),
                error: (error, _) =>
                    AppErrorState(onRetry: () => ref.invalidate(bookListProvider)),
                data: (books) {
                  final filtered = _filter(books);
                  if (filtered.isEmpty) {
                    return AppEmptyState(
                      icon: Icons.search_off,
                      title: 'No books found',
                      message: 'Try a different title or author.',
                      actionLabel: (_query.isEmpty && !_availableOnly)
                          ? null
                          : 'Clear Search',
                      onAction: () => setState(() {
                        _searchController.clear();
                        _query = '';
                        _availableOnly = false;
                      }),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${filtered.length} books',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Expanded(
                        child: GridView.builder(
                          itemCount: filtered.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: AppSpacing.md,
                                mainAxisSpacing: AppSpacing.md,
                                childAspectRatio: 0.48,
                              ),
                          itemBuilder: (context, index) => BookCard(
                            book: filtered[index],
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BookDetailsScreen(
                                  bookId: filtered[index].id,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.softSurface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.metadata.copyWith(
          color: selected ? AppColors.onPrimary : AppColors.textSecondary,
        ),
      ),
    ),
  );
}