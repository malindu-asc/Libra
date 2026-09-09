import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

/// No `confirmPassword` here — that's a UI-only check, not part of the
/// backend request shape. No `role`/`memberId`/`isActive` either; those are
/// server-controlled per the backend contract.
class RegisterParams {
  const RegisterParams({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });

  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
}

class Register implements UseCase<void, RegisterParams> {
  const Register(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, void>> call(RegisterParams params) =>
      repository.register(
        fullName: params.fullName,
        email: params.email,
        phoneNumber: params.phoneNumber,
        password: params.password,
      );
}
