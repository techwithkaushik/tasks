/// Cubit for managing authentication state across the app
///
/// Listens to Firebase authentication changes and emits:
/// - `loading`: Initial state while checking auth status
/// - `authenticated`: User is logged in
/// - `unauthenticated`: User is logged out
/// - `error`: An error occurred during authentication
///
/// The auth state is available app-wide and used by:
/// - AppAuthPage: Routes to HomePage or SignInPage
/// - TaskBloc: Automatically loads/unloads user's tasks
/// - Other features: Know if user is authenticated
library;

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:tasks/src/core/validation/validators.dart';
import 'package:tasks/src/features/app_auth/domain/entities/user_entity.dart';
import 'package:tasks/src/features/app_auth/domain/repositories/auth_repository.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/reset_password_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_in_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_out_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_up_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/usecase.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_state.dart';
import 'package:tasks/src/features/app_auth/presentation/models/auth_form_model.dart';

part 'app_auth_event.dart';

class AppAuthBloc extends Bloc<AppAuthEvent, AppAuthState> {
  final AuthRepository repository;
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  StreamSubscription<UserEntity?>? _subscription;

  AppAuthBloc({
    required this.repository,
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.resetPasswordUseCase,
  }) : super(AppAuthState.loading()) {
    on<AppAuthStarted>(_onStarted);
    on<AppAuthUserChanged>(_onUserChanged);
    on<AppAuthEmailChanged>(_onEmailChanged);
    on<AppAuthPasswordChanged>(_onPasswordChanged);
    on<AppAuthConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<AppAuthModeToggled>(_onModeToggled);
    on<AppAuthSubmitted>(_onSubmitted);
    on<AppAuthForgotPassword>(_onForgotPassword);
    on<AppAuthObscureToggled>(_onObscureToggled);
    on<AppAuthSignOutRequested>(_onSignOutRequested);

    add(AppAuthStarted());
  }

  Future<void> _onStarted(
    AppAuthStarted event,
    Emitter<AppAuthState> emit,
  ) async {
    // First, check current user so UI doesn't stay on loading
    final currentEither = await repository.getCurrentUser();
    currentEither.fold(
      (_) => emit(AppAuthState.unauthenticated(form: AuthFormModel.initial())),
      (user) {
        if (user == null) {
          emit(AppAuthState.unauthenticated(form: AuthFormModel.initial()));
        } else {
          emit(AppAuthState.authenticated(user));
        }
      },
    );

    // Then start listening to repository auth state changes
    _subscription?.cancel();
    _subscription = repository.authStateChanges().listen((user) {
      // Do not call emit from outside an event handler — dispatch an event
      // that will be handled inside the bloc's event handler.
      add(AppAuthUserChanged(user));
    });
  }

  void _onUserChanged(AppAuthUserChanged event, Emitter<AppAuthState> emit) {
    final user = event.user;
    if (user == null) {
      emit(AppAuthState.unauthenticated(form: AuthFormModel.initial()));
    } else {
      emit(AppAuthState.authenticated(user));
    }
  }

  void _onEmailChanged(AppAuthEmailChanged e, Emitter<AppAuthState> emit) {
    state.whenOrNull(
      unauthenticated: (form) {
        final updated = form.copyWith(
          email: e.email,
          isEmailValid: Validators.isValidEmail(e.email),
          error: null,
        );
        emit(AppAuthState.unauthenticated(form: updated));
      },
    );
  }

  void _onPasswordChanged(
    AppAuthPasswordChanged e,
    Emitter<AppAuthState> emit,
  ) {
    state.whenOrNull(
      unauthenticated: (form) {
        final updated = form.copyWith(
          password: e.password,
          isPasswordValid: Validators.isValidPassword(e.password),
          isConfirmPasswordValid: Validators.passwordsMatch(
            e.password,
            form.confirmPassword,
          ),
          error: null,
        );
        emit(AppAuthState.unauthenticated(form: updated));
      },
    );
  }

  void _onConfirmPasswordChanged(
    AppAuthConfirmPasswordChanged e,
    Emitter<AppAuthState> emit,
  ) {
    state.whenOrNull(
      unauthenticated: (form) {
        final updated = form.copyWith(
          confirmPassword: e.confirmPassword,
          isConfirmPasswordValid: Validators.passwordsMatch(
            form.password,
            e.confirmPassword,
          ),
          error: null,
        );
        emit(AppAuthState.unauthenticated(form: updated));
      },
    );
  }

  void _onModeToggled(AppAuthModeToggled e, Emitter<AppAuthState> emit) {
    state.whenOrNull(
      unauthenticated: (form) {
        final next = form.copyWith(
          mode: form.mode == AuthMode.signIn
              ? AuthMode.signUp
              : AuthMode.signIn,
          confirmPassword: '',
          isConfirmPasswordValid: false,
          error: null,
        );
        emit(AppAuthState.unauthenticated(form: next));
      },
    );
  }

  Future<void> _onSubmitted(
    AppAuthSubmitted e,
    Emitter<AppAuthState> emit,
  ) async {
    final maybeForm = state.maybeWhen(
      unauthenticated: (form) => form,
      orElse: () => null,
    );
    if (maybeForm == null) return;

    final form = maybeForm;
    final isFormValid =
        form.isEmailValid &&
        form.isPasswordValid &&
        (form.mode == AuthMode.signIn || form.isConfirmPasswordValid);
    if (!isFormValid) return;

    emit(
      AppAuthState.unauthenticated(
        form: form.copyWith(isSubmitting: true, error: null),
      ),
    );

    if (form.mode == AuthMode.signIn) {
      final result = await signInUseCase(
        SignInParams(email: form.email, password: form.password),
      );
      result.fold(
        (f) => emit(
          AppAuthState.unauthenticated(
            form: form.copyWith(isSubmitting: false, error: f.message),
          ),
        ),
        (user) => emit(AppAuthState.authenticated(user)),
      );
    } else {
      final result = await signUpUseCase(
        SignUpParams(email: form.email, password: form.password),
      );
      result.fold(
        (f) => emit(
          AppAuthState.unauthenticated(
            form: form.copyWith(isSubmitting: false, error: f.message),
          ),
        ),
        (user) => emit(AppAuthState.authenticated(user)),
      );
    }
  }

  Future<void> _onForgotPassword(
    AppAuthForgotPassword e,
    Emitter<AppAuthState> emit,
  ) async {
    final maybeForm = state.maybeWhen(
      unauthenticated: (form) => form,
      orElse: () => null,
    );
    if (maybeForm == null) return;
    final form = maybeForm;

    final result = await resetPasswordUseCase.call(
      ResetPasswordParams(email: form.email),
    );
    result.fold(
      (f) => emit(
        AppAuthState.unauthenticated(form: form.copyWith(error: f.message)),
      ),
      (_) => emit(
        AppAuthState.unauthenticated(
          form: form.copyWith(passwordResetSent: true),
        ),
      ),
    );
  }

  void _onObscureToggled(AppAuthObscureToggled e, Emitter<AppAuthState> emit) {
    state.whenOrNull(
      unauthenticated: (form) {
        emit(
          AppAuthState.unauthenticated(
            form: form.copyWith(obscureText: !form.obscureText, error: null),
          ),
        );
      },
    );
  }

  Future<void> _onSignOutRequested(
    AppAuthSignOutRequested e,
    Emitter<AppAuthState> emit,
  ) async {
    await signOutUseCase(const NoParams());
    emit(AppAuthState.unauthenticated(form: AuthFormModel.initial()));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
