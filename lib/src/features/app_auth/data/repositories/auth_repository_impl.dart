import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasks/src/core/errors/auth_failure.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Stream<UserEntity?> authStateChanges() {
    // Ensure upstream errors do not close the auth stream — convert errors
    // into a `null` user so the app can react by treating the user as
    // unauthenticated instead of crashing.
    final safeStream = remote.authStateChanges().transform<User?>(
      StreamTransformer<User?, User?>.fromHandlers(
        handleError: (error, stack, sink) {
          sink.add(null);
        },
      ),
    );

    return safeStream.map(
      (user) => user == null ? null : UserModel.fromFirebase(user).toEntity(),
    );
  }

  @override
  Future<Either<AuthFailure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remote.signIn(email, password);
      return Right(UserModel.fromFirebase(user).toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Login failed'));
    }
  }

  @override
  Future<Either<AuthFailure, UserEntity>> register({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remote.signUp(email, password);
      return Right(UserModel.fromFirebase(user).toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Register failed'));
    }
  }

  @override
  Future<Either<AuthFailure, UserEntity?>> getCurrentUser() async {
    final user = await remote.getCurrentUser();
    if (user == null) return const Right(null);
    return Right(UserModel.fromFirebase(user).toEntity());
  }

  @override
  Future<Either<AuthFailure, void>> sendEmailVerification() async {
    try {
      await remote.sendEmailVerification();
      return const Right(null);
    } catch (_) {
      return const Left(AuthFailure('Failed to send verification email'));
    }
  }

  @override
  Future<Either<AuthFailure, bool>> isEmailVerified() async {
    try {
      final verified = await remote.isEmailVerified();
      return Right(verified);
    } catch (_) {
      return const Left(AuthFailure('Failed to check verification'));
    }
  }

  @override
  Future<Either<AuthFailure, void>> signOut() async {
    await remote.signOut();
    return const Right(null);
  }

  @override
  Future<Either<AuthFailure, void>> resetPassword({
    required String email,
  }) async {
    try {
      await remote.resetPassword(email);
      return const Right(null);
    } catch (e) {
      return const Left(AuthFailure('Failed to send password reset email'));
    }
  }
}
