import 'package:flutter/material.dart';

// import '/apps/overlay_app.dart';
import '/core/theme/app_theme.dart';
import '/screens/home_page.dart';

class AdhikaryApp extends StatelessWidget {
  const AdhikaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      theme: AppTheme.themeData(screenWidth),
      // home: const AzkaryOverlayApp(),
      home: const HomePage(),
    );
  }
}
