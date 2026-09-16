import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/borrowing.dart';
import '../repositories/borrowing_repository.dart';

class GetBorrowings implements UseCase<List<Borrowing>, BorrowingStatus?> {
  const GetBorrowings(this.repository);

  final BorrowingRepository repository;

  @override
  Future<Either<Failure, List<Borrowing>>> call(BorrowingStatus? status) =>
      repository.getBorrowings(status: status);
}
