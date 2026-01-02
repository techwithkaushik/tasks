import 'package:equatable/equatable.dart';

abstract class AppAuthEvent extends Equatable {
  const AppAuthEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when app starts
class AppAuthStarted extends AppAuthEvent {}

/// Fired when auth state may have changed
class AppAuthUserChanged extends AppAuthEvent {}
