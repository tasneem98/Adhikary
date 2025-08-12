import 'package:flutter/material.dart';

import '/app/adhikary_app.dart';
import '/services/local_notifications_service.dart';
import 'core/theme/app_theme.dart';
import 'services/home_widget_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init Home Widget
  await HomeWidgetService.init();

  // Init local notifications
  await LocalNotificationsService.instance.init();

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
