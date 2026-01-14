import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      scaffoldBackgroundColor: ZayroColors.mainBackground,
      primaryColor: ZayroColors.zayroBlue,
      colorScheme: ColorScheme.light(
        primary: ZayroColors.zayroBlue,
        secondary: ZayroColors.zayroBlue,
      ),
      textTheme: const TextTheme(
        // Updated Flutter 3+ text theme
        bodyLarge: TextStyle(color: ZayroColors.primaryText),    // used for main text
        bodyMedium: TextStyle(color: ZayroColors.secondaryText), // used for secondary text
        titleLarge: TextStyle(color: ZayroColors.primaryText),   // headings
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: ZayroColors.fieldBackground,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: ZayroColors.fieldBorder),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ZayroColors.fieldBorder),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ZayroColors.zayroBlue),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ZayroColors.zayroBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
