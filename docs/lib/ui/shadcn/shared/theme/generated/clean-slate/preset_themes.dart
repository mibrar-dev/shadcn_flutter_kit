// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: clean-slate.json
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
    id: 'clean-slate',
    name: "Clean Slate",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFF8FAFC),
      foreground: Color(0xFF1E293B),
      card: Color(0xFFFFFFFF),
      cardForeground: Color(0xFF1E293B),
      popover: Color(0xFFFFFFFF),
      popoverForeground: Color(0xFF1E293B),
      primary: Color(0xFF6366F1),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFE5E7EB),
      secondaryForeground: Color(0xFF374151),
      muted: Color(0xFFF3F4F6),
      mutedForeground: Color(0xFF6B7280),
      accent: Color(0xFFE0E7FF),
      accentForeground: Color(0xFF374151),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFD1D5DB),
      input: Color(0xFFD1D5DB),
      ring: Color(0xFF6366F1),
      chart1: Color(0xFF6366F1),
      chart2: Color(0xFF4F46E5),
      chart3: Color(0xFF4338CA),
      chart4: Color(0xFF3730A3),
      chart5: Color(0xFF312E81),
      sidebar: Color(0xFFF3F4F6),
      sidebarForeground: Color(0xFF1E293B),
      sidebarPrimary: Color(0xFF6366F1),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFFE0E7FF),
      sidebarAccentForeground: Color(0xFF374151),
      sidebarBorder: Color(0xFFD1D5DB),
      sidebarRing: Color(0xFF6366F1),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF0F172A),
      foreground: Color(0xFFE2E8F0),
      card: Color(0xFF1E293B),
      cardForeground: Color(0xFFE2E8F0),
      popover: Color(0xFF1E293B),
      popoverForeground: Color(0xFFE2E8F0),
      primary: Color(0xFF818CF8),
      primaryForeground: Color(0xFF0F172A),
      secondary: Color(0xFF2D3748),
      secondaryForeground: Color(0xFFD1D5DB),
      muted: Color(0xFF152032),
      mutedForeground: Color(0xFF9CA3AF),
      accent: Color(0xFF374151),
      accentForeground: Color(0xFFD1D5DB),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFF0F172A),
      border: Color(0xFF4B5563),
      input: Color(0xFF4B5563),
      ring: Color(0xFF818CF8),
      chart1: Color(0xFF818CF8),
      chart2: Color(0xFF6366F1),
      chart3: Color(0xFF4F46E5),
      chart4: Color(0xFF4338CA),
      chart5: Color(0xFF3730A3),
      sidebar: Color(0xFF1E293B),
      sidebarForeground: Color(0xFFE2E8F0),
      sidebarPrimary: Color(0xFF818CF8),
      sidebarPrimaryForeground: Color(0xFF0F172A),
      sidebarAccent: Color(0xFF374151),
      sidebarAccentForeground: Color(0xFFD1D5DB),
      sidebarBorder: Color(0xFF4B5563),
      sidebarRing: Color(0xFF818CF8),
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
      fontSans: "Inter, sans-serif",
      fontSerif: "Merriweather, serif",
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
