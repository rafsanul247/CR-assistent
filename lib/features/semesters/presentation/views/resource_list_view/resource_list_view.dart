import 'package:cr_app/features/auth/presentation/manager/controller/auth_controller.dart';
import 'package:cr_app/features/semesters/presentation/manager/controller/semesters_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

    // Initial trigger after frame rendering
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchResources(subjectId);
    });

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
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
                    return _ResourceCard(
                      resource: controller.resources[index],
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
          onPressed: () => _showUploadBottomSheet(context, controller),
          elevation: 2,
          icon: const Icon(Icons.upload_file_rounded),
          label: const Text("Upload Note"),
        );
      }),
    );
  }

  void _showUploadBottomSheet(
      BuildContext context, SemestersController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _UploadBottomSheet(
        subjectId: subjectId,
        controller: controller,
      ),
    );
  }
}

// Sub-Widget: Individual Resource File Card
class _ResourceCard extends StatelessWidget {
  final dynamic resource;

  const _ResourceCard({required this.resource});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String type = (resource.type ?? '').toLowerCase();

    // Contextual icon and styling based on file type
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
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(iconData, color: iconColor, size: 24),
        ),
        title: Text(
          resource.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            resource.type.toString().toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        trailing: IconButton.filledTonal(
          onPressed: () async {
            final Uri url = Uri.parse(resource.url);
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            } else {
              Get.snackbar(
                'Error',
                'Could not open the file.',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          icon: const Icon(Icons.download_rounded, size: 20),
        ),
      ),
    );
  }
}

// Sub-Widget: Modern Upload Bottom Sheet
class _UploadBottomSheet extends StatelessWidget {
  final int subjectId;
  final SemestersController controller;

  const _UploadBottomSheet({
    required this.subjectId,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleController = TextEditingController();
    final urlController = TextEditingController();

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Upload New Resource",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: "Title",
              hintText: "e.g., Lecture 1 Notes",
              prefixIcon: const Icon(Icons.title_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: urlController,
            decoration: InputDecoration(
              labelText: "File URL",
              hintText: "https://example.com/file.pdf",
              prefixIcon: const Icon(Icons.link_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    urlController.text.isNotEmpty) {
                  controller.uploadResource(
                    subjectId,
                    titleController.text,
                    urlController.text,
                  );
                  Navigator.pop(context);
                }
              },

              child: const Text("Upload"),
            ),
          ),
        ],
      ),
    );
  }
}

// Sub-Widget: Empty State Display
class _EmptyResourcesView extends StatelessWidget {
  const _EmptyResourcesView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_off_outlined,
            size: 64,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            "No Resources Found",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "There are no uploaded files for this subject yet.",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// Sub-Widget: Error State Display
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 56,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}