import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/book_cover.dart';
import '../../domain/entities/book.dart';

/// Shared book card — used by the Books grid and Home's Recommended row.
/// [showAvailability] is off for Recommended (keeps that row's original,
/// simpler look) and on for the Books grid.
class BookCard extends StatelessWidget {
  const BookCard({
    required this.book,
    this.showAvailability = true,
    this.onTap,
    super.key,
  });

  final Book book;
  final bool showAvailability;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (book.availableCopies) {
      0 => ('Unavailable', AppColors.error),
      <= 2 => ('Few copies', AppColors.warning),
      _ => ('Available', AppColors.success),
    };

    return GestureDetector(
      onTap: onTap,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 2 / 3,
          child: LayoutBuilder(
            builder: (context, constraints) => BookCover(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              imageUrl: book.coverImageUrl,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          book.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.cardTitle.copyWith(
            color: AppColors.textHeading,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          book.author,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        if (showAvailability) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTextStyles.metadata.copyWith(color: color),
              ),
            ],
          ),
        ],
      ],
      ),
    );
  }
}
