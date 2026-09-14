// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bookLocalDataSource)
final bookLocalDataSourceProvider = BookLocalDataSourceProvider._();

final class BookLocalDataSourceProvider
    extends
        $FunctionalProvider<
          BookLocalDataSource,
          BookLocalDataSource,
          BookLocalDataSource
        >
    with $Provider<BookLocalDataSource> {
  BookLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookLocalDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<BookLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BookLocalDataSource create(Ref ref) {
    return bookLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookLocalDataSource>(value),
    );
  }
}

String _$bookLocalDataSourceHash() =>
    r'14186be024032d8debe15392633b93a178220577';

@ProviderFor(bookRepository)
final bookRepositoryProvider = BookRepositoryProvider._();

final class BookRepositoryProvider
    extends $FunctionalProvider<BookRepository, BookRepository, BookRepository>
    with $Provider<BookRepository> {
  BookRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookRepositoryHash();

  @$internal
  @override
  $ProviderElement<BookRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BookRepository create(Ref ref) {
    return bookRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookRepository>(value),
    );
  }
}

String _$bookRepositoryHash() => r'ed05d4ad68666163c69270aac612f55282abba18';

@ProviderFor(getBooksUseCase)
final getBooksUseCaseProvider = GetBooksUseCaseProvider._();

final class GetBooksUseCaseProvider
    extends $FunctionalProvider<GetBooks, GetBooks, GetBooks>
    with $Provider<GetBooks> {
  GetBooksUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getBooksUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getBooksUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetBooks> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetBooks create(Ref ref) {
    return getBooksUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetBooks value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetBooks>(value),
    );
  }
}

String _$getBooksUseCaseHash() => r'2b182248760ea1f90cf6f0846575645b1a9d082b';

/// The book catalog. `AsyncNotifier` (not a plain `FutureProvider`) so the
/// same invalidate-and-refetch pattern used elsewhere (pull-to-refresh, a
/// future search box) has somewhere to hook in later without a rewrite.

@ProviderFor(BookList)
final bookListProvider = BookListProvider._();

/// The book catalog. `AsyncNotifier` (not a plain `FutureProvider`) so the
/// same invalidate-and-refetch pattern used elsewhere (pull-to-refresh, a
/// future search box) has somewhere to hook in later without a rewrite.
final class BookListProvider
    extends $AsyncNotifierProvider<BookList, List<Book>> {
  /// The book catalog. `AsyncNotifier` (not a plain `FutureProvider`) so the
  /// same invalidate-and-refetch pattern used elsewhere (pull-to-refresh, a
  /// future search box) has somewhere to hook in later without a rewrite.
  BookListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookListHash();

  @$internal
  @override
  BookList create() => BookList();
}

String _$bookListHash() => r'3c69fe4fb7f76edb74c337dac6f877ac1ce817b2';

/// The book catalog. `AsyncNotifier` (not a plain `FutureProvider`) so the
/// same invalidate-and-refetch pattern used elsewhere (pull-to-refresh, a
/// future search box) has somewhere to hook in later without a rewrite.

abstract class _$BookList extends $AsyncNotifier<List<Book>> {
  FutureOr<List<Book>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Book>>, List<Book>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Book>>, List<Book>>,
              AsyncValue<List<Book>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(getBookByIdUseCase)
final getBookByIdUseCaseProvider = GetBookByIdUseCaseProvider._();

final class GetBookByIdUseCaseProvider
    extends $FunctionalProvider<GetBookById, GetBookById, GetBookById>
    with $Provider<GetBookById> {
  GetBookByIdUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getBookByIdUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getBookByIdUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetBookById> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetBookById create(Ref ref) {
    return getBookByIdUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetBookById value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetBookById>(value),
    );
  }
}

String _$getBookByIdUseCaseHash() =>
    r'3eac90610cba217c74a08c0f7a7641bcfe340871';

@ProviderFor(bookById)
final bookByIdProvider = BookByIdFamily._();

final class BookByIdProvider
    extends $FunctionalProvider<AsyncValue<Book>, Book, FutureOr<Book>>
    with $FutureModifier<Book>, $FutureProvider<Book> {
  BookByIdProvider._({
    required BookByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'bookByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bookByIdHash();

  @override
  String toString() {
    return r'bookByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Book> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Book> create(Ref ref) {
    final argument = this.argument as String;
    return bookById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BookByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookByIdHash() => r'5cd0575ad5a7d803e99c96f25d4f5558defc12ae';

final class BookByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Book>, String> {
  BookByIdFamily._()
    : super(
        retry: null,
        name: r'bookByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BookByIdProvider call(String id) =>
      BookByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'bookByIdProvider';
}
