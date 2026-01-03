import 'package:equatable/equatable.dart';

class AuthFailure extends Equatable {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}
