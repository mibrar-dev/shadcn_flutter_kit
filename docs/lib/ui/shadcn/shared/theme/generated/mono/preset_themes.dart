// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: mono.json
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
    id: 'mono',
    name: "Mono",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFFFFFFF),
      foreground: Color(0xFF0A0A0A),
      card: Color(0xFFFFFFFF),
      cardForeground: Color(0xFF0A0A0A),
      popover: Color(0xFFFFFFFF),
      popoverForeground: Color(0xFF0A0A0A),
      primary: Color(0xFF737373),
      primaryForeground: Color(0xFFFAFAFA),
      secondary: Color(0xFFF5F5F5),
      secondaryForeground: Color(0xFF171717),
      muted: Color(0xFFF5F5F5),
      mutedForeground: Color(0xFF717171),
      accent: Color(0xFFF5F5F5),
      accentForeground: Color(0xFF171717),
      destructive: Color(0xFFE7000B),
      destructiveForeground: Color(0xFFF5F5F5),
      border: Color(0xFFE5E5E5),
      input: Color(0xFFE5E5E5),
      ring: Color(0xFFA1A1A1),
      chart1: Color(0xFF737373),
      chart2: Color(0xFF737373),
      chart3: Color(0xFF737373),
      chart4: Color(0xFF737373),
      chart5: Color(0xFF737373),
      sidebar: Color(0xFFFAFAFA),
      sidebarForeground: Color(0xFF0A0A0A),
      sidebarPrimary: Color(0xFF171717),
      sidebarPrimaryForeground: Color(0xFFFAFAFA),
      sidebarAccent: Color(0xFFF5F5F5),
      sidebarAccentForeground: Color(0xFF171717),
      sidebarBorder: Color(0xFFE5E5E5),
      sidebarRing: Color(0xFFA1A1A1),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF0A0A0A),
      foreground: Color(0xFFFAFAFA),
      card: Color(0xFF191919),
      cardForeground: Color(0xFFFAFAFA),
      popover: Color(0xFF262626),
      popoverForeground: Color(0xFFFAFAFA),
      primary: Color(0xFF737373),
      primaryForeground: Color(0xFFFAFAFA),
      secondary: Color(0xFF262626),
      secondaryForeground: Color(0xFFFAFAFA),
      muted: Color(0xFF262626),
      mutedForeground: Color(0xFFA1A1A1),
      accent: Color(0xFF404040),
      accentForeground: Color(0xFFFAFAFA),
      destructive: Color(0xFFFF6467),
      destructiveForeground: Color(0xFF262626),
      border: Color(0xFF383838),
      input: Color(0xFF525252),
      ring: Color(0xFF737373),
      chart1: Color(0xFF737373),
      chart2: Color(0xFF737373),
      chart3: Color(0xFF737373),
      chart4: Color(0xFF737373),
      chart5: Color(0xFF737373),
      sidebar: Color(0xFF171717),
      sidebarForeground: Color(0xFFFAFAFA),
      sidebarPrimary: Color(0xFFFAFAFA),
      sidebarPrimaryForeground: Color(0xFF171717),
      sidebarAccent: Color(0xFF262626),
      sidebarAccentForeground: Color(0xFFFAFAFA),
      sidebarBorder: Color(0xFFFFFFFF),
      sidebarRing: Color(0xFF525252),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 0,
      spacing: SpacingScale(3.84),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x00000000),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x00000000),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x00000000),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x00000000),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x00000000),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x00000000),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x00000000),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x00000000),
          ),
        ],
      ),
      fontSans: "Geist Mono, monospace",
      fontSerif: "Geist Mono, monospace",
      fontMono: "Geist Mono, monospace",
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
