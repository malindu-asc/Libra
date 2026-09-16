import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/book.dart';

abstract class BookRepository {
  Future<Either<Failure, List<Book>>> getBooks();

  /// Mirrors `GET /api/books?search=` — an empty query means no filter.
  Future<Either<Failure, List<Book>>> searchBooks(String query);

  Future<Either<Failure, Book>> getBookById(String id);
}
