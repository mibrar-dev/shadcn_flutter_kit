// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: sunset-horizon.json
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
    id: 'sunset-horizon',
    name: "Sunset Horizon",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFFFF9F5),
      foreground: Color(0xFF3D3436),
      card: Color(0xFFFFFFFF),
      cardForeground: Color(0xFF3D3436),
      popover: Color(0xFFFFFFFF),
      popoverForeground: Color(0xFF3D3436),
      primary: Color(0xFFFF7E5F),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFFFEDEA),
      secondaryForeground: Color(0xFFB35340),
      muted: Color(0xFFFFF0EB),
      mutedForeground: Color(0xFF78716C),
      accent: Color(0xFFFEB47B),
      accentForeground: Color(0xFF3D3436),
      destructive: Color(0xFFE63946),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFFFE0D6),
      input: Color(0xFFFFE0D6),
      ring: Color(0xFFFF7E5F),
      chart1: Color(0xFFFF7E5F),
      chart2: Color(0xFFFEB47B),
      chart3: Color(0xFFFFCAA7),
      chart4: Color(0xFFFFAD8F),
      chart5: Color(0xFFCE6A57),
      sidebar: Color(0xFFFFF0EB),
      sidebarForeground: Color(0xFF3D3436),
      sidebarPrimary: Color(0xFFFF7E5F),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFFFEB47B),
      sidebarAccentForeground: Color(0xFF3D3436),
      sidebarBorder: Color(0xFFFFE0D6),
      sidebarRing: Color(0xFFFF7E5F),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF2A2024),
      foreground: Color(0xFFF2E9E4),
      card: Color(0xFF392F35),
      cardForeground: Color(0xFFF2E9E4),
      popover: Color(0xFF392F35),
      popoverForeground: Color(0xFFF2E9E4),
      primary: Color(0xFFFF7E5F),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFF463A41),
      secondaryForeground: Color(0xFFF2E9E4),
      muted: Color(0xFF30272C),
      mutedForeground: Color(0xFFD7C6BC),
      accent: Color(0xFFFEB47B),
      accentForeground: Color(0xFF2A2024),
      destructive: Color(0xFFE63946),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFF463A41),
      input: Color(0xFF463A41),
      ring: Color(0xFFFF7E5F),
      chart1: Color(0xFFFF7E5F),
      chart2: Color(0xFFFEB47B),
      chart3: Color(0xFFFFCAA7),
      chart4: Color(0xFFFFAD8F),
      chart5: Color(0xFFCE6A57),
      sidebar: Color(0xFF2A2024),
      sidebarForeground: Color(0xFFF2E9E4),
      sidebarPrimary: Color(0xFFFF7E5F),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFFFEB47B),
      sidebarAccentForeground: Color(0xFF2A2024),
      sidebarBorder: Color(0xFF463A41),
      sidebarRing: Color(0xFFFF7E5F),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 0.625,
      spacing: SpacingScale(3.84),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(0, 6),
            blurRadius: 12,
            spreadRadius: -3,
            color: Color(0x17000000),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 6),
            blurRadius: 12,
            spreadRadius: -3,
            color: Color(0x17000000),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 6),
            blurRadius: 12,
            spreadRadius: -3,
            color: Color(0x17000000),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 6),
            blurRadius: 12,
            spreadRadius: -3,
            color: Color(0x17000000),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 6),
            blurRadius: 12,
            spreadRadius: -3,
            color: Color(0x17000000),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 6),
            blurRadius: 12,
            spreadRadius: -3,
            color: Color(0x17000000),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 6),
            blurRadius: 12,
            spreadRadius: -3,
            color: Color(0x17000000),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 6),
            blurRadius: 12,
            spreadRadius: -3,
            color: Color(0x17000000),
          ),
        ],
      ),
      fontSans: "Montserrat, sans-serif",
      fontSerif: "Merriweather, serif",
      fontMono: "Ubuntu Mono, monospace",
    ),
    darkTokens: RegistryThemePresetTokens(
      radius: 0.625,
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
