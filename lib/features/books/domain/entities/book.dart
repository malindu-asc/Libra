class Book {
  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.publishedYear,
    required this.totalCopies,
    required this.availableCopies,
    this.description,
    this.coverImageUrl,
    this.pages,
  });

  final String id;
  final String title;
  final String author;
  final String isbn;
  final int publishedYear;
  final int totalCopies;
  final int availableCopies;

  /// From the book-details endpoint only 
  final String? description;

  /// Not in the current backend contract; nullable so the UI can fall back
  /// to a placeholder cover until a real image URL exists.
  final String? coverImageUrl;

  /// Not in the current backend contract either; same nullable treatment.
  final int? pages;
}
