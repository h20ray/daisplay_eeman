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
import 'package:flutter/foundation.dart';

class SmartstopService {
  SmartstopService({
    required this.callback,
    required this.duration,
  });

  VoidCallback callback;
  Duration duration;
  Duration _count = Duration.zero;
  final _timerPeriod = const Duration(seconds: 1);
  Timer? _timer;

  void start() => _timer = Timer.periodic(_timerPeriod, _onTick);
  void stop() => _timer?.cancel();

  Future<void> _onTick(Timer t) async {
    _count += _timerPeriod;

    if (_count >= duration) {
      _count = Duration.zero;
      t.cancel();
      callback();
    }
  }
}
