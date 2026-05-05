// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: amber-minimal.json
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
    id: 'amber-minimal',
    name: "Amber Minimal",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFFFFFFF),
      foreground: Color(0xFF262626),
      card: Color(0xFFFFFFFF),
      cardForeground: Color(0xFF262626),
      popover: Color(0xFFFFFFFF),
      popoverForeground: Color(0xFF262626),
      primary: Color(0xFFF59E0B),
      primaryForeground: Color(0xFF000000),
      secondary: Color(0xFFF3F4F6),
      secondaryForeground: Color(0xFF4B5563),
      muted: Color(0xFFF9FAFB),
      mutedForeground: Color(0xFF6B7280),
      accent: Color(0xFFFFFBEB),
      accentForeground: Color(0xFF92400E),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFE5E7EB),
      input: Color(0xFFE5E7EB),
      ring: Color(0xFFF59E0B),
      chart1: Color(0xFFF59E0B),
      chart2: Color(0xFFD97706),
      chart3: Color(0xFFB45309),
      chart4: Color(0xFF92400E),
      chart5: Color(0xFF78350F),
      sidebar: Color(0xFFF9FAFB),
      sidebarForeground: Color(0xFF262626),
      sidebarPrimary: Color(0xFFF59E0B),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFFFFFBEB),
      sidebarAccentForeground: Color(0xFF92400E),
      sidebarBorder: Color(0xFFE5E7EB),
      sidebarRing: Color(0xFFF59E0B),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF171717),
      foreground: Color(0xFFE5E5E5),
      card: Color(0xFF262626),
      cardForeground: Color(0xFFE5E5E5),
      popover: Color(0xFF262626),
      popoverForeground: Color(0xFFE5E5E5),
      primary: Color(0xFFF59E0B),
      primaryForeground: Color(0xFF000000),
      secondary: Color(0xFF262626),
      secondaryForeground: Color(0xFFE5E5E5),
      muted: Color(0xFF1F1F1F),
      mutedForeground: Color(0xFFA3A3A3),
      accent: Color(0xFF92400E),
      accentForeground: Color(0xFFFDE68A),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFF404040),
      input: Color(0xFF404040),
      ring: Color(0xFFF59E0B),
      chart1: Color(0xFFFBBF24),
      chart2: Color(0xFFD97706),
      chart3: Color(0xFF92400E),
      chart4: Color(0xFFB45309),
      chart5: Color(0xFF92400E),
      sidebar: Color(0xFF0F0F0F),
      sidebarForeground: Color(0xFFE5E5E5),
      sidebarPrimary: Color(0xFFF59E0B),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFF92400E),
      sidebarAccentForeground: Color(0xFFFDE68A),
      sidebarBorder: Color(0xFF404040),
      sidebarRing: Color(0xFFF59E0B),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 0.375,
      spacing: SpacingScale(4),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 8,
            spreadRadius: -1,
            color: Color(0x1A000000),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 8,
            spreadRadius: -1,
            color: Color(0x1A000000),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 8,
            spreadRadius: -1,
            color: Color(0x1A000000),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 8,
            spreadRadius: -1,
            color: Color(0x1A000000),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 8,
            spreadRadius: -1,
            color: Color(0x1A000000),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 8,
            spreadRadius: -1,
            color: Color(0x1A000000),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 8,
            spreadRadius: -1,
            color: Color(0x1A000000),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 8,
            spreadRadius: -1,
            color: Color(0x1A000000),
          ),
        ],
      ),
      fontSans: "Inter, sans-serif",
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
