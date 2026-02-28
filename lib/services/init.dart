import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:indhostels/bloc/auth/auth_bloc.dart';
import 'package:indhostels/data/repo/authrepo.dart';
import 'package:indhostels/services/apiservice/api_client.dart';
import 'package:indhostels/services/apiservice/client.dart';
import 'package:indhostels/services/database/app_secure_storage.dart';

final sl = GetIt.instance;

Future<void> setup() async {
  // DioClient
  sl.registerLazySingleton<DioClient>(() => DioClient());
  // Dio
  sl.registerLazySingleton(() => sl<DioClient>().dio);
  // ApiClient
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));
  // Secure Storage
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton<AppSecureStorage>(() => AppSecureStorage(sl()));
// Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(sl()));
  // Bloc (Factory because UI state)
  sl.registerFactory<AuthBloc>(() => AuthBloc(sl()));
}
