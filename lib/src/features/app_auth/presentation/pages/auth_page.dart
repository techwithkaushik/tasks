/// Authentication router that switches between login and home screens
///
/// Routes based on AppAuthBloc state:
/// - `loading`: Shows loading spinner
/// - `authenticated`: Shows HomePage with task list
/// - `unauthenticated`: Shows SignInUpPage for login/signup
/// - `error`: Shows error message
///
/// Entry point of the authenticated user experience
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_bloc.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_state.dart';
import 'package:tasks/src/features/app_auth/presentation/pages/sign_in_up_page.dart';
import 'package:tasks/src/features/home/home_page.dart';

class AppAuthPage extends StatelessWidget {
  const AppAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppAuthBloc, AppAuthState>(
      builder: (context, state) {
        return state.when(
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          authenticated: (_) => const HomePage(),
          unauthenticated: (form) => const SignInUpPage(),
          error: (_) => const Scaffold(body: Center(child: Text("Error"))),
        );
      },
    );
  }
}
