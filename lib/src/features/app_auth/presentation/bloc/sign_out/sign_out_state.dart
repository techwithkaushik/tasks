part of 'sign_out_bloc.dart';

abstract class SignOutState extends Equatable {
  const SignOutState();

  @override
  List<Object?> get props => [];
}

class SignOutInitial extends SignOutState {}

class SignOutLoading extends SignOutState {}

class SignOutSuccess extends SignOutState {}

class SignOutFailure extends SignOutState {
  final String message;

  const SignOutFailure(this.message);

  @override
  List<Object?> get props => [message];
}
