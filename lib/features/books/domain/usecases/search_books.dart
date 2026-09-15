import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/book.dart';
import '../repositories/book_repository.dart';

/// Mirrors `GET /api/books?search=`. Filtering lives behind this rather than
/// in the Books screen so that swapping the mock for a real HTTP datasource
/// turns it into a query parameter without the UI changing.
class SearchBooks implements UseCase<List<Book>, String> {
  const SearchBooks(this.repository);

  final BookRepository repository;

  @override
  Future<Either<Failure, List<Book>>> call(String query) =>
      repository.searchBooks(query);
}
