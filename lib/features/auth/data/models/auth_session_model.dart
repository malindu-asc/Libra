import '../../domain/entities/auth_session.dart';
import 'authenticated_member_model.dart';

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({
    required super.accessToken,
    required super.refreshToken,
    required super.expiresAt,
    required AuthenticatedMemberModel super.member,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) =>
      AuthSessionModel(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
        expiresAt: DateTime.parse(json['expiresAt'] as String),
        member: AuthenticatedMemberModel.fromJson(
          json['member'] as Map<String, dynamic>,
        ),
      );
}
