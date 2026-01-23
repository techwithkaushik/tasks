import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/l10n/app_localizations.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_bloc.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_state.dart';
import 'package:tasks/src/features/app_auth/presentation/models/auth_form_model.dart';

class SignInUpContentPage extends StatelessWidget {
  const SignInUpContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final authBloc = context.read<AppAuthBloc>();
    return BlocListener<AppAuthBloc, AppAuthState>(
      bloc: authBloc,
      listenWhen: (prev, curr) {
        final prevForm = prev.maybeWhen(
          unauthenticated: (f) => f,
          orElse: () => null,
        );
        final currForm = curr.maybeWhen(
          unauthenticated: (f) => f,
          orElse: () => null,
        );
        return (prevForm?.error != currForm?.error) ||
            (currForm?.passwordResetSent == true);
      },
      listener: (context, state) {
        final form = state.maybeWhen(
          unauthenticated: (f) => f,
          orElse: () => null,
        );
        if (form?.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(form!.error!)));
        }

        if (form?.passwordResetSent == true) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l.passwordResetEmailSent)));
        }
      },
      child: BlocBuilder<AppAuthBloc, AppAuthState>(
        bloc: authBloc,
        builder: (context, state) {
          final form = state.maybeWhen(
            unauthenticated: (f) => f,
            orElse: () => AuthFormModel.initial(),
          );
          return Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 🔹 Title
                Text(
                  form.mode == AuthMode.signIn
                      ? l.welcomeBack
                      : l.createAccount,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 32),
                // 🔹 Email
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (v) => authBloc.add(AppAuthEmailChanged(v)),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: Icon(Icons.email_outlined),
                    labelText: l.email,
                    errorText: form.email.isEmpty || form.isEmailValid
                        ? null
                        : l.invalidEmail,
                  ),
                ),
                const SizedBox(height: 16),
                // 🔹 Password
                TextField(
                  obscureText: form.mode == AuthMode.signUp
                      ? true
                      : form.obscureText,
                  onChanged: (v) => authBloc.add(AppAuthPasswordChanged(v)),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: Icon(Icons.key_outlined),
                    suffixIcon: form.mode != AuthMode.signUp
                        ? IconButton(
                            icon: Icon(
                              form.obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () =>
                                authBloc.add(AppAuthObscureToggled()),
                          )
                        : null,
                    labelText: l.password,
                    errorText: form.password.isEmpty || form.isPasswordValid
                        ? null
                        : l.min6characters,
                  ),
                ),
                form.mode == AuthMode.signUp
                    ? const SizedBox(height: 16)
                    : const SizedBox.shrink(),
                // 🔹 Confirm Password (SignUp only)
                form.mode == AuthMode.signUp
                    ? TextField(
                        obscureText: form.mode == AuthMode.signUp
                            ? form.obscureText
                            : true,
                        onChanged: (v) =>
                            authBloc.add(AppAuthConfirmPasswordChanged(v)),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          prefixIcon: Icon(Icons.key_outlined),
                          suffixIcon: form.mode == AuthMode.signUp
                              ? IconButton(
                                  icon: Icon(
                                    form.obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () =>
                                      authBloc.add(AppAuthObscureToggled()),
                                )
                              : null,
                          labelText: l.confirmPassword,
                          errorText:
                              form.confirmPassword.isEmpty ||
                                  form.isConfirmPasswordValid
                              ? null
                              : l.passwordsDoNotMatch,
                        ),
                      )
                    : const SizedBox.shrink(),

                // 🔹 Forgot password (SignIn only)
                if (form.mode == AuthMode.signIn)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: form.isEmailValid
                          ? () => authBloc.add(AppAuthForgotPassword())
                          : null,
                      child: Text(
                        l.forgotPassword,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),

                form.mode == AuthMode.signUp
                    ? const SizedBox(height: 16)
                    : const SizedBox.shrink(),

                // 🔹 Submit button
                ElevatedButton(
                  onPressed: form.isSubmitting
                      ? null
                      : () => authBloc.add(AppAuthSubmitted()),
                  child: form.isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          form.mode == AuthMode.signIn ? l.signin : l.signup,
                        ),
                ),

                // 🔹 Switch mode
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      form.mode == AuthMode.signIn
                          ? l.dontHaveAnAccount
                          : l.alreadyHaveAnAccount,
                    ),
                    TextButton(
                      onPressed: () {
                        authBloc.add(AppAuthModeToggled());
                      },
                      child: Text(
                        form.mode == AuthMode.signIn ? l.signup : l.signin,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
