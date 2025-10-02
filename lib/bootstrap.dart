import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/common/common.dart';
import 'package:quran_app/locator.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> init() async {
  FlutterError.onError = (details) {
    // Suppress SVG filter warnings as they don't affect functionality
    if (details.exceptionAsString().contains('unhandled element <filter/>')) {
      return;
    }
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = AppBlocObserver();
  await ScreenUtil.ensureScreenSize();

  // Initialize notification helper asynchronously to avoid blocking UI
  unawaited(Future.microtask(NotificationHelper.new));
  setStatusBar();

  /// Specifies the `SystemUiMode` to have visible when the application is running.
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [
      SystemUiOverlay.bottom,
      SystemUiOverlay.top,
    ],
  );

  setupLocator();
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    await init();

    runApp(await builder());
  } catch (error, stack) {
    log('Bootstrap error: $error', error: error, stackTrace: stack);
    rethrow;
  }
}
