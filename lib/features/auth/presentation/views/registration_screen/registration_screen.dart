import 'package:cr_app/core/common/divider.dart';
import 'package:cr_app/core/constants/sizes.dart';
import 'package:cr_app/core/helpers/device_helpers.dart';
import 'package:cr_app/features/auth/presentation/views/registration_screen/controller/registration_controller.dart';
import 'package:cr_app/features/auth/presentation/views/registration_screen/widgets/cr_registration_checkbox.dart';
import 'package:cr_app/features/auth/presentation/views/registration_screen/widgets/dept_and_batch.dart';
import 'package:cr_app/features/auth/presentation/views/registration_screen/widgets/email_input_Field.dart';
import 'package:cr_app/features/auth/presentation/views/registration_screen/widgets/footer_link.dart';
import 'package:cr_app/features/auth/presentation/views/registration_screen/widgets/full_name_input_field.dart';
import 'package:cr_app/features/auth/presentation/views/registration_screen/widgets/logo_and_title.dart';
import 'package:cr_app/features/auth/presentation/views/registration_screen/widgets/password_input_field.dart';
import 'package:cr_app/features/auth/presentation/views/registration_screen/widgets/signup_elevated_button.dart';
import 'package:cr_app/features/auth/presentation/views/registration_screen/widgets/university_name_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({super.key});

  final RegistrationController _registrationController = Get.put(
    RegistrationController(),
  );
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: USizes.md.w, vertical: USizes.sm),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                // LOGO AND TITLE
                ULogoAndTitle(),
                40.verticalSpace,

                // REGISTRATION TITLE AND SUBTITLE
                Text("Registration", style: context.tt.headlineMedium),
                4.verticalSpace,
                Text("Create a new account", style: context.tt.bodySmall),
                Text("For Students!", style: context.tt.bodySmall),
                50.verticalSpace,

                // FULL NAME INPUT FIELD
                UFullNameField(),
                16.verticalSpace,

                // University name field
                UniversityNameField(),
                16.verticalSpace,

                DeptAndBatch(),
                16.verticalSpace,

                // EMAIL INPUT FIELD
                UEmailFieldRegistration(
                  registrationController: _registrationController,
                ),
                16.verticalSpace,

                // PASSWORD INPUT FIELD
                UPasswordFieldRegistration(
                  registrationController: _registrationController,
                ),
                4.verticalSpace,

                // CREATE A STRONG PASSWORD TEXT
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Create a strong password!",
                    style: context.tt.bodySmall,
                  ),
                ),
                32.verticalSpace,

                // SIGN UP BUTTON
                USignUpButton(),
                40.verticalSpace,

                // DIVIDER
                UDivider(),
                30.verticalSpace,

                // CR Registration Checkbox
                CrRegistrationCheckbox(),
                20.verticalSpace,

                // FOOTER LINK
                UFooterLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




