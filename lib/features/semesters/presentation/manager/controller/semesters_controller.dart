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

  // Track current context for real-time refreshes
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

  Future<void> addSubject(int semesterId, String name) async {
    isLoading.value = true;
    final result = await _useCase.addSubject(semesterId, name);
    result.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (newSubject) {
        fetchSubjects(semesterId); // Refresh subjects list to include new one and updated counts
        fetchSemesters(); // Refresh semesters counts on home
      },
    );
    isLoading.value = false;
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

  Future<void> deleteSubject(int semesterId, int subjectId) async {
    isLoading.value = true;
    final result = await _useCase.deleteSubject(subjectId);
    result.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (_) {
        fetchSubjects(semesterId);
        fetchSemesters();
        Get.snackbar('Success', 'Subject deleted successfully');
      },
    );
    isLoading.value = false;
  }

  Future<void> uploadResourceFiles({
    required int subjectId,
    required String title,
    required List<String> filePaths,
    required String type,
  }) async {
    isLoading.value = true;
    
    int successCount = 0;
    for (String path in filePaths) {
      String finalType = type;
      if (type == 'NOTE') {
        final extension = path.split('.').last.toLowerCase();
        if (['jpg', 'jpeg', 'png', 'webp'].contains(extension)) {
          finalType = 'IMAGE';
        }
      }

      final result = await _useCase.uploadResourceFile(subjectId, title, path, finalType);
      result.fold(
        (failure) => Get.snackbar('Upload Failed', '${path.split('/').last}: ${failure.message}'),
        (_) => successCount++,
      );
    }

    if (successCount > 0) {
      fetchResources(subjectId);
      // Refresh subjects list if we have currentSemesterId to update resource count badge
      if (currentSemesterId != null) {
        fetchSubjects(currentSemesterId!);
      }
      fetchSemesters();
      Get.snackbar('Success', '$successCount file(s) uploaded successfully');
    }

    isLoading.value = false;
  }

  Future<void> deleteResource(int subjectId, int resourceId) async {
    isLoading.value = true;
    final result = await _useCase.deleteResource(resourceId);
    result.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (_) {
        fetchResources(subjectId);
        // Refresh subjects list if we have currentSemesterId to update resource count badge
        if (currentSemesterId != null) {
          fetchSubjects(currentSemesterId!);
        }
        fetchSemesters();
        Get.snackbar('Success', 'Resource deleted successfully');
      },
    );
    isLoading.value = false;
  }
}
