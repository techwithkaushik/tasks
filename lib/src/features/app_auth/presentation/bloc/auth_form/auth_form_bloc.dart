import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasks/src/core/validation/validators.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/reset_password_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_in_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_up_usecase.dart';

part 'auth_form_event.dart';
part 'auth_form_state.dart';

enum AuthMode { signIn, signUp }

class AuthFormBloc extends Bloc<AuthFormEvent, AuthFormState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  AuthFormBloc({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.resetPasswordUseCase,
  }) : super(AuthFormState.initial()) {
    on<AuthModeChanged>(_onModeChanged);
    on<AuthEmailChanged>(_onEmailChanged);
    on<AuthPasswordChanged>(_onPasswordChanged);
    on<AuthConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<AuthSubmitted>(_onSubmitted);
    on<ForgotPasswordSubmitted>(_onForgotPassword);
    on<ObscureTextChanged>(_onObscureTextChanged);
  }

  void _onModeChanged(AuthModeChanged e, Emitter<AuthFormState> emit) {
    emit(
      state.copyWith(
        mode: e.mode,
        confirmPassword: '',
        isConfirmPasswordValid: false,
      ),
    );
  }

  void _onEmailChanged(AuthEmailChanged e, Emitter<AuthFormState> emit) {
    emit(
      state.copyWith(
        email: e.email,
        isEmailValid: Validators.isValidEmail(e.email),
        error: null,
      ),
    );
  }

  void _onPasswordChanged(AuthPasswordChanged e, Emitter<AuthFormState> emit) {
    emit(
      state.copyWith(
        password: e.password,
        isPasswordValid: Validators.isValidPassword(e.password),
        isConfirmPasswordValid: Validators.passwordsMatch(
          e.password,
          state.confirmPassword,
        ),
        error: null,
      ),
    );
  }

  void _onConfirmPasswordChanged(
    AuthConfirmPasswordChanged e,
    Emitter<AuthFormState> emit,
  ) {
    emit(
      state.copyWith(
        confirmPassword: e.confirmPassword,
        isConfirmPasswordValid: Validators.passwordsMatch(
          state.password,
          e.confirmPassword,
        ),
        error: null,
      ),
    );
  }

  void _onObscureTextChanged(
    ObscureTextChanged e,
    Emitter<AuthFormState> emit,
  ) {
    emit(state.copyWith(obscureText: !state.obscureText, error: null));
  }

  Future<void> _onSubmitted(
    AuthSubmitted e,
    Emitter<AuthFormState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(isSubmitting: true, error: null));

    final result = state.mode == AuthMode.signIn
        ? await signInUseCase(
            SignInParams(email: state.email, password: state.password),
          )
        : await signUpUseCase(
            SignUpParams(email: state.email, password: state.password),
          );

    result.fold(
      (f) => emit(state.copyWith(isSubmitting: false, error: f.message)),
      (_) => emit(state.copyWith(isSubmitting: false)),
    );
  }

  Future<void> _onForgotPassword(
    ForgotPasswordSubmitted e,
    Emitter<AuthFormState> emit,
  ) async {
    final result = await resetPasswordUseCase(
      ResetPasswordParams(email: state.email),
    );
    result.fold(
      (f) => emit(state.copyWith(error: f.message)),
      (_) => emit(state.copyWith(passwordResetSent: true)),
    );
  }
}
