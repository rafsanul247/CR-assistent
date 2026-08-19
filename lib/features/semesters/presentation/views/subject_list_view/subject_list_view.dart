import 'package:cr_app/core/router/app_router.dart';
import 'package:cr_app/features/auth/presentation/manager/controller/auth_controller.dart';
import 'package:cr_app/features/semesters/presentation/manager/controller/semesters_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

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

  static const List<Color> _accentColors = [
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFFEC4899),
    Color(0xFF06B6D4),
  ];

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
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2, color: Colors.white, size: 26),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.semesterName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF3B82F6), strokeWidth: 2.5),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return _buildErrorState(controller.errorMessage.value);
        }

        if (controller.subjects.isEmpty) return const _EmptyState();

        return ListView.builder(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 90.h),
          itemCount: controller.subjects.length,
          itemBuilder: (context, index) {
            final subject = controller.subjects[index];
            final color = _accentColors[index % _accentColors.length];
            return _SubjectCard(
              name: subject.name,
              resourceCount: subject.resourceCount ?? 0,
              accentColor: color,
              isCR: authController.isCR,
              onDelete: () => _showDeleteConfirmDialog(subject.id),
              onTap: () => AppRouter.push('/resources', extra: {
                'subjectId': subject.id,
                'subjectName': subject.name,
              }),
            );
          },
        );
      }),
      floatingActionButton: Obx(() {
        if (authController.isCR) {
          return FloatingActionButton.extended(
            onPressed: () => _showAddSubjectDialog(context),
            backgroundColor: const Color(0xFF3B82F6),
            foregroundColor: Colors.white,
            elevation: 0,
            icon: const Icon(Iconsax.add, size: 20),
            label: const Text(
              "Add Subject",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  void _showDeleteConfirmDialog(int subjectId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF141414),
        title: const Text("Delete Subject", style: TextStyle(color: Colors.white)),
        content: const Text("Are you sure you want to delete this subject? All resources under it will be lost.", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              controller.deleteSubject(widget.semesterId, subjectId);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.warning_2, color: Color(0xFFEF4444), size: 32),
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 14.spMin),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSubjectDialog(BuildContext context) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF141414),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: const Color(0xFF262626)),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add Subject",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: nameController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Subject name",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: const Color(0xFF0A0A0A),
                  contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF262626)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF262626)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF3B82F6)),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text("Cancel", style: TextStyle(color: Colors.grey.shade400)),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameController.text.isNotEmpty) {
                          controller.addSubject(widget.semesterId, nameController.text);
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Add", style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final String name;
  final int resourceCount;
  final Color accentColor;
  final bool isCR;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const _SubjectCard({
    required this.name,
    required this.resourceCount,
    required this.accentColor,
    required this.isCR,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          splashColor: accentColor.withValues(alpha: 0.08),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF262626)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [accentColor, accentColor.withValues(alpha: 0.6)],
                    ),
                  ),
                  child: const Icon(Iconsax.book_saved, color: Colors.white, size: 22),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "$resourceCount resources",
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCR)
                  IconButton(
                    icon: const Icon(Iconsax.trash, color: Colors.redAccent, size: 20),
                    onPressed: onDelete,
                  ),
                Icon(Iconsax.arrow_right_3, color: Colors.grey.shade600, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF262626)),
            ),
            child: Icon(Iconsax.document, color: Colors.grey.shade600, size: 36),
          ),
          SizedBox(height: 16.h),
          Text(
            "No subjects found",
            style: TextStyle(color: Colors.grey.shade400, fontSize: 15.spMin, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
