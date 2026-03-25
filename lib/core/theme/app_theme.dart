import 'package:flutter/material.dart';

import 'app_color_scheme.dart';
import 'app_theme_extension.dart';

abstract final class AppTheme {
  static ThemeData get light => _buildTheme(
    brightness: Brightness.light,
    colorScheme: AppColorScheme.light,
    extension: AppThemeExtension.light,
  );

  static ThemeData get dark => _buildTheme(
    brightness: Brightness.dark,
    colorScheme: AppColorScheme.dark,
    extension: AppThemeExtension.dark,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required AppThemeExtension extension,
  }) {
    final isLight = brightness == Brightness.light;
    final baseTextTheme = isLight
        ? Typography.material2021().black
        : Typography.material2021().white;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: extension.navBar,
      textTheme: baseTextTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      extensions: [extension],
      splashFactory: NoSplash.splashFactory,
      appBarTheme: AppBarThemeData(
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: extension.panel,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: extension.cardBorder),
        ),
      ),
      iconTheme: IconThemeData(color: extension.iconMuted),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: extension.panelMuted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: extension.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: extension.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.primary;
            }
            return extension.panel;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.onPrimary;
            }
            return colorScheme.onSurfaceVariant;
          }),
          side: WidgetStatePropertyAll(BorderSide(color: extension.cardBorder)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 48),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, 48),
          elevation: 0,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 48),
          side: BorderSide(color: extension.cardBorder),
          foregroundColor: colorScheme.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: extension.panelMuted,
        selectedColor: colorScheme.secondaryContainer,
        disabledColor: extension.panelMuted,
        deleteIconColor: colorScheme.onSurfaceVariant,
        labelStyle: TextStyle(color: colorScheme.onSurface),
        secondaryLabelStyle: TextStyle(color: colorScheme.onSecondaryContainer),
        brightness: brightness,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: extension.cardBorder),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: extension.cardBorder,
        thickness: 1,
        space: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: extension.navBar,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.16),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? colorScheme.primary : extension.iconMuted,
          );
        }),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 2,
        highlightElevation: 0,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: extension.panelMuted,
        circularTrackColor: extension.panelMuted,
      ),
    );
  }
}
