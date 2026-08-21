import 'package:cr_app/core/constants/colors.dart';
import 'package:cr_app/core/router/app_router.dart';
import 'package:cr_app/features/auth/presentation/views/login_screen/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = Get.put(LoginController());
  }

  @override
  void dispose() {
    Get.delete<LoginController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UColors.dark,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: UColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Iconsax.user_square, color: UColors.primary, size: 64),
                  ),
                  SizedBox(height: 24.h),
                  
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: UColors.textPrimary,
                      fontSize: 28.spMin,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Login to manage your class easily",
                    style: TextStyle(
                      color: UColors.textSecondary,
                      fontSize: 14.spMin,
                    ),
                  ),
                  SizedBox(height: 40.h),

                  _buildTextField(
                    controller: _controller.emailController,
                    hint: "Email Address",
                    icon: Iconsax.sms,
                    validator: _controller.validateEmail,
                  ),
                  SizedBox(height: 16.h),

                  Obx(() => _buildTextField(
                    controller: _controller.passwordController,
                    hint: "Password",
                    icon: Iconsax.lock,
                    isPassword: true,
                    obscureText: _controller.isObscure.value,
                    onSuffixTap: _controller.passwordSwitchToggle,
                    validator: _controller.validatePassword,
                  )),
                  
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text("Forgot Password?", style: TextStyle(color: UColors.primary)),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  Obx(() => SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: _controller.isLoading.value ? null : () async {
                        if (_formKey.currentState!.validate()) {
                          final success = await _controller.login();
                          if (success) {
                            AppRouter.go('/main');
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
                        : const Text("Login", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  )),
                  
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?", style: TextStyle(color: UColors.textSecondary)),
                      TextButton(
                        onPressed: () => AppRouter.push('/register'),
                        child: const Text("Register", style: TextStyle(fontSize: 14, color: UColors.primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onSuffixTap,
    String? Function(String?)? validator,
  }) {
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: UColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: UColors.error, width: 1),
        ),
      ),
    );
  }
}
