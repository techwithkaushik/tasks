import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String? email;
  final String? name;
  final bool isEmailVerified;

  const UserEntity({
    required this.uid,
    this.email,
    this.name,
    required this.isEmailVerified,
  });

  @override
  List<Object?> get props => [uid, email, name, isEmailVerified];
}
