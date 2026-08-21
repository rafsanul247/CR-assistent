import 'dart:ui';

import 'package:cr_app/core/constants/colors.dart';
import 'package:cr_app/core/storage/storage_service.dart';
import 'package:cr_app/core/theme/widgets_theme/elevated_button_theme.dart';
import 'package:cr_app/core/theme/widgets_theme/outlined_button_theme.dart';
import 'package:cr_app/core/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

// Data Model
class SettingsItemModel {
  final String title;
  final String? subtitle;
  final IconData icon;
  final String? route;
  final VoidCallback? onTap;
  final bool isDestructive;

  const SettingsItemModel({
    required this.title,
    required this.icon,
    this.subtitle,
    this.route,
    this.onTap,
    this.isDestructive = false,
  });
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UColors.dark,
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            const _UserProfileCard(),
            const SizedBox(height: 24),
            _SettingsGroup(
              title: "Account & Preferences",
              items: [
                const SettingsItemModel(
                  title: "Profile",
                  subtitle: "Edit personal information and photo",
                  icon: Iconsax.user_square,
                  route: '/profile',
                ),
                const SettingsItemModel(
                  title: "Notifications",
                  subtitle: "Manage reminders and class alerts",
                  icon: Iconsax.notification,
                  route: '/notice',
                ),
                const SettingsItemModel(
                  title: "Class & Semester",
                  subtitle: "Manage active academic courses",
                  icon: Iconsax.teacher,
                  route: '/main',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SettingsGroup(
              title: "System & Info",
              items: [
                const SettingsItemModel(
                  title: "About CR Assistant",
                  subtitle: "App version and release notes",
                  icon: Iconsax.info_circle,
                  route: '/about',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SettingsGroup(
              title: "Session",
              items: [
                SettingsItemModel(
                  title: "Log Out",
                  subtitle: "Sign out of your account on this device",
                  icon: Iconsax.logout,
                  isDestructive: true,
                  onTap: () => _showLogoutDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Logout',
      barrierColor: Colors.black.withValues(alpha: 0.6), // Dim Background
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) => const SizedBox(),
      transitionBuilder: (context, anim1, anim2, child) {
        // Smooth Scale + Fade Animation
        return Transform.scale(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack).value,
          child: Opacity(
            opacity: anim1.value,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), // Glass Effect
              child: Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                insetPadding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: UColors.containerDark.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: UColors.error.withValues(alpha: 0.15),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Modern Glowing Icon Wrapper
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: UColors.error.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: UColors.error.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.logout_rounded,
                          color: UColors.error,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Title
                      const Text(
                        "Log Out",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Description
                      const Text(
                        "Are you sure you want to log out from your account?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: UColors.textSecondary,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Modern Actions (Buttons Side by Side)
                      Row(
                        children: [
                          // Cancel Button
                          Expanded(
                            child: OutlinedButton(
                              style: UOutlinedButtonTheme.radius12(context),
                              // style: OutlinedButton.styleFrom(
                              //   padding: const EdgeInsets.symmetric(vertical: 14),
                              //   side: BorderSide(
                              //     color: Colors.white.withValues(alpha: 0.15),
                              //   ),
                              //   shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(8),
                              //   ),
                              // ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Confirm Logout Button (Filled Gradient / Solid)
                          Expanded(
                            child: ElevatedButton(
                              style: UElevatedButtonTheme.radius12(context),
                              // style: ElevatedButton.styleFrom(
                              //   padding: const EdgeInsets.symmetric(vertical: 14),
                              //   backgroundColor: UColors.error,
                              //   elevation: 4,
                              //   shadowColor: UColors.error.withValues(alpha: 0.4),
                              //   shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(8),
                              //   ),
                              // ),
                              onPressed: () async {
                                Navigator.pop(context);
                                await StorageService.delete(Constants.keyAuthToken);
                                await StorageService.delete(Constants.keyUserRole);
                                await StorageService.delete(Constants.keyUserId);
                                if (context.mounted) {
                                  context.go('/');
                                }
                              },
                              child: const Text(
                                "Log Out",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _UserProfileCard extends StatelessWidget {
  const _UserProfileCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: UColors.containerDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: UColors.borderDark.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: UColors.primary.withValues(alpha: 0.1),
            child: const Icon(
              Iconsax.user,
              size: 32,
              color: UColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Student Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Class Representative Assistant",
                  style: TextStyle(
                    color: UColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<SettingsItemModel> items;

  const _SettingsGroup({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: UColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 11,
              letterSpacing: 1.1,
            ),
          ),
        ),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: UColors.containerDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: UColors.borderDark.withValues(alpha: 0.5),
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              indent: 56,
              color: UColors.borderDark.withValues(alpha: 0.3),
            ),
            itemBuilder: (context, index) {
              return _SettingsTile(item: items[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final SettingsItemModel item;

  const _SettingsTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final activeColor = item.isDestructive
        ? UColors.error
        : Colors.white;

    final iconBgColor = item.isDestructive
        ? UColors.error.withValues(alpha: 0.1)
        : UColors.dark.withValues(alpha: 0.5);

    final iconColor = item.isDestructive
        ? UColors.error
        : UColors.primary;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconBgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(item.icon, color: iconColor, size: 22),
      ),
      title: Text(
        item.title,
        style: TextStyle(
          color: activeColor,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: item.subtitle != null
          ? Text(
        item.subtitle!,
        style: const TextStyle(
          color: UColors.textSecondary,
          fontSize: 12,
        ),
      )
          : null,
      trailing: const Icon(
        Iconsax.arrow_right_3,
        size: 18,
        color: UColors.textSecondary,
      ),
      onTap: () {
        if (item.onTap != null) {
          item.onTap!();
        } else if (item.route != null) {
          context.push(item.route!);
        }
      },
    );
  }
}
