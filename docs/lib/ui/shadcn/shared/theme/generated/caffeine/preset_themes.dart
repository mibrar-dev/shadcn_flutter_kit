// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: caffeine.json
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
    id: 'caffeine',
    name: "Caffeine",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFF9F9F9),
      foreground: Color(0xFF202020),
      card: Color(0xFFFCFCFC),
      cardForeground: Color(0xFF202020),
      popover: Color(0xFFFCFCFC),
      popoverForeground: Color(0xFF202020),
      primary: Color(0xFF644A40),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFFFDFB5),
      secondaryForeground: Color(0xFF582D1D),
      muted: Color(0xFFEFEFEF),
      mutedForeground: Color(0xFF646464),
      accent: Color(0xFFE8E8E8),
      accentForeground: Color(0xFF202020),
      destructive: Color(0xFFE54D2E),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFD8D8D8),
      input: Color(0xFFD8D8D8),
      ring: Color(0xFF644A40),
      chart1: Color(0xFF644A40),
      chart2: Color(0xFFFFDFB5),
      chart3: Color(0xFFE8E8E8),
      chart4: Color(0xFFFFE6C4),
      chart5: Color(0xFF66493E),
      sidebar: Color(0xFFFBFBFB),
      sidebarForeground: Color(0xFF252525),
      sidebarPrimary: Color(0xFF343434),
      sidebarPrimaryForeground: Color(0xFFFBFBFB),
      sidebarAccent: Color(0xFFF7F7F7),
      sidebarAccentForeground: Color(0xFF343434),
      sidebarBorder: Color(0xFFEBEBEB),
      sidebarRing: Color(0xFFB5B5B5),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF111111),
      foreground: Color(0xFFEEEEEE),
      card: Color(0xFF191919),
      cardForeground: Color(0xFFEEEEEE),
      popover: Color(0xFF191919),
      popoverForeground: Color(0xFFEEEEEE),
      primary: Color(0xFFFFE0C2),
      primaryForeground: Color(0xFF081A1B),
      secondary: Color(0xFF393028),
      secondaryForeground: Color(0xFFFFE0C2),
      muted: Color(0xFF222222),
      mutedForeground: Color(0xFFB4B4B4),
      accent: Color(0xFF2A2A2A),
      accentForeground: Color(0xFFEEEEEE),
      destructive: Color(0xFFE54D2E),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFF201E18),
      input: Color(0xFF484848),
      ring: Color(0xFFFFE0C2),
      chart1: Color(0xFFFFE0C2),
      chart2: Color(0xFF393028),
      chart3: Color(0xFF2A2A2A),
      chart4: Color(0xFF42382E),
      chart5: Color(0xFFFFE0C1),
      sidebar: Color(0xFF18181B),
      sidebarForeground: Color(0xFFF4F4F5),
      sidebarPrimary: Color(0xFF1D4ED8),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFF27272A),
      sidebarAccentForeground: Color(0xFFF4F4F5),
      sidebarBorder: Color(0xFF27272A),
      sidebarRing: Color(0xFFD4D4D8),
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
