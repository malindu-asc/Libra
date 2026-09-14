import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class RestoreSession implements UseCase<AuthSession?, NoParams> {
  const RestoreSession(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, AuthSession?>> call(NoParams params) =>
      repository.restoreSession();
}
