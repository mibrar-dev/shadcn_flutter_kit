// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: bubblegum.json
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
    id: 'bubblegum',
    name: "Bubblegum",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFF6E6EE),
      foreground: Color(0xFF5B5B5B),
      card: Color(0xFFFDEDC9),
      cardForeground: Color(0xFF5B5B5B),
      popover: Color(0xFFFFFFFF),
      popoverForeground: Color(0xFF5B5B5B),
      primary: Color(0xFFD04F99),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFF8ACFD1),
      secondaryForeground: Color(0xFF333333),
      muted: Color(0xFFB2E1EB),
      mutedForeground: Color(0xFF7A7A7A),
      accent: Color(0xFFFBE2A7),
      accentForeground: Color(0xFF333333),
      destructive: Color(0xFFF96F70),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFD04F99),
      input: Color(0xFFE4E4E4),
      ring: Color(0xFFE670AB),
      chart1: Color(0xFFE670AB),
      chart2: Color(0xFF84D2E2),
      chart3: Color(0xFFFBE2A7),
      chart4: Color(0xFFF3A0CA),
      chart5: Color(0xFFD7488E),
      sidebar: Color(0xFFF8D8EA),
      sidebarForeground: Color(0xFF333333),
      sidebarPrimary: Color(0xFFEC4899),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFFF9A8D4),
      sidebarAccentForeground: Color(0xFF333333),
      sidebarBorder: Color(0xFFF3E8FF),
      sidebarRing: Color(0xFFEC4899),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF12242E),
      foreground: Color(0xFFF3E3EA),
      card: Color(0xFF1C2E38),
      cardForeground: Color(0xFFF3E3EA),
      popover: Color(0xFF1C2E38),
      popoverForeground: Color(0xFFF3E3EA),
      primary: Color(0xFFFBE2A7),
      primaryForeground: Color(0xFF12242E),
      secondary: Color(0xFFE4A2B1),
      secondaryForeground: Color(0xFF12242E),
      muted: Color(0xFF24272B),
      mutedForeground: Color(0xFFE4A2B1),
      accent: Color(0xFFC67B96),
      accentForeground: Color(0xFFF3E3EA),
      destructive: Color(0xFFE35EA4),
      destructiveForeground: Color(0xFF12242E),
      border: Color(0xFF324859),
      input: Color(0xFF20333D),
      ring: Color(0xFF50AFB6),
      chart1: Color(0xFF50AFB6),
      chart2: Color(0xFFE4A2B1),
      chart3: Color(0xFFC67B96),
      chart4: Color(0xFF175C6C),
      chart5: Color(0xFF24272B),
      sidebar: Color(0xFF101F28),
      sidebarForeground: Color(0xFFF3F4F6),
      sidebarPrimary: Color(0xFFEC4899),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFFF9A8D4),
      sidebarAccentForeground: Color(0xFF1F2937),
      sidebarBorder: Color(0xFF374151),
      sidebarRing: Color(0xFFEC4899),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 0.4,
      spacing: SpacingScale(3.84),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(3, 3),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x80D1519A),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(3, 3),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x80D1519A),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(3, 3),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x80D1519A),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(3, 3),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x80D1519A),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(3, 3),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x80D1519A),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(3, 3),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x80D1519A),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(3, 3),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x80D1519A),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(3, 3),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x80D1519A),
          ),
        ],
      ),
      fontSans: "Poppins, sans-serif",
      fontSerif: "Lora, serif",
      fontMono: "Fira Code, monospace",
    ),
    darkTokens: RegistryThemePresetTokens(
      radius: 0.5,
      spacing: SpacingScale(3.84),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF324859),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF324859),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF324859),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF324859),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF324859),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF324859),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF324859),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF324859),
          ),
        ],
      ),
      fontSans: "Poppins, sans-serif",
      fontSerif: "Lora, serif",
      fontMono: "Fira Code, monospace",
    ),
  ),
];
