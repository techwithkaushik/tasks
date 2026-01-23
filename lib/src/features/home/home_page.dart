/// Home page container that provides navigation management
///
/// Wraps HomeContentPage with NavCubit for tab navigation
/// Handles switching between main pages (Tasks, Settings, About)
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/src/features/home/cubit/nav_cubit.dart';
import 'package:tasks/src/features/home/home_content_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => NavCubit(), child: HomeContentPage());
  }
}
