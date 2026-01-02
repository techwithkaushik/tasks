import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Stream<User?> authStateChanges();
  Future<User> signIn(String email, String password);
  Future<User> signUp(String email, String password);
  Future<User?> getCurrentUser();
  Future<void> sendEmailVerification();
  Future<bool> isEmailVerified();
  Future<void> signOut();
  Future<void> resetPassword(String email);
}
