import 'package:cr_app/features/auth/presentation/manager/controller/auth_controller.dart';
import 'package:cr_app/features/semesters/presentation/manager/controller/semesters_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceListView extends StatelessWidget {
  final int subjectId;
  final String subjectName;

  const ResourceListView({
    super.key,
    required this.subjectId,
    required this.subjectName,
  });

  @override
  Widget build(BuildContext context) {
    final SemestersController controller = Get.find<SemestersController>();
    final AuthController authController = Get.find<AuthController>();
    final theme = Theme.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchResources(subjectId);
    });

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2, color: Colors.white, size: 26),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          subjectName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return _ErrorView(
              message: controller.errorMessage.value,
              onRetry: () => controller.fetchResources(subjectId),
            );
          }

          if (controller.resources.isEmpty) {
            return const _EmptyResourcesView();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Text(
                  "RESOURCE FILES",
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.resources.length,
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final resource = controller.resources[index];
                    return _ResourceCard(
                      resource: resource,
                      isCR: authController.isCR,
                      onDelete: () => _showDeleteResourceConfirm(context, controller, resource.id),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
      floatingActionButton: Obx(() {
        if (!authController.isCR) return const SizedBox.shrink();

        return FloatingActionButton.extended(
          onPressed: () => _showUploadOptions(context, controller),
          elevation: 2,
          icon: const Icon(Icons.upload_file_rounded),
          label: const Text("Add Resource"),
        );
      }),
    );
  }

  void _showDeleteResourceConfirm(BuildContext context, SemestersController controller, int resourceId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Resource"),
        content: const Text("Are you sure you want to delete this file?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              controller.deleteResource(subjectId, resourceId);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showUploadOptions(BuildContext context, SemestersController controller) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Select Upload Type", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text("Upload PDF"),
              onTap: () {
                Navigator.pop(context);
                _showTitleDialog(context, controller, 'PDF');
              },
            ),
            ListTile(
              leading: const Icon(Icons.notes, color: Colors.blue),
              title: const Text("Upload Notes (Multiple Images)"),
              onTap: () {
                Navigator.pop(context);
                _showTitleDialog(context, controller, 'NOTE');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showTitleDialog(BuildContext context, SemestersController controller, String type) {
    final titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Enter ${type == 'PDF' ? 'PDF' : 'Notes'} Title"),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(hintText: "e.g. Lecture 01"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                Navigator.pop(context);
                _pickAndUpload(controller, type, titleController.text);
              }
            },
            child: const Text("Next"),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndUpload(SemestersController controller, String type, String title) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: type == 'PDF' ? FileType.custom : FileType.image,
        allowedExtensions: type == 'PDF' ? ['pdf'] : null,
        allowMultiple: type == 'NOTE', // Allow multiple images for notes
      );

      if (result != null && result.paths.isNotEmpty) {
        final List<String> filePaths = result.paths.whereType<String>().toList();
        controller.uploadResourceFiles(
          subjectId: subjectId,
          title: title,
          filePaths: filePaths,
          type: type,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick files: $e');
    }
  }
}

class _ResourceCard extends StatelessWidget {
  final dynamic resource;
  final bool isCR;
  final VoidCallback onDelete;

  const _ResourceCard({
    required this.resource,
    required this.isCR,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String type = (resource.type ?? '').toLowerCase();

    IconData iconData = Icons.insert_drive_file_rounded;
    Color iconBg = theme.colorScheme.primaryContainer;
    Color iconColor = theme.colorScheme.primary;

    if (type.contains('pdf')) {
      iconData = Icons.picture_as_pdf_rounded;
      iconBg = theme.colorScheme.errorContainer;
      iconColor = theme.colorScheme.error;
    } else if (type.contains('image') || type.contains('jpg') || type.contains('png')) {
      iconData = Icons.image_rounded;
      iconBg = theme.colorScheme.tertiaryContainer;
      iconColor = theme.colorScheme.tertiary;
    }

    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
          child: Icon(iconData, color: iconColor, size: 24),
        ),
        title: Text(resource.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(resource.type.toString().toUpperCase(), style: theme.textTheme.labelSmall),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isCR)
              IconButton(
                icon: const Icon(Iconsax.trash, color: Colors.redAccent, size: 20),
                onPressed: onDelete,
              ),
            IconButton.filledTonal(
              onPressed: () async {
                final Uri url = Uri.parse(resource.url);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              icon: const Icon(Icons.download_rounded, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyResourcesView extends StatelessWidget {
  const _EmptyResourcesView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_off_outlined, size: 64, color: theme.colorScheme.outline),
          const SizedBox(height: 16),
          Text("No Resources Found", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded, size: 56, color: Colors.red),
          Text(message),
          ElevatedButton(onPressed: onRetry, child: const Text("Retry")),
        ],
      ),
    );
  }
}
