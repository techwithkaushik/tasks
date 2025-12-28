import 'package:dartz/dartz.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/usecase.dart';
import '../../../../core/errors/auth_failure.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserUseCase extends UseCase<UserEntity?, NoParams> {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<AuthFailure, UserEntity?>> call(NoParams params) {
    return repository.getCurrentUser();
  }
}
