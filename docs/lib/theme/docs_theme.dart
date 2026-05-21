import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';

import '../ui/shadcn/shared/theme/color_scheme.dart' as shadcn_colors;
import '../ui/shadcn/shared/theme/theme.dart' as shadcn_theme;

class DocsThemeData {
  final shadcn_colors.ColorScheme colorScheme;
  final double radius;
  final double scaling;
  final double surfaceOpacity;
  final double surfaceBlur;
  final shadcn_theme.Density density;
  final shadcn_theme.SpacingScale spacing;
  final shadcn_theme.TrackingScale tracking;
  final shadcn_theme.ShadowScale shadows;

  const DocsThemeData({
    required this.colorScheme,
    required this.radius,
    required this.scaling,
    required this.surfaceOpacity,
    required this.surfaceBlur,
    required this.density,
    required this.spacing,
    required this.tracking,
    required this.shadows,
  });

  DocsThemeData copyWith({
    shadcn_colors.ColorScheme? colorScheme,
    double? radius,
    double? scaling,
    double? surfaceOpacity,
    double? surfaceBlur,
    shadcn_theme.Density? density,
    shadcn_theme.SpacingScale? spacing,
    shadcn_theme.TrackingScale? tracking,
    shadcn_theme.ShadowScale? shadows,
  }) {
    return DocsThemeData(
      colorScheme: colorScheme ?? this.colorScheme,
      radius: radius ?? this.radius,
      scaling: scaling ?? this.scaling,
      surfaceOpacity: surfaceOpacity ?? this.surfaceOpacity,
      surfaceBlur: surfaceBlur ?? this.surfaceBlur,
      density: density ?? this.density,
      spacing: spacing ?? this.spacing,
      tracking: tracking ?? this.tracking,
      shadows: shadows ?? this.shadows,
    );
  }

  shadcn_theme.ThemeData toShadcnTheme() {
    return shadcn_theme.ThemeData(
      colorScheme: colorScheme,
      radius: radius,
      scaling: scaling,
      surfaceOpacity: surfaceOpacity,
      surfaceBlur: surfaceBlur,
      density: density,
      spacing: spacing,
      tracking: tracking,
      shadows: shadows,
    );
  }

  material.ThemeData toMaterialTheme() {
    final errorOn = material.ThemeData.estimateBrightnessForColor(
              colorScheme.destructive,
            ) ==
            material.Brightness.dark
        ? material.Colors.white
        : material.Colors.black;
    final materialScheme = material.ColorScheme(
      brightness: colorScheme.brightness,
      primary: colorScheme.primary,
      onPrimary: colorScheme.primaryForeground,
      secondary: colorScheme.secondary,
      onSecondary: colorScheme.secondaryForeground,
      error: colorScheme.destructive,
      onError: errorOn,
      surface: colorScheme.background,
      onSurface: colorScheme.foreground,
      surfaceContainerHighest: colorScheme.muted,
      onSurfaceVariant: colorScheme.mutedForeground,
      outline: colorScheme.border,
      outlineVariant: colorScheme.input,
      shadow: colorScheme.border,
      inverseSurface: colorScheme.foreground,
      onInverseSurface: colorScheme.background,
      inversePrimary: colorScheme.primary,
      scrim: colorScheme.ring,
    );
    return material.ThemeData(
      useMaterial3: true,
      colorScheme: materialScheme,
      scaffoldBackgroundColor: colorScheme.background,
      cardColor: colorScheme.card,
      dividerColor: colorScheme.border,
      canvasColor: colorScheme.background,
      iconTheme: material.IconThemeData(color: colorScheme.foreground),
      primaryIconTheme:
          material.IconThemeData(color: colorScheme.primaryForeground),
      textTheme: material.ThemeData(
        brightness: colorScheme.brightness,
        useMaterial3: true,
      ).textTheme.apply(
            bodyColor: colorScheme.foreground,
            displayColor: colorScheme.foreground,
          ),
      textButtonTheme: material.TextButtonThemeData(
        style: material.TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          iconColor: colorScheme.primary,
        ),
      ),
      filledButtonTheme: material.FilledButtonThemeData(
        style: material.FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.primaryForeground,
          disabledBackgroundColor: colorScheme.muted,
          disabledForegroundColor: colorScheme.mutedForeground,
        ),
      ),
      inputDecorationTheme: material.InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.input.withValues(alpha: 0.32),
        hintStyle: material.TextStyle(color: colorScheme.mutedForeground),
        labelStyle: material.TextStyle(color: colorScheme.foreground),
        errorStyle: material.TextStyle(color: colorScheme.destructive),
        enabledBorder: material.OutlineInputBorder(
          borderSide: material.BorderSide(color: colorScheme.border),
        ),
        focusedBorder: material.OutlineInputBorder(
          borderSide: material.BorderSide(color: colorScheme.ring),
        ),
        errorBorder: material.OutlineInputBorder(
          borderSide: material.BorderSide(color: colorScheme.destructive),
        ),
        focusedErrorBorder: material.OutlineInputBorder(
          borderSide: material.BorderSide(color: colorScheme.destructive),
        ),
      ),
    );
  }
}

class DocsThemeScope extends InheritedWidget {
  final DocsThemeData data;

  const DocsThemeScope({
    super.key,
    required this.data,
    required super.child,
  });

  static DocsThemeData of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<DocsThemeScope>();
    return scope?.data ?? _fallback;
  }

  static const DocsThemeData _fallback = DocsThemeData(
    colorScheme: shadcn_colors.ColorSchemes.lightDefaultColor,
    radius: 0.1,
    scaling: 1.0,
    surfaceOpacity: 1.0,
    surfaceBlur: 0.0,
    density: shadcn_theme.Density.defaultDensity,
    spacing: shadcn_theme.SpacingScale(3.84),
    tracking: shadcn_theme.TrackingScale(normal: 0),
    shadows: shadcn_theme.ShadowScale(
      shadow2xs: [
        BoxShadow(
          offset: Offset(20.5, 16.5),
          blurRadius: 25.5,
          spreadRadius: -30,
          color: Color(0x12000000),
        ),
      ],
      shadowXs: [
        BoxShadow(
          offset: Offset(20.5, 16.5),
          blurRadius: 25.5,
          spreadRadius: -30,
          color: Color(0x12000000),
        ),
      ],
      shadowSm: [
        BoxShadow(
          offset: Offset(20.5, 16.5),
          blurRadius: 25.5,
          spreadRadius: -30,
          color: Color(0x26000000),
        ),
        BoxShadow(
          offset: Offset(20.5, 1),
          blurRadius: 2,
          spreadRadius: -31,
          color: Color(0x26000000),
        ),
      ],
      shadow: [
        BoxShadow(
          offset: Offset(20.5, 16.5),
          blurRadius: 25.5,
          spreadRadius: -30,
          color: Color(0x26000000),
        ),
        BoxShadow(
          offset: Offset(20.5, 1),
          blurRadius: 2,
          spreadRadius: -31,
          color: Color(0x26000000),
        ),
      ],
      shadowMd: [
        BoxShadow(
          offset: Offset(20.5, 16.5),
          blurRadius: 25.5,
          spreadRadius: -30,
          color: Color(0x26000000),
        ),
        BoxShadow(
          offset: Offset(20.5, 2),
          blurRadius: 4,
          spreadRadius: -31,
          color: Color(0x26000000),
        ),
      ],
      shadowLg: [
        BoxShadow(
          offset: Offset(20.5, 16.5),
          blurRadius: 25.5,
          spreadRadius: -30,
          color: Color(0x26000000),
        ),
        BoxShadow(
          offset: Offset(20.5, 4),
          blurRadius: 6,
          spreadRadius: -31,
          color: Color(0x26000000),
        ),
      ],
      shadowXl: [
        BoxShadow(
          offset: Offset(20.5, 16.5),
          blurRadius: 25.5,
          spreadRadius: -30,
          color: Color(0x26000000),
        ),
        BoxShadow(
          offset: Offset(20.5, 8),
          blurRadius: 10,
          spreadRadius: -31,
          color: Color(0x26000000),
        ),
      ],
      shadow2xl: [
        BoxShadow(
          offset: Offset(20.5, 16.5),
          blurRadius: 25.5,
          spreadRadius: -30,
          color: Color(0x61000000),
        ),
      ],
    ),
  );

  @override
  bool updateShouldNotify(DocsThemeScope oldWidget) {
    return data != oldWidget.data;
  }
}

extension DocsThemeExtensions on BuildContext {
  DocsThemeData get docsTheme => DocsThemeScope.of(this);
}

extension ThemeScaling on material.ThemeData {
  double scaling(BuildContext context) => DocsThemeScope.of(context).scaling;
}
