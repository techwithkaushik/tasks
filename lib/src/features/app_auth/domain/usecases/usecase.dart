import 'package:dartz/dartz.dart';
import 'package:tasks/src/core/errors/auth_failure.dart';

abstract class UseCase<Result, Params> {
  Future<Either<AuthFailure, Result>> call(Params params);
}

class NoParams {
  const NoParams();
}
