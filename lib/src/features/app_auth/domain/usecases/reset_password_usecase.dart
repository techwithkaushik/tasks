import 'package:dartz/dartz.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/usecase.dart';
import '../../../../core/errors/auth_failure.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordParams {
  final String email;

  const ResetPasswordParams({required this.email});
}

class ResetPasswordUseCase extends UseCase<void, ResetPasswordParams> {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  @override
  Future<Either<AuthFailure, void>> call(ResetPasswordParams params) {
    return repository.resetPassword(email: params.email);
  }
}
