import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/borrowing.dart';
import '../repositories/borrowing_repository.dart';

class ReturnBook implements UseCase<Borrowing, String>{

  const ReturnBook(this.repository);
  
  final BorrowingRepository repository;
  

  /// [borrowingId] — the id in `POST /api/borrowings/{id}/return`, not a
  /// bookId. Nothing else client-decided, same as `BorrowBook`.
  @override
  Future<Either<Failure, Borrowing>> call(String borrowingId) =>
      repository.returnBorrowing(borrowingId);
}