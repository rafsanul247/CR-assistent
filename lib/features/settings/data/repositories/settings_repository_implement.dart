import '../../domain/repositories/settings_repository.dart';
import '../../data/data_sources/settings_data_source.dart';

class SettingsRepositoryImplement implements SettingsRepository {
  final SettingsDataSource dataSource;
    SettingsRepositoryImplement({required this.dataSource});
}
