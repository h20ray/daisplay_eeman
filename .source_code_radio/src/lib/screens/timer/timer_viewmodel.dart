/*
 *  Single Radio - Flutter Full App
 *  Copyright (c) 2022–2025 Ilia Chirkunov. All rights reserved.
 *
 *  This project is licensed under the Envato Market Regular/Extended License.
 *  License details: https://codecanyon.net/licenses/standard
 *
 *  For support or inquiries: support@cheebeez.com
 */

import 'dart:async';
import 'package:flutter/material.dart';

class TimerViewModel with ChangeNotifier {
  TimerViewModel({
    required this.onTimer,
  });

  final VoidCallback onTimer;

  Timer? timer;
  Duration timerDuration = const Duration(hours: 0, minutes: 20);
  final timerPeriod = const Duration(seconds: 1);

  void setTimer(Duration value) {
    timerDuration = value;
    notifyListeners();
  }

  void startTimer() {
    timer = Timer.periodic(timerPeriod, onTick);
    notifyListeners();
  }

  void stopTimer() {
    timer?.cancel();
    notifyListeners();
  }

  void onTick(Timer timer) {
    if (timerDuration == Duration.zero) {
      onTimer();
      stopTimer();
    } else {
      timerDuration -= timerPeriod;
      notifyListeners();
    }
  }
}
