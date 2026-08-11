import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:cr_app/core/network/dio_client.dart';
import 'package:cr_app/core/network/network_info.dart';

// Auth Feature
import 'package:cr_app/features/auth/data/data_sources/auth_data_source.dart';
import 'package:cr_app/features/auth/data/repositories/auth_repository_implement.dart';
import 'package:cr_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:cr_app/features/auth/domain/usecases/auth_usecase.dart';
import 'package:cr_app/features/auth/presentation/manager/controller/auth_controller.dart';

// Semesters Feature
import 'package:cr_app/features/semesters/data/data_sources/semesters_data_source.dart';
import 'package:cr_app/features/semesters/data/repositories/semesters_repository_implement.dart';
import 'package:cr_app/features/semesters/domain/repositories/semesters_repository.dart';
import 'package:cr_app/features/semesters/domain/usecases/semesters_usecase.dart';
import 'package:cr_app/features/semesters/presentation/manager/controller/semesters_controller.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => DioClient());
  sl.registerLazySingleton(() => NetworkInfo(sl()));

  // Auth Feature
  sl.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImplement(dioClient: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImplement(
      dataSource: sl(),
      networkInfo: sl(),
      dioClient: sl(),
    ),
  );
  sl.registerLazySingleton(() => AuthUseCase(repository: sl()));
  sl.registerLazySingleton(() => AuthController());

  // Semesters Feature
  sl.registerLazySingleton<SemestersDataSource>(
    () => SemestersDataSourceImplement(dioClient: sl()),
  );
  sl.registerLazySingleton<SemestersRepository>(
    () => SemestersRepositoryImplement(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton(() => SemestersUseCase(repository: sl()));
  sl.registerLazySingleton(() => SemestersController());
}
