import 'package:flutter_test/flutter_test.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_bloc.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_state.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_in_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_up_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_out_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/reset_password_usecase.dart';
import 'helpers/fake_auth_repository.dart';

void main() {
  test('emits a retryable error when initial session lookup fails', () async {
    final repo = FakeAuthRepository()..setCurrentUserShouldFail(true);
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

    expect(
      emitted.any(
        (state) => state.maybeWhen(error: (_) => true, orElse: () => false),
      ),
      isTrue,
    );

    await sub.cancel();
    await bloc.close();
  });
}
