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
    this.messageSpacing,
    this.labelStyle,
    this.hintStyle,
    this.messageStyle,
    this.labelColor,
    this.hintColor,
    this.messageColor,
  });

  /// Vertical gap between the label row and the control: shadcn `gap-2` (8).
  final double? spacing;

  /// Vertical gap between the control and its hint or error text: shadcn
  /// `gap-1.5` (6).
  final double? messageSpacing;

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
    ValueGetter<double?>? messageSpacing,
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
      messageSpacing: messageSpacing == null
          ? this.messageSpacing
          : messageSpacing(),
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
      messageSpacing: messageSpacing ?? fallback.messageSpacing,
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
      messageSpacing: lerpDouble(a.messageSpacing, b.messageSpacing, t),
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
        other.messageSpacing == messageSpacing &&
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
    messageSpacing,
    labelStyle,
    hintStyle,
    messageStyle,
    labelColor,
    hintColor,
    messageColor,
  );
}

/// Token-derived baseline for form layouts.
///
/// shadcn v4 `Field` rows: the label is `text-sm font-medium`, the description
/// and the error are `text-sm` (muted and destructive), the label-to-control
/// gap is `gap-2` (8) and the hint/error gap is `gap-1.5` (6).
const FormTheme formDefaults = FormTheme(
  spacing: 8,
  messageSpacing: 6,
  labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  hintStyle: TextStyle(fontSize: 14),
  messageStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
    required this.messageSpacing,
    required this.labelStyle,
    required this.hintStyle,
    required this.messageStyle,
  });

  /// Vertical gap between the label row and the control.
  final double spacing;

  /// Vertical gap between the control and its hint or error text.
  final double messageSpacing;

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
  // Both gaps are shadcn pixel values at the default density, scaled like every
  // other spacing in the registry.
  final double scale = theme.density.scale * theme.scaling;
  return FormResolvedTheme(
    spacing: (resolved.spacing ?? 8) * scale,
    messageSpacing: (resolved.messageSpacing ?? 6) * scale,
    labelStyle: style(
      resolved.labelStyle,
      resolved.labelColor,
      const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    ),
    hintStyle: style(
      resolved.hintStyle,
      resolved.hintColor,
      const TextStyle(fontSize: 14),
    ),
    messageStyle: style(
      resolved.messageStyle,
      resolved.messageColor,
      const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    ),
  );
}
