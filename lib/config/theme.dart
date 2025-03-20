import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color accentColor = Color(0xFF00D9F5);
  static const Color backgroundColor = Color(0xFF121212);
  static const Color cardColor = Color(0xFF1E1E1E);
  static const Color textColor = Color(0xFFF5F5F5);
  static const Color secondaryTextColor = Color(0xFFB3B3B3);

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      background: backgroundColor,
      surface: cardColor,
      onPrimary: textColor,
      onSecondary: textColor,
      onBackground: textColor,
      onSurface: textColor,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: textColor,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: textColor,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: textColor,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: secondaryTextColor,
        fontSize: 14,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}