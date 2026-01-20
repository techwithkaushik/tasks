import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_auth_event.freezed.dart';

@Freezed()
sealed class AppAuthEvent with _$AppAuthEvent {
  const factory AppAuthEvent.started() = _Started;
  const factory AppAuthEvent.userChanged() = _UserChanged;
}
