import 'package:cr_app/features/auth/presentation/manager/controller/auth_controller.dart';
import 'package:cr_app/features/semesters/presentation/manager/controller/semesters_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResourceListView extends StatefulWidget {
  final int subjectId;
  final String subjectName;

  const ResourceListView({
    super.key,
    required this.subjectId,
    required this.subjectName,
  });

  @override
  State<ResourceListView> createState() => _ResourceListViewState();
}

class _ResourceListViewState extends State<ResourceListView> {
  final SemestersController controller = Get.find<SemestersController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchResources(widget.subjectId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subjectName),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          }

          if (controller.resources.isEmpty) {
            return const Center(child: Text("No resources uploaded for this subject"));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "FILES",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.resources.length,
                  itemBuilder: (context, index) {
                    final resource = controller.resources[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: ListTile(
                        title: Text(resource.title),
                        subtitle: Text(resource.type),
                        leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                        trailing: const Icon(Icons.download),
                        onTap: () {
                          // TODO: Implement file download/view
                          Get.snackbar('Download', 'Downloading ${resource.title}...');
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
      floatingActionButton: Obx(() {
        if (authController.isCR) {
          return FloatingActionButton.extended(
            onPressed: () {
              _showUploadDialog(context);
            },
            label: const Text("Upload Note"),
            icon: const Icon(Icons.upload_file),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  void _showUploadDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController urlController = TextEditingController(); // Simple URL input for now

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Upload New Resource"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: "Title (e.g. Class PDF 1)"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(hintText: "File URL"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && urlController.text.isNotEmpty) {
                controller.uploadResource(
                  widget.subjectId,
                  titleController.text,
                  urlController.text,
                );
                Navigator.pop(context);
              }
            },
            child: const Text("Upload"),
          ),
        ],
      ),
    );
  }
}
