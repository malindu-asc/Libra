import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../auth/domain/entities/authenticated_member.dart';
import '../../../auth/presentation/providers/current_member_provider.dart';
import '../../data/datasources/member_local_datasource.dart';
import '../../data/repositories/member_repository_impl.dart';
import '../../domain/entities/member.dart';
import '../../domain/repositories/member_repository.dart';
import '../../domain/usecases/change_password.dart';
import '../../domain/usecases/get_my_profile.dart';
import '../../domain/usecases/update_my_profile.dart';

part 'member_providers.g.dart';

@Riverpod(keepAlive: true) //make it persistance cuz memebers.json acces by memeberlocaldatasoruce
MemberLocalDataSource memberLocalDataSource(Ref ref) =>
    MemberLocalDatasourceImpl(() => ref.read(currentMemberProvider)?.id);

@Riverpod(keepAlive: true)
MemberRepository memberRepository(Ref ref) => //persistantly bind it to repooooo
    MemberRepositoryImpl(ref.watch(memberLocalDataSourceProvider));

@riverpod
GetMyProfile getMyProfileUseCase(Ref ref) =>
    GetMyProfile(ref.watch(memberRepositoryProvider));

@riverpod
UpdateMyProfile updateMyProfileUseCase(Ref ref) =>
    UpdateMyProfile(ref.watch(memberRepositoryProvider));

@riverpod
ChangePassword changePasswordUseCase(Ref ref) =>
    ChangePassword(ref.watch(memberRepositoryProvider));

/// The logged-in member's full profile. Separate from `currentMemberProvider`
/// (which only holds what the login response returned) because
/// `registeredDate`/`isActive` only ever arrive from `GET /api/me`.
@riverpod
Future<Member> myProfile(Ref ref) async { //#
  final useCase = ref.read(getMyProfileUseCaseProvider);
  final result = await useCase(const NoParams());
  return result.match((failure) => throw failure, (member) => member);
}

@riverpod
class UpdateProfileController extends _$UpdateProfileController {
  @override
  FutureOr<bool> build() => false;

  Future<void> submit({
    required String fullName,
    required String email,
    required String phoneNumber,
  }) async {
    state = const AsyncLoading(); //show spin
    final useCase = ref.read(updateMyProfileUseCaseProvider); //updte
    final result = await useCase(
      UpdateMyProfileParams(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
      ),
    );

    state = result.match(
      (failure) => AsyncError(failure.message, StackTrace.current), //return
      (member) {
        // Profile refetches, and the session copy updates too so Home's
        // greeting reflects a name change.
        ref.invalidate(myProfileProvider);
        ref
            .read(currentMemberProvider.notifier)
            .set(
              AuthenticatedMember(
                id: member.id,
                fullName: member.fullName,
                email: member.email,
              ),
            );
        return const AsyncData(true);
      },
    );
  }
}

@riverpod
class ChangePasswordController extends _$ChangePasswordController {
  @override
  FutureOr<bool> build() => false;

  Future<void> submit({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = const AsyncLoading();//set load
    final useCase = ref.read(changePasswordUseCaseProvider);//do
    final result = await useCase(
      ChangePasswordParams(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );
    state = result.match(
      (failure) => AsyncError(failure.message, StackTrace.current),//return
      (_) => const AsyncData(true),
    );
  }
}