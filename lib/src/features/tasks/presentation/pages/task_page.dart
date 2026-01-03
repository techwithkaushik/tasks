import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/service_locator.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/sign_out/sign_out_bloc.dart';
import 'package:tasks/src/features/tasks/presentation/pages/taak_add_page.dart';

class TaskPage extends StatelessWidget {
  final String title;
  final bool isCompleted;
  const TaskPage({super.key, required this.title, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    final signOutBloc = sl<SignOutBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (!isCompleted)
            BlocBuilder(
              bloc: signOutBloc,
              builder: (context, state) {
                if (state is SignOutLoading) {
                  return CircularProgressIndicator();
                }
                return IconButton(
                  onPressed: () {
                    signOutBloc.add(SignOutRequested());
                  },
                  icon: Icon(Icons.login),
                );
              },
            ),
        ],
      ),
      body: Center(child: Text("HomePage")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => AddTaskPage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
