import '../../domain/entities/book.dart';

class BookModel extends Book {
  const BookModel({
    required super.id,
    required super.title,
    required super.author,
    required super.isbn,
    required super.publishedYear,
    required super.totalCopies,
    required super.availableCopies,
    super.description,
    super.coverImageUrl,
    super.pages,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) => BookModel(
    id: json['id'] as String,
    title: json['title'] as String,
    author: json['author'] as String,
    isbn: json['isbn'] as String,
    publishedYear: json['publishedYear'] as int,
    totalCopies: json['totalCopies'] as int,
    availableCopies: json['availableCopies'] as int,
    description: json['description'] as String?,
    coverImageUrl: json['coverImageUrl'] as String?,
    pages: json['pages'] as int?,
  );
}
