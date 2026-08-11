import 'package:cr_app/core/storage/storage_service.dart';
import 'package:cr_app/core/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Model class to represent each settings item
class SettingsItemModel {
  final String title;
  final IconData icon;
  final String? route;
  final VoidCallback? onTap;
  final bool isDestructive; // Used for actions like Logout or Delete

  SettingsItemModel({
    required this.title,
    required this.icon,
    this.route,
    this.onTap,
    this.isDestructive = false,
  });
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // List of settings options with their respective titles, icons, and routes/actions
    final List<SettingsItemModel> settingsItems = [
      SettingsItemModel(
        title: "Profile",
        icon: Icons.person_outline,
        route: '/profile', // Your GoRouter route name
      ),
      SettingsItemModel(
        title: "Notifications",
        icon: Icons.notifications_outlined,
        route: '/notifications',
      ),
      SettingsItemModel(
        title: "Class & Semester",
        icon: Icons.class_outlined,
        route: '/semesters',
      ),
      SettingsItemModel(
        title: "About CR Assistant",
        icon: Icons.info_outline,
        route: '/about',
      ),
      SettingsItemModel(
        title: "Log Out",
        icon: Icons.logout,
        isDestructive: true,
        onTap: () {
          // Trigger logout confirmation dialog
          _showLogoutDialog(context);
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: settingsItems.length,
          itemBuilder: (context, index) {
            final item = settingsItems[index];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: ListTile(
                leading: Icon(
                  item.icon,
                  color: item.isDestructive ? Colors.red : null,
                ),
                title: Text(
                  item.title,
                  style: TextStyle(
                    color: item.isDestructive ? Colors.red : null,
                    fontWeight: item.isDestructive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Smart navigation handler
                  if (item.onTap != null) {
                    item.onTap!();
                  } else if (item.route != null) {
                    context.push(item.route!); // Or use AppRouter.push(item.route!)
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }

  // Show confirmation dialog before logging out
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Log Out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              // Delete auth token using StorageService
              await StorageService.delete(Constants.keyAuthToken);

              // Check if context is still mounted after async storage operation
              if (context.mounted) {
                context.go('/');
              }
            },
            child: const Text("Log Out", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}