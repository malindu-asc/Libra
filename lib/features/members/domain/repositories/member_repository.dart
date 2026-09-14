import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/member.dart';

abstract class MemberRepository {
  /// Mirrors `GET /api/me`.
  Future<Either<Failure, Member>> getMyProfile();

  /// Mirrors `PUT /api/me`. No `id`, `registeredDate` or `isActive` — those
  /// are server-controlled and never sent from the client.
  Future<Either<Failure, Member>> updateMyProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
  });

  /// Mirrors `PUT /api/me/password`.
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
