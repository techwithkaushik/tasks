import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';

class UserModel {
  final String uid;
  final String email;
  final String? name;
  final bool isEmailVerified;

  const UserModel({
    required this.uid,
    required this.email,
    this.name,
    required this.isEmailVerified,
  });

  /// 🔹 From Firebase
  factory UserModel.fromFirebase(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      name: user.displayName,
      isEmailVerified: user.emailVerified,
    );
  }

  /// 🔹 Convert to Domain Entity
  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      name: name,
      isEmailVerified: isEmailVerified,
    );
  }
}
