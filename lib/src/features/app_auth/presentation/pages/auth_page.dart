import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/l10n/app_localizations.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_bloc.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_state.dart';
import 'package:tasks/src/features/app_auth/presentation/pages/sign_in_up_page.dart';
import 'package:tasks/src/features/home/home_page.dart';
import 'package:tasks/src/features/tasks/presentation/bloc/task_bloc.dart';

class AppAuthPage extends StatelessWidget {
  const AppAuthPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppAuthBloc, AppAuthState>(
      builder: (context, state) {
        if (state is AppAuthLoading) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final taskBloc = context.read<TaskBloc>();
        if (state is AppAuthAuthenticated) {
          taskBloc.add(LoadTasksEvent());
          return HomePage();
        }
        if (state is AppAuthUnauthenticated) {
          taskBloc.add(StopTasksEvent());
          return SignInUpPage();
        }
        return Scaffold(
          body: Center(child: Text(AppLocalizations.of(context).error)),
        );
      },
    );
  }
}
