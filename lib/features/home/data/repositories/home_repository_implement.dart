import '../../domain/repositories/home_repository.dart';
import '../../data/data_sources/home_data_source.dart';

class HomeRepositoryImplement implements HomeRepository {
  final HomeDataSource dataSource;
    HomeRepositoryImplement({required this.dataSource});
}
