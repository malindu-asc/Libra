import '../../domain/entities/borrowing.dart';

/// One row on the My Borrowings screen (either tab) — a `Borrowing` merged
/// with its `Book`'s display fields, since `Borrowing` itself only carries
/// a `bookId`. Kept separate from `ActiveBorrowingPreview` (Home's
/// dashboard card / the confirmation sheet) on purpose — this screen needs
/// more (status, both dates, a returned date) than that simpler card does,
/// same "small, feature-scoped model over one stretched shared one"
/// principle used everywhere else in this app.
class BorrowingListItem {
  const BorrowingListItem({
    required this.borrowingId,
    required this.bookTitle,
    required this.author,
    required this.borrowedAt,
    required this.dueDate,
    required this.status,
    this.coverImageUrl,
    this.returnedAt,
  });

  final String borrowingId;
  final String bookTitle;
  final String author;
  final DateTime borrowedAt;
  final DateTime dueDate;
  final BorrowingRecordStatus status;
  final String? coverImageUrl;
  final DateTime? returnedAt;

  /// Whole days left until [dueDate], clamped to 0 — same rule as
  /// `Borrowing.daysLeft`, recomputed here since this model doesn't extend
  /// `Borrowing`.
  int get daysLeft {
    final remaining = dueDate.difference(DateTime.now()).inDays;
    return remaining < 0 ? 0 : remaining;
  }
}
