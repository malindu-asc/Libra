import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/member.dart';
import '../repositories/member_repository.dart';

class GetMyProfile implements UseCase<Member, NoParams> {
  const GetMyProfile(this.repository);

  final MemberRepository repository;

  @override
  Future<Either<Failure, Member>> call(NoParams params) =>
      repository.getMyProfile();
}