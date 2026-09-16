import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/book_cover.dart';
import '../../domain/entities/book.dart';
import '../providers/book_providers.dart';
import '../widgets/borrow_confirmation_sheet.dart';

class BookDetailsScreen extends ConsumerWidget {
  const BookDetailsScreen({required this.bookId, super.key});

  final String bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookAsync = ref.watch(bookByIdProvider(bookId)); //actively listen on bookIdProvider

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: bookAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) => AppErrorState(
          onRetry: () => ref.invalidate(bookByIdProvider(bookId)),
        ),
        data: (book) => _BookDetailsBody(book: book),
      ),
      bottomNavigationBar: bookAsync.maybeWhen(
        data: (book) => _BorrowBar(book: book),
        orElse: () => null,
      ),
    );
  }
}

class _BookDetailsBody extends StatelessWidget {
  const _BookDetailsBody({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (book.availableCopies) {
      0 => ('Unavailable', AppColors.error),
      <= 2 => ('Few copies', AppColors.warning),
      _ => ('Available', AppColors.success),
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.softSurface,
              borderRadius: AppRadius.largeCardRadius,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BookCover(
                  width: 100,
                  height: 150,
                  imageUrl: book.coverImageUrl,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          label,
                          style: AppTextStyles.metadata.copyWith(color: color),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        book.title,
                        style: AppTextStyles.screenTitle.copyWith(
                          color: AppColors.textHeading,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        book.author,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.section),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.cardRadius,
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _StatColumn(
                      label: 'Published',
                      value: '${book.publishedYear}',
                    ),
                    _StatColumn(
                      label: 'Copies',
                      value: '${book.availableCopies} of ${book.totalCopies}',
                    ),
                    _StatColumn(
                      label: 'Pages',
                      value: book.pages?.toString() ?? '—',
                    ),
                  ],
                ),
                const Divider(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ISBN',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    Text(
                      book.isbn,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.section),
          Text(
            'About This Book',
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.textHeading,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            book.description ?? 'No description available.',
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.section),
        ],
      ),
    );
  }
}

class _BorrowBar extends StatelessWidget {
  const _BorrowBar({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.sm,
        AppSpacing.screenPadding,
        AppSpacing.sm,
      ),
      child: SizedBox(
        height: 56,
        child: ElevatedButton.icon(
          onPressed: book.availableCopies > 0
              ? () => showBorrowConfirmationSheet(context, book)
              : null,
          style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
          icon: const Icon(Icons.bookmark_add_outlined),
          label: Text(
            book.availableCopies > 0
                ? 'Borrow Book'
                : 'Currently Unavailable',
          ),
        ),
      ),
    ),
  );
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.cardTitle.copyWith(color: AppColors.textHeading),
        ),
      ],
    ),
  );
}
