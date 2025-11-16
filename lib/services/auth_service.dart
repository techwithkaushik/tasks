import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign up user with email & password
  Future<String?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user == null) {
        return "User creation failed";
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  /// Login user
  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  /// Logout current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Stream for auth state changes (optional, useful if you ever need it directly)
  Stream<User?> get userStream => _auth.authStateChanges();

  /// Current logged-in user
  User? get currentUser => _auth.currentUser;
}
