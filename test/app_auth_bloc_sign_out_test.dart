import 'package:flutter_test/flutter_test.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_bloc.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_in_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_up_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_out_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/reset_password_usecase.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_state.dart';
import 'package:tasks/src/features/app_auth/domain/entities/user_entity.dart';
import 'helpers/fake_auth_repository.dart';

void main() {
  group('AppAuthBloc - Sign Out', () {
    test('emits unauthenticated state on sign out', () async {
      final repo = FakeAuthRepository();
      final bloc = AppAuthBloc(
        repository: repo,
        signInUseCase: SignInUseCase(repo),
        signUpUseCase: SignUpUseCase(repo),
        signOutUseCase: SignOutUseCase(repo),
        resetPasswordUseCase: ResetPasswordUseCase(repo),
      );

      final emitted = <dynamic>[];
      final sub = bloc.stream.listen(emitted.add);

      bloc.add(AppAuthStarted());
      await Future.delayed(const Duration(milliseconds: 100));

      bloc.add(AppAuthSignOutRequested());
      await Future.delayed(const Duration(milliseconds: 100));

      expect(
        emitted.any(
          (e) =>
              e is AppAuthState &&
              e.maybeWhen(unauthenticated: (_) => true, orElse: () => false),
        ),
        isTrue,
      );

      await sub.cancel();
      await bloc.close();
    });

    test('keeps authenticated state when sign out fails', () async {
      final repo = FakeAuthRepository();
      final bloc = AppAuthBloc(
        repository: repo,
        signInUseCase: SignInUseCase(repo),
        signUpUseCase: SignUpUseCase(repo),
        signOutUseCase: SignOutUseCase(repo),
        resetPasswordUseCase: ResetPasswordUseCase(repo),
      );

      final emitted = <AppAuthState>[];
      final sub = bloc.stream.listen(emitted.add);

      await Future.delayed(const Duration(milliseconds: 100));
      repo.emit(
        UserEntity(
          uid: 'uid',
          email: 'user@example.com',
          name: 'Test User',
          isEmailVerified: true,
        ),
      );
      await Future.delayed(const Duration(milliseconds: 50));

      repo.setSignOutShouldFail(true);
      bloc.add(AppAuthSignOutRequested());
      await Future.delayed(const Duration(milliseconds: 100));

      expect(
        emitted.last.maybeWhen(
          authenticated: (_) => true,
          orElse: () => false,
        ),
        isTrue,
      );

      await sub.cancel();
      await bloc.close();
    });
  });
}
