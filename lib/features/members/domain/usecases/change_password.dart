import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/member_repository.dart';

/// No `confirmNewPassword` — that's a UI-only check, not part of the request.
class ChangePasswordParams {
  const ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });

  final String currentPassword;
  final String newPassword;
}

class ChangePassword implements UseCase<void, ChangePasswordParams> {
  const ChangePassword(this.repository);

  final MemberRepository repository;

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) =>
      repository.changePassword(
        currentPassword: params.currentPassword,
        newPassword: params.newPassword,
      );
}