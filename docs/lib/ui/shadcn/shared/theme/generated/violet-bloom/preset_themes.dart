// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: violet-bloom.json
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
    id: 'violet-bloom',
    name: "Violet Bloom",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFFDFDFD),
      foreground: Color(0xFF000000),
      card: Color(0xFFFDFDFD),
      cardForeground: Color(0xFF000000),
      popover: Color(0xFFFCFCFC),
      popoverForeground: Color(0xFF000000),
      primary: Color(0xFF7033FF),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFEDF0F4),
      secondaryForeground: Color(0xFF080808),
      muted: Color(0xFFF5F5F5),
      mutedForeground: Color(0xFF525252),
      accent: Color(0xFFE2EBFF),
      accentForeground: Color(0xFF1E69DC),
      destructive: Color(0xFFE54B4F),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFE7E7EE),
      input: Color(0xFFEBEBEB),
      ring: Color(0xFF000000),
      chart1: Color(0xFF4AC885),
      chart2: Color(0xFF7033FF),
      chart3: Color(0xFFFD822B),
      chart4: Color(0xFF3276E4),
      chart5: Color(0xFF747474),
      sidebar: Color(0xFFF5F8FB),
      sidebarForeground: Color(0xFF000000),
      sidebarPrimary: Color(0xFF000000),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFFEBEBEB),
      sidebarAccentForeground: Color(0xFF000000),
      sidebarBorder: Color(0xFFEBEBEB),
      sidebarRing: Color(0xFF000000),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF1A1B1E),
      foreground: Color(0xFFF0F0F0),
      card: Color(0xFF222327),
      cardForeground: Color(0xFFF0F0F0),
      popover: Color(0xFF222327),
      popoverForeground: Color(0xFFF0F0F0),
      primary: Color(0xFF8C5CFF),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFF2A2C33),
      secondaryForeground: Color(0xFFF0F0F0),
      muted: Color(0xFF2A2C33),
      mutedForeground: Color(0xFFA0A0A0),
      accent: Color(0xFF1E293B),
      accentForeground: Color(0xFF79C0FF),
      destructive: Color(0xFFF87171),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFF33353A),
      input: Color(0xFF33353A),
      ring: Color(0xFF8C5CFF),
      chart1: Color(0xFF4ADE80),
      chart2: Color(0xFF8C5CFF),
      chart3: Color(0xFFFCA5A5),
      chart4: Color(0xFF5993F4),
      chart5: Color(0xFFA0A0A0),
      sidebar: Color(0xFF161618),
      sidebarForeground: Color(0xFFF0F0F0),
      sidebarPrimary: Color(0xFF8C5CFF),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFF2A2C33),
      sidebarAccentForeground: Color(0xFF8C5CFF),
      sidebarBorder: Color(0xFF33353A),
      sidebarRing: Color(0xFF8C5CFF),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 1.4,
      spacing: SpacingScale(4.32),
      tracking: TrackingScale(normal: -0.4),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x29000000),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x29000000),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x29000000),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x29000000),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x29000000),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x29000000),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x29000000),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x29000000),
          ),
        ],
      ),
      fontSans: "Plus Jakarta Sans, sans-serif",
      fontSerif: "Lora, serif",
      fontMono: "IBM Plex Mono, monospace",
    ),
    darkTokens: RegistryThemePresetTokens(
      radius: 1.4,
      spacing: SpacingScale(4.32),
      tracking: TrackingScale(normal: -0.4),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x29000000),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x29000000),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x29000000),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x29000000),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x29000000),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x29000000),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x29000000),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            spreadRadius: 0,
            color: Color(0x29000000),
          ),
        ],
      ),
      fontSans: "Plus Jakarta Sans, sans-serif",
      fontSerif: "Lora, serif",
      fontMono: "IBM Plex Mono, monospace",
    ),
  ),
];
