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
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:single_radio/theme.dart';
import 'package:single_radio/config.dart';
import 'package:single_radio/routing/route_generator.dart';
import 'package:single_radio/providers/app_providers.dart';
import 'package:single_radio/services/fcm_service.dart';

void main() {
  SingleRadio.create().then(runApp);
}

/// Root widget, use 'create' for instantiation.
class SingleRadio extends StatelessWidget {
  const SingleRadio({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.createProviders(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Config.title,
        theme: AppTheme.themeData,
        onGenerateRoute: RouteGenerator.onGenerateRoute,
      ),
    );
  }

  // Initializes app with services and returns its widget.
  static Future<Widget> create() async {
    await _initApp();
    await _initServices();

    return const SingleRadio();
  }

  // Performs initial setup for the app.
  static Future<void> _initApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Set device orientation.
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  // Initializes key services like Firebase and KeyValue.
  static Future<void> _initServices() async {
    await FcmService.init();
  }
}
