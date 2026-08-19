import 'package:cr_app/features/auth/presentation/manager/controller/auth_controller.dart';
import 'package:cr_app/features/auth/presentation/views/registration_screen/widgets/cr_registration_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cr_app/injection.dart';
import 'package:cr_app/features/auth/domain/usecases/auth_usecase.dart';

class RegistrationController extends GetxController {
  final AuthUseCase _authUseCase = sl<AuthUseCase>();

  // ------------------ Text controllers ------------------
  final usernameController = TextEditingController();
  final universityNameController = TextEditingController();
  final deptNameController = TextEditingController();
  final batchNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final classCodeController = TextEditingController();

  var isObscureText = true.obs;

  // ------------------ Reactive state for API call ------------------
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // ------------------ Validators ------------------
  String? usernameValidate(String? value) {
    if (value == null || value.isEmpty) return "Please enter your full name!";
    return null;
  }

  String? universityValidate(String? value) {
    if (value == null || value.isEmpty) return "Please enter your university name!";
    return null;
  }

  String? deptValidate(String? value) {
    if (value == null || value.isEmpty) return "Please enter your department!";
    return null;
  }

  String? batchValidate(String? value) {
    if (value == null || value.isEmpty) return "Please enter your batch!";
    return null;
  }

  String? emailValidate(String? value) {
    if (value == null || value.isEmpty) return "Please enter your Email!";
    if (!GetUtils.isEmail(value)) return "Enter a valid Email";
    return null;
  }

  String? passwordValidate(String? value) {
    if (value == null || value.isEmpty) return "Please enter a password!";
    if (value.length < 6) return "Password must be at least 6 characters long";
    return null;
  }

  void passwordToggle() => isObscureText.value = !isObscureText.value;

  // ------------------ API call ------------------
  Future<bool> register() async {
    isLoading.value = true;
    errorMessage.value = '';

    final bool isCR = Get.find<RegiCheckBoxController>().isSelected.value;

    final result = await _authUseCase.register(
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      universityName: universityNameController.text.trim(),
      deptName: deptNameController.text.trim(),
      batchName: batchNameController.text.trim(),
      isCR: isCR,
      classCode: isCR ? null : classCodeController.text.trim(),
    );

    bool success = false;
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (user) {
        if (sl.isRegistered<AuthController>()) {
          sl<AuthController>().user.value = user;
        }
        success = true;
      },
    );

    isLoading.value = false;
    return success;
  }

  @override
  void onClose() {
    usernameController.dispose();
    universityNameController.dispose();
    deptNameController.dispose();
    batchNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    classCodeController.dispose();
    super.onClose();
  }
}
