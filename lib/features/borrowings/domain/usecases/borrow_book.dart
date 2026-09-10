import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/borrowing.dart';
import '../repositories/borrowing_repository.dart';

class BorrowBook implements UseCase<Borrowing, String> {
  const BorrowBook(this.repository);

  final BorrowingRepository repository;

  /// [bookId] only — matches the real `POST /api/borrowings` request body.
  /// Everything else (member identity, dates, the 3-active-borrowings limit)
  /// is decided server-side (mock datasource-side, for now).
  @override
  Future<Either<Failure, Borrowing>> call(String bookId) =>
      repository.borrowBook(bookId);
}
