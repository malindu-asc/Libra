import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/book_cover.dart';
import '../../domain/entities/borrowing.dart';
import '../models/borrowing_list_item.dart';
import '../providers/borrowings_providers.dart';

class MyBorrowingsScreen extends StatefulWidget {
  const MyBorrowingsScreen({super.key});

  @override
  State<MyBorrowingsScreen> createState() => _MyBorrowingsScreenState();
}

class _MyBorrowingsScreenState extends State<MyBorrowingsScreen> {
  BorrowingStatus _selectedTab = BorrowingStatus.active;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Borrowings',
              style: AppTextStyles.screenTitle.copyWith(
                color: AppColors.textHeading,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _TabSwitch(
              selected: _selectedTab,
              onChanged: (tab) => setState(() => _selectedTab = tab),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(child: _BorrowingsList(status: _selectedTab)),
          ],
        ),
      ),
    ),
  );
}

class _TabSwitch extends StatelessWidget {
  const _TabSwitch({required this.selected, required this.onChanged});

  final BorrowingStatus selected;
  final ValueChanged<BorrowingStatus> onChanged;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: AppColors.softSurface,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        _TabButton(
          label: 'Active',
          isSelected: selected == BorrowingStatus.active,
          onTap: () => onChanged(BorrowingStatus.active),
        ),
        _TabButton(
          label: 'History',
          isSelected: selected == BorrowingStatus.history,
          onTap: () => onChanged(BorrowingStatus.history),
        ),
      ],
    ),
  );
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.textPrimary.withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    ),
  );
}

class _BorrowingsList extends ConsumerWidget {
  const _BorrowingsList({required this.status});

  final BorrowingStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(borrowingListProvider(status));

    return itemsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (error, _) => AppErrorState(
        onRetry: () => ref.invalidate(borrowingListProvider(status)),
      ),
      data: (items) => items.isEmpty
          ? AppEmptyState(
              icon: status == BorrowingStatus.active
                  ? Icons.menu_book_outlined
                  : Icons.history,
              title: status == BorrowingStatus.active
                  ? 'No active borrowings'
                  : 'No borrowing history yet',
              message: status == BorrowingStatus.active
                  ? "You haven't borrowed any books yet."
                  : 'Books you return will show up here.',
            )
          : ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, index) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) =>
                  _BorrowingCard(item: items[index]),
            ),
    );
  }
}

class _BorrowingCard extends StatelessWidget {
  const _BorrowingCard({required this.item});

  final BorrowingListItem item;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final (badgeLabel, badgeColor) = switch (item.status) {
      BorrowingRecordStatus.returned => ('Returned', AppColors.textTertiary),
      BorrowingRecordStatus.overdue => ('Overdue', AppColors.error),
      BorrowingRecordStatus.borrowed => (
        '${item.daysLeft} days left',
        AppColors.warning,
      ),
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookCover(width: 60, height: 84, imageUrl: item.coverImageUrl),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.bookTitle,
                      style: AppTextStyles.cardTitle.copyWith(
                        color: AppColors.textHeading,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.author,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (item.status != BorrowingRecordStatus.returned)
                ElevatedButton(
                  onPressed: () {
                    // TODO: wire to a real ReturnBook usecase.
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Return'),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: 6),
              Text(
                'Borrowed: ${dateFormat.format(item.borrowedAt)}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                item.status == BorrowingRecordStatus.overdue
                    ? Icons.warning_amber_rounded
                    : Icons.access_time,
                size: 16,
                color: badgeColor,
              ),
              const SizedBox(width: 6),
              Text(
                item.returnedAt != null
                    ? 'Returned: ${dateFormat.format(item.returnedAt!)}'
                    : 'Due: ${dateFormat.format(item.dueDate)} ($badgeLabel)',
                style: AppTextStyles.caption.copyWith(color: badgeColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
