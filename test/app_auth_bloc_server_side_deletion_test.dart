import 'package:flutter_test/flutter_test.dart';
import 'package:tasks/src/features/app_auth/domain/entities/user_entity.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_bloc.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_in_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_up_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_out_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/reset_password_usecase.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_state.dart';
import 'helpers/fake_auth_repository.dart';

void main() {
  group('AppAuthBloc - Server-side deletion', () {
    test(
      'reacts to server-side deletion by emitting unauthenticated',
      () async {
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

        final user = UserEntity(
          uid: 'u1',
          email: 'a@b',
          name: 'n',
          isEmailVerified: true,
        );
        repo.emit(user);

        await Future.delayed(Duration(milliseconds: 50));

        repo.emit(null);
        await Future.delayed(Duration(milliseconds: 50));

        expect(
          emitted.any(
            (e) =>
                e is AppAuthState &&
                e.maybeWhen(authenticated: (_) => true, orElse: () => false),
          ),
          true,
        );
        expect(
          emitted.any(
            (e) =>
                e is AppAuthState &&
                e.maybeWhen(unauthenticated: (_) => true, orElse: () => false),
          ),
          true,
        );

        await sub.cancel();
        await bloc.close();
      },
    );
  });
}
