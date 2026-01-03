import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/src/features/app_auth/domain/entities/user_entity.dart';
import 'package:tasks/src/features/app_auth/domain/repositories/auth_repository.dart';

import 'app_auth_state.dart';

class AppAuthBloc extends Cubit<AppAuthState> {
  final AuthRepository repository;
  StreamSubscription<UserEntity?>? _subscription;

  AppAuthBloc(this.repository) : super(AppAuthInitial()) {
    _subscription = repository.authStateChanges().listen(_onUserChanged);
  }

  void _onUserChanged(UserEntity? user) {
    emit(AppAuthLoading());
    if (user == null) {
      emit(AppAuthUnauthenticated());
    } else {
      emit(AppAuthAuthenticated(user));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
