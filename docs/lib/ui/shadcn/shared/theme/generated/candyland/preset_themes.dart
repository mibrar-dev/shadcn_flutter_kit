// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: candyland.json
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
    id: 'candyland',
    name: "Candyland",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFF7F9FA),
      foreground: Color(0xFF333333),
      card: Color(0xFFFFFFFF),
      cardForeground: Color(0xFF333333),
      popover: Color(0xFFFFFFFF),
      popoverForeground: Color(0xFF333333),
      primary: Color(0xFFFFC0CB),
      primaryForeground: Color(0xFF000000),
      secondary: Color(0xFF87CEEB),
      secondaryForeground: Color(0xFF000000),
      muted: Color(0xFFDDD9C4),
      mutedForeground: Color(0xFF6E6E6E),
      accent: Color(0xFFFFFF00),
      accentForeground: Color(0xFF000000),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFD4D4D4),
      input: Color(0xFFD4D4D4),
      ring: Color(0xFFFFC0CB),
      chart1: Color(0xFFFFC0CB),
      chart2: Color(0xFF87CEEB),
      chart3: Color(0xFFFFFF00),
      chart4: Color(0xFFFF99CC),
      chart5: Color(0xFF33CC33),
      sidebar: Color(0xFFF7F9FA),
      sidebarForeground: Color(0xFF333333),
      sidebarPrimary: Color(0xFFFFC0CB),
      sidebarPrimaryForeground: Color(0xFF000000),
      sidebarAccent: Color(0xFFFFFF00),
      sidebarAccentForeground: Color(0xFF000000),
      sidebarBorder: Color(0xFFD4D4D4),
      sidebarRing: Color(0xFFFFC0CB),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF1A1D23),
      foreground: Color(0xFFE5E5E5),
      card: Color(0xFF2F3436),
      cardForeground: Color(0xFFE5E5E5),
      popover: Color(0xFF2F3436),
      popoverForeground: Color(0xFFE5E5E5),
      primary: Color(0xFFFF99CC),
      primaryForeground: Color(0xFF000000),
      secondary: Color(0xFF33CC33),
      secondaryForeground: Color(0xFF000000),
      muted: Color(0xFF444444),
      mutedForeground: Color(0xFFA3A3A3),
      accent: Color(0xFF87CEEB),
      accentForeground: Color(0xFF000000),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFF444444),
      input: Color(0xFF444444),
      ring: Color(0xFFFF99CC),
      chart1: Color(0xFFFF99CC),
      chart2: Color(0xFF33CC33),
      chart3: Color(0xFF87CEEB),
      chart4: Color(0xFFFFFF00),
      chart5: Color(0xFFFFCC00),
      sidebar: Color(0xFF1A1D23),
      sidebarForeground: Color(0xFFE5E5E5),
      sidebarPrimary: Color(0xFFFF99CC),
      sidebarPrimaryForeground: Color(0xFF000000),
      sidebarAccent: Color(0xFF87CEEB),
      sidebarAccentForeground: Color(0xFF000000),
      sidebarBorder: Color(0xFF444444),
      sidebarRing: Color(0xFFFF99CC),
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
      fontSans: "Poppins, sans-serif",
      fontMono: "Roboto Mono, monospace",
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
