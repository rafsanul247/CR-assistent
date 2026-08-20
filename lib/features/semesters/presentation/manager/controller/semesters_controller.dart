import 'package:get/get.dart';
import '../../../domain/entities/resource_entity.dart';
import '../../../domain/entities/semesters_entity.dart';
import '../../../domain/entities/subject_entity.dart';
import '../../../domain/usecases/semesters_usecase.dart';
import 'package:cr_app/injection.dart';

class SemestersController extends GetxController {
  final SemestersUseCase _useCase = sl<SemestersUseCase>();

  final RxList<SemestersEntity> semesters = <SemestersEntity>[].obs;
  final RxList<SubjectEntity> subjects = <SubjectEntity>[].obs;
  final RxList<ResourceEntity> resources = <ResourceEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  int? currentSemesterId;
  int? currentSubjectId;

  @override
  void onInit() {
    super.onInit();
    fetchSemesters();
  }

  Future<void> fetchSemesters() async {
    isLoading.value = true;
    errorMessage.value = '';
    final result = await _useCase.getSemesters();
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (data) => semesters.assignAll(data),
    );
    isLoading.value = false;
  }

  Future<void> fetchSubjects(int semesterId) async {
    currentSemesterId = semesterId;
    isLoading.value = true;
    errorMessage.value = '';
    final result = await _useCase.getSubjects(semesterId);
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (data) => subjects.assignAll(data),
    );
    isLoading.value = false;
  }

  Future<bool> addSubject(int semesterId, String name) async {
    isLoading.value = true;
    final result = await _useCase.addSubject(semesterId, name);
    bool success = false;
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (newSubject) {
        fetchSubjects(semesterId);
        fetchSemesters();
        success = true;
      },
    );
    isLoading.value = false;
    return success;
  }

  Future<void> fetchResources(int subjectId) async {
    currentSubjectId = subjectId;
    isLoading.value = true;
    errorMessage.value = '';
    final result = await _useCase.getResources(subjectId);
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (data) => resources.assignAll(data),
    );
    isLoading.value = false;
  }

  Future<bool> deleteSubject(int semesterId, int subjectId) async {
    isLoading.value = true;
    final result = await _useCase.deleteSubject(subjectId);
    bool success = false;
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (_) {
        fetchSubjects(semesterId);
        fetchSemesters();
        success = true;
      },
    );
    isLoading.value = false;
    return success;
  }

  Future<bool> uploadResourceFiles({
    required int subjectId,
    required String title,
    required List<String> filePaths,
    required String type,
  }) async {
    isLoading.value = true;
    bool anySuccess = false;
    
    for (String path in filePaths) {
      String finalType = type;
      if (type == 'NOTE') {
        final extension = path.split('.').last.toLowerCase();
        if (['jpg', 'jpeg', 'png', 'webp'].contains(extension)) {
          finalType = 'IMAGE';
        }
      }

      final result = await _useCase.uploadResourceFile(subjectId, title, path, finalType);
      result.fold((_) {}, (_) => anySuccess = true);
    }

    if (anySuccess) {
      fetchResources(subjectId);
      if (currentSemesterId != null) fetchSubjects(currentSemesterId!);
      fetchSemesters();
    }

    isLoading.value = false;
    return anySuccess;
  }

  Future<bool> deleteResource(int subjectId, int resourceId) async {
    isLoading.value = true;
    final result = await _useCase.deleteResource(resourceId);
    bool success = false;
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (_) {
        fetchResources(subjectId);
        if (currentSemesterId != null) fetchSubjects(currentSemesterId!);
        fetchSemesters();
        success = true;
      },
    );
    isLoading.value = false;
    return success;
  }
}
