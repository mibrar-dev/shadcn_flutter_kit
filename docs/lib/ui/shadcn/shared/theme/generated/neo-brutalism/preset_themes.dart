// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: neo-brutalism.json
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
    id: 'neo-brutalism',
    name: "Neo Brutalism",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFFFFFFF),
      foreground: Color(0xFF000000),
      card: Color(0xFFFFFFFF),
      cardForeground: Color(0xFF000000),
      popover: Color(0xFFFFFFFF),
      popoverForeground: Color(0xFF000000),
      primary: Color(0xFFFF3333),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFFFFF00),
      secondaryForeground: Color(0xFF000000),
      muted: Color(0xFFF0F0F0),
      mutedForeground: Color(0xFF333333),
      accent: Color(0xFF0066FF),
      accentForeground: Color(0xFFFFFFFF),
      destructive: Color(0xFF000000),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFF000000),
      input: Color(0xFF000000),
      ring: Color(0xFFFF3333),
      chart1: Color(0xFFFF3333),
      chart2: Color(0xFFFFFF00),
      chart3: Color(0xFF0066FF),
      chart4: Color(0xFF00CC00),
      chart5: Color(0xFFCC00CC),
      sidebar: Color(0xFFF0F0F0),
      sidebarForeground: Color(0xFF000000),
      sidebarPrimary: Color(0xFFFF3333),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFF0066FF),
      sidebarAccentForeground: Color(0xFFFFFFFF),
      sidebarBorder: Color(0xFF000000),
      sidebarRing: Color(0xFFFF3333),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF000000),
      foreground: Color(0xFFFFFFFF),
      card: Color(0xFF333333),
      cardForeground: Color(0xFFFFFFFF),
      popover: Color(0xFF333333),
      popoverForeground: Color(0xFFFFFFFF),
      primary: Color(0xFFFF6666),
      primaryForeground: Color(0xFF000000),
      secondary: Color(0xFFFFFF33),
      secondaryForeground: Color(0xFF000000),
      muted: Color(0xFF1A1A1A),
      mutedForeground: Color(0xFFCCCCCC),
      accent: Color(0xFF3399FF),
      accentForeground: Color(0xFF000000),
      destructive: Color(0xFFFFFFFF),
      destructiveForeground: Color(0xFF000000),
      border: Color(0xFFFFFFFF),
      input: Color(0xFFFFFFFF),
      ring: Color(0xFFFF6666),
      chart1: Color(0xFFFF6666),
      chart2: Color(0xFFFFFF33),
      chart3: Color(0xFF3399FF),
      chart4: Color(0xFF33CC33),
      chart5: Color(0xFFCC33CC),
      sidebar: Color(0xFF000000),
      sidebarForeground: Color(0xFFFFFFFF),
      sidebarPrimary: Color(0xFFFF6666),
      sidebarPrimaryForeground: Color(0xFF000000),
      sidebarAccent: Color(0xFF3399FF),
      sidebarAccentForeground: Color(0xFF000000),
      sidebarBorder: Color(0xFFFFFFFF),
      sidebarRing: Color(0xFFFF6666),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 0,
      spacing: SpacingScale(3.84),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(4, 4),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF000000),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(4, 4),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF000000),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(4, 4),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF000000),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(4, 4),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF000000),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(4, 4),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF000000),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(4, 4),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF000000),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(4, 4),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF000000),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(4, 4),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF000000),
          ),
        ],
      ),
      fontSans: "DM Sans, sans-serif",
      fontMono: "Space Mono, monospace",
    ),
    darkTokens: RegistryThemePresetTokens(
      radius: 0,
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
