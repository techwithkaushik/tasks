import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tasks/controllers/auth_controller.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController().obs();
  TextEditingController passwordController = TextEditingController().obs();

  final RxBool _isLogin = true.obs;
  get isLogin => _isLogin.value;

  final RxnString _emailError = RxnString();
  final RxnString _passwordError = RxnString();

  get emailError => _emailError.value;
  get passwordError => _passwordError.value;

  set emailError(String? s) => _emailError.value = s;
  set passwordError(String? s) => _passwordError.value = s;

  final RxBool _isLoading = false.obs;
  get isLoading => _isLoading.value;
  set isLoading(bool b) => _isLoading.value = b;

  final RxBool _isTerm = false.obs;
  get isTerm => _isTerm.value;
  set isTerm(bool b) => _isTerm.value = b;

  final RxBool _showPassword = false.obs;
  get showPassword => _showPassword.value;

  void checkEmailField() {
    final email = emailController.text.trim();

    emailError = null;

    if (email.isEmpty) {
      emailError = 'Enter email address!';
      return;
    } else if (!GetUtils.isEmail(email)) {
      emailError = 'Enter a valid email!';
      return;
    }
  }

  void checkPasswordField() {
    final password = passwordController.text;

    passwordError = null;

    if (password.isEmpty) {
      passwordError = 'Enter password!';
      return;
    } else if (password.length < 8) {
      passwordError = 'Password must have at least 8 characters!';
      return;
    }
  }

  void togleIsLogin() {
    _isLogin.value = !_isLogin.value;
  }

  void togleShowPassword() {
    _showPassword.value = !_showPassword.value;
  }

  void togleIsTerm(bool value) {
    isTerm = value;
  }

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    isLoading = true;
    if (email.isEmpty ||
        !GetUtils.isEmail(email) ||
        password.isEmpty ||
        password.length < 8) {
      checkEmailField();
      checkPasswordField();
      isLoading = false;
      return;
    }
    await AuthController.instance.login(email, password);
    isLoading = false;
  }

  void signUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    isLoading = true;
    if (email.isEmpty || password.isEmpty || !isTerm) {
      checkEmailField();
      checkPasswordField();
      isLoading = false;
      return;
    }
    await AuthController.instance.register(email, password);
    isLoading = false;
  }
}
