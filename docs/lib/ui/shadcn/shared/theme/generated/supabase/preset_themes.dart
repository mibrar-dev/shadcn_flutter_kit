// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: supabase.json
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
    id: 'supabase',
    name: "Supabase",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFFCFCFC),
      foreground: Color(0xFF171717),
      card: Color(0xFFFCFCFC),
      cardForeground: Color(0xFF171717),
      popover: Color(0xFFFCFCFC),
      popoverForeground: Color(0xFF525252),
      primary: Color(0xFF72E3AD),
      primaryForeground: Color(0xFF1E2723),
      secondary: Color(0xFFFDFDFD),
      secondaryForeground: Color(0xFF171717),
      muted: Color(0xFFEDEDED),
      mutedForeground: Color(0xFF202020),
      accent: Color(0xFFEDEDED),
      accentForeground: Color(0xFF202020),
      destructive: Color(0xFFCA3214),
      destructiveForeground: Color(0xFFFFFCFC),
      border: Color(0xFFDFDFDF),
      input: Color(0xFFF6F6F6),
      ring: Color(0xFF72E3AD),
      chart1: Color(0xFF72E3AD),
      chart2: Color(0xFF3B82F6),
      chart3: Color(0xFF8B5CF6),
      chart4: Color(0xFFF59E0B),
      chart5: Color(0xFF10B981),
      sidebar: Color(0xFFFCFCFC),
      sidebarForeground: Color(0xFF707070),
      sidebarPrimary: Color(0xFF72E3AD),
      sidebarPrimaryForeground: Color(0xFF1E2723),
      sidebarAccent: Color(0xFFEDEDED),
      sidebarAccentForeground: Color(0xFF202020),
      sidebarBorder: Color(0xFFDFDFDF),
      sidebarRing: Color(0xFF72E3AD),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF121212),
      foreground: Color(0xFFE2E8F0),
      card: Color(0xFF171717),
      cardForeground: Color(0xFFE2E8F0),
      popover: Color(0xFF242424),
      popoverForeground: Color(0xFFA9A9A9),
      primary: Color(0xFF006239),
      primaryForeground: Color(0xFFDDE8E3),
      secondary: Color(0xFF242424),
      secondaryForeground: Color(0xFFFAFAFA),
      muted: Color(0xFF1F1F1F),
      mutedForeground: Color(0xFFA2A2A2),
      accent: Color(0xFF313131),
      accentForeground: Color(0xFFFAFAFA),
      destructive: Color(0xFF541C15),
      destructiveForeground: Color(0xFFEDE9E8),
      border: Color(0xFF292929),
      input: Color(0xFF242424),
      ring: Color(0xFF4ADE80),
      chart1: Color(0xFF4ADE80),
      chart2: Color(0xFF60A5FA),
      chart3: Color(0xFFA78BFA),
      chart4: Color(0xFFFBBF24),
      chart5: Color(0xFF2DD4BF),
      sidebar: Color(0xFF121212),
      sidebarForeground: Color(0xFF898989),
      sidebarPrimary: Color(0xFF006239),
      sidebarPrimaryForeground: Color(0xFFDDE8E3),
      sidebarAccent: Color(0xFF313131),
      sidebarAccentForeground: Color(0xFFFAFAFA),
      sidebarBorder: Color(0xFF292929),
      sidebarRing: Color(0xFF4ADE80),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 0.5,
      spacing: SpacingScale(3.84),
      tracking: TrackingScale(normal: 0.4),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x2B000000),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x2B000000),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x2B000000),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x2B000000),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x2B000000),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x2B000000),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x2B000000),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x2B000000),
          ),
        ],
      ),
      fontSans: "Outfit, sans-serif",
      fontSerif: "ui-serif, Georgia, Cambria, \\",
      fontMono: "monospace",
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
