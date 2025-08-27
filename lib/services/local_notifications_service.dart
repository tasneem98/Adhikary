import 'dart:developer' as developer show log;

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../consts/app_data.dart';

class LocalNotificationsService {
  // Local notifications Instance
  LocalNotificationsService._internal();

  static final LocalNotificationsService _instance =
      LocalNotificationsService._internal();

  static LocalNotificationsService get instance => _instance;

  // Local notifications Plugin
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  // Initialize local notifications
  Future<void> init() async {
    if (_isInitialized) {
      return;
    }

    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    // iOS initialization settings
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
        );

    // Initialization settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    // Initialize local notifications
    final bool didInitialize =
        await _notifications.initialize(initializationSettings) ?? false;

    if (didInitialize) {
      _isInitialized = true;
      // You could add some logging here if needed:
      developer.log('LocalNotificationsService initialized successfully.');
    } else {
      // Handle initialization failure if necessary
      developer.log('LocalNotificationsService failed to initialize.');
    }
  }

  // Notification details
  static NotificationDetails notificationDetails() => NotificationDetails(
    android: AndroidNotificationDetails(
      'channel_id',
      AppData.appName,
      channelDescription: 'Main notifications channel for ${AppData.appName}',
      importance: Importance.max,
      priority: Priority.high,
      channelShowBadge: true,
      playSound: true,
      color: Colors.grey,
    ),
    iOS: const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  // Show notification
  Future<void> showNotification({int id = 0, String? body}) async {
    if (!_isInitialized) {
      await init();

      if (!_isInitialized) return;
    }
    await _notifications.show(
      id,
      '',
      // AppData.appName,
      body,
      notificationDetails(),
    );
  }

  // Request notifications permission
  Future<bool> requestNotificationsPermission() async {
    final status = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final permissionGranted = await status!.requestNotificationsPermission();

    return permissionGranted ?? false;
  }

  // Cancel notification
  Future<void> cancelAllNotification() async {
    await _notifications.cancelAll();
  }
}
