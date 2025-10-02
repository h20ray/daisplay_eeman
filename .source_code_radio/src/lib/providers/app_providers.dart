/*
 *  Single Radio - Flutter Full App
 *  Copyright (c) 2022–2025 Ilia Chirkunov. All rights reserved.
 *
 *  This project is licensed under the Envato Market Regular/Extended License.
 *  License details: https://codecanyon.net/licenses/standard
 *
 *  For support or inquiries: support@cheebeez.com
 */

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:single_radio/screens/screens.dart';

class AppProviders {
  static List<SingleChildWidget> createProviders() {
    late final playerViewModel = PlayerViewModel();
    late final timerViewModel = TimerViewModel(onTimer: playerViewModel.pause);

    return [
      ChangeNotifierProvider<PlayerViewModel>.value(value: playerViewModel),
      ChangeNotifierProvider<TimerViewModel>.value(value: timerViewModel),
    ];
  }
}
