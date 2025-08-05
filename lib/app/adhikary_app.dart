import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '/consts/widgets/centered_container.dart';
import 'lists.dart';

class AdhikaryApp extends StatefulWidget {
  const AdhikaryApp({super.key});

  @override
  State<AdhikaryApp> createState() => _AdhikaryAppState();
}

class _AdhikaryAppState extends State<AdhikaryApp> {
  final Random _randomNum = Random();

  String _randomZekr = '';

  void _anotherZekr() {
    setState(() {
      _randomZekr =
          AdhkarLists.adhkar[_randomNum.nextInt(AdhkarLists.adhkar.length - 1)];
    });
  }

  @override
  void initState() {
    super.initState();
    _anotherZekr();

    Timer.periodic(const Duration(seconds: 2), (timer) => _anotherZekr());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: _anotherZekr,
          child: CenteredContainer(
            child: Text(
              _randomZekr,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
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
