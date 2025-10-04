/*
 * Hide Overscroll Indicator Helper
 * Wraps a widget to hide overscroll indicators
 */

import 'package:flutter/material.dart';

class HideOverscrollIndicator extends StatelessWidget {
  const HideOverscrollIndicator({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: child,
    );
  }
}
