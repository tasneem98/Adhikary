import 'dart:async' show Timer;
import 'dart:developer' as developer show log;
import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:workmanager/workmanager.dart';

import '/consts/widgets/centered_container.dart';
import '/core/theme/app_theme.dart';
import '/core/utils/alert_dialog_helper.dart';
import '/core/utils/snack_bar_helper.dart';
import '/main.dart';
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
  // ..........................................................
  String _timerDisplay = '00:00:00'; // Initial display
  Timer? _periodicTimer; // Store the timer to cancel it later

  // ..........................................................

  // Skeletonizer Initialization
  bool _enableSkeleton = true;

  // Notification Service
  final LocalNotificationsService _notificationsService =
      LocalNotificationsService.instance;

  // Notification Permissions
  bool _enableNotifications = false;

  // Overlay Permissions
  bool _enableOverlay = false;

  // Shared Preferences
  final SharedPreferenceServices _shared = SharedPreferenceServices();

  // Random zekr Generator
  final Random _randomNum = Random();
  String _randomZekr = '';

  @override
  void initState() {
    super.initState();
    _periodicTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final totalSeconds = timer.tick;

      // Calculate hours, minutes, and seconds
      final hours = (totalSeconds ~/ 3600); // Integer division for hours
      final minutes =
          ((totalSeconds % 3600) ~/ 60); // Remainder divided by 60 for minutes
      final seconds = (totalSeconds % 60); // Remainder for seconds

      // Format each component to be two digits (e.g., 7 -> "07")
      final String hoursStr = hours.toString().padLeft(2, '0');
      final String minutesStr = minutes.toString().padLeft(2, '0');
      final String secondsStr = seconds.toString().padLeft(2, '0');

      if (mounted) {
        // Check if the widget is still in the tree
        setState(() {
          _timerDisplay = '$hoursStr : $minutesStr : $secondsStr';
        });
      }
    });

    _initializeApp();
  }

  @override
  void dispose() {
    _periodicTimer?.cancel();
    super.dispose();
  }

  Future<void> _scheduleZekrTimer() async {
    await Workmanager().registerPeriodicTask(
      periodicZekrTaskName,
      periodicZekrTaskName,
      initialDelay: const Duration(seconds: 3),
      // frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.notRequired,
        requiresBatteryNotLow: false,
        requiresStorageNotLow: false,
      ),
      // existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );
  }

  Future<void> _initializeApp() async {
    // Get notification status
    final bool notificationEnabled = await _shared.getBool(
      SharedPreferenceServices.enableNotification,
    );
    final bool overlayEnabled = await _shared.getBool(
      SharedPreferenceServices.enableOverLayWindow,
    );

    if (mounted) {
      setState(() {
        _enableNotifications = notificationEnabled;
        _enableOverlay = overlayEnabled;
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

  ///... Notification Permission Logic

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
      await _updateEnabledPreferences(key: 'notifications', enabled: true);
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
    await _updateEnabledPreferences(key: 'notifications', enabled: false);
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
          await _updateEnabledPreferences(key: 'notifications', enabled: true);
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

  ///... Overlay Permissions Logic
  Future<void> _toggleOverlay(bool enabled) async {
    if (enabled) {
      print('Overlay is enabled');
      await _enableOverlayWindow();
    } else {
      print('Overlay is disabled');
      await _disableOverlayWindow();
    }
  }

  bool overlayIsGranted = false;

  Future<void> _enableOverlayWindow() async {
    final bool? isGranted = await FlutterOverlayWindow.requestPermission();
    developer.log(
      ' ----- Overlay Request Is Granted: $isGranted -> isCalled -----',
    );
    final overlayRequest = await FlutterOverlayWindow.isPermissionGranted();
    developer.log(' ----- Overlay Status Is: $isGranted -> isCalled -----');
    await _updateEnabledPreferences(key: 'overlay-window', enabled: true);
    setState(() {
      _enableOverlay = isGranted!;
      overlayIsGranted = overlayRequest;
    });
  }

  Future<void> _disableOverlayWindow() async {
    await FlutterOverlayWindow.closeOverlay();
    await _updateEnabledPreferences(key: 'overlay-window', enabled: false);
  }

  Future<void> _updateEnabledPreferences({
    required String key,
    required bool enabled,
  }) async {
    print('Updating $key to $enabled');

    await _shared.setBool(
      key: key == 'notifications'
          ? SharedPreferenceServices.enableNotification
          : SharedPreferenceServices.enableOverLayWindow,

      value: enabled,
    );
    if (mounted) {
      key == 'notifications'
          ? setState(() => _enableNotifications = enabled)
          : setState(() => _enableOverlay = enabled);
      SnackBarHelper.showSnackBar(
        context,
        message:
            '${key == 'notifications' ? 'Notifications' : 'Overlay Window'} ${enabled ? "Enabled" : "Disabled"}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
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
              child: SwitchListTile(
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
            CenteredContainer(
              child: SwitchListTile(
                title: Text(
                  'Enable Overlay Window',
                  style: AppTheme.kText20Bold,
                ),
                subtitle: const Text(
                  'Allow overlay window to be shown when app is in background',
                ),
                value: _enableOverlay,
                onChanged: _toggleOverlay,
              ),
            ),
            CenteredContainer(
              child: Text(
                _timerDisplay,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
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
