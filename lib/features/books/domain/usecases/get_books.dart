import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/book.dart';
import '../repositories/book_repository.dart';

class GetBooks implements UseCase<List<Book>, NoParams> {
  const GetBooks(this.repository);

  final BookRepository repository;

  @override
  Future<Either<Failure, List<Book>>> call(NoParams params) =>
      repository.getBooks();
}
