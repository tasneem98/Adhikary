import 'package:flutter/material.dart';

class ModalBottomSheetHelper {
  static void showBottomSheet(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      isDismissible: true,
      sheetAnimationStyle: const AnimationStyle(
        duration: Duration(milliseconds: 500),
        reverseDuration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeInOut,
      ),
      builder: (_) {
        return Builder(
          builder: (context) {
            return SizedBox(height: 200.0, child: Center(child: child));
          },
        );
      },
    );
  }
}
