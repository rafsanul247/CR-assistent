import '../../domain/repositories/semesters_repository.dart';
import '../../data/data_sources/semesters_data_source.dart';

class SemestersRepositoryImplement implements SemestersRepository {
  final SemestersDataSource dataSource;
    SemestersRepositoryImplement({required this.dataSource});
}
