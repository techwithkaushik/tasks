import 'package:dartz/dartz.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/usecase.dart';
import '../../../../core/errors/auth_failure.dart';
import '../repositories/auth_repository.dart';

class IsEmailVerifiedUseCase extends UseCase<bool, NoParams> {
  final AuthRepository repository;

  IsEmailVerifiedUseCase(this.repository);

  @override
  Future<Either<AuthFailure, bool>> call(NoParams params) {
    return repository.isEmailVerified();
  }
}
