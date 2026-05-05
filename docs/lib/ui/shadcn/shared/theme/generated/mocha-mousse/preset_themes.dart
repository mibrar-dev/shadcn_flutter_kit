// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: mocha-mousse.json
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
    id: 'mocha-mousse',
    name: "Mocha Mousse",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFF1F0E5),
      foreground: Color(0xFF56453F),
      card: Color(0xFFF1F0E5),
      cardForeground: Color(0xFF56453F),
      popover: Color(0xFFFFFFFF),
      popoverForeground: Color(0xFF56453F),
      primary: Color(0xFFA37764),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFBAAB92),
      secondaryForeground: Color(0xFFFFFFFF),
      muted: Color(0xFFE4C7B8),
      mutedForeground: Color(0xFF8A655A),
      accent: Color(0xFFE4C7B8),
      accentForeground: Color(0xFF56453F),
      destructive: Color(0xFF1F1A17),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFBAAB92),
      input: Color(0xFFBAAB92),
      ring: Color(0xFFA37764),
      chart1: Color(0xFFA37764),
      chart2: Color(0xFF8A655A),
      chart3: Color(0xFFC39E88),
      chart4: Color(0xFFBAAB92),
      chart5: Color(0xFFA28777),
      sidebar: Color(0xFFEBD6CB),
      sidebarForeground: Color(0xFF56453F),
      sidebarPrimary: Color(0xFFA37764),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFFC39E88),
      sidebarAccentForeground: Color(0xFFFFFFFF),
      sidebarBorder: Color(0xFFA28777),
      sidebarRing: Color(0xFFA37764),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF2D2521),
      foreground: Color(0xFFF1F0E5),
      card: Color(0xFF3C332E),
      cardForeground: Color(0xFFF1F0E5),
      popover: Color(0xFF3C332E),
      popoverForeground: Color(0xFFF1F0E5),
      primary: Color(0xFFC39E88),
      primaryForeground: Color(0xFF2D2521),
      secondary: Color(0xFF8A655A),
      secondaryForeground: Color(0xFFF1F0E5),
      muted: Color(0xFF56453F),
      mutedForeground: Color(0xFFC5AA9B),
      accent: Color(0xFFBAAB92),
      accentForeground: Color(0xFF2D2521),
      destructive: Color(0xFFE57373),
      destructiveForeground: Color(0xFF2D2521),
      border: Color(0xFF56453F),
      input: Color(0xFF56453F),
      ring: Color(0xFFC39E88),
      chart1: Color(0xFFC39E88),
      chart2: Color(0xFFBAAB92),
      chart3: Color(0xFFA37764),
      chart4: Color(0xFF8A655A),
      chart5: Color(0xFFA28777),
      sidebar: Color(0xFF1F1A17),
      sidebarForeground: Color(0xFFF1F0E5),
      sidebarPrimary: Color(0xFFC39E88),
      sidebarPrimaryForeground: Color(0xFF1F1A17),
      sidebarAccent: Color(0xFFBAAB92),
      sidebarAccentForeground: Color(0xFF1F1A17),
      sidebarBorder: Color(0xFF56453F),
      sidebarRing: Color(0xFFC39E88),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 0.5,
      spacing: SpacingScale(3.84),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0B997B6C),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0B997B6C),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0B997B6C),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0B997B6C),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0B997B6C),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0B997B6C),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0B997B6C),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x0B997B6C),
          ),
        ],
      ),
      fontSans: "DM Sans, sans-serif",
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
            color: Color(0x805A483F),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x805A483F),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x805A483F),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x805A483F),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x805A483F),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x805A483F),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x805A483F),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x805A483F),
          ),
        ],
      ),
    ),
  ),
];
