// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrowings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(borrowingLocalDataSource)
final borrowingLocalDataSourceProvider = BorrowingLocalDataSourceProvider._();

final class BorrowingLocalDataSourceProvider
    extends
        $FunctionalProvider<
          BorrowingLocalDataSource,
          BorrowingLocalDataSource,
          BorrowingLocalDataSource
        >
    with $Provider<BorrowingLocalDataSource> {
  BorrowingLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'borrowingLocalDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$borrowingLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<BorrowingLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BorrowingLocalDataSource create(Ref ref) {
    return borrowingLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BorrowingLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BorrowingLocalDataSource>(value),
    );
  }
}

String _$borrowingLocalDataSourceHash() =>
    r'ace6d23586cf54dd43fbee4e381db63b58df5aef';

@ProviderFor(borrowingRepository)
final borrowingRepositoryProvider = BorrowingRepositoryProvider._();

final class BorrowingRepositoryProvider
    extends
        $FunctionalProvider<
          BorrowingRepository,
          BorrowingRepository,
          BorrowingRepository
        >
    with $Provider<BorrowingRepository> {
  BorrowingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'borrowingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$borrowingRepositoryHash();

  @$internal
  @override
  $ProviderElement<BorrowingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BorrowingRepository create(Ref ref) {
    return borrowingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BorrowingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BorrowingRepository>(value),
    );
  }
}

String _$borrowingRepositoryHash() =>
    r'7255644643c5ed886de2e40c51c27f45a3a234c5';

@ProviderFor(getBorrowingsUseCase)
final getBorrowingsUseCaseProvider = GetBorrowingsUseCaseProvider._();

final class GetBorrowingsUseCaseProvider
    extends $FunctionalProvider<GetBorrowings, GetBorrowings, GetBorrowings>
    with $Provider<GetBorrowings> {
  GetBorrowingsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getBorrowingsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getBorrowingsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetBorrowings> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetBorrowings create(Ref ref) {
    return getBorrowingsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetBorrowings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetBorrowings>(value),
    );
  }
}

String _$getBorrowingsUseCaseHash() =>
    r'ecd96a38631b92f1806cda128c6875e269a1d593';

@ProviderFor(borrowBookUseCase)
final borrowBookUseCaseProvider = BorrowBookUseCaseProvider._();

final class BorrowBookUseCaseProvider
    extends $FunctionalProvider<BorrowBook, BorrowBook, BorrowBook>
    with $Provider<BorrowBook> {
  BorrowBookUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'borrowBookUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$borrowBookUseCaseHash();

  @$internal
  @override
  $ProviderElement<BorrowBook> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BorrowBook create(Ref ref) {
    return borrowBookUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BorrowBook value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BorrowBook>(value),
    );
  }
}

String _$borrowBookUseCaseHash() => r'5db730eef054612b3babe629cdd16b8faa49d6c7';

@ProviderFor(activeBorrowings)
final activeBorrowingsProvider = ActiveBorrowingsProvider._();

final class ActiveBorrowingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Borrowing>>,
          List<Borrowing>,
          FutureOr<List<Borrowing>>
        >
    with $FutureModifier<List<Borrowing>>, $FutureProvider<List<Borrowing>> {
  ActiveBorrowingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeBorrowingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeBorrowingsHash();

  @$internal
  @override
  $FutureProviderElement<List<Borrowing>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Borrowing>> create(Ref ref) {
    return activeBorrowings(ref);
  }
}

String _$activeBorrowingsHash() => r'eff3c64f9a1f9bccf480dd23df7099520f341ea8';

/// Two-stage fetch: get the active borrowings first (there's no way to know
/// *which* books to ask for otherwise), then fetch all of those books
/// **concurrently** via `Future.wait` — not one at a time — since none of
/// the book fetches depend on each other once the bookIds are known.

@ProviderFor(activeBorrowingsPreview)
final activeBorrowingsPreviewProvider = ActiveBorrowingsPreviewProvider._();

/// Two-stage fetch: get the active borrowings first (there's no way to know
/// *which* books to ask for otherwise), then fetch all of those books
/// **concurrently** via `Future.wait` — not one at a time — since none of
/// the book fetches depend on each other once the bookIds are known.

final class ActiveBorrowingsPreviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ActiveBorrowingPreview>>,
          List<ActiveBorrowingPreview>,
          FutureOr<List<ActiveBorrowingPreview>>
        >
    with
        $FutureModifier<List<ActiveBorrowingPreview>>,
        $FutureProvider<List<ActiveBorrowingPreview>> {
  /// Two-stage fetch: get the active borrowings first (there's no way to know
  /// *which* books to ask for otherwise), then fetch all of those books
  /// **concurrently** via `Future.wait` — not one at a time — since none of
  /// the book fetches depend on each other once the bookIds are known.
  ActiveBorrowingsPreviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeBorrowingsPreviewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeBorrowingsPreviewHash();

  @$internal
  @override
  $FutureProviderElement<List<ActiveBorrowingPreview>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ActiveBorrowingPreview>> create(Ref ref) {
    return activeBorrowingsPreview(ref);
  }
}

String _$activeBorrowingsPreviewHash() =>
    r'866912ad48992350b8e1c5f400bd5c30f14f99ac';

@ProviderFor(activeBorrowingsLimit)
final activeBorrowingsLimitProvider = ActiveBorrowingsLimitProvider._();

final class ActiveBorrowingsLimitProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  ActiveBorrowingsLimitProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeBorrowingsLimitProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeBorrowingsLimitHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return activeBorrowingsLimit(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$activeBorrowingsLimitHash() =>
    r'10c3d7272a73dd9a17130df07e69be3784e64548';

/// Family provider — one cached instance per [BorrowingStatus], backing
/// both tabs of My Borrowings independently. Same two-stage fetch as
/// [activeBorrowingsPreview] (borrowings first, then `Future.wait` over
/// their books) — kept as a separate implementation rather than sharing
/// code between the two, since they build different display models for
/// different screens.

@ProviderFor(borrowingList)
final borrowingListProvider = BorrowingListFamily._();

/// Family provider — one cached instance per [BorrowingStatus], backing
/// both tabs of My Borrowings independently. Same two-stage fetch as
/// [activeBorrowingsPreview] (borrowings first, then `Future.wait` over
/// their books) — kept as a separate implementation rather than sharing
/// code between the two, since they build different display models for
/// different screens.

final class BorrowingListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BorrowingListItem>>,
          List<BorrowingListItem>,
          FutureOr<List<BorrowingListItem>>
        >
    with
        $FutureModifier<List<BorrowingListItem>>,
        $FutureProvider<List<BorrowingListItem>> {
  /// Family provider — one cached instance per [BorrowingStatus], backing
  /// both tabs of My Borrowings independently. Same two-stage fetch as
  /// [activeBorrowingsPreview] (borrowings first, then `Future.wait` over
  /// their books) — kept as a separate implementation rather than sharing
  /// code between the two, since they build different display models for
  /// different screens.
  BorrowingListProvider._({
    required BorrowingListFamily super.from,
    required BorrowingStatus super.argument,
  }) : super(
         retry: null,
         name: r'borrowingListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$borrowingListHash();

  @override
  String toString() {
    return r'borrowingListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<BorrowingListItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BorrowingListItem>> create(Ref ref) {
    final argument = this.argument as BorrowingStatus;
    return borrowingList(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BorrowingListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$borrowingListHash() => r'eed73c58480f05f3aaffdc45c3b6c193a3164892';

/// Family provider — one cached instance per [BorrowingStatus], backing
/// both tabs of My Borrowings independently. Same two-stage fetch as
/// [activeBorrowingsPreview] (borrowings first, then `Future.wait` over
/// their books) — kept as a separate implementation rather than sharing
/// code between the two, since they build different display models for
/// different screens.

final class BorrowingListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<BorrowingListItem>>,
          BorrowingStatus
        > {
  BorrowingListFamily._()
    : super(
        retry: null,
        name: r'borrowingListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Family provider — one cached instance per [BorrowingStatus], backing
  /// both tabs of My Borrowings independently. Same two-stage fetch as
  /// [activeBorrowingsPreview] (borrowings first, then `Future.wait` over
  /// their books) — kept as a separate implementation rather than sharing
  /// code between the two, since they build different display models for
  /// different screens.

  BorrowingListProvider call(BorrowingStatus status) =>
      BorrowingListProvider._(argument: status, from: this);

  @override
  String toString() => r'borrowingListProvider';
}
