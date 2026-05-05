// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: graphite.json
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
    id: 'graphite',
    name: "Graphite",
    light: const ColorScheme(
      brightness: Brightness.light,
      background: Color(0xFFF0F0F0),
      foreground: Color(0xFF333333),
      card: Color(0xFFF5F5F5),
      cardForeground: Color(0xFF333333),
      popover: Color(0xFFF5F5F5),
      popoverForeground: Color(0xFF333333),
      primary: Color(0xFF606060),
      primaryForeground: Color(0xFFFFFFFF),
      secondary: Color(0xFFE0E0E0),
      secondaryForeground: Color(0xFF333333),
      muted: Color(0xFFD9D9D9),
      mutedForeground: Color(0xFF666666),
      accent: Color(0xFFC0C0C0),
      accentForeground: Color(0xFF333333),
      destructive: Color(0xFFCC3333),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFFD0D0D0),
      input: Color(0xFFE0E0E0),
      ring: Color(0xFF606060),
      chart1: Color(0xFF606060),
      chart2: Color(0xFF476666),
      chart3: Color(0xFF909090),
      chart4: Color(0xFFA8A8A8),
      chart5: Color(0xFFC0C0C0),
      sidebar: Color(0xFFEAEAEA),
      sidebarForeground: Color(0xFF333333),
      sidebarPrimary: Color(0xFF606060),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFFC0C0C0),
      sidebarAccentForeground: Color(0xFF333333),
      sidebarBorder: Color(0xFFD0D0D0),
      sidebarRing: Color(0xFF606060),
    ),
    dark: const ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xFF1A1A1A),
      foreground: Color(0xFFD9D9D9),
      card: Color(0xFF202020),
      cardForeground: Color(0xFFD9D9D9),
      popover: Color(0xFF202020),
      popoverForeground: Color(0xFFD9D9D9),
      primary: Color(0xFFA0A0A0),
      primaryForeground: Color(0xFF1A1A1A),
      secondary: Color(0xFF303030),
      secondaryForeground: Color(0xFFD9D9D9),
      muted: Color(0xFF2A2A2A),
      mutedForeground: Color(0xFF808080),
      accent: Color(0xFF404040),
      accentForeground: Color(0xFFD9D9D9),
      destructive: Color(0xFFE06666),
      destructiveForeground: Color(0xFFFFFFFF),
      border: Color(0xFF353535),
      input: Color(0xFF303030),
      ring: Color(0xFFA0A0A0),
      chart1: Color(0xFFA0A0A0),
      chart2: Color(0xFF7E9CA0),
      chart3: Color(0xFF707070),
      chart4: Color(0xFF585858),
      chart5: Color(0xFF404040),
      sidebar: Color(0xFF1F1F1F),
      sidebarForeground: Color(0xFFD9D9D9),
      sidebarPrimary: Color(0xFFA0A0A0),
      sidebarPrimaryForeground: Color(0xFF1A1A1A),
      sidebarAccent: Color(0xFF404040),
      sidebarAccentForeground: Color(0xFFD9D9D9),
      sidebarBorder: Color(0xFF353535),
      sidebarRing: Color(0xFFA0A0A0),
    ),
    lightTokens: RegistryThemePresetTokens(
      radius: 0.35,
      spacing: SpacingScale(3.84),
      tracking: TrackingScale(normal: 0),
      shadows: ShadowScale(
        shadow2xs: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x04333333),
          ),
        ],
        shadowXs: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x04333333),
          ),
        ],
        shadowSm: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x04333333),
          ),
        ],
        shadow: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x04333333),
          ),
        ],
        shadowMd: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x04333333),
          ),
        ],
        shadowLg: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x04333333),
          ),
        ],
        shadowXl: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x04333333),
          ),
        ],
        shadow2xl: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 0,
            spreadRadius: 0,
            color: Color(0x04333333),
          ),
        ],
      ),
      fontSans: "Montserrat, sans-serif",
      fontSerif: "Georgia, serif",
      fontMono: "Fira Code, monospace",
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
      fontSans: "Inter, sans-serif",
      fontSerif: "Georgia, serif",
      fontMono: "Fira Code, monospace",
    ),
  ),
];
