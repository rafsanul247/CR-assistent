import '../../domain/repositories/chat_repository.dart';
import '../../data/data_sources/chat_data_source.dart';

class ChatRepositoryImplement implements ChatRepository {
  final ChatDataSource dataSource;
    ChatRepositoryImplement({required this.dataSource});
}
