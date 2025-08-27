import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class CenteredContainer extends StatelessWidget {
  const CenteredContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.kGrey200,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(12.0),
          ),
          width: screenWidth,
          child: Padding(padding: const EdgeInsets.all(12.0), child: child),
        ),
      ),
    );
  }
}
