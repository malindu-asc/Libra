import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/member.dart';
import '../../domain/repositories/member_repository.dart';
import '../datasources/member_exception.dart';
import '../datasources/member_local_datasource.dart';

class MemberRepositoryImpl implements MemberRepository {
  const MemberRepositoryImpl(this.localDataSource);

  final MemberLocalDataSource localDataSource;

  @override
  Future<Either<Failure, Member>> getMyProfile() async {
    try {
      final model = await localDataSource.getMyProfile();
      return Right(model);
    } on MemberException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Member>> updateMyProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
  }) async {
    try {
      final model = await localDataSource.updateMyProfile(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
      );
      return Right(model);
    } on MemberException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await localDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Right(null);
    } on MemberException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}