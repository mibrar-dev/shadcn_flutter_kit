// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: soft-pop.json
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
    id: 'soft-pop',
    name: "Soft Pop",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFF7F9F3),
      foreground: Color(0xFF000000),
      card: Color(0xFFFFFFFF),
      cardForeground: Color(0xFF000000),
      popover: Color(0xFFFFFFFF),
      popoverForeground: Color(0xFF000000),
      primary: Color(0xFF4F46E5),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFF14B8A6),
      secondaryForeground: Color(0xFFFFFFFF),
      muted: Color(0xFFF0F0F0),
      mutedForeground: Color(0xFF333333),
      accent: Color(0xFFF59E0B),
      accentForeground: Color(0xFF000000),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFF000000),
      input: Color(0xFF737373),
      ring: Color(0xFFA5B4FC),
      chart1: Color(0xFF4F46E5),
      chart2: Color(0xFF14B8A6),
      chart3: Color(0xFFF59E0B),
      chart4: Color(0xFFEC4899),
      chart5: Color(0xFF22C55E),
      sidebar: Color(0xFFF7F9F3),
      sidebarForeground: Color(0xFF000000),
      sidebarPrimary: Color(0xFF4F46E5),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFFF59E0B),
      sidebarAccentForeground: Color(0xFF000000),
      sidebarBorder: Color(0xFF000000),
      sidebarRing: Color(0xFFA5B4FC),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF000000),
      foreground: Color(0xFFFFFFFF),
      card: Color(0xFF1A212B),
      cardForeground: Color(0xFFFFFFFF),
      popover: Color(0xFF1A212B),
      popoverForeground: Color(0xFFFFFFFF),
      primary: Color(0xFF818CF8),
      primaryForeground: Color(0xFF000000),
      secondary: Color(0xFF2DD4BF),
      secondaryForeground: Color(0xFF000000),
      muted: Color(0xFF333333),
      mutedForeground: Color(0xFFCCCCCC),
      accent: Color(0xFFFCD34D),
      accentForeground: Color(0xFF000000),
      destructive: Color(0xFFF87171),
      destructiveForeground: Color(0xFF000000),
      border: Color(0xFF545454),
      input: Color(0xFFFFFFFF),
      ring: Color(0xFF818CF8),
      chart1: Color(0xFF818CF8),
      chart2: Color(0xFF2DD4BF),
      chart3: Color(0xFFFCD34D),
      chart4: Color(0xFFF472B6),
      chart5: Color(0xFF4ADE80),
      sidebar: Color(0xFF000000),
      sidebarForeground: Color(0xFFFFFFFF),
      sidebarPrimary: Color(0xFF818CF8),
      sidebarPrimaryForeground: Color(0xFF000000),
      sidebarAccent: Color(0xFFFCD34D),
      sidebarAccentForeground: Color(0xFF000000),
      sidebarBorder: Color(0xFFFFFFFF),
      sidebarRing: Color(0xFF818CF8),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 1,
      spacing: SpacingScale(4),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0D1A1A1A),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0D1A1A1A),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0D1A1A1A),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0D1A1A1A),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0D1A1A1A),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0D1A1A1A),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0D1A1A1A),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0D1A1A1A),
          ),
        ],
      ),
      fontSans: "DM Sans, sans-serif",
      fontSerif: "DM Sans, sans-serif",
      fontMono: "Space Mono, monospace",
    ),
    darkTokens: RegistryThemePresetTokens(
      radius: 1,
      spacing: SpacingScale(4),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0D1A1A1A),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0D1A1A1A),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0D1A1A1A),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0D1A1A1A),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0D1A1A1A),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0D1A1A1A),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0D1A1A1A),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0D1A1A1A),
          ),
        ],
      ),
      fontSans: "DM Sans, sans-serif",
      fontSerif: "DM Sans, sans-serif",
      fontMono: "Space Mono, monospace",
    ),
  ),
];
