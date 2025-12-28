import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String email;
  final String? name;
  final bool isEmailVerified;

  const UserModel({
    required this.id,
    required this.email,
    this.name,
    required this.isEmailVerified,
  });

  /// 🔹 From Firebase
  factory UserModel.fromFirebase(User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName,
      isEmailVerified: user.emailVerified,
    );
  }

  /// 🔹 Convert to Domain Entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      isEmailVerified: isEmailVerified,
    );
  }
}
