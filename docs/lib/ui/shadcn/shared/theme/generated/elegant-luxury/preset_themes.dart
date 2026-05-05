// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: elegant-luxury.json
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
    id: 'elegant-luxury',
    name: "Elegant Luxury",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFFAF7F5),
      foreground: Color(0xFF1A1A1A),
      card: Color(0xFFFAF7F5),
      cardForeground: Color(0xFF1A1A1A),
      popover: Color(0xFFFAF7F5),
      popoverForeground: Color(0xFF1A1A1A),
      primary: Color(0xFF9B2C2C),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFFDF2D6),
      secondaryForeground: Color(0xFF805500),
      muted: Color(0xFFF0EBE8),
      mutedForeground: Color(0xFF57534E),
      accent: Color(0xFFFEF3C7),
      accentForeground: Color(0xFF7F1D1D),
      destructive: Color(0xFF991B1B),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFF5E8D2),
      input: Color(0xFFF5E8D2),
      ring: Color(0xFF9B2C2C),
      chart1: Color(0xFFB91C1C),
      chart2: Color(0xFF9B2C2C),
      chart3: Color(0xFF7F1D1D),
      chart4: Color(0xFFB45309),
      chart5: Color(0xFF92400E),
      sidebar: Color(0xFFF0EBE8),
      sidebarForeground: Color(0xFF1A1A1A),
      sidebarPrimary: Color(0xFF9B2C2C),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFFFEF3C7),
      sidebarAccentForeground: Color(0xFF7F1D1D),
      sidebarBorder: Color(0xFFF5E8D2),
      sidebarRing: Color(0xFF9B2C2C),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF1C1917),
      foreground: Color(0xFFF5F5F4),
      card: Color(0xFF292524),
      cardForeground: Color(0xFFF5F5F4),
      popover: Color(0xFF292524),
      popoverForeground: Color(0xFFF5F5F4),
      primary: Color(0xFFB91C1C),
      primaryForeground: Color(0xFFFAF7F5),
      secondary: Color(0xFF92400E),
      secondaryForeground: Color(0xFFFEF3C7),
      muted: Color(0xFF1F1C1A),
      mutedForeground: Color(0xFFD6D3D1),
      accent: Color(0xFFB45309),
      accentForeground: Color(0xFFFEF3C7),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFF44403C),
      input: Color(0xFF44403C),
      ring: Color(0xFFB91C1C),
      chart1: Color(0xFFF87171),
      chart2: Color(0xFFEF4444),
      chart3: Color(0xFFDC2626),
      chart4: Color(0xFFFBBF24),
      chart5: Color(0xFFF59E0B),
      sidebar: Color(0xFF1C1917),
      sidebarForeground: Color(0xFFF5F5F4),
      sidebarPrimary: Color(0xFFB91C1C),
      sidebarPrimaryForeground: Color(0xFFFAF7F5),
      sidebarAccent: Color(0xFFB45309),
      sidebarAccentForeground: Color(0xFFFEF3C7),
      sidebarBorder: Color(0xFF44403C),
      sidebarRing: Color(0xFFB91C1C),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 0.375,
      spacing: SpacingScale(3.84),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 16,
            spreadRadius: -2,
            color: Color(0x1F4B1111),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 16,
            spreadRadius: -2,
            color: Color(0x1F4B1111),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 16,
            spreadRadius: -2,
            color: Color(0x1F4B1111),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 16,
            spreadRadius: -2,
            color: Color(0x1F4B1111),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 16,
            spreadRadius: -2,
            color: Color(0x1F4B1111),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 16,
            spreadRadius: -2,
            color: Color(0x1F4B1111),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 16,
            spreadRadius: -2,
            color: Color(0x1F4B1111),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 16,
            spreadRadius: -2,
            color: Color(0x1F4B1111),
          ),
        ],
      ),
      fontSans: "Poppins, sans-serif",
      fontSerif: "Libre Baskerville, serif",
      fontMono: "IBM Plex Mono, monospace",
    ),
    darkTokens: RegistryThemePresetTokens(
      radius: 0.375,
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
