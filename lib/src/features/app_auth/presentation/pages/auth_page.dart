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
        if (state is AppAuthLoading) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state is AppAuthAuthenticated) {
          return HomePage();
        }
        if (state is AppAuthUnauthenticated) {
          return SignInUpPage();
        }
        return Scaffold(body: Center(child: Text("Error")));
      },
    );
  }
}
