import 'package:cr_app/core/constants/colors.dart';
import 'package:cr_app/core/router/app_router.dart';
import 'package:cr_app/features/auth/presentation/views/registration_screen/controller/registration_controller.dart';
import 'package:cr_app/features/auth/presentation/views/registration_screen/widgets/cr_registration_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({super.key});

  final RegistrationController _controller = Get.put(RegistrationController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UColors.dark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2, color: Colors.white),
          onPressed: () => AppRouter.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create Account",
                  style: TextStyle(
                    color: UColors.textPrimary,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Join your batch and start collaborating",
                  style: TextStyle(
                    color: UColors.textSecondary,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 32.h),

                // Name
                _buildField("Full Name", Iconsax.user, _controller.usernameController, _controller.usernameValidate),
                SizedBox(height: 16.h),

                // University
                _buildField("University Name", Iconsax.teacher, _controller.universityNameController, _controller.universityValidate),
                SizedBox(height: 16.h),

                // Dept & Batch Row
                Row(
                  children: [
                    Expanded(child: _buildField("Dept.", Iconsax.hierarchy, _controller.deptNameController, _controller.deptValidate)),
                    SizedBox(width: 12.w),
                    Expanded(child: _buildField("Batch", Iconsax.profile_2user, _controller.batchNameController, _controller.batchValidate)),
                  ],
                ),
                SizedBox(height: 16.h),

                // Email
                _buildField("Email Address", Iconsax.sms, _controller.emailController, _controller.emailValidate),
                SizedBox(height: 16.h),

                // Password
                Obx(() => _buildField(
                  "Password", 
                  Iconsax.lock, 
                  _controller.passwordController, 
                  _controller.passwordValidate,
                  isPassword: true,
                  obscureText: _controller.isObscureText.value,
                  onSuffixTap: _controller.passwordToggle,
                )),
                SizedBox(height: 24.h),

                // CR Checkbox
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: UColors.containerDark,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const CrRegistrationCheckbox(),
                ),
                SizedBox(height: 32.h),

                // Submit Button
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: _controller.isLoading.value ? null : () async {
                      if (_formKey.currentState!.validate()) {
                        final bool isCR = Get.find<RegiCheckBoxController>().isSelected.value;
                        if (isCR) {
                          final success = await _controller.register();
                          if (success) AppRouter.go('/main');
                        } else {
                          AppRouter.push('/class-code');
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: UColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: _controller.isLoading.value 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Sign Up", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                )),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String hint, IconData icon, TextEditingController controller, String? Function(String?)? validator, {bool isPassword = false, bool obscureText = false, VoidCallback? onSuffixTap}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: UColors.textSecondary),
        prefixIcon: Icon(icon, color: UColors.primary, size: 20),
        suffixIcon: isPassword 
          ? IconButton(
              icon: Icon(obscureText ? Iconsax.eye_slash : Iconsax.eye, color: UColors.textSecondary, size: 20),
              onPressed: onSuffixTap,
            )
          : null,
        filled: true,
        fillColor: UColors.containerDark,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.transparent)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: UColors.primary, width: 1.5)),
      ),
    );
  }
}
