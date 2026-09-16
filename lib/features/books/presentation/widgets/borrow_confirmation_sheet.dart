import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/book_cover.dart';
import '../../../borrowings/domain/entities/borrowing.dart';
import '../../../borrowings/presentation/providers/borrowings_providers.dart';
import '../../domain/entities/book.dart';
import '../providers/book_providers.dart';

Future<void> showBorrowConfirmationSheet(BuildContext context, Book book) {
  return showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
    builder: (_) => BorrowConfirmationSheet(book: book),
  );
}

class BorrowConfirmationSheet extends ConsumerStatefulWidget {
  const BorrowConfirmationSheet({required this.book, super.key});

  final Book book;

  @override
  ConsumerState<BorrowConfirmationSheet> createState() =>
      _BorrowConfirmationSheetState();
}

class _BorrowConfirmationSheetState
    extends ConsumerState<BorrowConfirmationSheet> {
  bool _isSubmitting = false;
  bool _didBorrow = false;
  String? _errorMessage;

  Future<void> _confirmBorrow() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final useCase = ref.read(borrowBookUseCaseProvider); //execute 1time action
    final result = await useCase(widget.book.id); 

    if (!mounted) return;

    result.match(
      (failure) => setState(() {
        _isSubmitting = false;
        _errorMessage = failure.message;
      }),
      (_) {
        // The borrow succeeded — everything downstream that showed the old
        // counts/availability needs to refetch.
        ref.invalidate(activeBorrowingsProvider);
        ref.invalidate(bookByIdProvider(widget.book.id));
        ref.invalidate(bookListProvider);
        ref.invalidate(bookSearchProvider);
        ref.invalidate(borrowingListProvider(BorrowingStatus.active));
        setState(() {
          _isSubmitting = false;
          _didBorrow = true;
        });
      },
    );
  }

  // One `go` replaces the old "pop the sheet, then pop Book Details" pair —
  // it resolves the whole location rather than guessing how deep the stack is.
  void _goToMyBorrowings() {
    Navigator.of(context).pop(); // close the sheet
    context.go('/borrowings');
  }

  void _backToHome() {
    Navigator.of(context).pop(); // close the sheet
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.md,
      ),
      child: _didBorrow ? _buildSuccess(context) : _buildConfirmation(context),
    ),
  );

  Widget _buildConfirmation(BuildContext context) {
    final activeBorrowingsAsync = ref.watch(activeBorrowingsPreviewProvider);
    final activeLimit = ref.watch(activeBorrowingsLimitProvider);

    final borrowDate = DateTime.now();
    final dueDate = borrowDate.add(const Duration(days: 14));
    final dateFormat = DateFormat('MMM d, yyyy');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Borrow this book?',
          style: AppTextStyles.sectionTitle.copyWith(
            color: AppColors.textHeading,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.softSurface,
            borderRadius: AppRadius.cardRadius,
          ),
          child: Row(
            children: [
              BookCover(
                width: 48,
                height: 64,
                imageUrl: widget.book.coverImageUrl,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.book.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.cardTitle.copyWith(
                        color: AppColors.textHeading,
                      ),
                    ),
                    Text(
                      'By ${widget.book.author}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _InfoRow(
          icon: Icons.calendar_today_outlined,
          label: 'Borrow date',
          value: dateFormat.format(borrowDate),
        ),
        const Divider(),
        _InfoRow(
          icon: Icons.autorenew,
          label: 'Due date',
          value: dateFormat.format(dueDate),
          badge: '14 days',
        ),
        const Divider(),
        _InfoRow(
          icon: Icons.layers_outlined,
          label: 'Active borrowings',
          value: activeBorrowingsAsync.maybeWhen(
            data: (borrowings) => '${borrowings.length} of $activeLimit limits',
            orElse: () => '— of $activeLimit limits',
          ),
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            _errorMessage!,
            style: AppTextStyles.caption.copyWith(color: AppColors.error),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          height: 56,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _confirmBorrow,
            style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
            child: _isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : const Text('Confirm Borrow'),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextButton(
          onPressed: _isSubmitting
              ? null
              : () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccess(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 72,
        height: 72,
        decoration: const BoxDecoration(
          color: AppColors.successSoft,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: AppColors.success, size: 36),
      ),
      const SizedBox(height: AppSpacing.md),
      Text(
        'Book Borrowed!',
        style: AppTextStyles.sectionTitle.copyWith(
          color: AppColors.textHeading,
        ),
      ),
      const SizedBox(height: AppSpacing.xs),
      Text(
        'Your borrowing period has started',
        style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
      ),
      const SizedBox(height: AppSpacing.lg),
      SizedBox(
        height: 56,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _goToMyBorrowings,
          style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
          child: const Text('View My Borrowings'),
        ),
      ),
      const SizedBox(height: AppSpacing.sm),
      TextButton(
        onPressed: _backToHome,
        child: Text(
          'Back to Home',
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
      ),
    ],
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.badge,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? badge;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
    child: Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textTertiary),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        const Spacer(),
        if (badge != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              badge!,
              style: AppTextStyles.metadata.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(
          value,
          style: AppTextStyles.cardTitle.copyWith(color: AppColors.textHeading),
        ),
      ],
    ),
  );
}
