import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF3EEF7C),
        secondary: Color(0xFF55EE8B),
        surface: Color(0xFF0D1B13),
        error: Color(0xFFFF6B6B),
      ),
      scaffoldBackgroundColor: const Color(0xFF09110C),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0D1B13),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFFD6E1D8)),
        titleTextStyle: TextStyle(
          color: Color(0xFFE4ECE5),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF13261B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF294834)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF294834)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3EEF7C), width: 1.5),
        ),
        labelStyle: const TextStyle(color: Color(0xFF8DA494)),
        hintStyle: const TextStyle(color: Color(0xFF5A7563)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3EEF7C),
          foregroundColor: const Color(0xFF06200D),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF0D1B13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFF1C3826), width: 1),
        ),
        elevation: 2,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(0xFF3EEF7C),
      ),
    );
  }
}
