import 'package:flutter_test/flutter_test.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_bloc.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_in_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_up_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_out_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/reset_password_usecase.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_state.dart';
import 'helpers/fake_auth_repository.dart';

void main() {
  group('AppAuthBloc - UI Interactions', () {
    test('toggles obscure text when requested', () async {
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

      final initialState =
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
      final initialObscure = initialState?.maybeWhen(
        unauthenticated: (form) => form.obscureText,
        orElse: () => false,
      );

      bloc.add(AppAuthObscureToggled());
      await Future.delayed(Duration(milliseconds: 50));

      final toggledState =
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
      final toggledObscure = toggledState?.maybeWhen(
        unauthenticated: (form) => form.obscureText,
        orElse: () => false,
      );

      expect(toggledObscure, !initialObscure!);

      await sub.cancel();
      await bloc.close();
    });

    test('toggles between sign in and sign up modes', () async {
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

      final initialState =
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
      final initialMode = initialState?.maybeWhen(
        unauthenticated: (form) => form.mode,
        orElse: () => null,
      );

      bloc.add(AppAuthModeToggled());
      await Future.delayed(Duration(milliseconds: 50));

      final toggledState =
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
      final toggledMode = toggledState?.maybeWhen(
        unauthenticated: (form) => form.mode,
        orElse: () => null,
      );

      expect(toggledMode, isNot(initialMode));

      await sub.cancel();
      await bloc.close();
    });

    test('clears error when form field changes', () async {
      final repo = FakeAuthRepository();
      repo.setLoginShouldFail(true);
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

      bloc.add(AppAuthPasswordChanged('ValidPass123!'));
      await Future.delayed(Duration(milliseconds: 50));

      bloc.add(AppAuthSubmitted());
      await Future.delayed(Duration(milliseconds: 100));

      var stateWithError =
          emitted.lastWhere(
                (e) =>
                    e is AppAuthState &&
                    e.maybeWhen(
                      unauthenticated: (form) => form.error != null,
                      orElse: () => false,
                    ),
                orElse: () => null,
              )
              as AppAuthState?;
      expect(stateWithError, isNotNull);

      bloc.add(AppAuthEmailChanged('newemail@example.com'));
      await Future.delayed(Duration(milliseconds: 50));

      var stateWithoutError =
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
      final hasError = stateWithoutError?.maybeWhen(
        unauthenticated: (form) => form.error != null,
        orElse: () => false,
      );

      expect(hasError, false);

      await sub.cancel();
      await bloc.close();
    });
  });
}
