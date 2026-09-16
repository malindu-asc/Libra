/// Thrown by [BorrowingLocalDataSource] on a rejected borrow (limit reached,
/// book unavailable). Caught and converted to a [Failure] by the repository
/// implementation.
class BorrowingException implements Exception {
  const BorrowingException(this.message);

  final String message;
}
