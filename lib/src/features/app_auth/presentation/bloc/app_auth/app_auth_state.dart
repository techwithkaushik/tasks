/// States representing authentication status in the application
///
/// These states indicate:
/// - `loading`: Checking authentication status on app startup
/// - `authenticated`: User is logged in and has a valid session
/// - `unauthenticated`: User is logged out or session expired
/// - `error`: An error occurred during authentication
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tasks/src/features/app_auth/domain/entities/user_entity.dart';
import 'package:tasks/src/features/app_auth/presentation/models/auth_form_model.dart';

part 'app_auth_state.freezed.dart';

@Freezed()
sealed class AppAuthState with _$AppAuthState {
  const factory AppAuthState.loading() = _Loading;
  const factory AppAuthState.authenticated(UserEntity user) = _Authenticated;
  const factory AppAuthState.unauthenticated({required AuthFormModel form}) =
      _Unauthenticated;
  const factory AppAuthState.error(String message) = _Error;
}
