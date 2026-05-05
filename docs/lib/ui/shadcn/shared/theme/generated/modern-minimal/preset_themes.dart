// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: modern-minimal.json
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
    id: 'modern-minimal',
    name: "Modern Minimal",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFFFFFFF),
      foreground: Color(0xFF333333),
      card: Color(0xFFFFFFFF),
      cardForeground: Color(0xFF333333),
      popover: Color(0xFFFFFFFF),
      popoverForeground: Color(0xFF333333),
      primary: Color(0xFF3B82F6),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFF3F4F6),
      secondaryForeground: Color(0xFF4B5563),
      muted: Color(0xFFF9FAFB),
      mutedForeground: Color(0xFF6B7280),
      accent: Color(0xFFE0F2FE),
      accentForeground: Color(0xFF1E3A8A),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFE5E7EB),
      input: Color(0xFFE5E7EB),
      ring: Color(0xFF3B82F6),
      chart1: Color(0xFF3B82F6),
      chart2: Color(0xFF2563EB),
      chart3: Color(0xFF1D4ED8),
      chart4: Color(0xFF1E40AF),
      chart5: Color(0xFF1E3A8A),
      sidebar: Color(0xFFF9FAFB),
      sidebarForeground: Color(0xFF333333),
      sidebarPrimary: Color(0xFF3B82F6),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFFE0F2FE),
      sidebarAccentForeground: Color(0xFF1E3A8A),
      sidebarBorder: Color(0xFFE5E7EB),
      sidebarRing: Color(0xFF3B82F6),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF171717),
      foreground: Color(0xFFE5E5E5),
      card: Color(0xFF262626),
      cardForeground: Color(0xFFE5E5E5),
      popover: Color(0xFF262626),
      popoverForeground: Color(0xFFE5E5E5),
      primary: Color(0xFF3B82F6),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFF262626),
      secondaryForeground: Color(0xFFE5E5E5),
      muted: Color(0xFF1F1F1F),
      mutedForeground: Color(0xFFA3A3A3),
      accent: Color(0xFF1E3A8A),
      accentForeground: Color(0xFFBFDBFE),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFF404040),
      input: Color(0xFF404040),
      ring: Color(0xFF3B82F6),
      chart1: Color(0xFF60A5FA),
      chart2: Color(0xFF3B82F6),
      chart3: Color(0xFF2563EB),
      chart4: Color(0xFF1D4ED8),
      chart5: Color(0xFF1E40AF),
      sidebar: Color(0xFF171717),
      sidebarForeground: Color(0xFFE5E5E5),
      sidebarPrimary: Color(0xFF3B82F6),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFF1E3A8A),
      sidebarAccentForeground: Color(0xFFBFDBFE),
      sidebarBorder: Color(0xFF404040),
      sidebarRing: Color(0xFF3B82F6),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 0.375,
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
      fontSans: "Inter, sans-serif",
      fontSerif: "Source Serif 4, serif",
      fontMono: "JetBrains Mono, monospace",
    ),
    darkTokens: RegistryThemePresetTokens(
      radius: 0.375,
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
