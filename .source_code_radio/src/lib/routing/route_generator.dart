/*
 *  Single Radio - Flutter Full App
 *  Copyright (c) 2022–2025 Ilia Chirkunov. All rights reserved.
 *
 *  This project is licensed under the Envato Market Regular/Extended License.
 *  License details: https://codecanyon.net/licenses/standard
 *
 *  For support or inquiries: support@cheebeez.com
 */

import 'package:flutter/material.dart';
import 'package:single_radio/screens/screens.dart';

class RouteGenerator {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case PlayerView.routeName:
        return MaterialPageRoute(
          builder: (context) => const PlayerView(),
        );
      case AboutView.routeName:
        return MaterialPageRoute(
          builder: (context) => const AboutView(),
        );
      case TimerView.routeName:
        return MaterialPageRoute(
          builder: (context) => const TimerView(),
          allowSnapshotting: false,
        );
      default:
        throw Exception('Invalid route: ${settings.name}');
    }
  }
}
