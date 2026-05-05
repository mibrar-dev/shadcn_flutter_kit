// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: claude.json
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
    id: 'claude',
    name: "Claude",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFFAF9F5),
      foreground: Color(0xFF3D3929),
      card: Color(0xFFFAF9F5),
      cardForeground: Color(0xFF141413),
      popover: Color(0xFFFFFFFF),
      popoverForeground: Color(0xFF28261B),
      primary: Color(0xFFC96442),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFE9E6DC),
      secondaryForeground: Color(0xFF535146),
      muted: Color(0xFFEDE9DE),
      mutedForeground: Color(0xFF83827D),
      accent: Color(0xFFE9E6DC),
      accentForeground: Color(0xFF28261B),
      destructive: Color(0xFF141413),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFDAD9D4),
      input: Color(0xFFB4B2A7),
      ring: Color(0xFFC96442),
      chart1: Color(0xFFB05730),
      chart2: Color(0xFF9C87F5),
      chart3: Color(0xFFDED8C4),
      chart4: Color(0xFFDBD3F0),
      chart5: Color(0xFFB4552D),
      sidebar: Color(0xFFF5F4EE),
      sidebarForeground: Color(0xFF3D3D3A),
      sidebarPrimary: Color(0xFFC96442),
      sidebarPrimaryForeground: Color(0xFFFBFBFB),
      sidebarAccent: Color(0xFFE9E6DC),
      sidebarAccentForeground: Color(0xFF343434),
      sidebarBorder: Color(0xFFEBEBEB),
      sidebarRing: Color(0xFFB5B5B5),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF262624),
      foreground: Color(0xFFC3C0B6),
      card: Color(0xFF262624),
      cardForeground: Color(0xFFFAF9F5),
      popover: Color(0xFF30302E),
      popoverForeground: Color(0xFFE5E5E2),
      primary: Color(0xFFD97757),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFFAF9F5),
      secondaryForeground: Color(0xFF30302E),
      muted: Color(0xFF1B1B19),
      mutedForeground: Color(0xFFB7B5A9),
      accent: Color(0xFF1A1915),
      accentForeground: Color(0xFFF5F4EE),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFF3E3E38),
      input: Color(0xFF52514A),
      ring: Color(0xFFD97757),
      chart1: Color(0xFFB05730),
      chart2: Color(0xFF9C87F5),
      chart3: Color(0xFF1A1915),
      chart4: Color(0xFF2F2B48),
      chart5: Color(0xFFB4552D),
      sidebar: Color(0xFF1F1E1D),
      sidebarForeground: Color(0xFFC3C0B6),
      sidebarPrimary: Color(0xFF343434),
      sidebarPrimaryForeground: Color(0xFFFBFBFB),
      sidebarAccent: Color(0xFF0F0F0E),
      sidebarAccentForeground: Color(0xFFC3C0B6),
      sidebarBorder: Color(0xFFEBEBEB),
      sidebarRing: Color(0xFFB5B5B5),
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
