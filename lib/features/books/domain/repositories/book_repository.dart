import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/book.dart';

abstract class BookRepository {
  Future<Either<Failure, List<Book>>> getBooks();
  Future<Either<Failure, Book>> getBookById(String id);
}
