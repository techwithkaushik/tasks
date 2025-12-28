import 'package:dartz/dartz.dart';
import 'package:tasks/src/core/errors/auth_failure.dart';
import 'package:tasks/src/features/app_auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> authStateChanges();

  /// Login with email & password
  Future<Either<AuthFailure, UserEntity>> login({
    required String email,
    required String password,
  });

  /// Register new user
  Future<Either<AuthFailure, UserEntity>> register({
    required String email,
    required String password,
  });

  /// Currently logged-in user (cached / Firebase currentUser)
  Future<Either<AuthFailure, UserEntity?>> getCurrentUser();

  /// Send verification email
  Future<Either<AuthFailure, void>> sendEmailVerification();

  /// Reload user & check email verification
  Future<Either<AuthFailure, bool>> isEmailVerified();

  /// Sign out
  Future<Either<AuthFailure, void>> signOut();
}
