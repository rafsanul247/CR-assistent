// Single button radius

// import 'package:flutter/material.dart';
// import 'package:turf_book/core/utils/constants/colors.dart';
// import 'package:turf_book/core/utils/constants/sizes.dart';
//
//
// class UElevatedButtonTheme {
//   UElevatedButtonTheme._();
//
//
//
//   static final lightElevatedButtonTheme  = ElevatedButtonThemeData(
//     style: ElevatedButton.styleFrom(
//       elevation: 0,
//       foregroundColor: UColors.light,
//       backgroundColor: UColors.primary,
//       disabledForegroundColor: UColors.darkGrey,
//       disabledBackgroundColor: UColors.buttonDisabled,
//       side: const BorderSide(color: UColors.light),
//       padding: EdgeInsets.symmetric(vertical: USizes.buttonHeight),
//       textStyle: const TextStyle(fontSize: 16, color: UColors.textWhite, fontWeight: FontWeight.w700),
//       // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(USizes.buttonRadius)),
//     ),
//   );
//
//
//   static final darkElevatedButtonTheme = ElevatedButtonThemeData(
//     style: ElevatedButton.styleFrom(
//       elevation: 0,
//       foregroundColor: UColors.light,
//       backgroundColor: UColors.primary,
//       disabledForegroundColor: UColors.darkGrey,
//       disabledBackgroundColor: UColors.darkerGrey,
//       side: const BorderSide(color: UColors.primary),
//       padding: EdgeInsets.symmetric(vertical: USizes.buttonHeight),
//       textStyle: const TextStyle(fontSize: 16, color: UColors.textWhite, fontWeight: FontWeight.w600),
//       // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(USizes.buttonRadius)),
//     ),
//   );
// }

// double border radius button
import 'package:cr_app/core/constants/colors.dart';
import 'package:cr_app/core/constants/sizes.dart';
import 'package:flutter/material.dart';

class UElevatedButtonTheme {
  UElevatedButtonTheme._();

  //  Light Theme Button
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: UColors.light,
      backgroundColor: UColors.primary,
      disabledForegroundColor: UColors.darkGrey,
      disabledBackgroundColor: UColors.buttonDisabled,
      side: const BorderSide(color: UColors.light),
      padding: EdgeInsets.symmetric(vertical: USizes.buttonHeight),
      textStyle: const TextStyle(fontSize: 16, color: UColors.textWhite, fontWeight: FontWeight.w700),
    ),
  );


  //  Dark Theme Button
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: UColors.light,
      backgroundColor: UColors.primary,
      disabledForegroundColor: UColors.darkGrey,
      disabledBackgroundColor: UColors.darkerGrey,
      side: const BorderSide(color: UColors.primary),
      padding: EdgeInsets.symmetric(vertical: USizes.buttonHeight),
      textStyle: const TextStyle(fontSize: 16, color: UColors.textWhite, fontWeight: FontWeight.w600),
    ),
  );


  // Theme-Aware Custom Modifications (Overriding Radius Dynamically)

  /// Returns the current global theme style with an overridden border radius of 12
  static ButtonStyle radius12(BuildContext context) {
    return Theme.of(context).elevatedButtonTheme.style!.copyWith(
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),        // Use: UElevatedButtonTheme.radius12(context)
      ),
    );
  }

  /// Returns the current global theme style with an overridden border radius of 48
  static ButtonStyle radius48(BuildContext context) {
    return Theme.of(context).elevatedButtonTheme.style!.copyWith(
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(48)),        // Use : UElevatedButtonTheme.radius48(context)
      ),
    );
  }
}