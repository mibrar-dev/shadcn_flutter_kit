// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: kodama-grove.json
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
    id: 'kodama-grove',
    name: "Kodama Grove",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFE4D7B0),
      foreground: Color(0xFF5C4B3E),
      card: Color(0xFFE7DBBF),
      cardForeground: Color(0xFF5C4B3E),
      popover: Color(0xFFF3EAD2),
      popoverForeground: Color(0xFF5C4B3E),
      primary: Color(0xFF8D9D4F),
      primaryForeground: Color(0xFFFDFBF6),
      secondary: Color(0xFFDECEA0),
      secondaryForeground: Color(0xFF5C4B3E),
      muted: Color(0xFFDECEA0),
      mutedForeground: Color(0xFF85766A),
      accent: Color(0xFFDBC894),
      accentForeground: Color(0xFF5C4B3E),
      destructive: Color(0xFFD98B7E),
      destructiveForeground: Color(0xFFFAF8F2),
      border: Color(0xFFB19681),
      input: Color(0xFFDBC894),
      ring: Color(0xFF9DB18C),
      chart1: Color(0xFF9DB18C),
      chart2: Color(0xFF8A9F7B),
      chart3: Color(0xFFBAC9B4),
      chart4: Color(0xFF71856A),
      chart5: Color(0xFF5E6E58),
      sidebar: Color(0xFFE2D1A2),
      sidebarForeground: Color(0xFF5C4B3E),
      sidebarPrimary: Color(0xFF9DB18C),
      sidebarPrimaryForeground: Color(0xFFFDFBF6),
      sidebarAccent: Color(0xFFEAE5D9),
      sidebarAccentForeground: Color(0xFF5C4B3E),
      sidebarBorder: Color(0xFFE5E0D4),
      sidebarRing: Color(0xFF9DB18C),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF3A3529),
      foreground: Color(0xFFEDE4D4),
      card: Color(0xFF413C33),
      cardForeground: Color(0xFFEDE4D4),
      popover: Color(0xFF413C33),
      popoverForeground: Color(0xFFEDE4D4),
      primary: Color(0xFF8A9F7B),
      primaryForeground: Color(0xFF2A2521),
      secondary: Color(0xFF5A5345),
      secondaryForeground: Color(0xFFEDE4D4),
      muted: Color(0xFF4A4439),
      mutedForeground: Color(0xFFA8A096),
      accent: Color(0xFFA18F5C),
      accentForeground: Color(0xFF2A2521),
      destructive: Color(0xFFB5766A),
      destructiveForeground: Color(0xFFF0E9DB),
      border: Color(0xFF5A5345),
      input: Color(0xFF5A5345),
      ring: Color(0xFF8A9F7B),
      chart1: Color(0xFF8A9F7B),
      chart2: Color(0xFF9DB18C),
      chart3: Color(0xFF71856A),
      chart4: Color(0xFFA18F5C),
      chart5: Color(0xFF5E6E58),
      sidebar: Color(0xFF3A3529),
      sidebarForeground: Color(0xFFEDE4D4),
      sidebarPrimary: Color(0xFF8A9F7B),
      sidebarPrimaryForeground: Color(0xFF2A2521),
      sidebarAccent: Color(0xFFA18F5C),
      sidebarAccentForeground: Color(0xFF2A2521),
      sidebarBorder: Color(0xFF5A5345),
      sidebarRing: Color(0xFF8A9F7B),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 0.425,
      spacing: SpacingScale(3.84),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(3, 3),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x065B6D46),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(3, 3),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x065B6D46),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(3, 3),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x065B6D46),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(3, 3),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x065B6D46),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(3, 3),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x065B6D46),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(3, 3),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x065B6D46),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(3, 3),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x065B6D46),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(3, 3),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x065B6D46),
          ),
        ],
      ),
      fontSans: "Merriweather, serif",
      fontSerif: "Source Serif 4, serif",
      fontMono: "JetBrains Mono, monospace",
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
