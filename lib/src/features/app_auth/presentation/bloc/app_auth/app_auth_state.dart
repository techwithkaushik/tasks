import 'package:equatable/equatable.dart';
import 'package:tasks/src/features/app_auth/domain/entities/user_entity.dart';

abstract class AppAuthState extends Equatable {
  const AppAuthState();

  @override
  List<Object?> get props => [];
}

class AppAuthInitial extends AppAuthState {}

class AppAuthLoading extends AppAuthState {}

class AppAuthAuthenticated extends AppAuthState {
  final UserEntity user;

  const AppAuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AppAuthUnauthenticated extends AppAuthState {}
