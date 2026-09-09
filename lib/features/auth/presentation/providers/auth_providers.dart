import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/auth_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/forgot_password.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/register.dart';

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>(
  (ref) => AuthLocalDatasourceImpl(),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(authLocalDataSourceProvider)),
);

final loginUseCaseProvider = Provider<Login>(
  (ref) => Login(ref.watch(authRepositoryProvider)),
);

final registerUseCaseProvider = Provider<Register>(
  (ref) => Register(ref.watch(authRepositoryProvider)),
);

final forgotPasswordUseCaseProvider = Provider<ForgotPassword>(
  (ref) => ForgotPassword(ref.watch(authRepositoryProvider)),
);

/// `state.value` is null until a login attempt succeeds.
class LoginController extends AsyncNotifier<AuthSession?> {
  @override
  FutureOr<AuthSession?> build() => null;

  Future<void> submit({required String email, required String password}) async {
    state = const AsyncLoading();
    final useCase = ref.read(loginUseCaseProvider);
    final result = await useCase(LoginParams(email: email, password: password));
    state = result.match(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (session) => AsyncData(session),
    );
  }
}

final loginControllerProvider =
    AsyncNotifierProvider<LoginController, AuthSession?>(LoginController.new);

/// `state.value` is true once registration succeeds.
class RegisterController extends AsyncNotifier<bool> {
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
    state = result.match(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (_) => const AsyncData(true),
    );
  }
}

final registerControllerProvider =
    AsyncNotifierProvider<RegisterController, bool>(RegisterController.new);

/// `state.value` is true once the request has gone through — the backend
/// always responds the same way regardless of whether the email exists.
class ForgotPasswordController extends AsyncNotifier<bool> {
  @override
  FutureOr<bool> build() => false;

  Future<void> submit({required String email}) async {
    state = const AsyncLoading();
    final useCase = ref.read(forgotPasswordUseCaseProvider);
    final result = await useCase(ForgotPasswordParams(email: email));
    state = result.match(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (_) => const AsyncData(true),
    );
  }
}

final forgotPasswordControllerProvider =
    AsyncNotifierProvider<ForgotPasswordController, bool>(
      ForgotPasswordController.new,
    );
