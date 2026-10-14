import 'package:flutter_test/flutter_test.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_bloc.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_in_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_up_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_out_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/reset_password_usecase.dart';
import 'helpers/fake_auth_repository.dart';

void main() {
  test('auth stream errors show retryable error instead of logging out', () async {
    final repo = FakeAuthRepository();
    final bloc = AppAuthBloc(
      repository: repo,
      signInUseCase: SignInUseCase(repo),
      signUpUseCase: SignUpUseCase(repo),
      signOutUseCase: SignOutUseCase(repo),
      resetPasswordUseCase: ResetPasswordUseCase(repo),
    );

    await Future.delayed(const Duration(milliseconds: 100));
    repo.emitStreamError(Exception('temporary network failure'));
    await Future.delayed(const Duration(milliseconds: 100));

    expect(
      bloc.state.maybeWhen(error: (_) => true, orElse: () => false),
      isTrue,
    );

    await bloc.close();
  });
}
