// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: vintage-paper.json
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
    id: 'vintage-paper',
    name: "Vintage Paper",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFF5F1E6),
      foreground: Color(0xFF4A3F35),
      card: Color(0xFFFFFCF5),
      cardForeground: Color(0xFF4A3F35),
      popover: Color(0xFFFFFCF5),
      popoverForeground: Color(0xFF4A3F35),
      primary: Color(0xFFA67C52),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFE2D8C3),
      secondaryForeground: Color(0xFF5C4D3F),
      muted: Color(0xFFECE5D8),
      mutedForeground: Color(0xFF7D6B56),
      accent: Color(0xFFD4C8AA),
      accentForeground: Color(0xFF4A3F35),
      destructive: Color(0xFFB54A35),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFDBD0BA),
      input: Color(0xFFDBD0BA),
      ring: Color(0xFFA67C52),
      chart1: Color(0xFFA67C52),
      chart2: Color(0xFF8D6E4C),
      chart3: Color(0xFF735A3A),
      chart4: Color(0xFFB3906F),
      chart5: Color(0xFFC0A080),
      sidebar: Color(0xFFECE5D8),
      sidebarForeground: Color(0xFF4A3F35),
      sidebarPrimary: Color(0xFFA67C52),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFFD4C8AA),
      sidebarAccentForeground: Color(0xFF4A3F35),
      sidebarBorder: Color(0xFFDBD0BA),
      sidebarRing: Color(0xFFA67C52),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF2D2621),
      foreground: Color(0xFFECE5D8),
      card: Color(0xFF3A322C),
      cardForeground: Color(0xFFECE5D8),
      popover: Color(0xFF3A322C),
      popoverForeground: Color(0xFFECE5D8),
      primary: Color(0xFFC0A080),
      primaryForeground: Color(0xFF2D2621),
      secondary: Color(0xFF4A4039),
      secondaryForeground: Color(0xFFECE5D8),
      muted: Color(0xFF312B26),
      mutedForeground: Color(0xFFC5BCAC),
      accent: Color(0xFF59493E),
      accentForeground: Color(0xFFECE5D8),
      destructive: Color(0xFFB54A35),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFF4A4039),
      input: Color(0xFF4A4039),
      ring: Color(0xFFC0A080),
      chart1: Color(0xFFC0A080),
      chart2: Color(0xFFB3906F),
      chart3: Color(0xFFA67C52),
      chart4: Color(0xFF8D6E4C),
      chart5: Color(0xFF735A3A),
      sidebar: Color(0xFF2D2621),
      sidebarForeground: Color(0xFFECE5D8),
      sidebarPrimary: Color(0xFFC0A080),
      sidebarPrimaryForeground: Color(0xFF2D2621),
      sidebarAccent: Color(0xFF59493E),
      sidebarAccentForeground: Color(0xFFECE5D8),
      sidebarBorder: Color(0xFF4A4039),
      sidebarRing: Color(0xFFC0A080),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 0.25,
      spacing: SpacingScale(3.84),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(2, 3),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x1F3A332C),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(2, 3),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x1F3A332C),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(2, 3),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x1F3A332C),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(2, 3),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x1F3A332C),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(2, 3),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x1F3A332C),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(2, 3),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x1F3A332C),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(2, 3),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x1F3A332C),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(2, 3),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x1F3A332C),
          ),
        ],
      ),
      fontSans: "Libre Baskerville, serif",
      fontSerif: "Lora, serif",
      fontMono: "IBM Plex Mono, monospace",
    ),
    darkTokens: RegistryThemePresetTokens(
      radius: 0.25,
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
