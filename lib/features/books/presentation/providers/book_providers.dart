import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/usecase/usecase.dart';
import '../../data/datasources/book_local_datasource.dart';
import '../../data/repositories/book_repository_impl.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../../domain/usecases/get_book_by_id.dart';
import '../../domain/usecases/get_books.dart';
import '../../domain/usecases/search_books.dart';

part 'book_providers.g.dart';

@Riverpod(keepAlive: true)
BookLocalDataSource bookLocalDataSource(Ref ref) => BookLocalDatasourceImpl();//keep same instance keepalive without dispose

@Riverpod(keepAlive: true)
BookRepository bookRepository(Ref ref) =>
    BookRepositoryImpl(ref.watch(bookLocalDataSourceProvider)); //inject the upperone to this

@riverpod
GetBooks getBooksUseCase(Ref ref) =>
    GetBooks(ref.watch(bookRepositoryProvider));

/// The book catalog. `AsyncNotifier(asyncloading,asyncdata,asyncerror)` (not a plain `FutureProvider`) so the
/// same invalidate-and-refetch pattern used elsewhere (pull-to-refresh, a
/// future search box) has somewhere to hook in later without a rewrite.
@riverpod
class BookList extends _$BookList {
  @override
  Future<List<Book>> build() async {
    final useCase = ref.read(getBooksUseCaseProvider);
    final result = await useCase(const NoParams());
    return result.match((failure) => throw failure, (books) => books);
  }
}

@riverpod
SearchBooks searchBooksUseCase(Ref ref) =>
    SearchBooks(ref.watch(bookRepositoryProvider));

/// One cached instance per query string. The Books screen debounces before
/// changing the query, so this isn't rebuilt on every keystroke.
@riverpod
Future<List<Book>> bookSearch(Ref ref, String query) async {
  final useCase = ref.read(searchBooksUseCaseProvider);
  final result = await useCase(query);
  return result.match((failure) => throw failure, (books) => books);
}

@riverpod
GetBookById getBookByIdUseCase(Ref ref) => ////use the same repository
    GetBookById(ref.watch(bookRepositoryProvider));

@riverpod 
Future<Book> bookById(Ref ref, String id) async { //provide the data for books_detailsdart
  final useCase = ref.read(getBookByIdUseCaseProvider);
  final result = await useCase(id);
  return result.match((failure) => throw failure, (book) => book);
}
