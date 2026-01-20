import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tasks/src/features/app_auth/domain/entities/user_entity.dart';

part 'app_auth_state.freezed.dart';

@Freezed()
sealed class AppAuthState with _$AppAuthState {
  const factory AppAuthState.loading() = _Loading;
  const factory AppAuthState.authenticated(UserEntity user) = _Authenticated;
  const factory AppAuthState.unauthenticated() = _Unauthenticated;
  const factory AppAuthState.error(String message) = _Error;
}
