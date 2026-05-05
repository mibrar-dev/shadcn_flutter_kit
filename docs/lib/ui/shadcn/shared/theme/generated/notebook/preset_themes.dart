// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: notebook.json
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
    id: 'notebook',
    name: "Notebook",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFF9F9F9),
      foreground: Color(0xFF3A3A3A),
      card: Color(0xFFFFFFFF),
      cardForeground: Color(0xFF3A3A3A),
      popover: Color(0xFFFFFFFF),
      popoverForeground: Color(0xFF3A3A3A),
      primary: Color(0xFF606060),
      primaryForeground: Color(0xFFF0F0F0),
      secondary: Color(0xFFDEDEDE),
      secondaryForeground: Color(0xFF3A3A3A),
      muted: Color(0xFFE3E3E3),
      mutedForeground: Color(0xFF505050),
      accent: Color(0xFFF3EAC8),
      accentForeground: Color(0xFF5D4037),
      destructive: Color(0xFFC87A7A),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFF747272),
      input: Color(0xFFFFFFFF),
      ring: Color(0xFFA0A0A0),
      chart1: Color(0xFF333333),
      chart2: Color(0xFF555555),
      chart3: Color(0xFF777777),
      chart4: Color(0xFF999999),
      chart5: Color(0xFFBBBBBB),
      sidebar: Color(0xFFF0F0F0),
      sidebarForeground: Color(0xFF3A3A3A),
      sidebarPrimary: Color(0xFF606060),
      sidebarPrimaryForeground: Color(0xFFF0F0F0),
      sidebarAccent: Color(0xFFF3EAC8),
      sidebarAccentForeground: Color(0xFF5D4037),
      sidebarBorder: Color(0xFFC0C0C0),
      sidebarRing: Color(0xFFA0A0A0),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF2B2B2B),
      foreground: Color(0xFFDCDCDC),
      card: Color(0xFF333333),
      cardForeground: Color(0xFFDCDCDC),
      popover: Color(0xFF333333),
      popoverForeground: Color(0xFFDCDCDC),
      primary: Color(0xFFB0B0B0),
      primaryForeground: Color(0xFF2B2B2B),
      secondary: Color(0xFF5A5A5A),
      secondaryForeground: Color(0xFFC0C0C0),
      muted: Color(0xFF454545),
      mutedForeground: Color(0xFFA0A0A0),
      accent: Color(0xFFE0E0E0),
      accentForeground: Color(0xFF333333),
      destructive: Color(0xFFD9AFAF),
      destructiveForeground: Color(0xFF2B2B2B),
      border: Color(0xFF4F4F4F),
      input: Color(0xFF333333),
      ring: Color(0xFFC0C0C0),
      chart1: Color(0xFFEFEFEF),
      chart2: Color(0xFFD0D0D0),
      chart3: Color(0xFFB0B0B0),
      chart4: Color(0xFF909090),
      chart5: Color(0xFF707070),
      sidebar: Color(0xFF212121),
      sidebarForeground: Color(0xFFDCDCDC),
      sidebarPrimary: Color(0xFFB0B0B0),
      sidebarPrimaryForeground: Color(0xFF212121),
      sidebarAccent: Color(0xFFE0E0E0),
      sidebarAccentForeground: Color(0xFF333333),
      sidebarBorder: Color(0xFF4F4F4F),
      sidebarRing: Color(0xFFC0C0C0),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 0.625,
      spacing: SpacingScale(4),
      tracking: TrackingScale(normal: 0.5),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(1, 4),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x08000000),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(1, 4),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x08000000),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(1, 4),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x08000000),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(1, 4),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x08000000),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(1, 4),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x08000000),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(1, 4),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x08000000),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(1, 4),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x08000000),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(1, 4),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x08000000),
          ),
        ],
      ),
      fontSans: "Architects Daughter, sans-serif",
      fontSerif: "\\",
      fontMono: "\\",
    ),
    darkTokens: RegistryThemePresetTokens(
      radius: 0.625,
      spacing: SpacingScale(4),
      tracking: TrackingScale(normal: 0.5),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(1, 4),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x08000000),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(1, 4),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x08000000),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(1, 4),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x08000000),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(1, 4),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x08000000),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(1, 4),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x08000000),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(1, 4),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x08000000),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(1, 4),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x08000000),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(1, 4),
            blurRadius: 5,
            spreadRadius: 0,
            color: Color(0x08000000),
          ),
        ],
      ),
      fontSans: "Architects Daughter, sans-serif",
      fontSerif: "Georgia, serif",
      fontMono: "\\",
    ),
  ),
];
