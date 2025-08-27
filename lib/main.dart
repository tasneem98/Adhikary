import 'dart:developer' as developer show log;
import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

import '/app.dart';
import '/services/home_widget_service.dart';
import '/services/local_notifications_service.dart';
import '/services/shared_preference_services.dart';
import 'app/lists.dart';

const String periodicZekrTaskName = "com.tmi_group.adhikary.periodicZekrTask";

Future<void> zekrScheduledTask() async {
  developer.log(
    'zekrScheduledTask called at: ${DateTime.now().toHourMinuteSecond12Format}',
  );
  try {
    // Init local notifications
    final LocalNotificationsService notificationsService =
        LocalNotificationsService.instance;

    await notificationsService.init();

    // Init Shared Preferences
    final SharedPreferenceServices shared = SharedPreferenceServices();

    // Init Home Widget
    await HomeWidgetService.init();

    // Get notification status
    final bool enableNotifications = await shared.getBool(
      SharedPreferenceServices.enableNotification,
    );

    // Get a random zekr
    if (AdhkarLists.adhkar.isEmpty) {
      developer.log('Adhkar list is empty');
      return;
    }
    // Random zekr generator
    final Random randomNum = Random();
    final String randomZekr =
        AdhkarLists.adhkar[randomNum.nextInt(AdhkarLists.adhkar.length)];

    // Update Home Widget
    await HomeWidgetService.updateWidget(randomZekr);

    // Send local notification
    if (enableNotifications) {
      await notificationsService.showNotification(body: randomZekr);
    } else {
      developer.log('Notification is disabled');
    }
  } catch (e, stackTrace) {
    developer.log(
      'zekrScheduledTask error: $e',
      error: e,
      stackTrace: stackTrace,
      name: 'Zekr Scheduled Task Error',
    );
  }
}

@pragma("vm:entry-point")
void callbackDispatcher() {
  developer.log('Did it called?');
  Workmanager().executeTask((taskName, inputData) async {
    developer.log(
      'callbackDispatcher called at: ${DateTime.now().toHourMinuteSecond12Format}-Selected task: $taskName',
    );
    switch (taskName) {
      case periodicZekrTaskName:
        await zekrScheduledTask();

        break;
      default:
        developer.log('Task: $taskName not found', name: '$taskName Not Found');
        return Future.value(false);
    }

    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  developer.log(
    'Main function called at ${DateTime.now().toHourMinuteSecond12Format}',
  );

  // Initialize Work Manager
  try {
    await Workmanager().initialize(callbackDispatcher);
  } catch (e, stackTrace) {
    developer.log(
      'WorkManager initialization error: $e',
      error: e,
      stackTrace: stackTrace,
      name: 'WorkManager Initialization Error',
    );
  }

  runApp(const AdhikaryApp());
}

extension DateTimeExtension on DateTime {
  String get toHourMinuteSecond12Format =>
      '${hour > 12 ? (hour - 12).toString().padLeft(2, '0') : hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')} ${hour > 12 ? 'PM' : 'AM'}';
}
