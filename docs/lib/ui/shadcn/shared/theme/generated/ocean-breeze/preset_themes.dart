// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: ocean-breeze.json
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
    id: 'ocean-breeze',
    name: "Ocean Breeze",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFF0F8FF),
      foreground: Color(0xFF374151),
      card: Color(0xFFFFFFFF),
      cardForeground: Color(0xFF374151),
      popover: Color(0xFFFFFFFF),
      popoverForeground: Color(0xFF374151),
      primary: Color(0xFF22C55E),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFE0F2FE),
      secondaryForeground: Color(0xFF4B5563),
      muted: Color(0xFFF3F4F6),
      mutedForeground: Color(0xFF6B7280),
      accent: Color(0xFFD1FAE5),
      accentForeground: Color(0xFF374151),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFE5E7EB),
      input: Color(0xFFE5E7EB),
      ring: Color(0xFF22C55E),
      chart1: Color(0xFF22C55E),
      chart2: Color(0xFF10B981),
      chart3: Color(0xFF059669),
      chart4: Color(0xFF047857),
      chart5: Color(0xFF065F46),
      sidebar: Color(0xFFE0F2FE),
      sidebarForeground: Color(0xFF374151),
      sidebarPrimary: Color(0xFF22C55E),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFFD1FAE5),
      sidebarAccentForeground: Color(0xFF374151),
      sidebarBorder: Color(0xFFE5E7EB),
      sidebarRing: Color(0xFF22C55E),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF0F172A),
      foreground: Color(0xFFD1D5DB),
      card: Color(0xFF1E293B),
      cardForeground: Color(0xFFD1D5DB),
      popover: Color(0xFF1E293B),
      popoverForeground: Color(0xFFD1D5DB),
      primary: Color(0xFF34D399),
      primaryForeground: Color(0xFF0F172A),
      secondary: Color(0xFF2D3748),
      secondaryForeground: Color(0xFFA1A1AA),
      muted: Color(0xFF19212E),
      mutedForeground: Color(0xFF6B7280),
      accent: Color(0xFF374151),
      accentForeground: Color(0xFFA1A1AA),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFF0F172A),
      border: Color(0xFF4B5563),
      input: Color(0xFF4B5563),
      ring: Color(0xFF34D399),
      chart1: Color(0xFF34D399),
      chart2: Color(0xFF2DD4BF),
      chart3: Color(0xFF22C55E),
      chart4: Color(0xFF10B981),
      chart5: Color(0xFF059669),
      sidebar: Color(0xFF1E293B),
      sidebarForeground: Color(0xFFD1D5DB),
      sidebarPrimary: Color(0xFF34D399),
      sidebarPrimaryForeground: Color(0xFF0F172A),
      sidebarAccent: Color(0xFF374151),
      sidebarAccentForeground: Color(0xFFA1A1AA),
      sidebarBorder: Color(0xFF4B5563),
      sidebarRing: Color(0xFF34D399),
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
      fontSans: "DM Sans, sans-serif",
      fontSerif: "Lora, serif",
      fontMono: "IBM Plex Mono, monospace",
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
