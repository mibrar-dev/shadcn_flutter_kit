// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: tangerine.json
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
    id: 'tangerine',
    name: "Tangerine",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFE8EBED),
      foreground: Color(0xFF333333),
      card: Color(0xFFFFFFFF),
      cardForeground: Color(0xFF333333),
      popover: Color(0xFFFFFFFF),
      popoverForeground: Color(0xFF333333),
      primary: Color(0xFFE05D38),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFF3F4F6),
      secondaryForeground: Color(0xFF4B5563),
      muted: Color(0xFFF9FAFB),
      mutedForeground: Color(0xFF6B7280),
      accent: Color(0xFFD6E4F0),
      accentForeground: Color(0xFF1E3A8A),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFDCDFE2),
      input: Color(0xFFF4F5F7),
      ring: Color(0xFFE05D38),
      chart1: Color(0xFF86A7C8),
      chart2: Color(0xFFEEA591),
      chart3: Color(0xFF5A7CA6),
      chart4: Color(0xFF466494),
      chart5: Color(0xFF334C82),
      sidebar: Color(0xFFDDDFE2),
      sidebarForeground: Color(0xFF333333),
      sidebarPrimary: Color(0xFFE05D38),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFFD6E4F0),
      sidebarAccentForeground: Color(0xFF1E3A8A),
      sidebarBorder: Color(0xFFE5E7EB),
      sidebarRing: Color(0xFFE05D38),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF1C2433),
      foreground: Color(0xFFE5E5E5),
      card: Color(0xFF2A3040),
      cardForeground: Color(0xFFE5E5E5),
      popover: Color(0xFF262B38),
      popoverForeground: Color(0xFFE5E5E5),
      primary: Color(0xFFE05D38),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFF2A303E),
      secondaryForeground: Color(0xFFE5E5E5),
      muted: Color(0xFF2A303E),
      mutedForeground: Color(0xFFA3A3A3),
      accent: Color(0xFF2A3656),
      accentForeground: Color(0xFFBFDBFE),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFF3D4354),
      input: Color(0xFF3D4354),
      ring: Color(0xFFE05D38),
      chart1: Color(0xFF86A7C8),
      chart2: Color(0xFFE6A08F),
      chart3: Color(0xFF5A7CA6),
      chart4: Color(0xFF466494),
      chart5: Color(0xFF334C82),
      sidebar: Color(0xFF2A303F),
      sidebarForeground: Color(0xFFE5E5E5),
      sidebarPrimary: Color(0xFFE05D38),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFF2A3656),
      sidebarAccentForeground: Color(0xFFBFDBFE),
      sidebarBorder: Color(0xFF3D4354),
      sidebarRing: Color(0xFFE05D38),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 0.75,
      spacing: SpacingScale(3.84),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x1A000000),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x1A000000),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x1A000000),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x1A000000),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x1A000000),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x1A000000),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x1A000000),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
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
