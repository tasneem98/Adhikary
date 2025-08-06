import 'package:flutter/material.dart';

import '/app/adhikary_app.dart';
import '/app/home_widget.dart';
import '/consts/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init Home Widget
  await HomeWidgetProvider.init();

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
