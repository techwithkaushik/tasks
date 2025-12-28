import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasks/src/features/app_auth/data/datasources/auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl(this.firebaseAuth);

  @override
  Stream<User?> authStateChanges() {
    return firebaseAuth.authStateChanges();
  }

  @override
  Future<User> signIn(String email, String password) async {
    final result = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user!;
  }

  @override
  Future<User> signUp(String email, String password) async {
    final result = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user!;
  }

  @override
  Future<User?> getCurrentUser() async {
    return firebaseAuth.currentUser;
  }

  @override
  Future<void> sendEmailVerification() async {
    await firebaseAuth.currentUser?.sendEmailVerification();
  }

  @override
  Future<bool> isEmailVerified() async {
    await firebaseAuth.currentUser?.reload();
    return firebaseAuth.currentUser?.emailVerified ?? false;
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
