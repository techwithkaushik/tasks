import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/service_locator.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/sign_out/sign_out_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SignOutBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("HomePage"),
          actions: [
            BlocConsumer<SignOutBloc, SignOutState>(
              listener: (context, state) {
                if (state is SignOutFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                return IconButton(
                  onPressed: state is SignOutLoading
                      ? null
                      : () =>
                            context.read<SignOutBloc>().add(SignOutRequested()),
                  icon: state is SignOutLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.logout),
                );
              },
            ),
          ],
        ),
        body: const Center(child: Text("HomePage")),
      ),
    );
  }
}
