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
import 'package:single_radio/extensions/slider_track_shape.dart';

class AppTheme {
  // Primary colors in ARGB format.
  static const headerColor = Color(0xFF141C27);
  static const foregroundColor = Color(0xFFFFFFFF);
  static const backgroundColor = Color(0xFF172230);
  static const accentColor = Color(0xFFDF47D7);

  // Constants for detailed customization.
  static const backgroundImage = false;

  static const appBarColor = headerColor;
  static const appBarFontColor = foregroundColor;
  static const appBarIconColor = foregroundColor;
  static const appBarElevation = 4.0;

  static const artistFontColor = foregroundColor;
  static final trackFontColor = foregroundColor.withValues(alpha: .25);

  static const controlButtonColor = accentColor;
  static const controlButtonSplashColor = Color(0xFFE91E63);
  static const controlButtonIconColor = foregroundColor;

  static const volumeActiveColor = accentColor;
  static final volumeOverlayColor = accentColor.withValues(alpha: .12);
  static final volumeInactiveColor = foregroundColor.withValues(alpha: .05);

  static const drawerHeaderBackgroundColor = headerColor;
  static const drawerBackgroundColor = backgroundColor;
  static const drawerTitleFontColor = foregroundColor;
  static const drawerTitlePadding = 16.0;
  static final drawerDescriptionFontColor =
      foregroundColor.withValues(alpha: .25);
  static const drawerItemIconColor = foregroundColor;
  static const drawerItemFontColor = foregroundColor;

  static const artworkShadowColor = Color(0x30000000);
  static const artworkShadowOffset = Offset(2.0, 2.0);
  static const artworkShadowRadius = 8.0;

  static const aboutUsTitleColor = foregroundColor;
  static final aboutUsDescriptionColor = foregroundColor.withValues(alpha: .25);
  static final aboutUsFontColor = foregroundColor.withValues(alpha: .9);
  static const aboutUsContainerTitleColor = Color(0xFF019EF6);
  static const aboutUsContainerBackgroundColor = headerColor;

  static const timerColor = foregroundColor;
  static const timerButtonFontColor = foregroundColor;
  static const timerButtonBackgroundColor = Color(0xFF2196F3);
  static const timerStopButtonFontColor = foregroundColor;
  static const timerStopButtonBackgroundColor = Color(0xFF9E9E9E);
  static const timerSliderColor = Color(0xFF2196F3);
  static const timerSliderTrackColor = Color(0xFFBBDEFB);
  static const timerSliderDotColor = foregroundColor;
  static const timerSliderFontColor = foregroundColor;

  // You can replace font files in "fonts" directory.
  // To use the default system font, set to null.
  static const fontFamily = 'Custom';

  // The font weight can be adjusted by setting a value between 0.0 and 1.0.
  // For default system font, set this value to 0.0
  static const fontWeight = 0.9;

  // Don't edit this constant.
  static final themeData = ThemeData(
    fontFamily: fontFamily,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: accentColor,
      surfaceTint: Colors.transparent,
      surface: Colors.transparent,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: foregroundColor),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: appBarElevation,
      backgroundColor: appBarColor,
      foregroundColor: appBarIconColor,
      shadowColor: const Color(0xFF000000),
      titleSpacing: 16.0,
      toolbarHeight: 56.0,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.lerp(
          FontWeight.w500,
          FontWeight.w700,
          fontWeight,
        ),
        color: appBarFontColor,
        fontFamily: fontFamily,
      ),
    ),
    sliderTheme: SliderThemeData(
      trackShape: RoundSliderTrackShape(),
      activeTrackColor: volumeActiveColor,
      thumbColor: volumeActiveColor,
      overlayColor: volumeOverlayColor,
      inactiveTrackColor: volumeInactiveColor,
      activeTickMarkColor: Colors.transparent,
      inactiveTickMarkColor: Colors.transparent,
      valueIndicatorShape: const RoundSliderOverlayShape(),
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: drawerItemIconColor,
      textColor: drawerItemFontColor,
    ),
  );
}
