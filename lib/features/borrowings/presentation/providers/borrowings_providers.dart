import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/current_member_provider.dart';
import '../../../books/presentation/providers/book_providers.dart';
import '../../data/datasources/borrowing_local_datasource.dart';
import '../../data/repositories/borrowing_repository_impl.dart';
import '../../domain/entities/borrowing.dart';
import '../../domain/repositories/borrowing_repository.dart';
import '../../domain/usecases/borrow_book.dart';
import '../../domain/usecases/get_borrowings.dart';
import '../../domain/usecases/return_book.dart';
import '../models/active_borrowing_preview.dart';
import '../models/borrowing_list_item.dart';

part 'borrowings_providers.g.dart';

@Riverpod(keepAlive: true) //if not widget listen it stays
BorrowingLocalDataSource borrowingLocalDataSource(Ref ref) =>
    BorrowingLocalDatasourceImpl(
      ref.watch(bookLocalDataSourceProvider),
      () => ref.read(currentMemberProvider)?.id,
    );

@Riverpod(keepAlive: true) // keepwithout dispose
BorrowingRepository borrowingRepository(Ref ref) =>
    BorrowingRepositoryImpl(ref.watch(borrowingLocalDataSourceProvider));

@riverpod
GetBorrowings getBorrowingsUseCase(Ref ref) =>
    GetBorrowings(ref.watch(borrowingRepositoryProvider));

@riverpod
BorrowBook borrowBookUseCase(Ref ref) =>
    BorrowBook(ref.watch(borrowingRepositoryProvider));

@riverpod
ReturnBook returnBookUseCase(Ref ref) =>
    ReturnBook(ref.watch(borrowingRepositoryProvider));

@riverpod
Future<List<Borrowing>> activeBorrowings(Ref ref) async {
  final useCase = ref.read(getBorrowingsUseCaseProvider);
  final result = await useCase(BorrowingStatus.active);
  return result.match((failure) => throw failure, (borrowings) => borrowings);
}

/// Two-stage fetch: get the active borrowings first (there's no way to know
/// *which* books to ask for otherwise), then fetch all of those books
/// **concurrently** via `Future.wait` — not one at a time — since none of
/// the book fetches depend on each other once the bookIds are known.
@riverpod
Future<List<ActiveBorrowingPreview>> activeBorrowingsPreview(Ref ref) async {
  final borrowings = await ref.watch(activeBorrowingsProvider.future);
  final getBookById = ref.read(getBookByIdUseCaseProvider);

  final bookResults = await Future.wait(
    borrowings.map((b) => getBookById(b.bookId)),
  );

  return [
    for (var i = 0; i < borrowings.length; i++)
      bookResults[i].match(
        (failure) => throw failure,
        (book) => ActiveBorrowingPreview(
          bookTitle: book.title,
          author: book.author,
          daysLeft: borrowings[i].daysLeft,
          coverImageUrl: book.coverImageUrl,
        ),
      ),
  ];
}

@riverpod
int activeBorrowingsLimit(Ref ref) =>
    BorrowingLocalDatasourceImpl.maxActiveBorrowings;

/// Family provider — one cached instance per [BorrowingStatus], backing
/// both tabs of My Borrowings independently. Same two-stage fetch as
/// [activeBorrowingsPreview] (borrowings first, then `Future.wait` over
/// their books) — kept as a separate implementation rather than sharing
/// code between the two, since they build different display models for
/// different screens.
@riverpod
Future<List<BorrowingListItem>> borrowingList(
  Ref ref,
  BorrowingStatus status,
) async {
  final useCase = ref.read(getBorrowingsUseCaseProvider);
  final result = await useCase(status);
  final borrowings = result.match((failure) => throw failure, (b) => b);

  final getBookById = ref.read(getBookByIdUseCaseProvider);
  final bookResults = await Future.wait(
    borrowings.map((b) => getBookById(b.bookId)),
  );

  return [
    for (var i = 0; i < borrowings.length; i++)
      bookResults[i].match(
        (failure) => throw failure,
        (book) => BorrowingListItem(
          borrowingId: borrowings[i].id,
          bookId: borrowings[i].bookId,
          bookTitle: book.title,
          author: book.author,
          borrowedAt: borrowings[i].borrowedAt,
          dueDate: borrowings[i].dueDate,
          status: borrowings[i].status,
          coverImageUrl: book.coverImageUrl,
          returnedAt: borrowings[i].returnedAt,
        ),
      ),
  ];
}
