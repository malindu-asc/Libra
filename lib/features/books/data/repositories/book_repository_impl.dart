import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/book_local_datasource.dart';

class BookRepositoryImpl implements BookRepository {
  const BookRepositoryImpl(this.localDataSource);

  final BookLocalDataSource localDataSource;

  @override
  Future<Either<Failure, List<Book>>> getBooks() async {
    try {
      final models = await localDataSource.getBooks();
      return Right(models);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Book>> getBookById(String id) async {
    try {
      final model = await localDataSource.getBookById(id);
      return Right(model);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
