import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────
//  BRAND COLORS  (IndHostel — primary #4633BD)
// ─────────────────────────────────────────────────────────
class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF3D3BF3);
  static const Color primaryLight = Color(0xFF6554D6);
  static const Color primaryDark = Color(0xFF3225A0);
  static const Color primaryFaded = Color(0xFFEEECFB);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF1A1A2E);
  static const Color background = Color(0xFFF7F8FF);
  static const Color surface = Color(0xFFFFFFFF);

  // Text
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textGrey = Color(0xFF6B7280);
  static const Color textLight = Color(0xFFADB5BD);

  // Input
  static const Color inputBg = Color(0xFFF5F6FA);
  static const Color inputBorder = Color(0xFFE8EAF0);
  static const Color divider = Color(0xFFD1D5DB);

  // Feedback
  static const Color error = Color(0xFFE53E3E);
  static const Color success = Color(0xFF38A169);
}

// ─────────────────────────────────────────────────────────
//  APP THEME
// ─────────────────────────────────────────────────────────
class AppTheme {
  AppTheme._();

  /// 🌞 LIGHT THEME
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: AppColors.background,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      surface: AppColors.surface,
      error: AppColors.error,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.textDark,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        disabledBackgroundColor: AppColors.primaryLight,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(double.infinity, 52),
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textDark,
        side: const BorderSide(color: AppColors.inputBorder, width: 1.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(double.infinity, 52),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.inputBorder, width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.inputBorder, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error, width: 1.2),
      ),
      hintStyle: const TextStyle(
        color: AppColors.textLight,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected)
            ? AppColors.primary
            : Colors.transparent,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      side: const BorderSide(color: AppColors.divider, width: 1.5),
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: AppColors.textDark,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w800,
      ),
      headlineLarge: TextStyle(
        color: AppColors.textDark,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w800,
      ),
      headlineMedium: TextStyle(
        color: AppColors.textDark,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(
        color: AppColors.textDark,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: AppColors.textDark,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: AppColors.textDark,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textGrey,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        color: AppColors.textLight,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        color: AppColors.white,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
        fontSize: 15,
      ),
    ),

    iconTheme: const IconThemeData(color: AppColors.textDark),
    dividerColor: AppColors.inputBorder,
  );

  /// 🌙 DARK THEME
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: const Color(0xFF0F0E1A),

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primaryLight,
      surface: const Color(0xFF1A1930),
      error: AppColors.error,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.white,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(double.infinity, 52),
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: AppColors.white,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w800,
      ),
      headlineLarge: TextStyle(
        color: AppColors.white,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w800,
      ),
      headlineMedium: TextStyle(
        color: AppColors.white,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(
        color: AppColors.white,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(color: AppColors.white, fontFamily: 'Inter'),
      bodyMedium: TextStyle(color: Color(0xFFADB5BD), fontFamily: 'Inter'),
      bodySmall: TextStyle(color: Color(0xFF6B7280), fontFamily: 'Inter'),
    ),

    iconTheme: const IconThemeData(color: AppColors.white),
    dividerColor: const Color(0xFF2D2B45),
  );
}
