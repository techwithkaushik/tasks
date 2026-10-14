import 'package:flutter_test/flutter_test.dart';
import 'package:tasks/src/features/app_auth/domain/entities/user_entity.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_bloc.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_in_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_up_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_out_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/reset_password_usecase.dart';
import 'helpers/fake_auth_repository.dart';

void main() {
  test('auth stream errors preserve the active session and recover on later events', () async {
    final repo = FakeAuthRepository();
    final bloc = AppAuthBloc(
      repository: repo,
      signInUseCase: SignInUseCase(repo),
      signUpUseCase: SignUpUseCase(repo),
      signOutUseCase: SignOutUseCase(repo),
      resetPasswordUseCase: ResetPasswordUseCase(repo),
    );

    await Future.delayed(const Duration(milliseconds: 100));
    repo.emit(
      UserEntity(
        uid: 'uid',
        email: 'user@example.com',
        name: 'Test User',
        isEmailVerified: true,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 100));
    expect(
      bloc.state.maybeWhen(authenticated: (_) => true, orElse: () => false),
      isTrue,
    );

    repo.emitStreamError(Exception('temporary network failure'));
    await Future.delayed(const Duration(milliseconds: 100));

    // A stream failure is not proof of sign-out; keep the authenticated
    // route and the existing user session instead of blocking the app.
    expect(
      bloc.state.maybeWhen(
        authenticated: (user) => user.uid == 'uid',
        orElse: () => false,
      ),
      isTrue,
    );

    // A real signed-out event must still clear the remembered session.
    repo.emit(null);
    await Future.delayed(const Duration(milliseconds: 100));
    expect(
      bloc.state.maybeWhen(unauthenticated: (_) => true, orElse: () => false),
      isTrue,
    );

    // A recoverable stream error must not permanently detach the listener.
    repo.emit(
      UserEntity(
        uid: 'uid',
        email: 'user@example.com',
        name: 'Test User',
        isEmailVerified: true,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 100));
    expect(
      bloc.state.maybeWhen(authenticated: (_) => true, orElse: () => false),
      isTrue,
    );

    await bloc.close();
  });
}
