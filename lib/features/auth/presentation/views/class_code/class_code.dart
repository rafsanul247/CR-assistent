import 'package:cr_app/core/constants/colors.dart';
import 'package:cr_app/core/router/app_router.dart';
import 'package:cr_app/features/auth/presentation/views/registration_screen/controller/registration_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ClassCode extends StatelessWidget {
  const ClassCode({super.key});

  @override
  Widget build(BuildContext context) {
    final RegistrationController controller = Get.find<RegistrationController>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: UColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Iconsax.key, color: UColors.primary, size: 32),
              ),
              SizedBox(height: 24.h),
              Text(
                "Enter Class Code",
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Please enter the unique code provided by your CR to join your batch.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade400,
                ),
              ),
              SizedBox(height: 40.h),
              
              TextField(
                controller: controller.classCodeController,
                autofocus: true,
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 8),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "######",
                  hintStyle: TextStyle(color: Colors.grey.shade800),
                  filled: true,
                  fillColor: const Color(0xFF141414),
                  contentPadding: EdgeInsets.symmetric(vertical: 20.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade900),
                  ),
                ),
              ),
              
              const Spacer(),
              
              Obx(() => controller.isLoading.value 
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (controller.classCodeController.text.length < 4) {
                          Get.snackbar("Error", "Please enter a valid class code");
                          return;
                        }
                        final success = await controller.register();
                        if (success) {
                          AppRouter.go('/main');
                        } else if (controller.errorMessage.value.isNotEmpty) {
                          Get.snackbar("Error", controller.errorMessage.value);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: UColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text("Join Batch & Sign Up", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  )
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
