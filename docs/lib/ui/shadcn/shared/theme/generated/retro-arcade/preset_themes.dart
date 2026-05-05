// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: retro-arcade.json
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
    id: 'retro-arcade',
    name: "Retro Arcade",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFFDF6E3),
      foreground: Color(0xFF073642),
      card: Color(0xFFEEE8D5),
      cardForeground: Color(0xFF073642),
      popover: Color(0xFFEEE8D5),
      popoverForeground: Color(0xFF073642),
      primary: Color(0xFFD33682),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFF2AA198),
      secondaryForeground: Color(0xFFFFFFFF),
      muted: Color(0xFF93A1A1),
      mutedForeground: Color(0xFF073642),
      accent: Color(0xFFCB4B16),
      accentForeground: Color(0xFFFFFFFF),
      destructive: Color(0xFFDC322F),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFF839496),
      input: Color(0xFF839496),
      ring: Color(0xFFD33682),
      chart1: Color(0xFF268BD2),
      chart2: Color(0xFF2AA198),
      chart3: Color(0xFFD33682),
      chart4: Color(0xFFCB4B16),
      chart5: Color(0xFFDC322F),
      sidebar: Color(0xFFFDF6E3),
      sidebarForeground: Color(0xFF073642),
      sidebarPrimary: Color(0xFFD33682),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFF2AA198),
      sidebarAccentForeground: Color(0xFFFFFFFF),
      sidebarBorder: Color(0xFF839496),
      sidebarRing: Color(0xFFD33682),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF002B36),
      foreground: Color(0xFF93A1A1),
      card: Color(0xFF073642),
      cardForeground: Color(0xFF93A1A1),
      popover: Color(0xFF073642),
      popoverForeground: Color(0xFF93A1A1),
      primary: Color(0xFFD33682),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFF2AA198),
      secondaryForeground: Color(0xFFFFFFFF),
      muted: Color(0xFF586E75),
      mutedForeground: Color(0xFF93A1A1),
      accent: Color(0xFFCB4B16),
      accentForeground: Color(0xFFFFFFFF),
      destructive: Color(0xFFDC322F),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFF586E75),
      input: Color(0xFF586E75),
      ring: Color(0xFFD33682),
      chart1: Color(0xFF268BD2),
      chart2: Color(0xFF2AA198),
      chart3: Color(0xFFD33682),
      chart4: Color(0xFFCB4B16),
      chart5: Color(0xFFDC322F),
      sidebar: Color(0xFF002B36),
      sidebarForeground: Color(0xFF93A1A1),
      sidebarPrimary: Color(0xFFD33682),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFF2AA198),
      sidebarAccentForeground: Color(0xFFFFFFFF),
      sidebarBorder: Color(0xFF586E75),
      sidebarRing: Color(0xFFD33682),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 0.25,
      spacing: SpacingScale(3.84),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x2604232F),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x2604232F),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x2604232F),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x2604232F),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x2604232F),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x2604232F),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x2604232F),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x2604232F),
          ),
        ],
      ),
      fontSans: "Outfit, sans-serif",
      fontMono: "Space Mono, monospace",
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
