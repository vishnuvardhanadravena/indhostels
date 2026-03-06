import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:indhostels/bloc/accommodation/accommodation_bloc.dart';
import 'package:indhostels/bloc/auth/auth_bloc.dart';
import 'package:indhostels/bloc/profile/profile_bloc.dart';
import 'package:indhostels/data/repo/accomodation_repo.dart';
import 'package:indhostels/data/repo/authrepo.dart';
import 'package:indhostels/data/repo/profile_repo.dart';
import 'package:indhostels/services/apiservice/api_client.dart';
import 'package:indhostels/services/apiservice/client.dart';
import 'package:indhostels/services/database/app_secure_storage.dart';

final sl = GetIt.instance;

Future<void> setup() async {
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton<AppSecureStorage>(() => AppSecureStorage(sl()));
  // ── Core services ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<DioClient>(() => DioClient(sl<AppSecureStorage>()));
  sl.registerLazySingleton(() => sl<DioClient>().dio);
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));

  // ── Storage ────────────────────────────────────────────────────────────────

  // ── Repositories ───────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(sl()));
  sl.registerLazySingleton<AccommodationRepository>(
    () => AccommodationRepository(sl()),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepository(sl<ApiClient>()),
  );
  // // ── Blocs ──────────────────────────────────────────────────────────────────
  sl.registerFactory<AuthBloc>(() => AuthBloc(sl()));
  sl.registerFactory<AccommodationBloc>(() => AccommodationBloc(sl()));
  sl.registerFactory<ProfileBloc>(() => ProfileBloc(sl()));
}
