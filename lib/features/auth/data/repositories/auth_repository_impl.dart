import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_exception.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_session_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this.localDataSource, this.sessionStorage);

  final AuthLocalDataSource localDataSource;
  final AuthSessionStorage sessionStorage;

  @override
  Future<Either<Failure, AuthSession>> login({
    required String email,
    required String password,
  }) async {
    try {
      final session = await localDataSource.login(
        email: email,
        password: password,
      );
      await sessionStorage.save(session);
      return Right(session);
    } on AuthException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      await localDataSource.register(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      );
      return const Right(null);
    } on AuthException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({required String email}) async {
    try {
      await localDataSource.forgotPassword(email: email);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.logout();
      await sessionStorage.clear();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthSession?>> restoreSession() async {
    try {
      return Right(await sessionStorage.read());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
