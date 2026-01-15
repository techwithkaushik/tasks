import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/service_locator.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/auth_form/auth_form_bloc.dart';
import 'package:tasks/src/features/app_auth/presentation/pages/sign_in_up_content_page.dart';
import 'package:tasks/src/features/settings/settings_page.dart';

class SignInUpPage extends StatelessWidget {
  const SignInUpPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthFormBloc>(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => SettingsPage())),
              icon: Icon(Icons.settings),
            ),
          ],
        ),
        body: SignInUpContentPage(),
      ),
    );
  }
}
