import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/api_endpoint.dart';
import '../models/resource_model.dart';
import '../models/semesters_model.dart';
import '../models/subject_model.dart';

abstract class SemestersDataSource {
  Future<List<SemestersModel>> getSemesters();
  Future<List<SubjectModel>> getSubjects(int semesterId);
  Future<SubjectModel> addSubject(int semesterId, String name);
  Future<List<ResourceModel>> getResources(int subjectId);
  Future<void> uploadResource(int subjectId, {required String title, required String fileUrl});
}

class SemestersDataSourceImplement implements SemestersDataSource {
  final DioClient dioClient;

  SemestersDataSourceImplement({required this.dioClient});

  @override
  Future<List<SemestersModel>> getSemesters() async {
    try {
      final response = await dioClient.get(ApiEndpoint.semesters);
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => SemestersModel.fromJson(json)).toList();
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<List<SubjectModel>> getSubjects(int semesterId) async {
    try {
      final response = await dioClient.get(ApiEndpoint.subjects(semesterId));
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => SubjectModel.fromJson(json)).toList();
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<SubjectModel> addSubject(int semesterId, String name) async {
    try {
      final response = await dioClient.post(
        ApiEndpoint.addSubject(semesterId),
        data: {'name': name},
      );
      return SubjectModel.fromJson(response.data);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<List<ResourceModel>> getResources(int subjectId) async {
    try {
      final response = await dioClient.get(ApiEndpoint.resources(subjectId));
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => ResourceModel.fromJson(json)).toList();
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<void> uploadResource(int subjectId, {required String title, required String fileUrl}) async {
    try {
      await dioClient.post(
        ApiEndpoint.uploadResource(subjectId),
        data: {
          'title': title,
          'fileUrl': fileUrl,
          'type': 'PDF',
        },
      );
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }
}
