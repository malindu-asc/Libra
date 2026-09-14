import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/borrowing.dart';

abstract class BorrowingRepository {
  /// Omit [status] for the full history (own borrowings, active + returned).
  Future<Either<Failure, List<Borrowing>>> getBorrowings({
    BorrowingStatus? status,
  });

  Future<Either<Failure, Borrowing>> borrowBook(String bookId);
  Future<Either<Failure, Borrowing>> returnBorrowing(String borrowingId); //return
}
