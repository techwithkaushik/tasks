part of 'app_auth_bloc.dart';

abstract class AppAuthEvent {}

class AppAuthStarted extends AppAuthEvent {}

class AppAuthEmailChanged extends AppAuthEvent {
  final String email;
  AppAuthEmailChanged(this.email);
}

class AppAuthPasswordChanged extends AppAuthEvent {
  final String password;
  AppAuthPasswordChanged(this.password);
}

class AppAuthConfirmPasswordChanged extends AppAuthEvent {
  final String confirmPassword;
  AppAuthConfirmPasswordChanged(this.confirmPassword);
}

class AppAuthModeToggled extends AppAuthEvent {}

class AppAuthSubmitted extends AppAuthEvent {}

class AppAuthForgotPassword extends AppAuthEvent {}

class AppAuthObscureToggled extends AppAuthEvent {}

class AppAuthSignOutRequested extends AppAuthEvent {}

class AppAuthUserChanged extends AppAuthEvent {
  final UserEntity? user;
  AppAuthUserChanged(this.user);
}
