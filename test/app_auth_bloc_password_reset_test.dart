import 'package:flutter_test/flutter_test.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_bloc.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_in_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_up_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_out_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/reset_password_usecase.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_state.dart';
import 'helpers/fake_auth_repository.dart';

void main() {
  group('AppAuthBloc - Password Reset', () {
    test('emits passwordResetSent flag on successful password reset', () async {
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
      await Future.delayed(Duration(milliseconds: 100));

      bloc.add(AppAuthEmailChanged('test@example.com'));
      await Future.delayed(Duration(milliseconds: 50));

      bloc.add(AppAuthForgotPassword());
      await Future.delayed(Duration(milliseconds: 100));

      expect(
        emitted.any(
          (e) =>
              e is AppAuthState &&
              e.maybeWhen(
                unauthenticated: (form) => form.passwordResetSent,
                orElse: () => false,
              ),
        ),
        true,
      );

      await sub.cancel();
      await bloc.close();
    });

    test('emits error state on failed password reset', () async {
      final repo = FakeAuthRepository();
      repo.setResetPasswordShouldFail(true);
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
      await Future.delayed(Duration(milliseconds: 100));

      bloc.add(AppAuthEmailChanged('test@example.com'));
      await Future.delayed(Duration(milliseconds: 50));

      bloc.add(AppAuthForgotPassword());
      await Future.delayed(Duration(milliseconds: 100));

      expect(
        emitted.any(
          (e) =>
              e is AppAuthState &&
              e.maybeWhen(
                unauthenticated: (form) => form.error != null,
                orElse: () => false,
              ),
        ),
        true,
      );

      await sub.cancel();
      await bloc.close();
    });
  });
}
