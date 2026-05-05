// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: quantum-rose.json
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
    id: 'quantum-rose',
    name: "Quantum Rose",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFFFF0F8),
      foreground: Color(0xFF91185C),
      card: Color(0xFFFFF7FC),
      cardForeground: Color(0xFF91185C),
      popover: Color(0xFFFFF7FC),
      popoverForeground: Color(0xFF91185C),
      primary: Color(0xFFE6067A),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFFFD6FF),
      secondaryForeground: Color(0xFF91185C),
      muted: Color(0xFFFFE3F2),
      mutedForeground: Color(0xFFC04283),
      accent: Color(0xFFFFC1E3),
      accentForeground: Color(0xFF91185C),
      destructive: Color(0xFFD13869),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFFFC7E6),
      input: Color(0xFFFFD6FF),
      ring: Color(0xFFE6067A),
      chart1: Color(0xFFE6067A),
      chart2: Color(0xFFC44B97),
      chart3: Color(0xFF9969B6),
      chart4: Color(0xFF7371BF),
      chart5: Color(0xFF5E84FF),
      sidebar: Color(0xFFFFEDF6),
      sidebarForeground: Color(0xFF91185C),
      sidebarPrimary: Color(0xFFE6067A),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFFFFC1E3),
      sidebarAccentForeground: Color(0xFF91185C),
      sidebarBorder: Color(0xFFFFDDF0),
      sidebarRing: Color(0xFFE6067A),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF1A0922),
      foreground: Color(0xFFFFB3FF),
      card: Color(0xFF2A1435),
      cardForeground: Color(0xFFFFB3FF),
      popover: Color(0xFF2A1435),
      popoverForeground: Color(0xFFFFB3FF),
      primary: Color(0xFFFF6BEF),
      primaryForeground: Color(0xFF180518),
      secondary: Color(0xFF46204F),
      secondaryForeground: Color(0xFFFFB3FF),
      muted: Color(0xFF331941),
      mutedForeground: Color(0xFFD67AD6),
      accent: Color(0xFF5A1F5D),
      accentForeground: Color(0xFFFFB3FF),
      destructive: Color(0xFFFF2876),
      destructiveForeground: Color(0xFFF9F9F9),
      border: Color(0xFF4A1B5F),
      input: Color(0xFF46204F),
      ring: Color(0xFFFF6BEF),
      chart1: Color(0xFFFF6BEF),
      chart2: Color(0xFFC359E3),
      chart3: Color(0xFF9161FF),
      chart4: Color(0xFF6F73E2),
      chart5: Color(0xFF547AFF),
      sidebar: Color(0xFF1C0D25),
      sidebarForeground: Color(0xFFFFB3FF),
      sidebarPrimary: Color(0xFFFF6BEF),
      sidebarPrimaryForeground: Color(0xFF180518),
      sidebarAccent: Color(0xFF5A1F5D),
      sidebarAccentForeground: Color(0xFFFFB3FF),
      sidebarBorder: Color(0xFF4A1B5F),
      sidebarRing: Color(0xFFFF6BEF),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 0.5,
      spacing: SpacingScale(3.84),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0682174D),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0682174D),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0682174D),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0682174D),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0682174D),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0682174D),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0682174D),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0682174D),
          ),
        ],
      ),
      fontSans: "Poppins, sans-serif",
      fontSerif: "Playfair Display, serif",
      fontMono: "Space Mono, monospace",
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
            color: Color(0x40E619E6),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x40E619E6),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x40E619E6),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x40E619E6),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x40E619E6),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x40E619E6),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x40E619E6),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x40E619E6),
          ),
        ],
      ),
      fontSans: "Quicksand, sans-serif",
      fontSerif: "Playfair Display, serif",
      fontMono: "Space Mono, monospace",
    ),
  ),
];
