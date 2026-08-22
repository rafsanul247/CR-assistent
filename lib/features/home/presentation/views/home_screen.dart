import 'package:cr_app/core/constants/colors.dart';
import 'package:cr_app/core/router/app_router.dart';
import 'package:cr_app/features/auth/presentation/manager/controller/auth_controller.dart';
import 'package:cr_app/features/semesters/presentation/manager/controller/semesters_controller.dart';
import 'package:cr_app/injection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<Color> _accentColors = [
    Color(0xFF3B82F6), // blue
    Color(0xFF8B5CF6), // violet
    Color(0xFF10B981), // emerald
    Color(0xFFF59E0B), // amber
    Color(0xFFEC4899), // pink
    Color(0xFF06B6D4), // cyan
  ];

  @override
  Widget build(BuildContext context) {
    final SemestersController controller = Get.put(sl<SemestersController>());
    final AuthController authController = Get.put(sl<AuthController>());

    return Scaffold(
      backgroundColor: UColors.dark,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildHeader(context, authController),
            Obx(() {
              if (controller.isLoading.value) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: UColors.primary,
                      strokeWidth: 2.5,
                    ),
                  ),
                );
              }

              if (controller.errorMessage.isNotEmpty) {
                return SliverFillRemaining(
                  child: _buildErrorState(controller.errorMessage.value),
                );
              }

              if (controller.semesters.isEmpty) {
                return const SliverFillRemaining(child: _EmptyState());
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final semester = controller.semesters[index];
                      final accentColor = _accentColors[index % _accentColors.length];
                      return _SemesterCard(
                        name: semester.name,
                        subjectCount: semester.subjectCount ?? 0,
                        accentColor: accentColor,
                        onTap: () => AppRouter.push(
                          '/subjects',
                          extra: {
                            'semesterId': semester.id,
                            'semesterName': semester.name,
                          },
                        ),
                      );
                    },
                    childCount: controller.semesters.length,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AuthController authController) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "CR Assistant",
                    style: TextStyle(
                      color: UColors.textPrimary,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Your semesters",
                    style: TextStyle(
                      color: UColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: UColors.containerDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: UColors.borderDark),
              ),
              child: IconButton(
                onPressed: () {
                  AppRouter.push('/notice');
                },
                icon: const Icon(
                  Iconsax.notification,
                  color: UColors.textPrimary,
                  size: 22,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: UColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.warning_2, color: UColors.error, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: UColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _SemesterCard extends StatelessWidget {
  final String name;
  final int subjectCount;
  final Color accentColor;
  final VoidCallback onTap;

  const _SemesterCard({
    required this.name,
    required this.subjectCount,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: UColors.containerDark,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: UColors.borderDark),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Iconsax.book_1, color: UColors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: UColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$subjectCount subjects",
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Iconsax.arrow_right_3, color: UColors.textSecondary, size: 18),
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
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: UColors.containerDark,
              shape: BoxShape.circle,
              border: Border.all(color: UColors.borderDark),
            ),
            child: const Icon(Iconsax.document, color: UColors.textSecondary, size: 36),
          ),
          const SizedBox(height: 16),
          const Text(
            "No semesters found",
            style: TextStyle(color: UColors.textSecondary, fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
