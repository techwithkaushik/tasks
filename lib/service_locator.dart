import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:tasks/src/features/tasks/data/datasources/task_firestore_datasource.dart';
import 'package:tasks/src/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:tasks/src/features/tasks/domain/repositories/task_repository.dart';
import 'package:tasks/src/features/tasks/domain/usecases/add_task_use_case.dart';
import 'package:tasks/src/features/tasks/domain/usecases/delete_task_use_case.dart';
import 'package:tasks/src/features/tasks/domain/usecases/update_task_use_case.dart';
import 'package:tasks/src/features/tasks/domain/usecases/watch_task_use_case.dart';
import 'package:tasks/src/features/tasks/presentation/bloc/task_bloc.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // 🔹 External
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

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

  // Firestore
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => TaskFirestoreDataSource());

  sl.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(sl()));
  sl.registerLazySingleton<WatchTaskUseCase>(() => WatchTaskUseCase(sl()));
  sl.registerLazySingleton<AddTaskUseCase>(() => AddTaskUseCase(sl()));
  sl.registerLazySingleton<DeleteTaskUseCase>(() => DeleteTaskUseCase(sl()));
  sl.registerLazySingleton<UpdateTaskUseCase>(() => UpdateTaskUseCase(sl()));

  sl.registerFactory(() => TaskBloc(sl(), sl(), sl(), sl()));
}
