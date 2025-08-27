import 'package:flutter/material.dart';

import '/app/home_page.dart';
import '/core/theme/app_theme.dart';

class AdhikaryApp extends StatelessWidget {
  const AdhikaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      theme: AppTheme.themeData(screenWidth),
      // home: const TestWidget(),
      home: const HomePage(),
    );
  }
}
