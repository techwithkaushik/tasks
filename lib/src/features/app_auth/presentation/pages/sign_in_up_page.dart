import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/service_locator.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/auth_form/auth_form_bloc.dart';

class SignInUpPage extends StatelessWidget {
  const SignInUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authFormBloc = sl<AuthFormBloc>();
    return BlocListener<AuthFormBloc, AuthFormState>(
      bloc: authFormBloc,
      listenWhen: (prev, curr) =>
          prev.error != curr.error ||
          prev.passwordResetSent != curr.passwordResetSent,
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!)));
        }

        if (state.passwordResetSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password reset email sent')),
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: BlocBuilder<AuthFormBloc, AuthFormState>(
            bloc: authFormBloc,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 🔹 Title
                    Text(
                      state.mode == AuthMode.signIn
                          ? 'Welcome Back'
                          : 'Create Account',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 32),
                    // 🔹 Email
                    TextField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (v) => authFormBloc.add(AuthEmailChanged(v)),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        prefixIcon: Icon(Icons.email_outlined),
                        labelText: "Email",
                        errorText: state.email.isEmpty || state.isEmailValid
                            ? null
                            : 'Invalid email',
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 🔹 Password
                    TextField(
                      textInputAction: state.mode == AuthMode.signUp
                          ? TextInputAction.next
                          : TextInputAction.done,
                      obscureText: state.mode == AuthMode.signUp
                          ? true
                          : state.obscureText,
                      onChanged: (v) =>
                          authFormBloc.add(AuthPasswordChanged(v)),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        prefixIcon: Icon(Icons.key_outlined),
                        suffixIcon: state.mode != AuthMode.signUp
                            ? IconButton(
                                icon: Icon(
                                  state.obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  authFormBloc.add(ObscureTextChanged());
                                },
                              )
                            : null,
                        labelText: 'Password',
                        errorText:
                            state.password.isEmpty || state.isPasswordValid
                            ? null
                            : 'Min 6 characters',
                      ),
                    ),
                    state.mode == AuthMode.signUp
                        ? const SizedBox(height: 16)
                        : const SizedBox.shrink(),
                    // 🔹 Confirm Password (SignUp only)
                    state.mode == AuthMode.signUp
                        ? TextField(
                            textInputAction: TextInputAction.done,
                            key: const ValueKey('confirmPassword'),
                            obscureText: state.mode == AuthMode.signUp
                                ? state.obscureText
                                : true,
                            onChanged: (v) =>
                                authFormBloc.add(AuthConfirmPasswordChanged(v)),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              prefixIcon: Icon(Icons.key_outlined),
                              suffixIcon: state.mode == AuthMode.signUp
                                  ? IconButton(
                                      icon: Icon(
                                        state.obscureText
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        authFormBloc.add(ObscureTextChanged());
                                      },
                                    )
                                  : null,
                              labelText: 'Confirm Password',
                              errorText:
                                  state.confirmPassword.isEmpty ||
                                      state.isConfirmPasswordValid
                                  ? null
                                  : 'Passwords do not match',
                            ),
                          )
                        : const SizedBox.shrink(),

                    // 🔹 Forgot password (SignIn only)
                    if (state.mode == AuthMode.signIn)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: state.isEmailValid
                              ? () =>
                                    authFormBloc.add(ForgotPasswordSubmitted())
                              : null,
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),

                    state.mode == AuthMode.signUp
                        ? const SizedBox(height: 16)
                        : const SizedBox.shrink(),

                    // 🔹 Submit button
                    ElevatedButton(
                      onPressed: state.isSubmitting
                          ? null
                          : () => authFormBloc.add(AuthSubmitted()),
                      child: state.isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              state.mode == AuthMode.signIn
                                  ? 'Sign In'
                                  : 'Sign Up',
                            ),
                    ),

                    // 🔹 Switch mode
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.mode == AuthMode.signIn
                              ? "Don't have an account? "
                              : "Already have an account? ",
                        ),
                        TextButton(
                          onPressed: () {
                            authFormBloc.add(
                              AuthModeChanged(
                                state.mode == AuthMode.signIn
                                    ? AuthMode.signUp
                                    : AuthMode.signIn,
                              ),
                            );
                          },
                          child: Text(
                            state.mode == AuthMode.signIn
                                ? "Sign Up"
                                : "Sign In",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
