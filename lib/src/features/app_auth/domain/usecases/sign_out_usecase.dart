import 'package:dartz/dartz.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/usecase.dart';
import '../../../../core/errors/auth_failure.dart';
import '../repositories/auth_repository.dart';

class SignOutUseCase extends UseCase<void, NoParams> {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  @override
  Future<Either<AuthFailure, void>> call(NoParams params) {
    return repository.signOut();
  }
}
