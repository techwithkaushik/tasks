import 'package:dartz/dartz.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/usecase.dart';
import '../../../../core/errors/auth_failure.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpParams {
  final String email;
  final String password;

  const SignUpParams({required this.email, required this.password});
}

class SignUpUseCase extends UseCase<UserEntity, SignUpParams> {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  @override
  Future<Either<AuthFailure, UserEntity>> call(SignUpParams params) {
    return repository.register(email: params.email, password: params.password);
  }
}
