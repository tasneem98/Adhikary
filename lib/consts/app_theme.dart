import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static Color kGrey800 = Colors.grey.shade800;
  static Color kGrey200 = Colors.grey.shade200;

  static Color kBlack54 = Colors.black54;

  static RoundedRectangleBorder kRoundRectangleBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12.0),
  );

  static ThemeData themeData(double screenWidth) => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey.shade800),
    fontFamily: GoogleFonts.cairo().fontFamily,
    scaffoldBackgroundColor: Colors.white70,
    cardTheme: CardThemeData(
      elevation: 5.0,
      shape: kRoundRectangleBorder,
      color: kGrey200,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(screenWidth * 0.8, 50.0),
        backgroundColor: kBlack54,
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.cairo(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        shape: kRoundRectangleBorder,
      ),
    ),
  );
}
