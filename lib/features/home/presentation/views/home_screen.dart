import 'package:cr_app/core/utils/formatters.dart';
import 'package:cr_app/core/router/app_router.dart';
import 'package:cr_app/features/auth/presentation/manager/controller/auth_controller.dart';
import 'package:cr_app/features/semesters/presentation/manager/controller/semesters_controller.dart';
import 'package:cr_app/injection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controllers from GetIt
    final SemestersController controller = Get.put(sl<SemestersController>());
    final AuthController authController = Get.put(sl<AuthController>());

    return Scaffold(
      appBar: AppBar(
        title: const Text("CR Assistant"),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          }

          if (controller.semesters.isEmpty) {
            return const Center(child: Text("No semesters found"));
          }

          return ListView.builder(
            itemCount: controller.semesters.length,
            itemBuilder: (context, index) {
              final semester = controller.semesters[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ListTile(
                  onTap: () {
                    AppRouter.push(
                      '/subjects',
                      extra: {
                        'semesterId': semester.id,
                        'semesterName': semester.name,
                      },
                    );
                  },
                  title: Text(semester.name),
                  leading: const Icon(Icons.book),
                  subtitle: Text("${semester.subjectCount ?? 0} subjects"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
