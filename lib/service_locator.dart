import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tasks/src/core/constants/global_constant.dart';
import 'package:tasks/src/features/app_auth/data/datasources/auth_remote_datasource.dart';
import 'package:tasks/src/features/app_auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:tasks/src/features/app_auth/data/repositories/auth_repository_impl.dart';
import 'package:tasks/src/features/app_auth/domain/repositories/auth_repository.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/get_current_user_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/is_email_verified_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/reset_password_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/send_email_verification_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_in_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_out_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_up_usecase.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_bloc.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/auth_form/auth_form_bloc.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/sign_out/sign_out_bloc.dart';
import 'package:tasks/src/features/tasks/data/models/task.dart';
import 'package:tasks/src/features/tasks/presentation/bloc/task_bloc.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // 🔹 External
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<Box<Task>>(
    () => Hive.box<Task>(GlobalConstant.tasksBox),
  );
  sl.registerFactory<TaskBloc>(() => TaskBloc(sl<Box<Task>>()));
  // 🔹 Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  // 🔹 Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // usecases
  sl.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(sl()),
  );
  sl.registerLazySingleton<SignInUseCase>(() => SignInUseCase(sl()));
  sl.registerLazySingleton<SignUpUseCase>(() => SignUpUseCase(sl()));
  sl.registerLazySingleton<SignOutUseCase>(() => SignOutUseCase(sl()));
  sl.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(sl()),
  );
  sl.registerLazySingleton<IsEmailVerifiedUseCase>(
    () => IsEmailVerifiedUseCase(sl()),
  );
  sl.registerLazySingleton<SendEmailVerificationUseCase>(
    () => SendEmailVerificationUseCase(sl()),
  );

  // 🔹 App-level Auth Bloc (GLOBAL)
  sl.registerLazySingleton<AppAuthBloc>(() => AppAuthBloc(sl()));
  sl.registerFactory<AuthFormBloc>(
    () => AuthFormBloc(
      signInUseCase: sl(),
      signUpUseCase: sl(),
      resetPasswordUseCase: sl(),
    ),
  );

  sl.registerFactory<SignOutBloc>(() => SignOutBloc(signOutUseCase: sl()));
}
