// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: northern-lights.json
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
    id: 'northern-lights',
    name: "Northern Lights",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFF9F9FA),
      foreground: Color(0xFF333333),
      card: Color(0xFFFFFFFF),
      cardForeground: Color(0xFF333333),
      popover: Color(0xFFFFFFFF),
      popoverForeground: Color(0xFF333333),
      primary: Color(0xFF34A85A),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFF6495ED),
      secondaryForeground: Color(0xFFFFFFFF),
      muted: Color(0xFFDDD9C4),
      mutedForeground: Color(0xFF6E6E6E),
      accent: Color(0xFF66D9EF),
      accentForeground: Color(0xFF333333),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFD4D4D4),
      input: Color(0xFFD4D4D4),
      ring: Color(0xFF34A85A),
      chart1: Color(0xFF34A85A),
      chart2: Color(0xFF6495ED),
      chart3: Color(0xFF66D9EF),
      chart4: Color(0xFF4682B4),
      chart5: Color(0xFF1A9641),
      sidebar: Color(0xFFF9F9FA),
      sidebarForeground: Color(0xFF333333),
      sidebarPrimary: Color(0xFF34A85A),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFF66D9EF),
      sidebarAccentForeground: Color(0xFF333333),
      sidebarBorder: Color(0xFFD4D4D4),
      sidebarRing: Color(0xFF34A85A),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF1A1D23),
      foreground: Color(0xFFE5E5E5),
      card: Color(0xFF2F3436),
      cardForeground: Color(0xFFE5E5E5),
      popover: Color(0xFF2F3436),
      popoverForeground: Color(0xFFE5E5E5),
      primary: Color(0xFF34A85A),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFF4682B4),
      secondaryForeground: Color(0xFFE5E5E5),
      muted: Color(0xFF444444),
      mutedForeground: Color(0xFFA3A3A3),
      accent: Color(0xFF6495ED),
      accentForeground: Color(0xFFE5E5E5),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFF444444),
      input: Color(0xFF444444),
      ring: Color(0xFF34A85A),
      chart1: Color(0xFF34A85A),
      chart2: Color(0xFF4682B4),
      chart3: Color(0xFF6495ED),
      chart4: Color(0xFF66D9EF),
      chart5: Color(0xFF1A9641),
      sidebar: Color(0xFF1A1D23),
      sidebarForeground: Color(0xFFE5E5E5),
      sidebarPrimary: Color(0xFF34A85A),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFF6495ED),
      sidebarAccentForeground: Color(0xFFE5E5E5),
      sidebarBorder: Color(0xFF444444),
      sidebarRing: Color(0xFF34A85A),
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
      fontSans: "Plus Jakarta Sans, sans-serif",
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
