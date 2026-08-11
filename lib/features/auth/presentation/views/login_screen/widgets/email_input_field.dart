import 'package:cr_app/core/common/input_text_field.dart';
import 'package:cr_app/features/auth/presentation/views/login_screen/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class UEmailField extends StatelessWidget {
  const UEmailField({
    super.key,
    required LoginController loginController,
  }) : _loginController = loginController;

  final LoginController _loginController;

  @override
  Widget build(BuildContext context) {
    return UTextField(controller: _loginController.emailController,
      labelText: "Email",
      prefixIcon: Icon(LucideIcons.mail),
      validator: _loginController.validateEmail,);
  }
}