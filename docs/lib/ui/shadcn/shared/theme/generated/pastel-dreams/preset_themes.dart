// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: pastel-dreams.json
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
    id: 'pastel-dreams',
    name: "Pastel Dreams",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFF7F3F9),
      foreground: Color(0xFF374151),
      card: Color(0xFFFFFFFF),
      cardForeground: Color(0xFF374151),
      popover: Color(0xFFFFFFFF),
      popoverForeground: Color(0xFF374151),
      primary: Color(0xFFA78BFA),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFE9D8FD),
      secondaryForeground: Color(0xFF4B5563),
      muted: Color(0xFFF3E8FF),
      mutedForeground: Color(0xFF6B7280),
      accent: Color(0xFFF3E5F5),
      accentForeground: Color(0xFF374151),
      destructive: Color(0xFFFCA5A5),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFE9D8FD),
      input: Color(0xFFE9D8FD),
      ring: Color(0xFFA78BFA),
      chart1: Color(0xFFA78BFA),
      chart2: Color(0xFF8B5CF6),
      chart3: Color(0xFF7C3AED),
      chart4: Color(0xFF6D28D9),
      chart5: Color(0xFF5B21B6),
      sidebar: Color(0xFFE9D8FD),
      sidebarForeground: Color(0xFF374151),
      sidebarPrimary: Color(0xFFA78BFA),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFFF3E5F5),
      sidebarAccentForeground: Color(0xFF374151),
      sidebarBorder: Color(0xFFE9D8FD),
      sidebarRing: Color(0xFFA78BFA),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF1C1917),
      foreground: Color(0xFFE0E7FF),
      card: Color(0xFF2D2535),
      cardForeground: Color(0xFFE0E7FF),
      popover: Color(0xFF2D2535),
      popoverForeground: Color(0xFFE0E7FF),
      primary: Color(0xFFC0AAFD),
      primaryForeground: Color(0xFF1C1917),
      secondary: Color(0xFF3F324A),
      secondaryForeground: Color(0xFFD1D5DB),
      muted: Color(0xFF20182B),
      mutedForeground: Color(0xFF9CA3AF),
      accent: Color(0xFF4A3D5A),
      accentForeground: Color(0xFFD1D5DB),
      destructive: Color(0xFFFCA5A5),
      destructiveForeground: Color(0xFF1C1917),
      border: Color(0xFF3F324A),
      input: Color(0xFF3F324A),
      ring: Color(0xFFC0AAFD),
      chart1: Color(0xFFC0AAFD),
      chart2: Color(0xFFA78BFA),
      chart3: Color(0xFF8B5CF6),
      chart4: Color(0xFF7C3AED),
      chart5: Color(0xFF6D28D9),
      sidebar: Color(0xFF3F324A),
      sidebarForeground: Color(0xFFE0E7FF),
      sidebarPrimary: Color(0xFFC0AAFD),
      sidebarPrimaryForeground: Color(0xFF1C1917),
      sidebarAccent: Color(0xFF4A3D5A),
      sidebarAccentForeground: Color(0xFFD1D5DB),
      sidebarBorder: Color(0xFF3F324A),
      sidebarRing: Color(0xFFC0AAFD),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 1.5,
      spacing: SpacingScale(3.84),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(0, 8),
            blurRadius: 16,
            spreadRadius: -4,
            color: Color(0x14000000),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 8),
            blurRadius: 16,
            spreadRadius: -4,
            color: Color(0x14000000),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 8),
            blurRadius: 16,
            spreadRadius: -4,
            color: Color(0x14000000),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 8),
            blurRadius: 16,
            spreadRadius: -4,
            color: Color(0x14000000),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 8),
            blurRadius: 16,
            spreadRadius: -4,
            color: Color(0x14000000),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 8),
            blurRadius: 16,
            spreadRadius: -4,
            color: Color(0x14000000),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 8),
            blurRadius: 16,
            spreadRadius: -4,
            color: Color(0x14000000),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 8),
            blurRadius: 16,
            spreadRadius: -4,
            color: Color(0x14000000),
          ),
        ],
      ),
      fontSans: "Open Sans, sans-serif",
      fontSerif: "Source Serif 4, serif",
      fontMono: "IBM Plex Mono, monospace",
    ),
    darkTokens: RegistryThemePresetTokens(
      radius: 1.5,
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
