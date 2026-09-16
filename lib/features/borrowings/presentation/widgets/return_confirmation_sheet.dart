import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/book_cover.dart';
import '../../../books/presentation/providers/book_providers.dart';
import '../../domain/entities/borrowing.dart';
import '../models/borrowing_list_item.dart';
import '../providers/borrowings_providers.dart';

Future<void> showReturnConfirmationSheet(
  BuildContext context,
  BorrowingListItem item,
) {
  return showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
    builder: (_) => ReturnConfirmationSheet(item: item),
  );
}

class ReturnConfirmationSheet extends ConsumerStatefulWidget {
  const ReturnConfirmationSheet({required this.item, super.key});

  final BorrowingListItem item;

  @override
  ConsumerState<ReturnConfirmationSheet> createState() =>
      _ReturnConfirmationSheetState();
}

class _ReturnConfirmationSheetState
    extends ConsumerState<ReturnConfirmationSheet> {
  bool _isSubmitting = false;
  bool _didReturn = false;
  String? _errorMessage;

  Future<void> _confirmReturn() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final useCase = ref.read(returnBookUseCaseProvider);
    final result = await useCase(widget.item.borrowingId);

    if (!mounted) return;

    result.match(
      (failure) => setState(() {
        _isSubmitting = false;
        _errorMessage = failure.message;
      }),
      (_) {
        ref.invalidate(borrowingListProvider(BorrowingStatus.active));
        ref.invalidate(borrowingListProvider(BorrowingStatus.history));
        ref.invalidate(activeBorrowingsProvider);
        ref.invalidate(bookByIdProvider(widget.item.bookId));
        ref.invalidate(bookListProvider);
        setState(() {
          _isSubmitting = false;
          _didReturn = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.md,
      ),
      child: _didReturn ? _buildSuccess(context) : _buildConfirmation(context),
    ),
  );

  Widget _buildConfirmation(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Return this book?',
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
                imageUrl: widget.item.coverImageUrl,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.bookTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.cardTitle.copyWith(
                        color: AppColors.textHeading,
                      ),
                    ),
                    Text(
                      'By ${widget.item.author}',
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
        Text(
          'Borrowed on ${dateFormat.format(widget.item.borrowedAt)}, '
          'due ${dateFormat.format(widget.item.dueDate)}.',
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
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
            onPressed: _isSubmitting ? null : _confirmReturn,
            style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
            child: _isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : const Text('Confirm Return'),
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
        'Book Returned!',
        style: AppTextStyles.sectionTitle.copyWith(
          color: AppColors.textHeading,
        ),
      ),
      const SizedBox(height: AppSpacing.xs),
      Text(
        'Thanks for returning it on time.',
        style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
      ),
      const SizedBox(height: AppSpacing.lg),
      SizedBox(
        height: 56,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
          child: const Text('Done'),
        ),
      ),
    ],
  );
}
