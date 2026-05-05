// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: t3-chat.json
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
    id: 't3-chat',
    name: "T3 Chat",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFFAF5FA),
      foreground: Color(0xFF501854),
      card: Color(0xFFFAF5FA),
      cardForeground: Color(0xFF501854),
      popover: Color(0xFFFFFFFF),
      popoverForeground: Color(0xFF501854),
      primary: Color(0xFFA84370),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFF1C4E6),
      secondaryForeground: Color(0xFF77347C),
      muted: Color(0xFFF6E5F3),
      mutedForeground: Color(0xFF834588),
      accent: Color(0xFFF1C4E6),
      accentForeground: Color(0xFF77347C),
      destructive: Color(0xFFAB4347),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFEFBDEB),
      input: Color(0xFFE7C1DC),
      ring: Color(0xFFDB2777),
      chart1: Color(0xFFD926A2),
      chart2: Color(0xFF6C12B9),
      chart3: Color(0xFF274754),
      chart4: Color(0xFFE8C468),
      chart5: Color(0xFFF4A462),
      sidebar: Color(0xFFF3E4F6),
      sidebarForeground: Color(0xFFAC1668),
      sidebarPrimary: Color(0xFF454554),
      sidebarPrimaryForeground: Color(0xFFFAF1F7),
      sidebarAccent: Color(0xFFF8F8F7),
      sidebarAccentForeground: Color(0xFF454554),
      sidebarBorder: Color(0xFFECEAE9),
      sidebarRing: Color(0xFFDB2777),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF221D27),
      foreground: Color(0xFFD2C4DE),
      card: Color(0xFF2C2632),
      cardForeground: Color(0xFFDBC5D2),
      popover: Color(0xFF100A0E),
      popoverForeground: Color(0xFFF8F1F5),
      primary: Color(0xFFA3004C),
      primaryForeground: Color(0xFFEFC0D8),
      secondary: Color(0xFF362D3D),
      secondaryForeground: Color(0xFFD4C7E1),
      muted: Color(0xFF28222D),
      mutedForeground: Color(0xFFC2B6CF),
      accent: Color(0xFF463753),
      accentForeground: Color(0xFFF8F1F5),
      destructive: Color(0xFF301015),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFF3B3237),
      input: Color(0xFF3E343C),
      ring: Color(0xFFDB2777),
      chart1: Color(0xFFA84370),
      chart2: Color(0xFF934DCB),
      chart3: Color(0xFFE88C30),
      chart4: Color(0xFFAF57DB),
      chart5: Color(0xFFE23670),
      sidebar: Color(0xFF181117),
      sidebarForeground: Color(0xFFE0CAD6),
      sidebarPrimary: Color(0xFF1D4ED8),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFF261922),
      sidebarAccentForeground: Color(0xFFF4F4F5),
      sidebarBorder: Color(0xFF000000),
      sidebarRing: Color(0xFFDB2777),
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
