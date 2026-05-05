// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: starry-night.json
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
    id: 'starry-night',
    name: "Starry Night",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFF5F7FA),
      foreground: Color(0xFF1A2238),
      card: Color(0xFFE3EAF2),
      cardForeground: Color(0xFF1A2238),
      popover: Color(0xFFFFFBE6),
      popoverForeground: Color(0xFF1A2238),
      primary: Color(0xFF3A5BA0),
      primaryForeground: Color(0xFFFFFBE6),
      secondary: Color(0xFFF7C873),
      secondaryForeground: Color(0xFF1A2238),
      muted: Color(0xFFE5E5DF),
      mutedForeground: Color(0xFF3A5BA0),
      accent: Color(0xFF6EA3C1),
      accentForeground: Color(0xFFFFFBE6),
      destructive: Color(0xFF2D1E2F),
      destructiveForeground: Color(0xFFFFFBE6),
      border: Color(0xFFB0B8C1),
      input: Color(0xFF6EA3C1),
      ring: Color(0xFFF7C873),
      chart1: Color(0xFF3A5BA0),
      chart2: Color(0xFFF7C873),
      chart3: Color(0xFF6EA3C1),
      chart4: Color(0xFFB0B8C1),
      chart5: Color(0xFF2D1E2F),
      sidebar: Color(0xFFE3EAF2),
      sidebarForeground: Color(0xFF1A2238),
      sidebarPrimary: Color(0xFF3A5BA0),
      sidebarPrimaryForeground: Color(0xFFFFFBE6),
      sidebarAccent: Color(0xFFF7C873),
      sidebarAccentForeground: Color(0xFF1A2238),
      sidebarBorder: Color(0xFFB0B8C1),
      sidebarRing: Color(0xFFF7C873),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF181A24),
      foreground: Color(0xFFE6EAF3),
      card: Color(0xFF23243A),
      cardForeground: Color(0xFFE6EAF3),
      popover: Color(0xFF23243A),
      popoverForeground: Color(0xFFFFE066),
      primary: Color(0xFF3A5BA0),
      primaryForeground: Color(0xFFFFE066),
      secondary: Color(0xFFFFE066),
      secondaryForeground: Color(0xFF23243A),
      muted: Color(0xFF1D1E2F),
      mutedForeground: Color(0xFF7A88A1),
      accent: Color(0xFFBCCDF0),
      accentForeground: Color(0xFF181A24),
      destructive: Color(0xFFA04A6C),
      destructiveForeground: Color(0xFFFFE066),
      border: Color(0xFF2D2E3E),
      input: Color(0xFF3A5BA0),
      ring: Color(0xFFFFE066),
      chart1: Color(0xFF3A5BA0),
      chart2: Color(0xFFFFE066),
      chart3: Color(0xFF6EA3C1),
      chart4: Color(0xFF7A88A1),
      chart5: Color(0xFFA04A6C),
      sidebar: Color(0xFF23243A),
      sidebarForeground: Color(0xFFE6EAF3),
      sidebarPrimary: Color(0xFF3A5BA0),
      sidebarPrimaryForeground: Color(0xFFFFE066),
      sidebarAccent: Color(0xFFFFE066),
      sidebarAccentForeground: Color(0xFF23243A),
      sidebarBorder: Color(0xFF2D2E3E),
      sidebarRing: Color(0xFFFFE066),
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
      fontSans: "Libre Baskerville, serif",
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
