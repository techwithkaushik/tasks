import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks/controllers/login_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 150),
              Text(
                loginController.isLogin
                    ? "Welcome back to Tasks"
                    : "Wecome to Tasks",
                style: Theme.of(context).textTheme.headlineLarge,
              ),

              SizedBox(height: 40),
              Obx(
                () => TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: loginController.emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    label: Text("Email"),
                    hintText: "enter email address",
                    errorText: loginController.emailError,
                  ),
                  onChanged: (value) => loginController.checkEmailField(),
                ),
              ),
              SizedBox(height: 10),
              Obx(
                () => TextFormField(
                  obscureText: !loginController.showPassword,
                  controller: loginController.passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    label: Text("Password"),
                    hintText: "enter password",
                    errorText: loginController.passwordError,
                    suffixIcon: IconButton(
                      onPressed: () => loginController.togleShowPassword(),
                      icon: Icon(
                        loginController.showPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  onChanged: (value) => loginController.checkPasswordField(),
                ),
              ),
              SizedBox(height: 20),
              Obx(
                () => !loginController.isLogin
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            isError: !loginController.isTerm,
                            value: loginController.isTerm,
                            onChanged: (value) =>
                                loginController.togleIsTerm(value!),
                          ),
                          Text("Term and conditions"),
                        ],
                      )
                    : SizedBox(height: 0),
              ),
              Obx(
                () => OutlinedButton(
                  onPressed: () {
                    loginController.isLogin
                        ? loginController.login()
                        : loginController.signUp();
                  },
                  child: loginController.isLoading
                      ? SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                      : Text(loginController.isLogin ? "Login" : "SignUp"),
                ),
              ),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      loginController.isLogin
                          ? "dont have an account?"
                          : "already have account?",
                    ),
                    TextButton(
                      onPressed: () {
                        loginController.togleIsLogin();
                      },
                      child: Text(loginController.isLogin ? "SignUp" : "Login"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
