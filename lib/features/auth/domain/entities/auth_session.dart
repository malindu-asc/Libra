import 'authenticated_member.dart';

/// Matches the token shape returned by `/api/auth/login`, `/register`, and
/// `/refresh` per the backend contract.
class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.member,
  });

  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final AuthenticatedMember member;
}
