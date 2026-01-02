part of 'auth_form_bloc.dart';

class AuthFormState extends Equatable {
  final AuthMode mode;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isConfirmPasswordValid;
  final bool isSubmitting;
  final String? error;
  final bool passwordResetSent;
  final bool obscureText;

  const AuthFormState({
    required this.mode,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.isEmailValid,
    required this.isPasswordValid,
    required this.isConfirmPasswordValid,
    required this.isSubmitting,
    this.error,
    required this.passwordResetSent,
    required this.obscureText,
  });

  factory AuthFormState.initial() => const AuthFormState(
    mode: AuthMode.signIn,
    email: '',
    password: '',
    confirmPassword: '',
    isEmailValid: false,
    isPasswordValid: false,
    isConfirmPasswordValid: false,
    isSubmitting: false,
    passwordResetSent: false,
    obscureText: true,
  );

  bool get isFormValid =>
      isEmailValid &&
      isPasswordValid &&
      (mode == AuthMode.signIn || isConfirmPasswordValid);

  AuthFormState copyWith({
    AuthMode? mode,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isConfirmPasswordValid,
    bool? isSubmitting,
    String? error,
    bool? passwordResetSent,
    bool? obscureText,
  }) {
    return AuthFormState(
      mode: mode ?? this.mode,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isConfirmPasswordValid:
          isConfirmPasswordValid ?? this.isConfirmPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
      passwordResetSent: passwordResetSent ?? this.passwordResetSent,
      obscureText: obscureText ?? this.obscureText,
    );
  }

  @override
  List<Object?> get props => [
    mode,
    email,
    password,
    confirmPassword,
    isEmailValid,
    isPasswordValid,
    isConfirmPasswordValid,
    isSubmitting,
    error,
    passwordResetSent,
    obscureText,
  ];
}
