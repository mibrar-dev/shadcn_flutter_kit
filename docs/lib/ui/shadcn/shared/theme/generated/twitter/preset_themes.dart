// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: twitter.json
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
    id: 'twitter',
    name: "Twitter",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFFFFFFF),
      foreground: Color(0xFF0F1419),
      card: Color(0xFFF7F8F8),
      cardForeground: Color(0xFF0F1419),
      popover: Color(0xFFFFFFFF),
      popoverForeground: Color(0xFF0F1419),
      primary: Color(0xFF1E9DF1),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFF0F1419),
      secondaryForeground: Color(0xFFFFFFFF),
      muted: Color(0xFFE5E5E6),
      mutedForeground: Color(0xFF0F1419),
      accent: Color(0xFFE3ECF6),
      accentForeground: Color(0xFF1E9DF1),
      destructive: Color(0xFFF4212E),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFE1EAEF),
      input: Color(0xFFF7F9FA),
      ring: Color(0xFF1DA1F2),
      chart1: Color(0xFF1E9DF1),
      chart2: Color(0xFF00B87A),
      chart3: Color(0xFFF7B928),
      chart4: Color(0xFF17BF63),
      chart5: Color(0xFFE0245E),
      sidebar: Color(0xFFF7F8F8),
      sidebarForeground: Color(0xFF0F1419),
      sidebarPrimary: Color(0xFF1E9DF1),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFFE3ECF6),
      sidebarAccentForeground: Color(0xFF1E9DF1),
      sidebarBorder: Color(0xFFE1E8ED),
      sidebarRing: Color(0xFF1DA1F2),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF000000),
      foreground: Color(0xFFE7E9EA),
      card: Color(0xFF17181C),
      cardForeground: Color(0xFFD9D9D9),
      popover: Color(0xFF000000),
      popoverForeground: Color(0xFFE7E9EA),
      primary: Color(0xFF1C9CF0),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFF0F3F4),
      secondaryForeground: Color(0xFF0F1419),
      muted: Color(0xFF181818),
      mutedForeground: Color(0xFF72767A),
      accent: Color(0xFF061622),
      accentForeground: Color(0xFF1C9CF0),
      destructive: Color(0xFFF4212E),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFF242628),
      input: Color(0xFF22303C),
      ring: Color(0xFF1DA1F2),
      chart1: Color(0xFF1E9DF1),
      chart2: Color(0xFF00B87A),
      chart3: Color(0xFFF7B928),
      chart4: Color(0xFF17BF63),
      chart5: Color(0xFFE0245E),
      sidebar: Color(0xFF17181C),
      sidebarForeground: Color(0xFFD9D9D9),
      sidebarPrimary: Color(0xFF1DA1F2),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFF061622),
      sidebarAccentForeground: Color(0xFF1C9CF0),
      sidebarBorder: Color(0xFF38444D),
      sidebarRing: Color(0xFF1DA1F2),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 1.3,
      spacing: SpacingScale(3.84),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x001DA1F2),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x001DA1F2),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x001DA1F2),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x001DA1F2),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x001DA1F2),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x001DA1F2),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x001DA1F2),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x001DA1F2),
          ),
        ],
      ),
      fontSans: "Open Sans, sans-serif",
      fontSerif: "Georgia, serif",
      fontMono: "Menlo, monospace",
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
            color: Color(0x401DA1F2),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x401DA1F2),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x401DA1F2),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x401DA1F2),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x401DA1F2),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x401DA1F2),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x401DA1F2),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x401DA1F2),
          ),
        ],
      ),
    ),
  ),
];
