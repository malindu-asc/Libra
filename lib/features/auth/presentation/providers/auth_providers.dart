import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_session_storage.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/forgot_password.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/register.dart';
import '../../domain/usecases/restore_session.dart';
import '../../domain/usecases/logout.dart';
import 'current_member_provider.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
AuthLocalDataSource authLocalDataSource(Ref ref) => AuthLocalDatasourceImpl();

@Riverpod(keepAlive: true)
AuthSessionStorage authSessionStorage(Ref ref) =>
    const AuthSessionStorage(FlutterSecureStorage());

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => AuthRepositoryImpl(
  ref.watch(authLocalDataSourceProvider),
  ref.watch(authSessionStorageProvider),
);

@riverpod
Login loginUseCase(Ref ref) => Login(ref.watch(authRepositoryProvider));

@riverpod
Register registerUseCase(Ref ref) =>
    Register(ref.watch(authRepositoryProvider));

@riverpod
ForgotPassword forgotPasswordUseCase(Ref ref) =>
    ForgotPassword(ref.watch(authRepositoryProvider));

@riverpod
Logout logoutUseCase(Ref ref) =>
    Logout(ref.watch(authRepositoryProvider));

@riverpod
RestoreSession restoreSessionUseCase(Ref ref) =>
    RestoreSession(ref.watch(authRepositoryProvider));

@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<AuthSession?> build() => null;

  Future<void> submit({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final useCase = ref.read(loginUseCaseProvider);
    final result = await useCase(
      LoginParams(email: email, password: password),
    );
    // These controllers are autoDispose, so the screen may already be gone
    // by the time the call returns — assigning state then throws.
    if (!ref.mounted) return;
    state = result.match(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (session) {
        ref.read(currentMemberProvider.notifier).set(session.member);
        return AsyncData(session);
      },
    );
  }
}

@riverpod
class RegisterController extends _$RegisterController {
  @override
  FutureOr<bool> build() => false;

  Future<void> submit({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    state = const AsyncLoading();
    final useCase = ref.read(registerUseCaseProvider);
    final result = await useCase(
      RegisterParams(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      ),
    );
    if (!ref.mounted) return;
    state = result.match(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (_) => const AsyncData(true),
    );
  }
}

@riverpod
class ForgotPasswordController extends _$ForgotPasswordController {
  @override
  FutureOr<bool> build() => false;

  Future<void> submit({required String email}) async {
    state = const AsyncLoading();
    final useCase = ref.read(forgotPasswordUseCaseProvider);
    final result = await useCase(ForgotPasswordParams(email: email));
    if (!ref.mounted) return;
    state = result.match(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (_) => const AsyncData(true),
    );
  }
}
