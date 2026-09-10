/// A minimal view of "a book currently borrowed" — just enough for a
/// dashboard card or a borrow-confirmation summary. Deliberately not the
/// full `Borrowing` entity a real `borrowings` domain layer would have
/// (that doesn't exist yet); this gets replaced once it does, same
/// swap-the-datasource-not-the-screen approach used everywhere else.
/// Shared across `home` (dashboard carousel) and `books` (borrow
/// confirmation sheet) — moved here from `home` once `books` needed it too.
class ActiveBorrowingPreview {
  const ActiveBorrowingPreview({
    required this.bookTitle,
    required this.author,
    required this.daysLeft,
    this.coverImageUrl,
    this.totalBorrowDays = 14, // matches the backend's 14-day loan period
  });

  final String bookTitle;
  final String author;
  final int daysLeft;
  final String? coverImageUrl;
  final int totalBorrowDays;

  double get progress =>
      ((totalBorrowDays - daysLeft) / totalBorrowDays).clamp(0.0, 1.0);
}
