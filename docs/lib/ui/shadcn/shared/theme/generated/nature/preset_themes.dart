// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: nature.json
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
    id: 'nature',
    name: "Nature",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFF8F5F0),
      foreground: Color(0xFF3E2723),
      card: Color(0xFFF8F5F0),
      cardForeground: Color(0xFF3E2723),
      popover: Color(0xFFF8F5F0),
      popoverForeground: Color(0xFF3E2723),
      primary: Color(0xFF2E7D32),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFE8F5E9),
      secondaryForeground: Color(0xFF1B5E20),
      muted: Color(0xFFF0E9E0),
      mutedForeground: Color(0xFF6D4C41),
      accent: Color(0xFFC8E6C9),
      accentForeground: Color(0xFF1B5E20),
      destructive: Color(0xFFC62828),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFE0D6C9),
      input: Color(0xFFE0D6C9),
      ring: Color(0xFF2E7D32),
      chart1: Color(0xFF4CAF50),
      chart2: Color(0xFF388E3C),
      chart3: Color(0xFF2E7D32),
      chart4: Color(0xFF1B5E20),
      chart5: Color(0xFF0A1F0C),
      sidebar: Color(0xFFF0E9E0),
      sidebarForeground: Color(0xFF3E2723),
      sidebarPrimary: Color(0xFF2E7D32),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFFC8E6C9),
      sidebarAccentForeground: Color(0xFF1B5E20),
      sidebarBorder: Color(0xFFE0D6C9),
      sidebarRing: Color(0xFF2E7D32),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF1C2A1F),
      foreground: Color(0xFFF0EBE5),
      card: Color(0xFF2D3A2E),
      cardForeground: Color(0xFFF0EBE5),
      popover: Color(0xFF2D3A2E),
      popoverForeground: Color(0xFFF0EBE5),
      primary: Color(0xFF4CAF50),
      primaryForeground: Color(0xFF0A1F0C),
      secondary: Color(0xFF3E4A3D),
      secondaryForeground: Color(0xFFD7E0D6),
      muted: Color(0xFF252F26),
      mutedForeground: Color(0xFFD7CFC4),
      accent: Color(0xFF388E3C),
      accentForeground: Color(0xFFF0EBE5),
      destructive: Color(0xFFC62828),
      destructiveForeground: Color(0xFFF0EBE5),
      border: Color(0xFF3E4A3D),
      input: Color(0xFF3E4A3D),
      ring: Color(0xFF4CAF50),
      chart1: Color(0xFF81C784),
      chart2: Color(0xFF66BB6A),
      chart3: Color(0xFF4CAF50),
      chart4: Color(0xFF43A047),
      chart5: Color(0xFF388E3C),
      sidebar: Color(0xFF1C2A1F),
      sidebarForeground: Color(0xFFF0EBE5),
      sidebarPrimary: Color(0xFF4CAF50),
      sidebarPrimaryForeground: Color(0xFF0A1F0C),
      sidebarAccent: Color(0xFF388E3C),
      sidebarAccentForeground: Color(0xFFF0EBE5),
      sidebarBorder: Color(0xFF3E4A3D),
      sidebarRing: Color(0xFF4CAF50),
    ),
    lightTokens: RegistryThemePresetTokens(
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
      fontSans: "Montserrat, sans-serif",
      fontSerif: "Merriweather, serif",
      fontMono: "Source Code Pro, monospace",
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
