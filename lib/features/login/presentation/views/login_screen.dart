import 'package:cr_app/core/common/divider.dart';
import 'package:cr_app/core/constants/colors.dart';
import 'package:cr_app/core/constants/sizes.dart';
import 'package:cr_app/core/constants/texts.dart';
import 'package:cr_app/core/helpers/device_helpers.dart';
import 'package:cr_app/features/auth/presentation/views/login_screen/controller/login_controller.dart';
import 'package:cr_app/features/login/presentation/views/cr_login_screen.dart';
import 'package:cr_app/features/login/presentation/widgets/cr_login_checkbox.dart';
import 'package:cr_app/features/login/presentation/widgets/email_input_field.dart';
import 'package:cr_app/features/login/presentation/widgets/forget_password_text.dart';
import 'package:cr_app/features/login/presentation/widgets/have_any_account.dart';
import 'package:cr_app/features/login/presentation/widgets/login_elevated_button.dart';
import 'package:cr_app/features/login/presentation/widgets/logo.dart';
import 'package:cr_app/features/login/presentation/widgets/password_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});

  final LoginController _loginController = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  কীবোর্ড আসলেও যেন ডিজাইন পুশ করে উপরে না ভেঙে যায়
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(USizes.md.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40.h),

                  // SECTION 1: TITLE & LOGO
                  ULogo(),
                  SizedBox(height: 12.h),
                  Text(UTexts.appTitle, style: context.tt.headlineMedium),
                  Text("Welcome Back!", style: context.tt.bodySmall),
                  SizedBox(height: 50.h), // Gap between two Section

                  // SECTION 2: INPUT FIELDS

                  // EMAIL INPUT FIELD
                  UEmailField(loginController: _loginController),
                  SizedBox(height: USizes.spaceBtwInputFields.h),

                  // PASSWORD INPUT FIELD
                  UPasswordInputField(loginController: _loginController),
                  4.verticalSpace,

                  //FORGET PASSWORD TEXT
                  UForgetPasswordText(),
                  SizedBox(height: USizes.spaceBtwSections.h),

                  // LOGIN BUTTON
                  LoginElevatedButton(),
                  40.verticalSpace,

                  // Divider
                  UDivider(),
                  30.verticalSpace,

                  // CR Login Checkbox
                  CrLoginCheckbox(),

                  // SECTION 3: FOOTER LINKS
                  UHaveAnyAccount(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
