import 'package:cr_app/core/constants/colors.dart';
import 'package:cr_app/features/auth/presentation/manager/controller/auth_controller.dart';
import 'package:cr_app/features/notice/presentation/manager/controller/notice_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class NoticeScreen extends StatelessWidget {
  const NoticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final NoticeController noticeController = Get.put(NoticeController());

    if (authController.isCR) {
      noticeController.fetchMyClassCode();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text("Notices"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              if (authController.isCR)
                _buildClassCodeCard(noticeController),
              
              SizedBox(height: 24.h),
              
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Iconsax.notification_bing, color: Colors.grey.shade800, size: 48),
                      SizedBox(height: 16.h),
                      Text(
                        "No notices yet",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassCodeCard(NoticeController controller) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: UColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.personalcard, color: UColors.primary, size: 20),
              SizedBox(width: 8.w),
              const Text(
                "Your Batch Class Code",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          const Text(
            "Share this code with your students so they can enroll in this batch.",
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
          SizedBox(height: 20.h),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      controller.classCode.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: UColors.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: controller.classCode.value));
                    Get.snackbar("Copied", "Class code copied to clipboard", 
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: UColors.primary,
                      colorText: Colors.white,
                    );
                  },
                  icon: const Icon(Iconsax.copy, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF262626),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.all(12.w),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
