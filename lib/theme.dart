import 'package:flutter/material.dart';

import 'infrastructure/ui/util/colors.dart';

// ignore: avoid_classes_with_only_static_members
/// Themes used in the panel
abstract class AppTheme {
  /// Get default light theme
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: false,
      primaryColor: AppColors.of(context).primary,
      primarySwatch: Colors.blue,
      colorScheme: ColorScheme.light(
        primary: AppColors.of(context).primary,
        secondary: AppColors.of(context).primary,
        onSecondary: Colors.white,
        error: AppColors.of(context).error,
      ),
      scaffoldBackgroundColor: AppColors.of(context).background,
      dividerColor: AppColors.of(context).primary,
      brightness: Brightness.light,
      cardColor: Colors.white,
      canvasColor: Colors.transparent,
      splashColor: Colors.black12,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
            AppColors.of(context).primary,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.of(context).primary,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.of(context).primary,
        selectionHandleColor: AppColors.of(context).primary,
        selectionColor: AppColors.of(context).primary,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.of(context).primary,
          side: BorderSide(
            color: AppColors.of(context).primary,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.of(context).primary,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.black26),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black,
        contentTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w200,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.of(context).error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.of(context).error,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey.shade400,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.of(context).primary,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}
