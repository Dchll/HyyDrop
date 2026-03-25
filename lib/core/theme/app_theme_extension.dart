import 'package:flutter/material.dart';

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.success,
    required this.warning,
    required this.danger,
    required this.info,
    required this.cardBorder,
    required this.panel,
    required this.panelMuted,
    required this.panelStrong,
    required this.navBar,
    required this.heroStart,
    required this.heroEnd,
    required this.iconMuted,
    required this.transferGlow,
    required this.overlay,
  });

  final Color success;
  final Color warning;
  final Color danger;
  final Color info;
  final Color cardBorder;
  final Color panel;
  final Color panelMuted;
  final Color panelStrong;
  final Color navBar;
  final Color heroStart;
  final Color heroEnd;
  final Color iconMuted;
  final Color transferGlow;
  final Color overlay;

  @override
  AppThemeExtension copyWith({
    Color? success,
    Color? warning,
    Color? danger,
    Color? info,
    Color? cardBorder,
    Color? panel,
    Color? panelMuted,
    Color? panelStrong,
    Color? navBar,
    Color? heroStart,
    Color? heroEnd,
    Color? iconMuted,
    Color? transferGlow,
    Color? overlay,
  }) {
    return AppThemeExtension(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      info: info ?? this.info,
      cardBorder: cardBorder ?? this.cardBorder,
      panel: panel ?? this.panel,
      panelMuted: panelMuted ?? this.panelMuted,
      panelStrong: panelStrong ?? this.panelStrong,
      navBar: navBar ?? this.navBar,
      heroStart: heroStart ?? this.heroStart,
      heroEnd: heroEnd ?? this.heroEnd,
      iconMuted: iconMuted ?? this.iconMuted,
      transferGlow: transferGlow ?? this.transferGlow,
      overlay: overlay ?? this.overlay,
    );
  }

  @override
  AppThemeExtension lerp(covariant AppThemeExtension? other, double t) {
    if (other == null) {
      return this;
    }

    return AppThemeExtension(
      success: Color.lerp(success, other.success, t) ?? success,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      danger: Color.lerp(danger, other.danger, t) ?? danger,
      info: Color.lerp(info, other.info, t) ?? info,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t) ?? cardBorder,
      panel: Color.lerp(panel, other.panel, t) ?? panel,
      panelMuted: Color.lerp(panelMuted, other.panelMuted, t) ?? panelMuted,
      panelStrong: Color.lerp(panelStrong, other.panelStrong, t) ?? panelStrong,
      navBar: Color.lerp(navBar, other.navBar, t) ?? navBar,
      heroStart: Color.lerp(heroStart, other.heroStart, t) ?? heroStart,
      heroEnd: Color.lerp(heroEnd, other.heroEnd, t) ?? heroEnd,
      iconMuted: Color.lerp(iconMuted, other.iconMuted, t) ?? iconMuted,
      transferGlow:
          Color.lerp(transferGlow, other.transferGlow, t) ?? transferGlow,
      overlay: Color.lerp(overlay, other.overlay, t) ?? overlay,
    );
  }

  static const light = AppThemeExtension(
    success: Color(0xFF17A768),
    warning: Color(0xFFF0A128),
    danger: Color(0xFFF2526B),
    info: Color(0xFF0084FF),
    cardBorder: Color(0xFFD8E1EC),
    panel: Color(0xFFFFFFFF),
    panelMuted: Color(0xFFF3F7FB),
    panelStrong: Color(0xFFE9F5FF),
    navBar: Color(0xFFFFFFFF),
    heroStart: Color(0xFF0084FF),
    heroEnd: Color(0xFF00C6FF),
    iconMuted: Color(0xFF708197),
    transferGlow: Color(0x290084FF),
    overlay: Color(0x660B1220),
  );

  static const dark = AppThemeExtension(
    success: Color(0xFF3DDC97),
    warning: Color(0xFFF7C45D),
    danger: Color(0xFFFF6E7D),
    info: Color(0xFF0084FF),
    cardBorder: Color(0xFF233041),
    panel: Color(0xFF101620),
    panelMuted: Color(0xFF161D28),
    panelStrong: Color(0xFF1B2636),
    navBar: Color(0xFF0E141D),
    heroStart: Color(0xFF0C1016),
    heroEnd: Color(0xFF1A2432),
    iconMuted: Color(0xFF8EA1B8),
    transferGlow: Color(0x3D0084FF),
    overlay: Color(0x99000000),
  );
}

extension AppThemeExtensionX on BuildContext {
  AppThemeExtension get appColors =>
      Theme.of(this).extension<AppThemeExtension>()!;
}
