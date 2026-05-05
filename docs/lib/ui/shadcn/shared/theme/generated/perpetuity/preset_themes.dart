// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: perpetuity.json
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
    id: 'perpetuity',
    name: "Perpetuity",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFE8F0F0),
      foreground: Color(0xFF0A4A55),
      card: Color(0xFFF2F7F7),
      cardForeground: Color(0xFF0A4A55),
      popover: Color(0xFFF2F7F7),
      popoverForeground: Color(0xFF0A4A55),
      primary: Color(0xFF06858E),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFD9EAEA),
      secondaryForeground: Color(0xFF0A4A55),
      muted: Color(0xFFE0EAEA),
      mutedForeground: Color(0xFF427A7E),
      accent: Color(0xFFC9E5E7),
      accentForeground: Color(0xFF0A4A55),
      destructive: Color(0xFFD13838),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFCDE0E2),
      input: Color(0xFFD9EAEA),
      ring: Color(0xFF06858E),
      chart1: Color(0xFF06858E),
      chart2: Color(0xFF1E9EA6),
      chart3: Color(0xFF37B6BE),
      chart4: Color(0xFF5DC7CE),
      chart5: Color(0xFF8AD8DD),
      sidebar: Color(0xFFDAEBED),
      sidebarForeground: Color(0xFF0A4A55),
      sidebarPrimary: Color(0xFF06858E),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFFC9E5E7),
      sidebarAccentForeground: Color(0xFF0A4A55),
      sidebarBorder: Color(0xFFCDE0E2),
      sidebarRing: Color(0xFF06858E),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF0A1A20),
      foreground: Color(0xFF4DE8E8),
      card: Color(0xFF0C2025),
      cardForeground: Color(0xFF4DE8E8),
      popover: Color(0xFF0C2025),
      popoverForeground: Color(0xFF4DE8E8),
      primary: Color(0xFF4DE8E8),
      primaryForeground: Color(0xFF0A1A20),
      secondary: Color(0xFF164955),
      secondaryForeground: Color(0xFF4DE8E8),
      muted: Color(0xFF0F3039),
      mutedForeground: Color(0xFF36A5A5),
      accent: Color(0xFF164955),
      accentForeground: Color(0xFF4DE8E8),
      destructive: Color(0xFFE83C3C),
      destructiveForeground: Color(0xFFF2F2F2),
      border: Color(0xFF164955),
      input: Color(0xFF164955),
      ring: Color(0xFF4DE8E8),
      chart1: Color(0xFF4DE8E8),
      chart2: Color(0xFF36A5A5),
      chart3: Color(0xFF2D8A8A),
      chart4: Color(0xFF19595E),
      chart5: Color(0xFF0E383C),
      sidebar: Color(0xFF0A1A20),
      sidebarForeground: Color(0xFF4DE8E8),
      sidebarPrimary: Color(0xFF4DE8E8),
      sidebarPrimaryForeground: Color(0xFF0A1A20),
      sidebarAccent: Color(0xFF164955),
      sidebarAccentForeground: Color(0xFF4DE8E8),
      sidebarBorder: Color(0xFF164955),
      sidebarRing: Color(0xFF4DE8E8),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 0.125,
      spacing: SpacingScale(3.84),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x06177982),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x06177982),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x06177982),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x06177982),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x06177982),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x06177982),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x06177982),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x06177982),
          ),
        ],
      ),
      fontSans: "Courier New, monospace",
      fontSerif: "Courier New, monospace",
      fontMono: "Courier New, monospace",
    ),
    darkTokens: RegistryThemePresetTokens(
      radius: 0.125,
      spacing: SpacingScale(3.84),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x0A52E0E0),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x0A52E0E0),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x0A52E0E0),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x0A52E0E0),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x0A52E0E0),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x0A52E0E0),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x0A52E0E0),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x0A52E0E0),
          ),
        ],
      ),
      fontSans: "Source Code Pro, monospace",
      fontSerif: "Source Code Pro, monospace",
      fontMono: "Source Code Pro, monospace",
    ),
  ),
];
