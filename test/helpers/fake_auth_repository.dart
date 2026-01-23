import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:tasks/src/features/app_auth/domain/entities/user_entity.dart';
import 'package:tasks/src/features/app_auth/domain/repositories/auth_repository.dart';
import 'package:tasks/src/core/errors/auth_failure.dart';

class FakeAuthRepository implements AuthRepository {
  final StreamController<UserEntity?> _ctrl = StreamController.broadcast();
  bool _loginShouldFail = false;
  bool _registerShouldFail = false;
  bool _resetPasswordShouldFail = false;

  @override
  Stream<UserEntity?> authStateChanges() => _ctrl.stream;

  void emit(UserEntity? u) => _ctrl.add(u);

  void setLoginShouldFail(bool value) => _loginShouldFail = value;
  void setRegisterShouldFail(bool value) => _registerShouldFail = value;
  void setResetPasswordShouldFail(bool value) =>
      _resetPasswordShouldFail = value;

  @override
  Future<Either<AuthFailure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    if (_loginShouldFail) {
      return Left(AuthFailure('Login failed'));
    }
    return Right(
      UserEntity(
        uid: 'uid',
        email: email,
        name: 'Test User',
        isEmailVerified: true,
      ),
    );
  }

  @override
  Future<Either<AuthFailure, UserEntity>> register({
    required String email,
    required String password,
  }) async {
    if (_registerShouldFail) {
      return Left(AuthFailure('Registration failed'));
    }
    return Right(
      UserEntity(
        uid: 'uid2',
        email: email,
        name: 'New User',
        isEmailVerified: false,
      ),
    );
  }

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
  }) async {
    if (_resetPasswordShouldFail) {
      return Left(AuthFailure('Password reset failed'));
    }
    return const Right(null);
  }
}
