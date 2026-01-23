import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasks/src/features/app_auth/domain/entities/user_entity.dart';
import 'package:tasks/src/features/app_auth/domain/repositories/auth_repository.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_bloc.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_in_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_up_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_out_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/reset_password_usecase.dart';
import 'package:tasks/src/core/errors/auth_failure.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_state.dart';

class FakeAuthRepository implements AuthRepository {
  final StreamController<UserEntity?> _ctrl = StreamController.broadcast();

  @override
  Stream<UserEntity?> authStateChanges() => _ctrl.stream;

  void emit(UserEntity? u) => _ctrl.add(u);

  @override
  Future<Either<AuthFailure, UserEntity>> login({
    required String email,
    required String password,
  }) async => Right(
    UserEntity(uid: 'uid', email: email, name: 'n', isEmailVerified: true),
  );

  @override
  Future<Either<AuthFailure, UserEntity>> register({
    required String email,
    required String password,
  }) async => Right(
    UserEntity(uid: 'uid2', email: email, name: 'n2', isEmailVerified: true),
  );

  @override
  Future<Either<AuthFailure, UserEntity?>> getCurrentUser() async =>
      const Right(null);

  @override
  Future<Either<AuthFailure, void>> sendEmailVerification() async =>
      const Right(null);

  @override
  Future<Either<AuthFailure, bool>> isEmailVerified() async =>
      const Right(true);

  @override
  Future<Either<AuthFailure, void>> signOut() async => const Right(null);

  @override
  Future<Either<AuthFailure, void>> resetPassword({
    required String email,
  }) async => const Right(null);
}

void main() {
  test(
    'AppAuthBloc reacts to server-side deletion by emitting unauthenticated',
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

      // start the bloc
      bloc.add(AppAuthStarted());

      // wait for AppAuthStarted to be processed and subscription to be set up
      await Future.delayed(Duration(milliseconds: 100));

      // emit authenticated user
      final user = UserEntity(
        uid: 'u1',
        email: 'a@b',
        name: 'n',
        isEmailVerified: true,
      );
      repo.emit(user);

      // give some time for event to propagate
      await Future.delayed(Duration(milliseconds: 50));

      // then simulate server-side deletion
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
}
