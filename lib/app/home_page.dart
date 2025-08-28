import 'dart:math' show Random;

import 'package:adhikary/core/utils/modal_bottom_sheet_helper.dart';
import 'package:adhikary/main.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:workmanager/workmanager.dart';

import '/consts/widgets/centered_container.dart';
import '/core/theme/app_theme.dart';
import '/core/utils/alert_dialog_helper.dart';
import '/core/utils/snack_bar_helper.dart';
import '/services/home_widget_service.dart';
import '/services/local_notifications_service.dart';
import '/services/shared_preference_services.dart';
import 'lists.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Skeletonizer Initialization
  bool _enableSkeleton = true;

  // Notification Service
  final LocalNotificationsService _notificationsService =
      LocalNotificationsService.instance;

  // Notification Permissions
  bool _enableNotifications = false;

  // Shared Preferences
  final SharedPreferenceServices _shared = SharedPreferenceServices();

  // Random zekr Generator
  final Random _randomNum = Random();
  String _randomZekr = '';

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _scheduleZekrTimer() async {
    await Workmanager().registerPeriodicTask(
      periodicZekrTaskName,
      periodicZekrTaskName,
      initialDelay: const Duration(seconds: 3),
      constraints: Constraints(
        networkType: NetworkType.notRequired,
        requiresBatteryNotLow: false,
        requiresStorageNotLow: false,
      ),
    );
  }

  Future<void> _initializeApp() async {
    // Get notification status
    final bool enabled = await _shared.getBool(
      SharedPreferenceServices.enableNotification,
    );

    if (mounted) {
      setState(() {
        _enableNotifications = enabled;
        _enableSkeleton = false;
      });
    }

    // Init Home Widget
    await HomeWidgetService.init();

    // Init local notifications
    await _notificationsService.init();

    // Display a zekr
    _displayZekr();

    // Schedule zekr timer
    await _scheduleZekrTimer();
  }

  Future<void> _displayZekr() async {
    if (AdhkarLists.adhkar.isEmpty) return; // Guard clause for empty list

    setState(() {
      _randomZekr =
          AdhkarLists.adhkar[_randomNum.nextInt(AdhkarLists.adhkar.length)];
    });

    // Update Home Widget
    await HomeWidgetService.updateWidget(_randomZekr);
  }

  // Notification Permission Logic

  Future<void> _toggleNotifications(bool enable) async {
    if (enable) {
      await _enableAppNotifications();
    } else {
      await _disableNotifications();
    }

    if (enable) {
      await _scheduleZekrTimer();
    } else {
      await Workmanager().cancelAll();
    }
    if (mounted) Navigator.pop(context);
  }

  Future<void> _enableAppNotifications() async {
    final bool notificationIsGranted =
        await Permission.notification.isGranted; // check notification status

    bool notificationRequestedAndGranted = false;

    if (!notificationIsGranted) {
      notificationRequestedAndGranted = await _notificationsService
          .requestNotificationsPermission();
    }

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
      SnackBarHelper.showSnackBar(
        context,
        message: 'Notifications ${enabled ? "Enabled" : "Disabled"}',
      );
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
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        elevation: 0.0,
        forceMaterialTransparency: true,

        actions: [
          IconButton(
            onPressed: () => ModalBottomSheetHelper.showBottomSheet(
              context,
              SwitchListTile(
                title: Text(
                  'Enable Notifications',
                  style: AppTheme.kText20Bold,
                ),
                subtitle: const Text(
                  'Allow notifications to be sent every 15 minutes',
                ),
                value: _enableNotifications,
                onChanged: _toggleNotifications,
              ),
            ),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Skeletonizer(
        enabled: _enableSkeleton,
        containersColor: Colors.grey.shade300,
        effect: const PulseEffect(),
        enableSwitchAnimation: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
            ),

            CenteredContainer(
              child: Text(
                _randomZekr,
                style: AppTheme.kText22Bold,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
