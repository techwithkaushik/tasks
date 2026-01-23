import 'package:flutter_test/flutter_test.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_bloc.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_in_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_up_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_out_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/reset_password_usecase.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_state.dart';
import 'helpers/fake_auth_repository.dart';

void main() {
  group('AppAuthBloc - Form Validation', () {
    test('updates email validity when email changes', () async {
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

      bloc.add(AppAuthEmailChanged('invalid-email'));
      await Future.delayed(Duration(milliseconds: 50));

      var unauthState =
          emitted.lastWhere(
                (e) =>
                    e is AppAuthState &&
                    e.maybeWhen(
                      unauthenticated: (_) => true,
                      orElse: () => false,
                    ),
                orElse: () => null,
              )
              as AppAuthState?;
      expect(
        unauthState?.maybeWhen(
          unauthenticated: (form) => form.isEmailValid,
          orElse: () => false,
        ),
        false,
      );

      bloc.add(AppAuthEmailChanged('valid@example.com'));
      await Future.delayed(Duration(milliseconds: 50));

      unauthState =
          emitted.lastWhere(
                (e) =>
                    e is AppAuthState &&
                    e.maybeWhen(
                      unauthenticated: (_) => true,
                      orElse: () => false,
                    ),
                orElse: () => null,
              )
              as AppAuthState?;
      expect(
        unauthState?.maybeWhen(
          unauthenticated: (form) => form.isEmailValid,
          orElse: () => false,
        ),
        true,
      );

      await sub.cancel();
      await bloc.close();
    });

    test('updates password validity when password changes', () async {
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

      bloc.add(AppAuthPasswordChanged('short'));
      await Future.delayed(Duration(milliseconds: 50));

      var unauthState =
          emitted.lastWhere(
                (e) =>
                    e is AppAuthState &&
                    e.maybeWhen(
                      unauthenticated: (_) => true,
                      orElse: () => false,
                    ),
                orElse: () => null,
              )
              as AppAuthState?;
      expect(
        unauthState?.maybeWhen(
          unauthenticated: (form) => form.isPasswordValid,
          orElse: () => false,
        ),
        false,
      );

      bloc.add(AppAuthPasswordChanged('ValidPass123!'));
      await Future.delayed(Duration(milliseconds: 50));

      unauthState =
          emitted.lastWhere(
                (e) =>
                    e is AppAuthState &&
                    e.maybeWhen(
                      unauthenticated: (_) => true,
                      orElse: () => false,
                    ),
                orElse: () => null,
              )
              as AppAuthState?;
      expect(
        unauthState?.maybeWhen(
          unauthenticated: (form) => form.isPasswordValid,
          orElse: () => false,
        ),
        true,
      );

      await sub.cancel();
      await bloc.close();
    });

    test('validates confirm password matching', () async {
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

      bloc.add(AppAuthPasswordChanged('ValidPass123!'));
      await Future.delayed(Duration(milliseconds: 50));

      bloc.add(AppAuthConfirmPasswordChanged('DifferentPass123!'));
      await Future.delayed(Duration(milliseconds: 50));

      var unauthState =
          emitted.lastWhere(
                (e) =>
                    e is AppAuthState &&
                    e.maybeWhen(
                      unauthenticated: (_) => true,
                      orElse: () => false,
                    ),
                orElse: () => null,
              )
              as AppAuthState?;
      expect(
        unauthState?.maybeWhen(
          unauthenticated: (form) => form.isConfirmPasswordValid,
          orElse: () => false,
        ),
        false,
      );

      bloc.add(AppAuthConfirmPasswordChanged('ValidPass123!'));
      await Future.delayed(Duration(milliseconds: 50));

      unauthState =
          emitted.lastWhere(
                (e) =>
                    e is AppAuthState &&
                    e.maybeWhen(
                      unauthenticated: (_) => true,
                      orElse: () => false,
                    ),
                orElse: () => null,
              )
              as AppAuthState?;
      expect(
        unauthState?.maybeWhen(
          unauthenticated: (form) => form.isConfirmPasswordValid,
          orElse: () => false,
        ),
        true,
      );

      await sub.cancel();
      await bloc.close();
    });
  });
}
