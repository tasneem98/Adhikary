import 'package:flutter/material.dart';

import '/app/adhikary_app.dart';
import '/consts/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      theme: AppTheme.themeData(screenWidth),
      home: const AdhikaryApp(),
    );
  }
}
