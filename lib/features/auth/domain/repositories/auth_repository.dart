import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/auth_session.dart';
//tells what operatoin can be performed and what data required
abstract class AuthRepository {
  Future<Either<Failure, AuthSession>> login({
    required String email,
    required String password,
  });

  /// Per the backend contract, registration does not auto-login — success
  /// just means the account was created.
  Future<Either<Failure, void>> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  });

  /// Always resolves the same way regardless of whether the email exists
  /// (anti-enumeration) - the repository has nothing further to expose.
  Future<Either<Failure, void>> forgotPassword({required String email});

  /// Mirrors `POST /api/auth/logout` — revokes the refresh token server-side.
  /// Clearing local session state is the caller's job, not the repository's.
  Future<Either<Failure, void>> logout();
}
