import 'package:flutter/material.dart';

abstract final class AppColorScheme {
  static const brandBlue = Color(0xFF0084FF);
  static const accentBlue = Color(0xFF00C6FF);

  static final light =
      ColorScheme.fromSeed(
        seedColor: brandBlue,
        brightness: Brightness.light,
      ).copyWith(
        primary: brandBlue,
        onPrimary: Colors.white,
        primaryContainer: const Color(0xFFD9EEFF),
        onPrimaryContainer: const Color(0xFF002A52),
        secondary: accentBlue,
        onSecondary: const Color(0xFF002838),
        secondaryContainer: const Color(0xFFD7F6FF),
        onSecondaryContainer: const Color(0xFF003547),
        tertiary: accentBlue,
        onTertiary: const Color(0xFF002838),
        tertiaryContainer: const Color(0xFFD7F6FF),
        onTertiaryContainer: const Color(0xFF003547),
        surface: const Color(0xFFF4F7FB),
        onSurface: const Color(0xFF333333),
        surfaceContainerLowest: Colors.white,
        surfaceContainerLow: const Color(0xFFFFFFFF),
        surfaceContainer: const Color(0xFFF3F7FB),
        surfaceContainerHigh: const Color(0xFFEDF3F8),
        surfaceContainerHighest: const Color(0xFFE5EDF5),
        onSurfaceVariant: const Color(0xFF617285),
        outline: const Color(0xFFD8E1EC),
        outlineVariant: const Color(0xFFE7EEF5),
        shadow: const Color(0x1A0B1220),
        scrim: const Color(0x660B1220),
        inverseSurface: const Color(0xFF1F2328),
        onInverseSurface: Colors.white,
        inversePrimary: accentBlue,
      );

  static final dark =
      ColorScheme.fromSeed(
        seedColor: brandBlue,
        brightness: Brightness.dark,
      ).copyWith(
        primary: brandBlue,
        onPrimary: Colors.white,
        primaryContainer: const Color(0xFF003966),
        onPrimaryContainer: const Color(0xFFD9EEFF),
        secondary: accentBlue,
        onSecondary: const Color(0xFF002838),
        secondaryContainer: const Color(0xFF003F59),
        onSecondaryContainer: const Color(0xFFD7F6FF),
        tertiary: accentBlue,
        onTertiary: const Color(0xFF002838),
        tertiaryContainer: const Color(0xFF003F59),
        onTertiaryContainer: const Color(0xFFD7F6FF),
        surface: Colors.black,
        onSurface: const Color(0xFFFFFFFF),
        surfaceContainerLowest: Colors.black,
        surfaceContainerLow: const Color(0xFF101620),
        surfaceContainer: const Color(0xFF141B26),
        surfaceContainerHigh: const Color(0xFF1A2431),
        surfaceContainerHighest: const Color(0xFF223043),
        onSurfaceVariant: const Color(0xFFAAB8CB),
        outline: const Color(0xFF263548),
        outlineVariant: const Color(0xFF1A2431),
        shadow: Colors.black,
        scrim: const Color(0x99000000),
        inverseSurface: Colors.white,
        onInverseSurface: Colors.black,
        inversePrimary: brandBlue,
      );
}
