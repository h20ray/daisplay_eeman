/*
 * Radio Theme - Material Design 3 Expressive
 * Modern theme following M3 guidelines with expressive design tokens
 */

import 'package:flutter/material.dart';

class RadioAppTheme {
  // Material Design 3 Color Tokens
  static const Color primaryColor = Color(0xFF6750A4);
  static const Color onPrimaryColor = Color(0xFFFFFFFF);
  static const Color primaryContainerColor = Color(0xFFEADDFF);
  static const Color onPrimaryContainerColor = Color(0xFF21005D);

  static const Color secondaryColor = Color(0xFF625B71);
  static const Color onSecondaryColor = Color(0xFFFFFFFF);
  static const Color secondaryContainerColor = Color(0xFFE8DEF8);
  static const Color onSecondaryContainerColor = Color(0xFF1D192B);

  static const Color surfaceColor = Color(0xFFFEF7FF);
  static const Color onSurfaceColor = Color(0xFF1C1B1F);
  static const Color surfaceContainerHighestColor = Color(0xFFE6E0E9);
  static const Color onSurfaceVariantColor = Color(0xFF49454F);

  static const Color errorColor = Color(0xFFBA1A1A);
  static const Color onErrorColor = Color(0xFFFFFFFF);

  // Typography
  static const String fontFamily = 'Poppins';

  // Spacing and Elevation
  static const double borderRadius = 24;
  static const double controlButtonSize = 72;
  static const double artworkSize = 0.7; // Percentage of screen width

  // Material Design 3 Theme Data
  static ThemeData get themeData => ThemeData(
        useMaterial3: true,
        fontFamily: fontFamily,
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          primaryContainer: primaryContainerColor,
          onPrimaryContainer: onPrimaryContainerColor,
          secondary: secondaryColor,
          onSecondary: onSecondaryColor,
          secondaryContainer: secondaryContainerColor,
          onSecondaryContainer: onSecondaryContainerColor,
          surface: surfaceColor,
          onSurface: onSurfaceColor,
          surfaceContainerHighest: surfaceContainerHighestColor,
          onSurfaceVariant: onSurfaceVariantColor,
          error: errorColor,
          outline: Color(0xFF79747E),
          shadow: Color(0xFF000000),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: onSurfaceColor,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: onSurfaceColor,
            fontFamily: fontFamily,
          ),
        ),
        sliderTheme: SliderThemeData(
          trackHeight: 6,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
          activeTrackColor: primaryColor,
          inactiveTrackColor: surfaceContainerHighestColor,
          thumbColor: primaryColor,
          overlayColor: primaryColor.withValues(alpha: 0.12),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      );

  // Dark theme variant
  static ThemeData get darkThemeData => ThemeData(
        useMaterial3: true,
        fontFamily: fontFamily,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD0BCFF),
          primaryContainer: Color(0xFF4F378B),
          onPrimaryContainer: Color(0xFFEADDFF),
          secondary: Color(0xFFCCC2DC),
          onSecondary: Color(0xFF332D41),
          secondaryContainer: Color(0xFF4A4458),
          onSecondaryContainer: Color(0xFFE8DEF8),
          surface: Color(0xFF141218),
          onSurface: Color(0xFFE6E0E9),
          surfaceContainerHighest: Color(0xFF2B2930),
          onSurfaceVariant: Color(0xFFCAC4D0),
          error: Color(0xFFFFB4AB),
          onError: Color(0xFF690005),
          outline: Color(0xFF938F99),
          shadow: Color(0xFF000000),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFFE6E0E9),
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE6E0E9),
            fontFamily: fontFamily,
          ),
        ),
        sliderTheme: SliderThemeData(
          trackHeight: 6,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
          activeTrackColor: const Color(0xFFD0BCFF),
          inactiveTrackColor: const Color(0xFF2B2930),
          thumbColor: const Color(0xFFD0BCFF),
          overlayColor: const Color(0xFFD0BCFF).withValues(alpha: 0.12),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      );
}
