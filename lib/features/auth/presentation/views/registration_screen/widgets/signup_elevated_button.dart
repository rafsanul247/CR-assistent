import 'package:cr_app/core/router/app_router.dart';
import 'package:cr_app/core/common/elevated_button.dart';
import 'package:cr_app/features/auth/presentation/views/registration_screen/controller/registration_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class USignUpButton extends StatelessWidget {
  const USignUpButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final RegistrationController controller = Get.find<RegistrationController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const CircularProgressIndicator();
      }

      return UElevatedButton(
        onPressed: () async {
          if (!Form.of(context).validate()) return;

          final success = await controller.register();

          if (success && context.mounted) {
            AppRouter.go('/main');
          } else if (context.mounted && controller.errorMessage.value.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(controller.errorMessage.value)),
            );
          }
        },
        child: const Text("Sign Up"),
      );
    });
  }
}