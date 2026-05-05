// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: sage-garden.json
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
    id: 'sage-garden',
    name: "Sage Garden",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFF8F7F4),
      foreground: Color(0xFF1A1F2E),
      card: Color(0xFFFFFFFF),
      cardForeground: Color(0xFF1A1F2E),
      popover: Color(0xFFFFFFFF),
      popoverForeground: Color(0xFF1A1F2E),
      primary: Color(0xFF7C9082),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFCED4BF),
      secondaryForeground: Color(0xFF1A1F2E),
      muted: Color(0xFFE8E6E1),
      mutedForeground: Color(0xFF6B7280),
      accent: Color(0xFFBFC9BB),
      accentForeground: Color(0xFF1A1F2E),
      destructive: Color(0xFFC73E3A),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFE8E6E1),
      input: Color(0xFFFFFFFF),
      ring: Color(0xFF7C9082),
      chart1: Color(0xFF7C9082),
      chart2: Color(0xFFA0AA88),
      chart3: Color(0xFF8B9D83),
      chart4: Color(0xFF6B7280),
      chart5: Color(0xFFE8E6E1),
      sidebar: Color(0xFFFAFAF8),
      sidebarForeground: Color(0xFF1A1F2E),
      sidebarPrimary: Color(0xFF7C9082),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFFE8E6E1),
      sidebarAccentForeground: Color(0xFF1A1F2E),
      sidebarBorder: Color(0xFFE8E6E1),
      sidebarRing: Color(0xFF7C9082),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF0A0A0A),
      foreground: Color(0xFFF5F5F5),
      card: Color(0xFF121212),
      cardForeground: Color(0xFFF5F5F5),
      popover: Color(0xFF121212),
      popoverForeground: Color(0xFFF5F5F5),
      primary: Color(0xFF7C9082),
      primaryForeground: Color(0xFF000000),
      secondary: Color(0xFF1A1A1A),
      secondaryForeground: Color(0xFFF5F5F5),
      muted: Color(0xFF1A1A1A),
      mutedForeground: Color(0xFFA0A0A0),
      accent: Color(0xFF36443A),
      accentForeground: Color(0xFFF5F5F5),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFF2A2A2A),
      input: Color(0xFF121212),
      ring: Color(0xFF7C9082),
      chart1: Color(0xFF7C9082),
      chart2: Color(0xFFA0AA88),
      chart3: Color(0xFF8B9D83),
      chart4: Color(0xFF6B7280),
      chart5: Color(0xFF5A6B5E),
      sidebar: Color(0xFF0F0F0F),
      sidebarForeground: Color(0xFFF5F5F5),
      sidebarPrimary: Color(0xFF7C9082),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFF1A1A1A),
      sidebarAccentForeground: Color(0xFFF5F5F5),
      sidebarBorder: Color(0xFF2A2A2A),
      sidebarRing: Color(0xFF7C9082),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 0.35,
      spacing: SpacingScale(3.68),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x0A1A1F2E),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x0A1A1F2E),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x0A1A1F2E),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x0A1A1F2E),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x0A1A1F2E),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x0A1A1F2E),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x0A1A1F2E),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x0A1A1F2E),
          ),
        ],
      ),
      fontSans: "Antic, ui-sans-serif, sans-serif, system-ui",
      fontSerif: "Signifier, Georgia, serif",
      fontMono: "JetBrains Mono, Courier New, monospace",
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
