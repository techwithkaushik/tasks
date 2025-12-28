import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasks/src/features/app_auth/data/datasources/auth_remote_datasource.dart';
import 'package:tasks/src/features/app_auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:tasks/src/features/app_auth/data/repositories/auth_repository_impl.dart';
import 'package:tasks/src/features/app_auth/domain/repositories/auth_repository.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth_bloc.dart';

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

  // 🔹 App-level Auth Bloc (GLOBAL)
  sl.registerLazySingleton<AppAuthBloc>(() => AppAuthBloc(sl()));
}
