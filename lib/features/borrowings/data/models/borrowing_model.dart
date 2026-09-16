import '../../domain/entities/borrowing.dart';

class BorrowingModel extends Borrowing {
  const BorrowingModel({
    required super.id,
    required super.bookId,
    required super.memberId,
    required super.borrowedAt,
    required super.dueDate,
    super.returnedAt,
  });

  factory BorrowingModel.fromJson(Map<String, dynamic> json) => BorrowingModel(
    id: json['id'] as String,
    bookId: json['bookId'] as String,
    memberId: json['memberId'] as String,
    borrowedAt: DateTime.parse(json['borrowedAt'] as String),
    dueDate: DateTime.parse(json['dueDate'] as String),
    returnedAt: json['returnedAt'] == null
        ? null
        : DateTime.parse(json['returnedAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'bookId': bookId,
    'memberId': memberId,
    'borrowedAt': borrowedAt.toIso8601String(),
    'dueDate': dueDate.toIso8601String(),
    'returnedAt': returnedAt?.toIso8601String(),
  };
}
