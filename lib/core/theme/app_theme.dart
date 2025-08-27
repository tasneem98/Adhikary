import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static Color kGrey800 = Colors.grey.shade800;
  static Color kGrey200 = Colors.grey.shade200;

  static Color kBlack54 = Colors.black54;

  static RoundedRectangleBorder kRoundRectangleBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12.0),
  );

  static ButtonStyle textButtonStyle = TextButton.styleFrom(
    backgroundColor: Colors.black54,
    foregroundColor: Colors.white,
    shape: kRoundRectangleBorder,
    textStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold),
  );

  static TextStyle kText20Bold = const TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  );
  static TextStyle kText22Bold = const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static ThemeData lightTheme(double screenWidth) => ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey.shade800),
    fontFamily: GoogleFonts.cairo().fontFamily,
    scaffoldBackgroundColor: Colors.white70,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white70,
      centerTitle: true,
      elevation: 0.0,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      elevation: 5.0,
      modalElevation: 5.0,
      showDragHandle: true,
      // backgroundColor: Colors.white70,
      // modalBackgroundColor: Colors.white70,
    ),
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
    dialogTheme: DialogThemeData(
      titleTextStyle: GoogleFonts.cairo(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      elevation: 5.0,
      shadowColor: Colors.grey.shade300,
      shape: kRoundRectangleBorder,
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.black54,
      contentTextStyle: GoogleFonts.cairo(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      elevation: 5.0,
      behavior: SnackBarBehavior.floating,
      shape: ShapeBorder.lerp(
        kRoundRectangleBorder,
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: const BorderSide(width: 2.0),
        ),
        0.5,
      ),
    ),
  );
}
