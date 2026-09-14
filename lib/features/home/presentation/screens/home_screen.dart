import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/providers/main_shell_providers.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/book_cover.dart';
import '../../../auth/domain/entities/authenticated_member.dart';
import '../../../books/domain/entities/book.dart';
import '../../../books/presentation/providers/book_providers.dart';
import '../../../books/presentation/screens/book_details_screen.dart';
import '../../../books/presentation/widgets/book_card.dart';
import '../../../borrowings/presentation/models/active_borrowing_preview.dart';
import '../../../borrowings/presentation/providers/borrowings_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({required this.member, super.key});

  final AuthenticatedMember member;

  String get _firstName {
    final trimmed = member.fullName.trim();
    return trimmed.isEmpty ? 'there' : trimmed.split(' ').first;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeBorrowingsAsync = ref.watch(activeBorrowingsPreviewProvider);
    final activeLimit = ref.watch(activeBorrowingsLimitProvider);
    final booksAsync = ref.watch(bookListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.md,
          ),
          children: [
            _GreetingRow(firstName: _firstName),
            const SizedBox(height: AppSpacing.section),
            _SearchBar(
              onTap: () =>
                  ref.read(mainShellTabIndexProvider.notifier).select(1),
            ),
            const SizedBox(height: AppSpacing.section),
            _MyBorrowingsSection(
              borrowingsAsync: activeBorrowingsAsync,
              activeLimit: activeLimit,
            ),
            const SizedBox(height: AppSpacing.section),
            _RecommendedSection(
              booksAsync: booksAsync,
              onRetry: () => ref.invalidate(bookListProvider),
            ),
            const SizedBox(height: AppSpacing.section),
          ],
        ),
      ),
    );
  }
}

class _GreetingRow extends StatelessWidget {
  const _GreetingRow({required this.firstName});

  final String firstName;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good morning,',
              style: AppTextStyles.screenTitle.copyWith(
                color: AppColors.textHeading,
              ),
            ),
            Text(
              firstName,
              style: AppTextStyles.screenTitle.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
      Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.softSurface,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                // TODO: no notifications screen yet.
              },
              icon: const Icon(
                Icons.notifications_outlined,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(width: AppSpacing.sm),
      CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.primarySoft,
        child: Text(
          firstName.isNotEmpty ? firstName[0].toUpperCase() : '?',
          style: AppTextStyles.cardTitle.copyWith(color: AppColors.primary),
        ),
      ),
    ],
  );
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(14),
    onTap: onTap,
    child: Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.softSurface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.textTertiary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Search books, authors, or genres...',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _MyBorrowingsSection extends StatefulWidget {
  const _MyBorrowingsSection({
    required this.borrowingsAsync,
    required this.activeLimit,
  });

  final AsyncValue<List<ActiveBorrowingPreview>> borrowingsAsync;
  final int activeLimit;

  @override
  State<_MyBorrowingsSection> createState() => _MyBorrowingsSectionState();
}

class _MyBorrowingsSectionState extends State<_MyBorrowingsSection> {
  final _controller = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borrowings = widget.borrowingsAsync.value ?? const [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'My Borrowings',
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.textHeading,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${borrowings.length} of ${widget.activeLimit} active',
                style: AppTextStyles.metadata.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Keep track of your reading',
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.md),
        if (widget.borrowingsAsync.isLoading && borrowings.isEmpty)
          const SizedBox(
            height: 160,
            child: Center(child: CircularProgressIndicator.adaptive()),
          )
        else if (borrowings.isEmpty)
          _EmptyBorrowingsCard()
        else ...[
          SizedBox(
            height: 160,
            child: PageView.builder(
              controller: _controller,
              itemCount: borrowings.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) =>
                  _BorrowingCard(preview: borrowings[index]),
            ),
          ),
          if (borrowings.length > 1) ...[
            const SizedBox(height: AppSpacing.sm),
            // Same dot-indicator pattern as onboarding — worth extracting to
            // core/widgets if a third screen ends up needing it too.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(borrowings.length, (index) {
                final isActive = index == _currentIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isActive ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : AppColors.border,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ],
        ],
      ],
    );
  }
}

class _EmptyBorrowingsCard extends StatelessWidget {
  const _EmptyBorrowingsCard();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: AppColors.softSurface,
      borderRadius: AppRadius.cardRadius,
    ),
    child: Text(
      "You haven't borrowed any books yet.",
      style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
    ),
  );
}

class _BorrowingCard extends StatelessWidget {
  const _BorrowingCard({required this.preview});

  final ActiveBorrowingPreview preview;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: AppRadius.cardRadius,
      border: Border.all(color: AppColors.border),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookCover(width: 80, height: 120, imageUrl: preview.coverImageUrl),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                preview.bookTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.cardTitle.copyWith(
                  color: AppColors.textHeading,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'By ${preview.author}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: preview.progress,
                  minHeight: 6,
                  backgroundColor: AppColors.mutedSurface,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${preview.daysLeft} days left to return',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _RecommendedSection extends StatelessWidget {
  const _RecommendedSection({required this.booksAsync, required this.onRetry});

  final AsyncValue<List<Book>> booksAsync;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            'Recommended',
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.textHeading,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              // TODO: switch to the Books tab once MainShell exposes that.
            },
            child: Text(
              'See all',
              style: AppTextStyles.body.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.md),
      SizedBox(
        height: 270,
        child: booksAsync.when(
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
          error: (error, _) => AppErrorState(onRetry: onRetry),
          data: (books) => ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            separatorBuilder: (_, index) =>
                const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) => SizedBox(
              width: 128,
              child: BookCard(
                book: books[index],
                showAvailability: false,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        BookDetailsScreen(bookId: books[index].id),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
