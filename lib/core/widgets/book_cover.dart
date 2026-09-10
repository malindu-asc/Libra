import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

/// Renders the real cover when [imageUrl] is set, otherwise a purple
/// placeholder box with a book icon. Shared across features — used by
/// `books`' BookCard and `home`'s borrowing-preview card.
class BookCover extends StatelessWidget {
  const BookCover({
    required this.width,
    required this.height,
    this.imageUrl,
    super.key,
  });

  final double width;
  final double height;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: AppRadius.bookCoverRadius,
    child: imageUrl == null
        ? Container(
            width: width,
            height: height,
            color: AppColors.primarySoft,
            child: Icon(
              Icons.menu_book_outlined,
              color: AppColors.primary,
              size: width * 0.4,
            ),
          )
        : Image.asset(
            imageUrl!,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
  );
}
