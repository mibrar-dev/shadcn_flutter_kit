// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: darkmatter.json
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
    id: 'darkmatter',
    name: "Darkmatter",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFFFFFFF),
      foreground: Color(0xFF111827),
      card: Color(0xFFFFFFFF),
      cardForeground: Color(0xFF111827),
      popover: Color(0xFFFFFFFF),
      popoverForeground: Color(0xFF111827),
      primary: Color(0xFFD87943),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFF527575),
      secondaryForeground: Color(0xFFFFFFFF),
      muted: Color(0xFFF3F4F6),
      mutedForeground: Color(0xFF6B7280),
      accent: Color(0xFFEEEEEE),
      accentForeground: Color(0xFF111827),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFAFAFA),
      border: Color(0xFFE5E7EB),
      input: Color(0xFFE5E7EB),
      ring: Color(0xFFD87943),
      chart1: Color(0xFF5F8787),
      chart2: Color(0xFFE78A53),
      chart3: Color(0xFFFBCB97),
      chart4: Color(0xFF888888),
      chart5: Color(0xFF999999),
      sidebar: Color(0xFFF3F4F6),
      sidebarForeground: Color(0xFF111827),
      sidebarPrimary: Color(0xFFD87943),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFFFFFFFF),
      sidebarAccentForeground: Color(0xFF111827),
      sidebarBorder: Color(0xFFE5E7EB),
      sidebarRing: Color(0xFFD87943),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF121113),
      foreground: Color(0xFFC1C1C1),
      card: Color(0xFF121212),
      cardForeground: Color(0xFFC1C1C1),
      popover: Color(0xFF121113),
      popoverForeground: Color(0xFFC1C1C1),
      primary: Color(0xFFE78A53),
      primaryForeground: Color(0xFF121113),
      secondary: Color(0xFF5F8787),
      secondaryForeground: Color(0xFF121113),
      muted: Color(0xFF222222),
      mutedForeground: Color(0xFF888888),
      accent: Color(0xFF333333),
      accentForeground: Color(0xFFC1C1C1),
      destructive: Color(0xFF5F8787),
      destructiveForeground: Color(0xFF121113),
      border: Color(0xFF222222),
      input: Color(0xFF222222),
      ring: Color(0xFFE78A53),
      chart1: Color(0xFF5F8787),
      chart2: Color(0xFFE78A53),
      chart3: Color(0xFFFBCB97),
      chart4: Color(0xFF888888),
      chart5: Color(0xFF999999),
      sidebar: Color(0xFF121212),
      sidebarForeground: Color(0xFFC1C1C1),
      sidebarPrimary: Color(0xFFE78A53),
      sidebarPrimaryForeground: Color(0xFF121113),
      sidebarAccent: Color(0xFF333333),
      sidebarAccentForeground: Color(0xFFC1C1C1),
      sidebarBorder: Color(0xFF222222),
      sidebarRing: Color(0xFFE78A53),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 0.75,
      spacing: SpacingScale(4),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x0D000000),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x0D000000),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x0D000000),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x0D000000),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x0D000000),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x0D000000),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x0D000000),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x0D000000),
          ),
        ],
      ),
      fontSans: "Geist Mono, ui-monospace, monospace",
      fontSerif: "serif",
      fontMono: "JetBrains Mono, monospace",
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
            color: Color(0xFF000000),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF000000),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF000000),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF000000),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF000000),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF000000),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF000000),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0xFF000000),
          ),
        ],
      ),
    ),
  ),
];
