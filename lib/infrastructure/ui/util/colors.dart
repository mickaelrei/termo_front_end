import 'dart:math';

import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
/// Colors commonly used in the app
abstract class AppColors {
  /// Get app colors based on current theme mode (light/dark)
  static AppColors of(BuildContext context) {
    switch (Theme.of(context).brightness) {
      case Brightness.dark:
        throw UnimplementedError('dark theme not implemented yet');
      case Brightness.light:
        return _PanelColorsLight();
    }
  }

  /// Primary app color
  Color get primary;

  /// Primary app color, but lighter
  Color get primaryLight;

  /// Primary app color, but darker
  Color get primaryDark;

  /// Color used as background
  Color get background;

  /// Error color
  Color get error;

  /// Success color
  Color get success;

  /// Warning color
  Color get warning;
}

class _PanelColorsLight extends AppColors {
  @override
  Color get primary => const Color.fromRGBO(25, 100, 169, 1.0);

  @override
  Color get primaryLight => const Color.fromRGBO(17, 136, 221, 1.0);

  @override
  Color get primaryDark => const Color.fromRGBO(11, 55, 96, 1.0);

  @override
  Color get background => const Color.fromRGBO(252, 252, 255, 1.0);

  @override
  Color get error => const Color(0xFFB00020);

  @override
  Color get success => const Color(0xFF4ECD4D);

  @override
  Color get warning => const Color(0xFFE49A3A);
}

/// Basic util methods for colors
extension ColorLightnessAdjust on Color {
  /// Adjusts the lightness of the color by a given delta lightness factor
  ///
  /// The [delta] value will be added on top of the current lightness and will
  /// be interpreted as a percentage. The final lightness will be clamped
  /// between 0% and 100%
  Color adjustLightness([int delta = 10]) {
    final hsl = HSLColor.fromColor(this);
    final lightness = max(0.0, min(hsl.lightness + delta * 0.01, 1.0));
    return HSLColor.fromAHSL(
      hsl.alpha,
      hsl.hue,
      hsl.saturation,
      lightness,
    ).toColor();
  }
}
