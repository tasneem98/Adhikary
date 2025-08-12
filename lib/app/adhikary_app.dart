import 'dart:async' show Timer;
import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '/consts/widgets/centered_container.dart';
import '/core/theme/app_theme.dart';
import '/core/utils/alert_dialog_helper.dart';
import '/core/utils/snack_bar_helper.dart';
import '/services/home_widget_service.dart';
import '/services/local_notifications_service.dart';
import '/services/shared_preference_services.dart';
import 'lists.dart';

class AdhikaryApp extends StatefulWidget {
  const AdhikaryApp({super.key});

  @override
  State<AdhikaryApp> createState() => _AdhikaryAppState();
}

class _AdhikaryAppState extends State<AdhikaryApp> {
  // Notification Service
  final LocalNotificationsService _notificationsService =
      LocalNotificationsService.instance;

  // Shared Preferences
  final SharedPreferenceServices _shared = SharedPreferenceServices();

  // Zekr Timer
  Timer? _zekrTimer;

  // Random zekr generator
  final Random _randomNum = Random();

  String _randomZekr = '';

  // Notification Permissions
  bool _enableNotifications = false;

  @override
  void initState() {
    super.initState();

    _initializeApp();
  }

  @override
  void dispose() {
    _zekrTimer?.cancel();

    super.dispose();
  }

  Future<void> _initializeApp() async {
    // Get shared preferences
    final bool enabled = await _shared.getBool(
      SharedPreferenceServices.enableNotification,
    );
    if (mounted) {
      setState(() => _enableNotifications = enabled);
    }

    // Init Home Widget
    await HomeWidgetService.init();

    // Get the first zekr
    _anotherZekr();

    // Update zekr every 2 seconds
    _zekrTimer = Timer.periodic(
      const Duration(
        seconds: 30,
        //‼️ ToDo: Rewrite this function to be after 15 min
        // minutes: 15,
      ),
      (timer) => _anotherZekr(),
    );
  }

  Future<void> _anotherZekr() async {
    if (AdhkarLists.adhkar.isEmpty) return; // Guard clause for empty list

    setState(() {
      _randomZekr =
          AdhkarLists.adhkar[_randomNum.nextInt(AdhkarLists.adhkar.length)];
    });

    // Update Home Widget
    await HomeWidgetService.updateWidget(_randomZekr);

    // Send local notification
    if (_enableNotifications) {
      await _notificationsService.showNotification(body: _randomZekr);
    }
  }

  // ---  Notification Permission Logic  ---

  Future<void> _toggleNotifications(bool enable) async {
    if (enable) {
      await _enableAppNotifications();
    } else {
      await _disableNotifications();
    }
  }

  Future<void> _enableAppNotifications() async {
    final bool notificationIsGranted =
        await Permission.notification.isGranted; // check notification status

    bool notificationRequestedAndGranted = false;

    if (!notificationIsGranted) {
      notificationRequestedAndGranted = await _notificationsService
          .requestNotificationsPermission();
    }

    // ......
    if (notificationIsGranted || notificationRequestedAndGranted) {
      await _updateNotificationPreferences(true);
    } else {
      final PermissionStatus currentStatus =
          await Permission.notification.status;
      if (currentStatus.isPermanentlyDenied || currentStatus.isRestricted) {
        if (mounted) {
          _showPermanentlyDeniedDialog();
        }
      } else if (currentStatus.isDenied && mounted) {
        // Denied but not permanently
        SnackBarHelper.showSnackBar(
          context,
          message: 'Notification permission was denied.',
        );
      }
    }
  }

  Future<void> _disableNotifications() async {
    await _notificationsService.cancelAllNotification();
    await _updateNotificationPreferences(false);
  }

  Future<void> _updateNotificationPreferences(bool enabled) async {
    await _shared.setBool(
      key: SharedPreferenceServices.enableNotification,
      value: enabled,
    );
    if (mounted) {
      setState(() => _enableNotifications = enabled);
      if (enabled) {
        SnackBarHelper.showSnackBar(context, message: 'Notifications Enabled');
      } else {
        SnackBarHelper.showSnackBar(context, message: 'Notifications Disabled');
      }
    }
  }

  Future<void>
  _showPermanentlyDeniedDialog() => AlertDialogHelper.showAlertDialog(
    context,
    title: 'Enable Notifications',
    message:
        'You have permanently denied notifications\nPlease enable notifications by going to settings',
    actionButton: TextButton(
      onPressed: () async {
        Navigator.pop(context);
        await openAppSettings();

        final statusAfterSettings = await Permission.notification.status;
        if (statusAfterSettings.isGranted) {
          await _updateNotificationPreferences(true);
        } else if (mounted) {
          SnackBarHelper.showSnackBar(
            context,
            message: 'Notifications still not enabled from settings.',
          );
        }
      },
      style: AppTheme.textButtonStyle,
      child: const Text('Go To Settings'),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CenteredContainer(
            child: SwitchListTile(
              title: Text('Enable Notifications', style: AppTheme.kText20Bold),
              subtitle: const Text(
                'Allow notifications to be sent every 15 minutes',
              ),
              value: _enableNotifications,
              onChanged: _toggleNotifications,
            ),
          ),
          CenteredContainer(
            child: Text(
              _randomZekr,
              style: AppTheme.kText22Bold,
              textAlign: TextAlign.center,
            ),
          ),

          /* ElevatedButton(
            onPressed: () {
              // SnackBarHelper.showSnackBar(context, message: 'Hello');


            },
            child: const Text('Test Button'),
          ),*/
        ],
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: _anotherZekr,
          child: const Text("ذكر اخر"),
        ),
      ),
    );
  }
}
