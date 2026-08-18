import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_flutter/core/utils/common/divider.dart';
import 'package:learn_flutter/core/utils/common/platform_login.dart';
import 'package:learn_flutter/core/utils/constants/sizes.dart';
import 'package:learn_flutter/core/utils/helpers/device_helpers.dart';
import 'package:learn_flutter/features/registration/presentation/manager/controller/registration_controller.dart';
import 'package:learn_flutter/features/registration/presentation/widgets/email_input_Field.dart';
import 'package:learn_flutter/features/registration/presentation/widgets/footer_link.dart';
import 'package:learn_flutter/features/registration/presentation/widgets/full_name_input_field.dart';
import 'package:learn_flutter/features/registration/presentation/widgets/logo_and_title.dart';
import 'package:learn_flutter/features/registration/presentation/widgets/password_input_field.dart';
import 'package:learn_flutter/features/registration/presentation/widgets/signup_elevated_button.dart';

class RegistrationPage extends StatelessWidget {
  RegistrationPage({super.key});

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
                50.verticalSpace,

                // FULL NAME INPUT FIELD
                UFullNameField(),
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

                // PLATFORM LOGIN
                UPlatformLogin(),
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
