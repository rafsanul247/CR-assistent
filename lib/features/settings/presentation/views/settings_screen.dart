import 'package:cr_app/core/storage/storage_service.dart';
import 'package:cr_app/core/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
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
                SettingsItemModel(
                  title: "Profile",
                  subtitle: "Edit personal information and photo",
                  icon: Icons.person_outline_rounded,
                  route: '/profile',
                ),
                SettingsItemModel(
                  title: "Notifications",
                  subtitle: "Manage reminders and class alerts",
                  icon: Icons.notifications_none_rounded,
                  route: '/notifications',
                ),
                SettingsItemModel(
                  title: "Class & Semester",
                  subtitle: "Manage active academic courses",
                  icon: Icons.class_outlined,
                  route: '/semesters',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SettingsGroup(
              title: "System & Info",
              items: [
                SettingsItemModel(
                  title: "About CR Assistant",
                  subtitle: "App version and release notes",
                  icon: Icons.info_outline_rounded,
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
                  icon: Icons.logout_rounded,
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
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text("Log Out"),
        content: const Text("Are you sure you want to log out of your session?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            onPressed: () async {
              Navigator.pop(context);
              await StorageService.delete(Constants.keyAuthToken);
              if (context.mounted) {
                context.go('/');
              }
            },
            child: const Text("Log Out"),
          ),
        ],
      ),
    );
  }
}

// Custom Sub-Widget: Header Profile Card
class _UserProfileCard extends StatelessWidget {
  const _UserProfileCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Icon(
              Icons.person,
              size: 32,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Student Profile",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Class Representative Assistant",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
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

// Custom Sub-Widget: Grouped Container
class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<SettingsItemModel> items;

  const _SettingsGroup({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
        ),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              indent: 56,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
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

// Custom Sub-Widget: Individual Tile
class _SettingsTile extends StatelessWidget {
  final SettingsItemModel item;

  const _SettingsTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final activeColor = item.isDestructive
        ? theme.colorScheme.error
        : theme.colorScheme.onSurface;

    final iconBgColor = item.isDestructive
        ? theme.colorScheme.errorContainer.withValues(alpha: 0.4)
        : theme.colorScheme.surfaceContainerHigh;

    final iconColor = item.isDestructive
        ? theme.colorScheme.error
        : theme.colorScheme.primary;

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
        style: TextStyle(
          color: theme.colorScheme.onSurfaceVariant,
          fontSize: 12,
        ),
      )
          : null,
      trailing: Icon(
        Icons.chevron_right_rounded,
        size: 20,
        color: theme.colorScheme.onSurfaceVariant,
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