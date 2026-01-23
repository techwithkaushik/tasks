import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasks/src/features/app_auth/data/datasources/auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl(this.firebaseAuth);

  @override
  Stream<User?> authStateChanges() {
    // Use idTokenChanges so we get updates when the token is refreshed.
    // Additionally attempt to reload the user to detect server-side
    // deletion or disabling. If reload fails with a "user-not-found"
    // or "user-disabled" error, sign out locally and emit null so the
    // app treats the user as unauthenticated.
    return firebaseAuth.idTokenChanges().asyncMap((user) async {
      if (user == null) return null;
      try {
        await user.reload();
        // After reload, return the current user (may include refreshed token)
        return firebaseAuth.currentUser;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' || e.code == 'user-disabled') {
          // Ensure local sign-out so all listeners receive a null user
          try {
            await firebaseAuth.signOut();
          } catch (_) {}
          return null;
        }
        // For other firebase auth errors, treat as unauthenticated instead of
        // rethrowing to avoid bubbling stream exceptions to UI.
        return null;
      } catch (_) {
        // Any other unexpected error should not break the stream; return null
        return null;
      }
    });
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

  @override
  Future<void> resetPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
