// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: bold-tech.json
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
    id: 'bold-tech',
    name: "Bold Tech",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFFFFFFF),
      foreground: Color(0xFF312E81),
      card: Color(0xFFFFFFFF),
      cardForeground: Color(0xFF312E81),
      popover: Color(0xFFFFFFFF),
      popoverForeground: Color(0xFF312E81),
      primary: Color(0xFF8B5CF6),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFF3F0FF),
      secondaryForeground: Color(0xFF4338CA),
      muted: Color(0xFFF5F3FF),
      mutedForeground: Color(0xFF7C3AED),
      accent: Color(0xFFDBEAFE),
      accentForeground: Color(0xFF1E40AF),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFE0E7FF),
      input: Color(0xFFE0E7FF),
      ring: Color(0xFF8B5CF6),
      chart1: Color(0xFF8B5CF6),
      chart2: Color(0xFF7C3AED),
      chart3: Color(0xFF6D28D9),
      chart4: Color(0xFF5B21B6),
      chart5: Color(0xFF4C1D95),
      sidebar: Color(0xFFF5F3FF),
      sidebarForeground: Color(0xFF312E81),
      sidebarPrimary: Color(0xFF8B5CF6),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFFDBEAFE),
      sidebarAccentForeground: Color(0xFF1E40AF),
      sidebarBorder: Color(0xFFE0E7FF),
      sidebarRing: Color(0xFF8B5CF6),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF0F172A),
      foreground: Color(0xFFE0E7FF),
      card: Color(0xFF1E1B4B),
      cardForeground: Color(0xFFE0E7FF),
      popover: Color(0xFF1E1B4B),
      popoverForeground: Color(0xFFE0E7FF),
      primary: Color(0xFF8B5CF6),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFF1E1B4B),
      secondaryForeground: Color(0xFFE0E7FF),
      muted: Color(0xFF171447),
      mutedForeground: Color(0xFFC4B5FD),
      accent: Color(0xFF4338CA),
      accentForeground: Color(0xFFE0E7FF),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFF2E1065),
      input: Color(0xFF2E1065),
      ring: Color(0xFF8B5CF6),
      chart1: Color(0xFFA78BFA),
      chart2: Color(0xFF8B5CF6),
      chart3: Color(0xFF7C3AED),
      chart4: Color(0xFF6D28D9),
      chart5: Color(0xFF5B21B6),
      sidebar: Color(0xFF0F172A),
      sidebarForeground: Color(0xFFE0E7FF),
      sidebarPrimary: Color(0xFF8B5CF6),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFF4338CA),
      sidebarAccentForeground: Color(0xFFE0E7FF),
      sidebarBorder: Color(0xFF2E1065),
      sidebarRing: Color(0xFF8B5CF6),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 0.625,
      spacing: SpacingScale(3.84),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x33835EF3),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x33835EF3),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x33835EF3),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x33835EF3),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x33835EF3),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x33835EF3),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x33835EF3),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x33835EF3),
          ),
        ],
      ),
      fontSans: "Roboto, sans-serif",
      fontSerif: "Playfair Display, serif",
      fontMono: "Fira Code, monospace",
    ),
    darkTokens: RegistryThemePresetTokens(
      radius: 0.625,
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
