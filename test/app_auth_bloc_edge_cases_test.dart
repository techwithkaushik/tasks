import 'package:flutter_test/flutter_test.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_bloc.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_in_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_up_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_out_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/reset_password_usecase.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_state.dart';
import 'helpers/fake_auth_repository.dart';

void main() {
  group('AppAuthBloc - Edge Cases', () {
    test('handles submission with invalid form data', () async {
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

      bloc.add(AppAuthSubmitted());
      await Future.delayed(Duration(milliseconds: 100));

      expect(
        emitted.any(
          (e) =>
              e is AppAuthState &&
              e.maybeWhen(authenticated: (_) => true, orElse: () => false),
        ),
        false,
      );

      await sub.cancel();
      await bloc.close();
    });

    test('confirms password is cleared when toggling mode', () async {
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

      bloc.add(AppAuthModeToggled());
      await Future.delayed(Duration(milliseconds: 50));

      bloc.add(AppAuthConfirmPasswordChanged('TestPass123!'));
      await Future.delayed(Duration(milliseconds: 50));

      bloc.add(AppAuthModeToggled());
      await Future.delayed(Duration(milliseconds: 50));

      final finalState =
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
      final confirmPassword = finalState?.maybeWhen(
        unauthenticated: (form) => form.confirmPassword,
        orElse: () => '',
      );

      expect(confirmPassword, '');

      await sub.cancel();
      await bloc.close();
    });
  });
}
