// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: cosmic-night.json
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
    id: 'cosmic-night',
    name: "Cosmic Night",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFF5F5FF),
      foreground: Color(0xFF2A2A4A),
      card: Color(0xFFFFFFFF),
      cardForeground: Color(0xFF2A2A4A),
      popover: Color(0xFFFFFFFF),
      popoverForeground: Color(0xFF2A2A4A),
      primary: Color(0xFF6E56CF),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFE4DFFF),
      secondaryForeground: Color(0xFF4A4080),
      muted: Color(0xFFF0F0FA),
      mutedForeground: Color(0xFF6C6C8A),
      accent: Color(0xFFD8E6FF),
      accentForeground: Color(0xFF2A2A4A),
      destructive: Color(0xFFFF5470),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFE0E0F0),
      input: Color(0xFFE0E0F0),
      ring: Color(0xFF6E56CF),
      chart1: Color(0xFF6E56CF),
      chart2: Color(0xFF9E8CFC),
      chart3: Color(0xFF5D5FEF),
      chart4: Color(0xFF7C75FA),
      chart5: Color(0xFF4740B3),
      sidebar: Color(0xFFF0F0FA),
      sidebarForeground: Color(0xFF2A2A4A),
      sidebarPrimary: Color(0xFF6E56CF),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFFD8E6FF),
      sidebarAccentForeground: Color(0xFF2A2A4A),
      sidebarBorder: Color(0xFFE0E0F0),
      sidebarRing: Color(0xFF6E56CF),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF0F0F1A),
      foreground: Color(0xFFE2E2F5),
      card: Color(0xFF1A1A2E),
      cardForeground: Color(0xFFE2E2F5),
      popover: Color(0xFF1A1A2E),
      popoverForeground: Color(0xFFE2E2F5),
      primary: Color(0xFFA48FFF),
      primaryForeground: Color(0xFF0F0F1A),
      secondary: Color(0xFF2D2B55),
      secondaryForeground: Color(0xFFC4C2FF),
      muted: Color(0xFF222244),
      mutedForeground: Color(0xFFA0A0C0),
      accent: Color(0xFF303060),
      accentForeground: Color(0xFFE2E2F5),
      destructive: Color(0xFFFF5470),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFF303052),
      input: Color(0xFF303052),
      ring: Color(0xFFA48FFF),
      chart1: Color(0xFFA48FFF),
      chart2: Color(0xFF7986CB),
      chart3: Color(0xFF64B5F6),
      chart4: Color(0xFF4DB6AC),
      chart5: Color(0xFFFF79C6),
      sidebar: Color(0xFF1A1A2E),
      sidebarForeground: Color(0xFFE2E2F5),
      sidebarPrimary: Color(0xFFA48FFF),
      sidebarPrimaryForeground: Color(0xFF0F0F1A),
      sidebarAccent: Color(0xFF303060),
      sidebarAccentForeground: Color(0xFFE2E2F5),
      sidebarBorder: Color(0xFF303052),
      sidebarRing: Color(0xFFA48FFF),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 0.5,
      spacing: SpacingScale(3.84),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 10,
            spreadRadius: 0,
            color: Color(0x1F2D2D53),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 10,
            spreadRadius: 0,
            color: Color(0x1F2D2D53),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 10,
            spreadRadius: 0,
            color: Color(0x1F2D2D53),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 10,
            spreadRadius: 0,
            color: Color(0x1F2D2D53),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 10,
            spreadRadius: 0,
            color: Color(0x1F2D2D53),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 10,
            spreadRadius: 0,
            color: Color(0x1F2D2D53),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 10,
            spreadRadius: 0,
            color: Color(0x1F2D2D53),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 10,
            spreadRadius: 0,
            color: Color(0x1F2D2D53),
          ),
        ],
      ),
      fontSans: "Inter, sans-serif",
      fontSerif: "Georgia, serif",
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
