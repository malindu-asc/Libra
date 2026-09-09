import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';
//each class is specific for 1 usecase, and wrapper around repository

class ForgotPasswordParams {
  const ForgotPasswordParams({required this.email});

  final String email;
}

class ForgotPassword implements UseCase<void, ForgotPasswordParams> {
  const ForgotPassword(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, void>> call(ForgotPasswordParams params) =>
      repository.forgotPassword(email: params.email);
}
