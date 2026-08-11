import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class UFullNameField extends StatelessWidget {
  const UFullNameField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: "Full Name",
        prefixIcon: Icon(LucideIcons.user),
      ),
    );
  }
}