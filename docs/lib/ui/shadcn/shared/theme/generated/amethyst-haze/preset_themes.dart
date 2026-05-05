// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: amethyst-haze.json
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
    id: 'amethyst-haze',
    name: "Amethyst Haze",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFF8F7FA),
      foreground: Color(0xFF3D3C4F),
      card: Color(0xFFFFFFFF),
      cardForeground: Color(0xFF3D3C4F),
      popover: Color(0xFFFFFFFF),
      popoverForeground: Color(0xFF3D3C4F),
      primary: Color(0xFF8A79AB),
      primaryForeground: Color(0xFFF8F7FA),
      secondary: Color(0xFFDFD9EC),
      secondaryForeground: Color(0xFF3D3C4F),
      muted: Color(0xFFDCD9E3),
      mutedForeground: Color(0xFF6B6880),
      accent: Color(0xFFE6A5B8),
      accentForeground: Color(0xFF4B2E36),
      destructive: Color(0xFFD95C5C),
      destructiveForeground: Color(0xFFF8F7FA),
      border: Color(0xFFCEC9D9),
      input: Color(0xFFEAE7F0),
      ring: Color(0xFF8A79AB),
      chart1: Color(0xFF8A79AB),
      chart2: Color(0xFFE6A5B8),
      chart3: Color(0xFF77B8A1),
      chart4: Color(0xFFF0C88D),
      chart5: Color(0xFFA0BBE3),
      sidebar: Color(0xFFF1EFF5),
      sidebarForeground: Color(0xFF3D3C4F),
      sidebarPrimary: Color(0xFF8A79AB),
      sidebarPrimaryForeground: Color(0xFFF8F7FA),
      sidebarAccent: Color(0xFFE6A5B8),
      sidebarAccentForeground: Color(0xFF4B2E36),
      sidebarBorder: Color(0xFFD7D2E0),
      sidebarRing: Color(0xFF8A79AB),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF1A1823),
      foreground: Color(0xFFE0DDEF),
      card: Color(0xFF232030),
      cardForeground: Color(0xFFE0DDEF),
      popover: Color(0xFF232030),
      popoverForeground: Color(0xFFE0DDEF),
      primary: Color(0xFFA995C9),
      primaryForeground: Color(0xFF1A1823),
      secondary: Color(0xFF5A5370),
      secondaryForeground: Color(0xFFE0DDEF),
      muted: Color(0xFF242031),
      mutedForeground: Color(0xFFA09AAD),
      accent: Color(0xFF372E3F),
      accentForeground: Color(0xFFF2B8C6),
      destructive: Color(0xFFE57373),
      destructiveForeground: Color(0xFF1A1823),
      border: Color(0xFF302C40),
      input: Color(0xFF2A273A),
      ring: Color(0xFFA995C9),
      chart1: Color(0xFFA995C9),
      chart2: Color(0xFFF2B8C6),
      chart3: Color(0xFF77B8A1),
      chart4: Color(0xFFF0C88D),
      chart5: Color(0xFFA0BBE3),
      sidebar: Color(0xFF16141E),
      sidebarForeground: Color(0xFFE0DDEF),
      sidebarPrimary: Color(0xFFA995C9),
      sidebarPrimaryForeground: Color(0xFF1A1823),
      sidebarAccent: Color(0xFF372E3F),
      sidebarAccentForeground: Color(0xFFF2B8C6),
      sidebarBorder: Color(0xFF2A273A),
      sidebarRing: Color(0xFFA995C9),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 0.5,
      spacing: SpacingScale(4),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(1, 2),
            blurRadius: 5,
            spreadRadius: 1,
            color: Color(0x0F000000),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(1, 2),
            blurRadius: 5,
            spreadRadius: 1,
            color: Color(0x0F000000),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(1, 2),
            blurRadius: 5,
            spreadRadius: 1,
            color: Color(0x0F000000),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(1, 2),
            blurRadius: 5,
            spreadRadius: 1,
            color: Color(0x0F000000),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(1, 2),
            blurRadius: 5,
            spreadRadius: 1,
            color: Color(0x0F000000),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(1, 2),
            blurRadius: 5,
            spreadRadius: 1,
            color: Color(0x0F000000),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(1, 2),
            blurRadius: 5,
            spreadRadius: 1,
            color: Color(0x0F000000),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(1, 2),
            blurRadius: 5,
            spreadRadius: 1,
            color: Color(0x0F000000),
          ),
        ],
      ),
      fontSans: "Geist, sans-serif",
      fontSerif: "\\",
      fontMono: "\\",
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
