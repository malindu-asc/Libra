// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(memberLocalDataSource)
final memberLocalDataSourceProvider = MemberLocalDataSourceProvider._();

final class MemberLocalDataSourceProvider
    extends
        $FunctionalProvider<
          MemberLocalDataSource,
          MemberLocalDataSource,
          MemberLocalDataSource
        >
    with $Provider<MemberLocalDataSource> {
  MemberLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memberLocalDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memberLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<MemberLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MemberLocalDataSource create(Ref ref) {
    return memberLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MemberLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MemberLocalDataSource>(value),
    );
  }
}

String _$memberLocalDataSourceHash() =>
    r'9880cda5ff56bde65e640462454fa0e91b4d036c';

@ProviderFor(memberRepository)
final memberRepositoryProvider = MemberRepositoryProvider._();

final class MemberRepositoryProvider
    extends
        $FunctionalProvider<
          MemberRepository,
          MemberRepository,
          MemberRepository
        >
    with $Provider<MemberRepository> {
  MemberRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memberRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memberRepositoryHash();

  @$internal
  @override
  $ProviderElement<MemberRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MemberRepository create(Ref ref) {
    return memberRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MemberRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MemberRepository>(value),
    );
  }
}

String _$memberRepositoryHash() => r'64cfe0786ff05b917178fb26241f308111265688';

@ProviderFor(getMyProfileUseCase)
final getMyProfileUseCaseProvider = GetMyProfileUseCaseProvider._();

final class GetMyProfileUseCaseProvider
    extends $FunctionalProvider<GetMyProfile, GetMyProfile, GetMyProfile>
    with $Provider<GetMyProfile> {
  GetMyProfileUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getMyProfileUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getMyProfileUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetMyProfile> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetMyProfile create(Ref ref) {
    return getMyProfileUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetMyProfile value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetMyProfile>(value),
    );
  }
}

String _$getMyProfileUseCaseHash() =>
    r'29d8ca38dc8a15429a1cc2b9212b28f3da009e33';

@ProviderFor(updateMyProfileUseCase)
final updateMyProfileUseCaseProvider = UpdateMyProfileUseCaseProvider._();

final class UpdateMyProfileUseCaseProvider
    extends
        $FunctionalProvider<UpdateMyProfile, UpdateMyProfile, UpdateMyProfile>
    with $Provider<UpdateMyProfile> {
  UpdateMyProfileUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateMyProfileUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateMyProfileUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateMyProfile> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdateMyProfile create(Ref ref) {
    return updateMyProfileUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateMyProfile value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateMyProfile>(value),
    );
  }
}

String _$updateMyProfileUseCaseHash() =>
    r'f81483377ceb684dfdecb5695d43a44fc8e68591';

@ProviderFor(changePasswordUseCase)
final changePasswordUseCaseProvider = ChangePasswordUseCaseProvider._();

final class ChangePasswordUseCaseProvider
    extends $FunctionalProvider<ChangePassword, ChangePassword, ChangePassword>
    with $Provider<ChangePassword> {
  ChangePasswordUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'changePasswordUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$changePasswordUseCaseHash();

  @$internal
  @override
  $ProviderElement<ChangePassword> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChangePassword create(Ref ref) {
    return changePasswordUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChangePassword value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChangePassword>(value),
    );
  }
}

String _$changePasswordUseCaseHash() =>
    r'a130a96a05109ac4ee584b7a4579158b6db36986';

/// The logged-in member's full profile. Separate from `currentMemberProvider`
/// (which only holds what the login response returned) because
/// `registeredDate`/`isActive` only ever arrive from `GET /api/me`.

@ProviderFor(myProfile)
final myProfileProvider = MyProfileProvider._();

/// The logged-in member's full profile. Separate from `currentMemberProvider`
/// (which only holds what the login response returned) because
/// `registeredDate`/`isActive` only ever arrive from `GET /api/me`.

final class MyProfileProvider
    extends $FunctionalProvider<AsyncValue<Member>, Member, FutureOr<Member>>
    with $FutureModifier<Member>, $FutureProvider<Member> {
  /// The logged-in member's full profile. Separate from `currentMemberProvider`
  /// (which only holds what the login response returned) because
  /// `registeredDate`/`isActive` only ever arrive from `GET /api/me`.
  MyProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myProfileHash();

  @$internal
  @override
  $FutureProviderElement<Member> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Member> create(Ref ref) {
    return myProfile(ref);
  }
}

String _$myProfileHash() => r'c3bfefba519ab817ddd3b754b9af268527cc782d';

@ProviderFor(UpdateProfileController)
final updateProfileControllerProvider = UpdateProfileControllerProvider._();

final class UpdateProfileControllerProvider
    extends $AsyncNotifierProvider<UpdateProfileController, bool> {
  UpdateProfileControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateProfileControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateProfileControllerHash();

  @$internal
  @override
  UpdateProfileController create() => UpdateProfileController();
}

String _$updateProfileControllerHash() =>
    r'3dbe8eef984d5024d7e9c6f4cc053ae664f85d30';

abstract class _$UpdateProfileController extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(ChangePasswordController)
final changePasswordControllerProvider = ChangePasswordControllerProvider._();

final class ChangePasswordControllerProvider
    extends $AsyncNotifierProvider<ChangePasswordController, bool> {
  ChangePasswordControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'changePasswordControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$changePasswordControllerHash();

  @$internal
  @override
  ChangePasswordController create() => ChangePasswordController();
}

String _$changePasswordControllerHash() =>
    r'870e6b5b2f91ec25b473cd6255a9e964af2a8756';

abstract class _$ChangePasswordController extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
