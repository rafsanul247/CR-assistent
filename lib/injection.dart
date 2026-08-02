import 'features/settings/data/data_sources/settings_data_source.dart';
import 'features/settings/data/repositories/settings_repository_implement.dart';
import 'features/settings/domain/repositories/settings_repository.dart';
import 'features/settings/domain/usecases/settings_usecase.dart';

import 'features/chat/data/data_sources/chat_data_source.dart';
import 'features/chat/data/repositories/chat_repository_implement.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/domain/usecases/chat_usecase.dart';

import 'features/semesters/data/data_sources/semesters_data_source.dart';
import 'features/semesters/data/repositories/semesters_repository_implement.dart';
import 'features/semesters/domain/repositories/semesters_repository.dart';
import 'features/semesters/domain/usecases/semesters_usecase.dart';

import 'features/home/data/data_sources/home_data_source.dart';
import 'features/home/data/repositories/home_repository_implement.dart';
import 'features/home/domain/repositories/home_repository.dart';
import 'features/home/domain/usecases/home_usecase.dart';

import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _setUpSettings();

  await _setUpChat();

  await _setUpSemesters();

  await _setUpHome();

  // Register your dependencies here.
}

Future<void> _setUpHome() async {  // Repositories
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImplement(dataSource:sl()));

  // Use Cases
  sl.registerLazySingleton(() => HomeUseCase(repository: sl()));

  // Data Sources
  sl.registerLazySingleton<HomeDataSource>(() => HomeDataSourceImplement());
}

Future<void> _setUpSemesters() async {  // Repositories
  sl.registerLazySingleton<SemestersRepository>(() => SemestersRepositoryImplement(dataSource:sl()));

  // Use Cases
  sl.registerLazySingleton(() => SemestersUseCase(repository: sl()));

  // Data Sources
  sl.registerLazySingleton<SemestersDataSource>(() => SemestersDataSourceImplement());
}

Future<void> _setUpChat() async {  // Repositories
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImplement(dataSource:sl()));

  // Use Cases
  sl.registerLazySingleton(() => ChatUseCase(repository: sl()));

  // Data Sources
  sl.registerLazySingleton<ChatDataSource>(() => ChatDataSourceImplement());
}

Future<void> _setUpSettings() async {  // Repositories
  sl.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImplement(dataSource:sl()));

  // Use Cases
  sl.registerLazySingleton(() => SettingsUseCase(repository: sl()));

  // Data Sources
  sl.registerLazySingleton<SettingsDataSource>(() => SettingsDataSourceImplement());
}
