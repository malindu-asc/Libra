import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;
}

class Login implements UseCase<AuthSession, LoginParams> { //auth.provider call authrepository
  const Login(this.repository);

  final AuthRepository repository;

  @override 
  Future<Either<Failure, AuthSession>> call(LoginParams params) =>
      repository.login(email: params.email, password: params.password);
}
