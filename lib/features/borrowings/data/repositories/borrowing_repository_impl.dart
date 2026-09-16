import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/borrowing.dart';
import '../../domain/repositories/borrowing_repository.dart';
import '../datasources/borrowing_exception.dart';
import '../datasources/borrowing_local_datasource.dart';

class BorrowingRepositoryImpl implements BorrowingRepository {
  const BorrowingRepositoryImpl(this.localDataSource);

  final BorrowingLocalDataSource localDataSource;

  @override
  Future<Either<Failure, List<Borrowing>>> getBorrowings({
    BorrowingStatus? status,
  }) async {
    try {
      final models = await localDataSource.getBorrowings(status: status);
      return Right(models);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Borrowing>> borrowBook(String bookId) async {
    try {
      final model = await localDataSource.borrowBook(bookId);
      return Right(model);
    } on BorrowingException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


    @override //return
  Future<Either<Failure, Borrowing>> returnBorrowing(
    String borrowingId,
  ) async {
    try {
      final model = await localDataSource.returnBorrowing(borrowingId);
      return Right(model);
    } on BorrowingException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
