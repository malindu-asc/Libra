/// One borrow record — a member borrowing one copy of one book.
/// Deliberately schema-pure: only `bookId`, not the book's title/author/
/// cover — those get resolved separately (fetch the `Book` by `bookId`)
/// rather than embedded here, matching the given backend schema exactly.
class Borrowing {
  const Borrowing({
    required this.id,
    required this.bookId,
    required this.memberId,
    required this.borrowedAt,
    required this.dueDate,
    this.returnedAt,
  });

  final String id;
  final String bookId;
  final String memberId;
  final DateTime borrowedAt;
  final DateTime dueDate;
  final DateTime? returnedAt;

  /// Mirrors the backend's `Status` field (`Borrowed`/`Returned`/`Overdue`).
  BorrowingRecordStatus get status {
    if (returnedAt != null) return BorrowingRecordStatus.returned;
    if (DateTime.now().isAfter(dueDate)) return BorrowingRecordStatus.overdue;
    return BorrowingRecordStatus.borrowed;
  }

  /// Whole days left until [dueDate], clamped to 0 — an overdue borrowing is
  /// represented via [status], not a negative day count here.
  int get daysLeft {
    final remaining = dueDate.difference(DateTime.now()).inDays;
    return remaining < 0 ? 0 : remaining;
  }
}

/// The record's own lifecycle state — matches the backend's `Status` enum.
enum BorrowingRecordStatus { borrowed, returned, overdue }

/// Matches the backend's `?status=` *query* values on
/// `GET /api/me/borrowings` — a different axis from [BorrowingRecordStatus]:
/// this decides which records come back at all (returned vs. not-yet-
/// returned); `BorrowingRecordStatus` decides how a not-yet-returned one is
/// styled (on-time vs. overdue).
enum BorrowingStatus { active, history }
