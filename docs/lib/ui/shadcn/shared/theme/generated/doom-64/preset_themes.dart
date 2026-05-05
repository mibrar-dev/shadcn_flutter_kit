// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: doom-64.json
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
    id: 'doom-64',
    name: "Doom 64",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFCCCCCC),
      foreground: Color(0xFF1F1F1F),
      card: Color(0xFFB0B0B0),
      cardForeground: Color(0xFF1F1F1F),
      popover: Color(0xFFB0B0B0),
      popoverForeground: Color(0xFF1F1F1F),
      primary: Color(0xFFB71C1C),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFF556B2F),
      secondaryForeground: Color(0xFFFFFFFF),
      muted: Color(0xFFB8B8B8),
      mutedForeground: Color(0xFF4A4A4A),
      accent: Color(0xFF4682B4),
      accentForeground: Color(0xFFFFFFFF),
      destructive: Color(0xFFFF6F00),
      destructiveForeground: Color(0xFF000000),
      border: Color(0xFF505050),
      input: Color(0xFF505050),
      ring: Color(0xFFB71C1C),
      chart1: Color(0xFFB71C1C),
      chart2: Color(0xFF556B2F),
      chart3: Color(0xFF4682B4),
      chart4: Color(0xFFFF6F00),
      chart5: Color(0xFF8D6E63),
      sidebar: Color(0xFFB0B0B0),
      sidebarForeground: Color(0xFF1F1F1F),
      sidebarPrimary: Color(0xFFB71C1C),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFF4682B4),
      sidebarAccentForeground: Color(0xFFFFFFFF),
      sidebarBorder: Color(0xFF505050),
      sidebarRing: Color(0xFFB71C1C),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF1A1A1A),
      foreground: Color(0xFFE0E0E0),
      card: Color(0xFF2A2A2A),
      cardForeground: Color(0xFFE0E0E0),
      popover: Color(0xFF2A2A2A),
      popoverForeground: Color(0xFFE0E0E0),
      primary: Color(0xFFE53935),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFF689F38),
      secondaryForeground: Color(0xFF000000),
      muted: Color(0xFF252525),
      mutedForeground: Color(0xFFA0A0A0),
      accent: Color(0xFF64B5F6),
      accentForeground: Color(0xFF000000),
      destructive: Color(0xFFFFA000),
      destructiveForeground: Color(0xFF000000),
      border: Color(0xFF4A4A4A),
      input: Color(0xFF4A4A4A),
      ring: Color(0xFFE53935),
      chart1: Color(0xFFE53935),
      chart2: Color(0xFF689F38),
      chart3: Color(0xFF64B5F6),
      chart4: Color(0xFFFFA000),
      chart5: Color(0xFFA1887F),
      sidebar: Color(0xFF141414),
      sidebarForeground: Color(0xFFE0E0E0),
      sidebarPrimary: Color(0xFFE53935),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFF64B5F6),
      sidebarAccentForeground: Color(0xFF000000),
      sidebarBorder: Color(0xFF4A4A4A),
      sidebarRing: Color(0xFFE53935),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 0,
      spacing: SpacingScale(4),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x66000000),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x66000000),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x66000000),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x66000000),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x66000000),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x66000000),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x66000000),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x66000000),
          ),
        ],
      ),
      fontSans: "\\",
      fontSerif: "ui-serif, Georgia, Cambria, \\",
      fontMono: "\\",
    ),
    darkTokens: RegistryThemePresetTokens(
      radius: 0,
      spacing: SpacingScale(4),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x99000000),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x99000000),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x99000000),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x99000000),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x99000000),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x99000000),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x99000000),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x99000000),
          ),
        ],
      ),
      fontSans: "\\",
      fontSerif: "ui-serif, Georgia, Cambria, \\",
      fontMono: "\\",
    ),
  ),
];
