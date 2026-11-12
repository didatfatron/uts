
import 'package:flutter/material.dart';

class AppTheme {
  static const Color navy = Color(0xFF142B45);
  static const Color mint = Color(0xFF72E0B0);
  static const Color background = Color(0xFFF4F7F8);
  static const Color white = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF263746);
  static const Color textGrey = Color(0xFF84919C);
  static const Color expense = Color(0xFFE57373);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: navy,
      primary: navy,
      secondary: mint,
      surface: white,
    ),
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      foregroundColor: navy,
      elevation: 0,
      centerTitle: false,
    ),
  );
}
