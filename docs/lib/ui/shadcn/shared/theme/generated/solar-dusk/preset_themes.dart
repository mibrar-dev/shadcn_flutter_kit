// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: solar-dusk.json
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
    id: 'solar-dusk',
    name: "Solar Dusk",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFFDFBF7),
      foreground: Color(0xFF4A3B33),
      card: Color(0xFFF8F4EE),
      cardForeground: Color(0xFF4A3B33),
      popover: Color(0xFFF8F4EE),
      popoverForeground: Color(0xFF4A3B33),
      primary: Color(0xFFB45309),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFE4C090),
      secondaryForeground: Color(0xFF57534E),
      muted: Color(0xFFF1E9DA),
      mutedForeground: Color(0xFF78716C),
      accent: Color(0xFFF2DABA),
      accentForeground: Color(0xFF57534E),
      destructive: Color(0xFF991B1B),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFE4D9BC),
      input: Color(0xFFE4D9BC),
      ring: Color(0xFFB45309),
      chart1: Color(0xFFB45309),
      chart2: Color(0xFF78716C),
      chart3: Color(0xFFA16207),
      chart4: Color(0xFF78716C),
      chart5: Color(0xFFCA8A04),
      sidebar: Color(0xFFF1E9DA),
      sidebarForeground: Color(0xFF4A3B33),
      sidebarPrimary: Color(0xFFB45309),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFFA16207),
      sidebarAccentForeground: Color(0xFFFFFFFF),
      sidebarBorder: Color(0xFFE4D9BC),
      sidebarRing: Color(0xFFB45309),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF1C1917),
      foreground: Color(0xFFF5F5F4),
      card: Color(0xFF292524),
      cardForeground: Color(0xFFF5F5F4),
      popover: Color(0xFF292524),
      popoverForeground: Color(0xFFF5F5F4),
      primary: Color(0xFFF97316),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFF57534E),
      secondaryForeground: Color(0xFFE7E5E4),
      muted: Color(0xFF201D1A),
      mutedForeground: Color(0xFFA8A29E),
      accent: Color(0xFF1E4252),
      accentForeground: Color(0xFFE7E5E4),
      destructive: Color(0xFFDC2626),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFF44403C),
      input: Color(0xFF44403C),
      ring: Color(0xFFF97316),
      chart1: Color(0xFFF97316),
      chart2: Color(0xFF0EA5E9),
      chart3: Color(0xFFEAB308),
      chart4: Color(0xFFA8A29E),
      chart5: Color(0xFF78716C),
      sidebar: Color(0xFF292524),
      sidebarForeground: Color(0xFFF5F5F4),
      sidebarPrimary: Color(0xFFF97316),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFF0EA5E9),
      sidebarAccentForeground: Color(0xFF0C2A4D),
      sidebarBorder: Color(0xFF44403C),
      sidebarRing: Color(0xFFF97316),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 0.3,
      spacing: SpacingScale(3.84),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x2E4B3F34),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x2E4B3F34),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x2E4B3F34),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x2E4B3F34),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x2E4B3F34),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x2E4B3F34),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x2E4B3F34),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x2E4B3F34),
          ),
        ],
      ),
      fontSans: "Oxanium, sans-serif",
      fontSerif: "Merriweather, serif",
      fontMono: "Fira Code, monospace",
    ),
    darkTokens: RegistryThemePresetTokens(
      radius: 0.3,
      spacing: SpacingScale(3.84),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF0D0D0D),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF0D0D0D),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF0D0D0D),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF0D0D0D),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF0D0D0D),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF0D0D0D),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF0D0D0D),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF0D0D0D),
          ),
        ],
      ),
    ),
  ),
];
