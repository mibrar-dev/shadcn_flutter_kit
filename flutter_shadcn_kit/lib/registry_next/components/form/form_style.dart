// Registry-owned theme data for the `form` component: the [FormTheme] fields
// used by `ShadcnFormField` / `FormInline` / `FormTableLayout` plus the token-derived
// `formDefaults`.
//
// User-owned overrides live in `form_theme.dart`; CLI updates may replace this
// file.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Label, hint, message and spacing choices for form layouts.
class FormTheme extends ComponentThemeData implements Mergeable<FormTheme> {
  /// Creates a form theme.
  const FormTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.spacing,
    this.labelStyle,
    this.hintStyle,
    this.messageStyle,
    this.labelColor,
    this.hintColor,
    this.messageColor,
  });

  /// Vertical gap between label, field, hint and message.
  final double? spacing;

  /// Label text style; colour comes from [labelColor].
  final TextStyle? labelStyle;

  /// Hint text style; colour comes from [hintColor].
  final TextStyle? hintStyle;

  /// Error message style; colour comes from [messageColor].
  final TextStyle? messageStyle;

  /// Label colour; defaults to `foreground`.
  final ThemedColor? labelColor;

  /// Hint colour; defaults to `mutedForeground`.
  final ThemedColor? hintColor;

  /// Error message colour; defaults to `destructive`.
  final ThemedColor? messageColor;

  /// Returns a copy with the given fields replaced.
  FormTheme copyWith({
    ValueGetter<double?>? spacing,
    ValueGetter<TextStyle?>? labelStyle,
    ValueGetter<TextStyle?>? hintStyle,
    ValueGetter<TextStyle?>? messageStyle,
    ValueGetter<ThemedColor?>? labelColor,
    ValueGetter<ThemedColor?>? hintColor,
    ValueGetter<ThemedColor?>? messageColor,
  }) {
    return FormTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      spacing: spacing == null ? this.spacing : spacing(),
      labelStyle: labelStyle == null ? this.labelStyle : labelStyle(),
      hintStyle: hintStyle == null ? this.hintStyle : hintStyle(),
      messageStyle: messageStyle == null ? this.messageStyle : messageStyle(),
      labelColor: labelColor == null ? this.labelColor : labelColor(),
      hintColor: hintColor == null ? this.hintColor : hintColor(),
      messageColor: messageColor == null ? this.messageColor : messageColor(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  FormTheme merge(FormTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return FormTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      spacing: spacing ?? fallback.spacing,
      labelStyle: labelStyle == null
          ? fallback.labelStyle
          : (fallback.labelStyle?.merge(labelStyle) ?? labelStyle),
      hintStyle: hintStyle == null
          ? fallback.hintStyle
          : (fallback.hintStyle?.merge(hintStyle) ?? hintStyle),
      messageStyle: messageStyle == null
          ? fallback.messageStyle
          : (fallback.messageStyle?.merge(messageStyle) ?? messageStyle),
      labelColor: labelColor ?? fallback.labelColor,
      hintColor: hintColor ?? fallback.hintColor,
      messageColor: messageColor ?? fallback.messageColor,
    );
  }

  /// Lerps scalars; styles and token references step at t < 0.5.
  static FormTheme lerp(FormTheme a, FormTheme b, double t) {
    return FormTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      spacing: lerpDouble(a.spacing, b.spacing, t),
      labelStyle: TextStyle.lerp(a.labelStyle, b.labelStyle, t),
      hintStyle: TextStyle.lerp(a.hintStyle, b.hintStyle, t),
      messageStyle: TextStyle.lerp(a.messageStyle, b.messageStyle, t),
      labelColor: t < 0.5 ? a.labelColor : b.labelColor,
      hintColor: t < 0.5 ? a.hintColor : b.hintColor,
      messageColor: t < 0.5 ? a.messageColor : b.messageColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is FormTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.spacing == spacing &&
        other.labelStyle == labelStyle &&
        other.hintStyle == hintStyle &&
        other.messageStyle == messageStyle &&
        other.labelColor == labelColor &&
        other.hintColor == hintColor &&
        other.messageColor == messageColor;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    spacing,
    labelStyle,
    hintStyle,
    messageStyle,
    labelColor,
    hintColor,
    messageColor,
  );
}

/// Token-derived baseline for form layouts.
const FormTheme formDefaults = FormTheme(
  spacing: 8,
  labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
  hintStyle: TextStyle(fontSize: 12),
  messageStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
  labelColor: ThemedColor.ref(ColorRef.foreground),
  hintColor: ThemedColor.ref(ColorRef.mutedForeground),
  messageColor: ThemedColor.ref(ColorRef.destructive),
);

/// [FormTheme] values with token colours already resolved.
///
/// The form layouts resolve their theme once per field and read these styles
/// directly; keeping the resolved shape next to the theme means the widget file
/// only carries layout code.
class FormResolvedTheme {
  /// Creates a resolved theme snapshot.
  const FormResolvedTheme({
    required this.spacing,
    required this.labelStyle,
    required this.hintStyle,
    required this.messageStyle,
  });

  /// Vertical gap between label, field, hint and message.
  final double spacing;

  /// Fully coloured label style.
  final TextStyle labelStyle;

  /// Fully coloured hint style.
  final TextStyle hintStyle;

  /// Fully coloured error-message style.
  final TextStyle messageStyle;
}

/// Resolves [widgetLeg] through all four theme legs and applies token colours.
FormResolvedTheme resolveFormTheme(BuildContext context, FormTheme? widgetLeg) {
  final ShadcnThemeData theme = ShadcnTheme.of(context);
  final FormTheme resolved = resolveComponentStyle<FormTheme, FormTheme>(
    context,
    widget: widgetLeg,
    select: (t) => t,
    defaults: formDefaults,
  );
  TextStyle style(TextStyle? base, ThemedColor? color, TextStyle fallback) =>
      (base ?? fallback).copyWith(color: color?.resolve(theme.colors));
  return FormResolvedTheme(
    spacing: resolved.spacing ?? 8,
    labelStyle: style(
      resolved.labelStyle,
      resolved.labelColor,
      const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
    ),
    hintStyle: style(
      resolved.hintStyle,
      resolved.hintColor,
      const TextStyle(fontSize: 12),
    ),
    messageStyle: style(
      resolved.messageStyle,
      resolved.messageColor,
      const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    ),
  );
}
