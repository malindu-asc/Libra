import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/book_model.dart';

/// Mock datasource — reads the bundled catalog once, then caches it in
/// memory so `decrementAvailableCopies`/`incrementAvailableCopies` (called
/// by borrowing) actually persist for the rest of the session instead of
/// being overwritten by the next re-read of the JSON file.
abstract class BookLocalDataSource {
  Future<List<BookModel>> getBooks();

  /// Stands in for `GET /api/books?search=`. An empty query returns
  /// everything, same as omitting the parameter.
  Future<List<BookModel>> searchBooks(String query);

  Future<BookModel> getBookById(String id);
  Future<void> decrementAvailableCopies(String id);
  Future<void> incrementAvailableCopies(String id);
}

class BookLocalDatasourceImpl implements BookLocalDataSource {
  List<BookModel>? _cache;

  Future<List<BookModel>> _load() async {
    final cached = _cache;
    if (cached != null) return cached;

    await Future.delayed(const Duration(milliseconds: 600));

    final raw = await rootBundle.loadString('assets/data/books.json');
    final jsonList = json.decode(raw) as List<dynamic>;

    final loaded = jsonList
        .map((e) => BookModel.fromJson(e as Map<String, dynamic>))
        .toList();
    _cache = loaded;
    return loaded;
  }

  @override
  Future<List<BookModel>> getBooks() async => List.of(await _load());

  @override
  Future<List<BookModel>> searchBooks(String query) async {
    final books = await _load();
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return List.of(books);

    return books
        .where(
          (book) =>
              book.title.toLowerCase().contains(normalized) ||
              book.author.toLowerCase().contains(normalized),
        )
        .toList();
  }

  @override
  Future<BookModel> getBookById(String id) async {
    final books = await _load();
    return books.firstWhere(
      (book) => book.id == id,
      orElse: () => throw Exception('Book not found: $id'),
    );
  }

  @override
  Future<void> decrementAvailableCopies(String id) async {
    final books = await _load();
    final index = books.indexWhere((book) => book.id == id);
    if (index == -1) throw Exception('Book not found: $id');

    final book = books[index];
    if (book.availableCopies <= 0) {
      throw Exception('No available copies for book: $id');
    }
    books[index] = _withAvailableCopies(book, book.availableCopies - 1);
  }

  @override
  Future<void> incrementAvailableCopies(String id) async {
    final books = await _load();
    final index = books.indexWhere((book) => book.id == id);
    if (index == -1) throw Exception('Book not found: $id');

    final book = books[index];
    books[index] = _withAvailableCopies(book, book.availableCopies + 1);
  }

  BookModel _withAvailableCopies(BookModel book, int availableCopies) =>
      BookModel(
        id: book.id,
        title: book.title,
        author: book.author,
        isbn: book.isbn,
        publishedYear: book.publishedYear,
        totalCopies: book.totalCopies,
        availableCopies: availableCopies,
        description: book.description,
        coverImageUrl: book.coverImageUrl,
        pages: book.pages,
      );
}
