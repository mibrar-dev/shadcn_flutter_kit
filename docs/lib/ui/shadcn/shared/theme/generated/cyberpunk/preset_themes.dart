// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: cyberpunk.json
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
    id: 'cyberpunk',
    name: "Cyberpunk",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFF8F9FA),
      foreground: Color(0xFF0C0C1D),
      card: Color(0xFFFFFFFF),
      cardForeground: Color(0xFF0C0C1D),
      popover: Color(0xFFFFFFFF),
      popoverForeground: Color(0xFF0C0C1D),
      primary: Color(0xFFFF00C8),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFF0F0FF),
      secondaryForeground: Color(0xFF0C0C1D),
      muted: Color(0xFFF0F0FF),
      mutedForeground: Color(0xFF0C0C1D),
      accent: Color(0xFF00FFCC),
      accentForeground: Color(0xFF0C0C1D),
      destructive: Color(0xFFFF3D00),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFDFE6E9),
      input: Color(0xFFDFE6E9),
      ring: Color(0xFFFF00C8),
      chart1: Color(0xFFFF00C8),
      chart2: Color(0xFF9000FF),
      chart3: Color(0xFF00E5FF),
      chart4: Color(0xFF00FFCC),
      chart5: Color(0xFFFFE600),
      sidebar: Color(0xFFF0F0FF),
      sidebarForeground: Color(0xFF0C0C1D),
      sidebarPrimary: Color(0xFFFF00C8),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFF00FFCC),
      sidebarAccentForeground: Color(0xFF0C0C1D),
      sidebarBorder: Color(0xFFDFE6E9),
      sidebarRing: Color(0xFFFF00C8),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF0C0C1D),
      foreground: Color(0xFFECEFF4),
      card: Color(0xFF1E1E3F),
      cardForeground: Color(0xFFECEFF4),
      popover: Color(0xFF1E1E3F),
      popoverForeground: Color(0xFFECEFF4),
      primary: Color(0xFFFF00C8),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFF1E1E3F),
      secondaryForeground: Color(0xFFECEFF4),
      muted: Color(0xFF151530),
      mutedForeground: Color(0xFF8085A6),
      accent: Color(0xFF00FFCC),
      accentForeground: Color(0xFF0C0C1D),
      destructive: Color(0xFFFF3D00),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFF2E2E5E),
      input: Color(0xFF2E2E5E),
      ring: Color(0xFFFF00C8),
      chart1: Color(0xFFFF00C8),
      chart2: Color(0xFF9000FF),
      chart3: Color(0xFF00E5FF),
      chart4: Color(0xFF00FFCC),
      chart5: Color(0xFFFFE600),
      sidebar: Color(0xFF0C0C1D),
      sidebarForeground: Color(0xFFECEFF4),
      sidebarPrimary: Color(0xFFFF00C8),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFF00FFCC),
      sidebarAccentForeground: Color(0xFF0C0C1D),
      sidebarBorder: Color(0xFF2E2E5E),
      sidebarRing: Color(0xFFFF00C8),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 0.5,
      spacing: SpacingScale(3.84),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 8,
            spreadRadius: -2,
            color: Color(0x1A000000),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 8,
            spreadRadius: -2,
            color: Color(0x1A000000),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 8,
            spreadRadius: -2,
            color: Color(0x1A000000),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 8,
            spreadRadius: -2,
            color: Color(0x1A000000),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 8,
            spreadRadius: -2,
            color: Color(0x1A000000),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 8,
            spreadRadius: -2,
            color: Color(0x1A000000),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 8,
            spreadRadius: -2,
            color: Color(0x1A000000),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 8,
            spreadRadius: -2,
            color: Color(0x1A000000),
          ),
        ],
      ),
      fontSans: "Outfit, sans-serif",
      fontMono: "Fira Code, monospace",
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
