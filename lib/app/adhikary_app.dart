import 'dart:math';

import 'package:flutter/material.dart';

import 'lists.dart';

class AdhikaryApp extends StatefulWidget {
  const AdhikaryApp({super.key});

  @override
  State<AdhikaryApp> createState() => _AdhikaryAppState();
}

class _AdhikaryAppState extends State<AdhikaryApp> {
  final _randomNum = Random();

  String _randomAdhkar = '';

  void _anotherZekr() {
    setState(() {
      _randomAdhkar =
          AdhkarLists.adhkar[_randomNum.nextInt(AdhkarLists.adhkar.length - 1)];
    });
  }

  @override
  void initState() {
    super.initState();
    _anotherZekr();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  _randomAdhkar,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
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
