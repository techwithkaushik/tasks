import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tasks/services/auth_service.dart';

import '../pages/login_page.dart';
import '../pages/home_page.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Rx<User?> firebaseUser;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialPage);
  }

  void _setInitialPage(User? user) {
    if (user == null) {
      Get.offAll(() => LoginPage());
    } else {
      Get.offAll(() => HomePage());
    }
  }

  Future<void> register(String email, String password) async {
    final error = await AuthService().signUp(email, password);
    if (error != null) {
      Get.snackbar("Signup Failed", error, snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar(
        "SignUp Sucessfully",
        "Welcome $email",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> login(String email, String password) async {
    final error = await AuthService().signIn(email, password);
    if (error != null) {
      Get.snackbar("Login Failed", error, snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar(
        "Login Sucessfully",
        "Welcome back $email",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> logout() async {
    await AuthService().signOut();
  }
}
