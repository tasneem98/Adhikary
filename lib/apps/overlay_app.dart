import 'package:adhikary/consts/app_data.dart';
import 'package:flutter/material.dart';

class AzkaryOverlayApp extends StatelessWidget {
  const AzkaryOverlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(centerTitle: true, title: Text(AppData.appName)),
      body: Container(
        alignment: Alignment.center,
        // width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        child: Center(child: Text("Azkary Overlay")),
      ),
    );
  }
}
