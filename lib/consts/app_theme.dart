import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static Color grey800 = Colors.grey.shade800;
  static Color grey200 = Colors.grey.shade200;

  static const Color secondaryColor = Color(0xFF1E1E1E);

  static Color black54 = Colors.black54;

  static ThemeData themeData(double screenWidth) => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey.shade800),
    fontFamily: GoogleFonts.cairo().fontFamily,
    cardTheme: CardThemeData(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: grey200,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(screenWidth * 0.8, 50.0),
        backgroundColor: black54,
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.cairo(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    ),
  );
}
