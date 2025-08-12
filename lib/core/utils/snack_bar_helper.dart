import 'package:flutter/material.dart';

class SnackBarHelper {
  static void showSnackBar(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
