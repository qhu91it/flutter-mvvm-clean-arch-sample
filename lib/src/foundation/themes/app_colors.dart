import 'package:flutter/material.dart';

class AppColors {
  const AppColors({
    required this.primary,
    required this.primaryVariant,
    required this.onPrimary,
    required this.secondary,
    required this.secondaryVariant,
    required this.onSecondary,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.error,
    required this.onError,
    required this.scheme,
  });

  factory AppColors.light() {
    return const AppColors(
      primary: Color(0xFFB90063),
      primaryVariant: Color(0xFFFFD9E2),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFF74565F),
      secondaryVariant: Color(0xFF018786),
      onSecondary: Color(0xFFFFFFFF),
      background: Color(0xFFFFFBFF),
      onBackground: Color(0xFF201A1B),
      surface: Color(0xFFFFFBFF),
      onSurface: Color(0xFF201A1B),
      error: Color(0xFFBA1A1A),
      onError: Color(0xFFFFFFFF),
      scheme: ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFFB90063),
        onPrimary: Color(0xFFFFFFFF),
        primaryContainer: Color(0xFFFFD9E2),
        onPrimaryContainer: Color(0xFF3E001D),
        secondary: Color(0xFF74565F),
        onSecondary: Color(0xFFFFFFFF),
        secondaryContainer: Color(0xFFFFD9E2),
        onSecondaryContainer: Color(0xFF2B151C),
        tertiary: Color(0xFF7C5635),
        onTertiary: Color(0xFFFFFFFF),
        tertiaryContainer: Color(0xFFFFDCC1),
        onTertiaryContainer: Color(0xFF2E1500),
        error: Color(0xFFBA1A1A),
        errorContainer: Color(0xFFFFDAD6),
        onError: Color(0xFFFFFFFF),
        onErrorContainer: Color(0xFF410002),
        background: Color(0xFFFFFBFF),
        onBackground: Color(0xFF201A1B),
        surface: Color(0xFFFFFBFF),
        onSurface: Color(0xFF201A1B),
        surfaceVariant: Color(0xFFF2DDE1),
        onSurfaceVariant: Color(0xFF514347),
        outline: Color(0xFF837377),
        onInverseSurface: Color(0xFFFAEEEF),
        inverseSurface: Color(0xFF352F30),
        inversePrimary: Color(0xFFFFB1C8),
        shadow: Color(0xFF000000),
        surfaceTint: Color(0xFFB90063),
      ),
    );
  }

  factory AppColors.dark() {
    return const AppColors(
      primary: Color(0xFFFFB1C8),
      primaryVariant: Color(0xFF8E004A),
      onPrimary: Color(0xFF650033),
      secondary: Color(0xFFE3BDC6),
      secondaryVariant: Color(0xFF5A3F47),
      onSecondary: Color(0xFF422931),
      background: Color(0xFF201A1B),
      onBackground: Color(0xFFEBE0E1),
      surface: Color(0xFF201A1B),
      onSurface: Color(0xFFEBE0E1),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      scheme: ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFFFFB1C8),
        onPrimary: Color(0xFF650033),
        primaryContainer: Color(0xFF8E004A),
        onPrimaryContainer: Color(0xFFFFD9E2),
        secondary: Color(0xFFE3BDC6),
        onSecondary: Color(0xFF422931),
        secondaryContainer: Color(0xFF5A3F47),
        onSecondaryContainer: Color(0xFFFFD9E2),
        tertiary: Color(0xFFEFBD94),
        onTertiary: Color(0xFF48290B),
        tertiaryContainer: Color(0xFF623F20),
        onTertiaryContainer: Color(0xFFFFDCC1),
        error: Color(0xFFFFB4AB),
        errorContainer: Color(0xFF93000A),
        onError: Color(0xFF690005),
        onErrorContainer: Color(0xFFFFDAD6),
        background: Color(0xFF201A1B),
        onBackground: Color(0xFFEBE0E1),
        surface: Color(0xFF201A1B),
        onSurface: Color(0xFFEBE0E1),
        surfaceVariant: Color(0xFF514347),
        onSurfaceVariant: Color(0xFFD5C2C6),
        outline: Color(0xFF9E8C90),
        onInverseSurface: Color(0xFF201A1B),
        inverseSurface: Color(0xFFEBE0E1),
        inversePrimary: Color(0xFFB90063),
        shadow: Color(0xFF000000),
        surfaceTint: Color(0xFFFFB1C8),
      ),
    );
  }

  /// Material Colors https://material.io/design/color/the-color-system.html#color-theme-creation
  final Color primary;
  final Color primaryVariant;
  final Color onPrimary;
  final Color secondary;
  final Color secondaryVariant;
  final Color onSecondary;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color error;
  final Color onError;

  /// Generate scheme: https://m3.material.io/theme-builder#/custom
  final ColorScheme scheme;
}
