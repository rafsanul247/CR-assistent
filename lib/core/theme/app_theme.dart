import 'package:cr_app/core/constants/colors.dart';
import 'package:cr_app/core/theme/text_theme.dart';
import 'package:cr_app/core/theme/widgets_theme/appbar_theme.dart';
import 'package:cr_app/core/theme/widgets_theme/botton_sheet_theme.dart';
import 'package:cr_app/core/theme/widgets_theme/checkbox_theme.dart';
import 'package:cr_app/core/theme/widgets_theme/chip_theme.dart';
import 'package:cr_app/core/theme/widgets_theme/elevated_button_theme.dart';
import 'package:cr_app/core/theme/widgets_theme/outlined_button_theme.dart';
import 'package:cr_app/core/theme/widgets_theme/text_field_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


/// Global App Theme Configuration Class
/// Manages Light and Dark themes with consistent Material 3 styling
class AppTheme {
  AppTheme._(); // Private constructor to prevent instantiation

  // =========================================================================
  // ☀️ Light Theme Configuration
  // =========================================================================
  static ThemeData lightTheme(BuildContext context) => ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.inter().fontFamily, // Global font family configuration
    brightness: Brightness.light,
    primaryColor: UColors.primary,
    disabledColor: UColors.grey,
    textTheme: UTextTheme.lightTextTheme(context),
    chipTheme: UChipTheme.lightChipTheme,
    scaffoldBackgroundColor: UColors.light,
    appBarTheme: UAppBarTheme.lightAppBarTheme,
    checkboxTheme: UCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: UBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: UElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: UOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: UTextFormFieldTheme.lightInputDecorationTheme,
  );

  // =========================================================================
  // 🌙 Dark Theme Configuration
  // =========================================================================
  static ThemeData darkTheme(BuildContext context) => ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.inter().fontFamily, // Global font family configuration
    brightness: Brightness.dark,
    primaryColor: UColors.primary,
    disabledColor: UColors.grey,
    textTheme: UTextTheme.darkTextTheme(context),
    chipTheme: UChipTheme.darkChipTheme,
    scaffoldBackgroundColor: UColors.black,
    appBarTheme: UAppBarTheme.darkAppBarTheme,
    checkboxTheme: UCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: UBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: UElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: UOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: UTextFormFieldTheme.darkInputDecorationTheme,
  );

  /// Returns theme mode based on system preferences
  static ThemeMode get systemThemeMode => ThemeMode.system;
}