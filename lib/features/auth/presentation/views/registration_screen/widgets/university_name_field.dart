import 'package:flutter/material.dart';

class UniversityNameField extends StatelessWidget {
  const UniversityNameField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: "University name",
        prefixIcon: Icon(Icons.school_outlined),
      ),
    );
  }
}