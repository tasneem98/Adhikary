import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

import '/consts/widgets/centered_container.dart';
import 'lists.dart';

class AdhikaryApp extends StatefulWidget {
  const AdhikaryApp({super.key});

  @override
  State<AdhikaryApp> createState() => _AdhikaryAppState();
}

class _AdhikaryAppState extends State<AdhikaryApp> {
  // Home Widget
  final String _appGroupId = "group.homeScreenApp";
  final String _iOSWidgetName = "ZekrWidget";
  final String _androidWidgetName = "ZekrWidget";
  final String _dataKey = "the_zekr";

  // Random zekr generator
  final Random _randomNum = Random();

  String _randomZekr = '';

  void _anotherZekr() async {
    setState(() {
      _randomZekr =
          AdhkarLists.adhkar[_randomNum.nextInt(AdhkarLists.adhkar.length - 1)];
    });

    // Save widget zekr
    await HomeWidget.saveWidgetData(_dataKey, _randomZekr);

    // Update widget
    await HomeWidget.updateWidget(
      name: _iOSWidgetName,
      androidName: _androidWidgetName,
    );
  }

  @override
  void initState() {
    super.initState();

    // Get the first zekr
    _anotherZekr();

    // Init Home Widget
    HomeWidget.setAppGroupId(_appGroupId);

    // Update zekr every 2 seconds
    Timer.periodic(
      const Duration(
        seconds: 2,
        //‼️ ToDo: Rewrite this function to be after 15 min
        // minutes: 15
      ),
      (timer) => _anotherZekr(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: CenteredContainer(
          child: Text(
            _randomZekr,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),

        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            onPressed: _anotherZekr,
            child: const Text("ذكر اخر"),
          ),
        ),
      ),
    );
  }
}
