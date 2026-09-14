import '../../../books/data/datasources/book_local_datasource.dart';
import '../../domain/entities/borrowing.dart';
import '../models/borrowing_model.dart';
import 'borrowing_exception.dart';

abstract class BorrowingLocalDataSource {
  Future<List<BorrowingModel>> getBorrowings({BorrowingStatus? status});
  Future<BorrowingModel> borrowBook(String bookId);
  Future<BorrowingModel> returnBorrowing(String borrowingId); //return
}

class BorrowingLocalDatasourceImpl implements BorrowingLocalDataSource {
  BorrowingLocalDatasourceImpl(
    this._bookLocalDataSource,
    this._currentMemberId,
  );

  final BookLocalDataSource _bookLocalDataSource;

  /// Reads the *current* logged-in member id at call time, not once at
  /// construction — plays the same role a real backend's JWT-derived
  /// identity would, just simulated locally instead of read off a token.
  final String? Function() _currentMemberId;

  static const maxActiveBorrowings = 3;

  final List<BorrowingModel> _borrowings = [];

  @override
  Future<List<BorrowingModel>> getBorrowings({BorrowingStatus? status}) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final memberId = _currentMemberId();
    final own = _borrowings.where((b) => b.memberId == memberId);

    return switch (status) {
      BorrowingStatus.active => own.where((b) => b.returnedAt == null).toList(),
      BorrowingStatus.history => own
          .where((b) => b.returnedAt != null)
          .toList(),
      null => own.toList(),
    };
  }

  @override
  Future<BorrowingModel> borrowBook(String bookId) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final memberId = _currentMemberId();
    if (memberId == null) {
      throw const BorrowingException(
        'You must be logged in to borrow a book.',
      );
    }

    final activeCount = _borrowings.where((b) => b.returnedAt == null).length;
    if (activeCount >= maxActiveBorrowings) {
      throw const BorrowingException(
        'You already have $maxActiveBorrowings active borrowings. '
        'Return a book before borrowing another.',
      );
    }

    final book = await _bookLocalDataSource.getBookById(bookId);
    if (book.availableCopies <= 0) {
      throw const BorrowingException(
        'This book has no available copies right now.',
      );
    }

    await _bookLocalDataSource.decrementAvailableCopies(bookId);

    final now = DateTime.now();
    final borrowing = BorrowingModel(
      id: 'brw-${now.microsecondsSinceEpoch}',
      bookId: book.id,
      memberId: memberId,
      borrowedAt: now,
      dueDate: now.add(const Duration(days: 14)),
    );
    _borrowings.add(borrowing);
    return borrowing;
  }

   @override //return
   Future<BorrowingModel> returnBorrowing(String borrowingId) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final memberId = _currentMemberId();
    final index = _borrowings.indexWhere(
      (b) => b.id == borrowingId && b.memberId == memberId,
    );
    if (index == -1) {
      throw const BorrowingException('Borrowing not found.');
    }

    final borrowing = _borrowings[index];
    if (borrowing.returnedAt != null) {
      throw const BorrowingException('This book has already been returned.');
    }

    await _bookLocalDataSource.incrementAvailableCopies(borrowing.bookId);

    final updated = BorrowingModel(
      id: borrowing.id,
      bookId: borrowing.bookId,
      memberId: borrowing.memberId,
      borrowedAt: borrowing.borrowedAt,
      dueDate: borrowing.dueDate,
      returnedAt: DateTime.now(),
    );
    _borrowings[index] = updated;
    return updated;
  }

}
