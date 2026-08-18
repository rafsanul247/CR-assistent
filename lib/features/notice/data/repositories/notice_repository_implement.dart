import '../../domain/repositories/notice_repository.dart';
import '../../data/data_sources/notice_data_source.dart';

class NoticeRepositoryImplement implements NoticeRepository {
  final NoticeDataSource dataSource;
    NoticeRepositoryImplement({required this.dataSource});
}
