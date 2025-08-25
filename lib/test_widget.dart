import 'dart:async';

import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  String _timerDisplay = '00:00:00'; // Initial display
  Timer? _periodicTimer; // Store the timer to cancel it later
  final String _uniqueId =
      'Scheduled task ${DateTime.now().millisecondsSinceEpoch}';

  @override
  void initState() {
    // TODO: implement initState
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
  }

  @override
  void dispose() {
    _periodicTimer
        ?.cancel(); // Important: Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10,
          children: [
            Text(
              _timerDisplay,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            ElevatedButton(
              onPressed: () {
                // developerLog.w('Button Clicked at: Now: ${DateTime.now()}');
                // Workmanager().registerOneOffTask(
                Workmanager().registerPeriodicTask(
                  _uniqueId,
                  'task-one',
                  initialDelay: const Duration(seconds: 3),
                  constraints: Constraints(
                    networkType: NetworkType.notRequired,
                  ),
                  // frequency: const Duration(minutes: 15),
                );
              },
              child: const Text('Test Button'),
            ),
          ],
        ),
      ),
    );
  }
}
