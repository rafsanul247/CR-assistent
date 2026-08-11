import 'package:cr_app/core/router/app_router.dart';
import 'package:cr_app/features/auth/presentation/manager/controller/auth_controller.dart';
import 'package:cr_app/features/semesters/presentation/manager/controller/semesters_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SubjectListView extends StatefulWidget {
  final int semesterId;
  final String semesterName;

  const SubjectListView({
    super.key,
    required this.semesterId,
    required this.semesterName,
  });

  @override
  State<SubjectListView> createState() => _SubjectListViewState();
}

class _SubjectListViewState extends State<SubjectListView> {
  final SemestersController controller = Get.find<SemestersController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchSubjects(widget.semesterId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.semesterName)),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
        
        if (controller.errorMessage.isNotEmpty) {
           return Center(child: Text(controller.errorMessage.value));
        }

        if (controller.subjects.isEmpty) return const Center(child: Text("No subjects found"));

        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          itemCount: controller.subjects.length,
          itemBuilder: (context, index) {
            final subject = controller.subjects[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
              child: ListTile(
                onTap: () => AppRouter.push('/resources', extra: {
                  'subjectId': subject.id,
                  'subjectName': subject.name,
                }),
                title: Text(subject.name),
                subtitle: Text("${subject.resourceCount ?? 0} resources"),
                leading: const Icon(Icons.menu_book),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            );
          },
        );
      }),
      floatingActionButton: Obx(() {
        if (authController.isCR) {
          return FloatingActionButton.extended(
            onPressed: () => _showAddSubjectDialog(context),
            label: const Text("Add Subject"),
            icon: const Icon(Icons.add),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  void _showAddSubjectDialog(BuildContext context) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Subject"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: "Subject Name"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                controller.addSubject(widget.semesterId, nameController.text);
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
