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
        subjects.add(newSubject);
        fetchSemesters(); // Refresh counts on home
      },
    );
    isLoading.value = false;
  }

  Future<void> fetchResources(int subjectId) async {
    isLoading.value = true;
    errorMessage.value = '';
    final result = await _useCase.getResources(subjectId);
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (data) => resources.assignAll(data),
    );
    isLoading.value = false;
  }

  Future<void> uploadResource(int subjectId, String title, String fileUrl) async {
    isLoading.value = true;
    final result = await _useCase.uploadResource(subjectId, title, fileUrl);
    result.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (_) {
        fetchResources(subjectId);
        fetchSemesters(); // Sync global counts
      },
    );
    isLoading.value = false;
  }
}
