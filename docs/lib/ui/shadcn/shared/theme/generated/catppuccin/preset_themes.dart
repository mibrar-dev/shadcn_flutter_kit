// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: catppuccin.json
// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/painting.dart';

import '../../color_scheme.dart';
import '../../theme.dart';

class RegistryThemePresetTokens {
  final double radius;
  final SpacingScale spacing;
  final TrackingScale tracking;
  final ShadowScale shadows;
  final String? fontSans;
  final String? fontSerif;
  final String? fontMono;

  const RegistryThemePresetTokens({
    required this.radius,
    required this.spacing,
    required this.tracking,
    required this.shadows,
    this.fontSans,
    this.fontSerif,
    this.fontMono,
  });

  Density get density => Density.fromSpacingScale(spacing);
}

class RegistryThemePreset {
  final String id;
  final String name;
  final ColorScheme light;
  final ColorScheme dark;
  final RegistryThemePresetTokens lightTokens;
  final RegistryThemePresetTokens darkTokens;

  const RegistryThemePreset({
    required this.id,
    required this.name,
    required this.light,
    required this.dark,
    required this.lightTokens,
    required this.darkTokens,
  });
}

final List<RegistryThemePreset> registryThemePresets = <RegistryThemePreset>[
  RegistryThemePreset(
    id: 'catppuccin',
    name: "Catppuccin",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFEFF1F5),
      foreground: Color(0xFF4C4F69),
      card: Color(0xFFFFFFFF),
      cardForeground: Color(0xFF4C4F69),
      popover: Color(0xFFCCD0DA),
      popoverForeground: Color(0xFF4C4F69),
      primary: Color(0xFF8839EF),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFCCD0DA),
      secondaryForeground: Color(0xFF4C4F69),
      muted: Color(0xFFDCE0E8),
      mutedForeground: Color(0xFF6C6F85),
      accent: Color(0xFF04A5E5),
      accentForeground: Color(0xFFFFFFFF),
      destructive: Color(0xFFD20F39),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFBCC0CC),
      input: Color(0xFFCCD0DA),
      ring: Color(0xFF8839EF),
      chart1: Color(0xFF8839EF),
      chart2: Color(0xFF04A5E5),
      chart3: Color(0xFF40A02B),
      chart4: Color(0xFFFE640B),
      chart5: Color(0xFFDC8A78),
      sidebar: Color(0xFFE6E9EF),
      sidebarForeground: Color(0xFF4C4F69),
      sidebarPrimary: Color(0xFF8839EF),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFF04A5E5),
      sidebarAccentForeground: Color(0xFFFFFFFF),
      sidebarBorder: Color(0xFFBCC0CC),
      sidebarRing: Color(0xFF8839EF),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF181825),
      foreground: Color(0xFFCDD6F4),
      card: Color(0xFF1E1E2E),
      cardForeground: Color(0xFFCDD6F4),
      popover: Color(0xFF45475A),
      popoverForeground: Color(0xFFCDD6F4),
      primary: Color(0xFFCBA6F7),
      primaryForeground: Color(0xFF1E1E2E),
      secondary: Color(0xFF585B70),
      secondaryForeground: Color(0xFFCDD6F4),
      muted: Color(0xFF292C3C),
      mutedForeground: Color(0xFFA6ADC8),
      accent: Color(0xFF89DCEB),
      accentForeground: Color(0xFF1E1E2E),
      destructive: Color(0xFFF38BA8),
      destructiveForeground: Color(0xFF1E1E2E),
      border: Color(0xFF313244),
      input: Color(0xFF313244),
      ring: Color(0xFFCBA6F7),
      chart1: Color(0xFFCBA6F7),
      chart2: Color(0xFF89DCEB),
      chart3: Color(0xFFA6E3A1),
      chart4: Color(0xFFFAB387),
      chart5: Color(0xFFF5E0DC),
      sidebar: Color(0xFF11111B),
      sidebarForeground: Color(0xFFCDD6F4),
      sidebarPrimary: Color(0xFFCBA6F7),
      sidebarPrimaryForeground: Color(0xFF1E1E2E),
      sidebarAccent: Color(0xFF89DCEB),
      sidebarAccentForeground: Color(0xFF1E1E2E),
      sidebarBorder: Color(0xFF45475A),
      sidebarRing: Color(0xFFCBA6F7),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 0.35,
      spacing: SpacingScale(3.84),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: 0,
            color: Color(0x1F2D2D53),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: 0,
            color: Color(0x1F2D2D53),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: 0,
            color: Color(0x1F2D2D53),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: 0,
            color: Color(0x1F2D2D53),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: 0,
            color: Color(0x1F2D2D53),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: 0,
            color: Color(0x1F2D2D53),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: 0,
            color: Color(0x1F2D2D53),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: 0,
            color: Color(0x1F2D2D53),
          ),
        ],
      ),
      fontSans: "Montserrat, sans-serif",
      fontSerif: "Georgia, serif",
      fontMono: "Fira Code, monospace",
    ),
    darkTokens: RegistryThemePresetTokens(
      radius: 0.5,
      spacing: SpacingScale(3.84),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(20.5, 16.5),
            blurRadius: 25.5,
            spreadRadius: -30,
            color: Color(0x12000000),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(20.5, 16.5),
            blurRadius: 25.5,
            spreadRadius: -30,
            color: Color(0x12000000),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(20.5, 16.5),
            blurRadius: 25.5,
            spreadRadius: -30,
            color: Color(0x12000000),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(20.5, 16.5),
            blurRadius: 25.5,
            spreadRadius: -30,
            color: Color(0x12000000),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(20.5, 16.5),
            blurRadius: 25.5,
            spreadRadius: -30,
            color: Color(0x12000000),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(20.5, 16.5),
            blurRadius: 25.5,
            spreadRadius: -30,
            color: Color(0x12000000),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(20.5, 16.5),
            blurRadius: 25.5,
            spreadRadius: -30,
            color: Color(0x12000000),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(20.5, 16.5),
            blurRadius: 25.5,
            spreadRadius: -30,
            color: Color(0x12000000),
          ),
        ],
      ),
    ),
  ),
];
