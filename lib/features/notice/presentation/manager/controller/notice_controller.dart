import 'package:cr_app/features/auth/domain/usecases/auth_usecase.dart';
import 'package:cr_app/injection.dart';
import 'package:get/get.dart';

class NoticeController extends GetxController {
  final AuthUseCase _authUseCase = sl<AuthUseCase>();

  final RxString classCode = ''.obs;
  final RxBool isLoading = false.obs;

  Future<void> fetchMyClassCode() async {
    isLoading.value = true;
    final result = await _authUseCase.getMyClassCode();
    result.fold(
      (failure) => null,
      (code) => classCode.value = code,
    );
    isLoading.value = false;
  }
}
