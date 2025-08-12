import 'package:flutter/material.dart';

class AlertDialogHelper {
  static Future<void> showAlertDialog(
    BuildContext context, {
    required String title,
    required String message,
    TextButton? actionButton,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ?actionButton,
          ],
        );
      },
    );
  }
}
