import '../../domain/repositories/registration_repository.dart';
import '../../data/data_sources/registration_data_source.dart';

class RegistrationRepositoryImplement implements RegistrationRepository {
  final RegistrationDataSource dataSource;
    RegistrationRepositoryImplement({required this.dataSource});
}
