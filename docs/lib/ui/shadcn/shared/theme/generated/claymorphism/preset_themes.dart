// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: claymorphism.json
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
    id: 'claymorphism',
    name: "Claymorphism",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFE7E5E4),
      foreground: Color(0xFF1E293B),
      card: Color(0xFFF5F5F4),
      cardForeground: Color(0xFF1E293B),
      popover: Color(0xFFF5F5F4),
      popoverForeground: Color(0xFF1E293B),
      primary: Color(0xFF6366F1),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFD6D3D1),
      secondaryForeground: Color(0xFF4B5563),
      muted: Color(0xFFE7E5E4),
      mutedForeground: Color(0xFF6B7280),
      accent: Color(0xFFF3E5F5),
      accentForeground: Color(0xFF374151),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFD6D3D1),
      input: Color(0xFFD6D3D1),
      ring: Color(0xFF6366F1),
      chart1: Color(0xFF6366F1),
      chart2: Color(0xFF4F46E5),
      chart3: Color(0xFF4338CA),
      chart4: Color(0xFF3730A3),
      chart5: Color(0xFF312E81),
      sidebar: Color(0xFFD6D3D1),
      sidebarForeground: Color(0xFF1E293B),
      sidebarPrimary: Color(0xFF6366F1),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFFF3E5F5),
      sidebarAccentForeground: Color(0xFF374151),
      sidebarBorder: Color(0xFFD6D3D1),
      sidebarRing: Color(0xFF6366F1),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF1E1B18),
      foreground: Color(0xFFE2E8F0),
      card: Color(0xFF2C2825),
      cardForeground: Color(0xFFE2E8F0),
      popover: Color(0xFF2C2825),
      popoverForeground: Color(0xFFE2E8F0),
      primary: Color(0xFF818CF8),
      primaryForeground: Color(0xFF1E1B18),
      secondary: Color(0xFF3A3633),
      secondaryForeground: Color(0xFFD1D5DB),
      muted: Color(0xFF1F1C19),
      mutedForeground: Color(0xFF9CA3AF),
      accent: Color(0xFF484441),
      accentForeground: Color(0xFFD1D5DB),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFF1E1B18),
      border: Color(0xFF3A3633),
      input: Color(0xFF3A3633),
      ring: Color(0xFF818CF8),
      chart1: Color(0xFF818CF8),
      chart2: Color(0xFF6366F1),
      chart3: Color(0xFF4F46E5),
      chart4: Color(0xFF4338CA),
      chart5: Color(0xFF3730A3),
      sidebar: Color(0xFF3A3633),
      sidebarForeground: Color(0xFFE2E8F0),
      sidebarPrimary: Color(0xFF818CF8),
      sidebarPrimaryForeground: Color(0xFF1E1B18),
      sidebarAccent: Color(0xFF484441),
      sidebarAccentForeground: Color(0xFFD1D5DB),
      sidebarBorder: Color(0xFF3A3633),
      sidebarRing: Color(0xFF818CF8),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 1.25,
      spacing: SpacingScale(3.84),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 10,
            spreadRadius: 4,
            color: Color(0x2E95959D),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 10,
            spreadRadius: 4,
            color: Color(0x2E95959D),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 10,
            spreadRadius: 4,
            color: Color(0x2E95959D),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 10,
            spreadRadius: 4,
            color: Color(0x2E95959D),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 10,
            spreadRadius: 4,
            color: Color(0x2E95959D),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 10,
            spreadRadius: 4,
            color: Color(0x2E95959D),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 10,
            spreadRadius: 4,
            color: Color(0x2E95959D),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 10,
            spreadRadius: 4,
            color: Color(0x2E95959D),
          ),
        ],
      ),
      fontSans: "Plus Jakarta Sans, sans-serif",
      fontSerif: "Lora, serif",
      fontMono: "Roboto Mono, monospace",
    ),
    darkTokens: RegistryThemePresetTokens(
      radius: 1.25,
      spacing: SpacingScale(3.84),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF000000),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF000000),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF000000),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF000000),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF000000),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF000000),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF000000),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF000000),
          ),
        ],
      ),
    ),
  ),
];
