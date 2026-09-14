import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/member.dart';
import '../repositories/member_repository.dart';

class UpdateMyProfileParams {
  const UpdateMyProfileParams({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });

  final String fullName;
  final String email;
  final String phoneNumber;
}

class UpdateMyProfile implements UseCase<Member, UpdateMyProfileParams> {
  const UpdateMyProfile(this.repository);

  final MemberRepository repository;

  @override
  Future<Either<Failure, Member>> call(UpdateMyProfileParams params) =>
      repository.updateMyProfile(
        fullName: params.fullName,
        email: params.email,
        phoneNumber: params.phoneNumber,
      );
}