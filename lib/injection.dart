import 'features/notice/data/data_sources/notice_data_source.dart';
import 'features/notice/data/repositories/notice_repository_implement.dart';
import 'features/notice/domain/repositories/notice_repository.dart';
import 'features/notice/domain/usecases/notice_usecase.dart';

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
  await _setUpNotice();

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

Future<void> _setUpNotice() async {  // Repositories
  sl.registerLazySingleton<NoticeRepository>(() => NoticeRepositoryImplement(dataSource:sl()));

  // Use Cases
  sl.registerLazySingleton(() => NoticeUseCase(repository: sl()));

  // Data Sources
  sl.registerLazySingleton<NoticeDataSource>(() => NoticeDataSourceImplement());
}
