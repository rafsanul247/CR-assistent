import 'package:cr_app/core/network/dio_client.dart';
import 'package:cr_app/core/utils/api_endpoint.dart';
import 'package:cr_app/features/auth/domain/usecases/auth_usecase.dart';
import 'package:cr_app/features/notice/data/models/notice_model.dart';
import 'package:cr_app/injection.dart';
import 'package:get/get.dart';

class NoticeController extends GetxController {
  final AuthUseCase _authUseCase = sl<AuthUseCase>();
  final DioClient _dioClient = sl<DioClient>();

  final RxString classCode = ''.obs;
  final RxList<NoticeModel> notices = <NoticeModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotices();
  }

  Future<void> fetchMyClassCode() async {
    final result = await _authUseCase.getMyClassCode();
    result.fold(
      (failure) => null,
      (code) => classCode.value = code,
    );
  }

  Future<void> fetchNotices() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await _dioClient.get(ApiEndpoint.notices);
      final List<dynamic> data = response.data as List<dynamic>;
      notices.assignAll(data.map((json) => NoticeModel.fromJson(json)).toList());
    } catch (e) {
      errorMessage.value = "Failed to fetch notices";
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> postNotice(String title, String description) async {
    isLoading.value = true;
    try {
      await _dioClient.post(
        ApiEndpoint.notices,
        data: {
          'title': title,
          'description': description,
        },
      );
      fetchNotices();
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
