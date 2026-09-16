import '../../domain/entities/authenticated_member.dart';

class AuthenticatedMemberModel extends AuthenticatedMember {
  const AuthenticatedMemberModel({
    required super.id,
    required super.fullName,
    required super.email,
  });

  factory AuthenticatedMemberModel.fromJson(Map<String, dynamic> json) =>
      AuthenticatedMemberModel(
        id: json['id'] as String,
        fullName: json['fullName'] as String,
        email: json['email'] as String,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'email': email,
  };
}
