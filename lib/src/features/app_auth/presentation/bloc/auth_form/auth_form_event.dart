part of 'auth_form_bloc.dart';

abstract class AuthFormEvent extends Equatable {
  const AuthFormEvent();
  @override
  List<Object?> get props => [];
}

class AuthModeChanged extends AuthFormEvent {
  final AuthMode mode;
  const AuthModeChanged(this.mode);
}

class AuthEmailChanged extends AuthFormEvent {
  final String email;
  const AuthEmailChanged(this.email);
}

class AuthPasswordChanged extends AuthFormEvent {
  final String password;
  const AuthPasswordChanged(this.password);
}

class AuthConfirmPasswordChanged extends AuthFormEvent {
  final String confirmPassword;
  const AuthConfirmPasswordChanged(this.confirmPassword);
}

class AuthSubmitted extends AuthFormEvent {}

class ForgotPasswordSubmitted extends AuthFormEvent {}

class ObscureTextChanged extends AuthFormEvent {}
