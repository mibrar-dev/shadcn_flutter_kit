// Registry-owned theme data for the `formatted_input` component: the
// [FormattedInputTheme] container, the token-derived `formattedInputDefaults`
// and the build-time [resolveFormattedInputSurface].
//
// User-owned overrides live in `formatted_input_theme.dart`; CLI updates may
// replace this file. Like `calendar`, the theme class carries no
// `copyWith`/`lerp`: nothing in `registry_next` calls them.

import 'package:flutter/widgets.dart';

import '../../primitives/text_editing/editable_text_style.dart';
import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';

/// Visual contract of a formatted (masked) field.
class FormattedInputTheme extends ComponentThemeData
    implements Mergeable<FormattedInputTheme> {
  /// Creates a formatted input theme.
  const FormattedInputTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.background,
    this.hoveredBackground,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.height,
    this.textStyle,
    this.placeholderStyle,
    this.separatorStyle,
    this.leadingGap,
    this.partGap,
  });

  /// Field fill at rest. Default: `input` at 30%.
  final ThemedColor? background;

  /// Field fill while hovered. Default: `input` at 50%.
  final ThemedColor? hoveredBackground;

  /// Field border. Default: the `input` token.
  final ThemedColor? borderColor;

  /// Border width. Default: 1.
  final double? borderWidth;

  /// Corner radius; null resolves `theme.borderRadiusMd`.
  final BorderRadiusGeometry? borderRadius;

  /// Inner padding. Default: 8 horizontal, 4 vertical (scaled).
  final EdgeInsetsGeometry? padding;

  /// Field height. Default: 36 (the shadcn input height).
  final double? height;

  /// Segment text style; null takes the theme mono at `text-sm`.
  final TextStyle? textStyle;

  /// Placeholder style; null takes `text-sm` muted.
  final TextStyle? placeholderStyle;

  /// Style of the static separators; null takes [textStyle].
  final TextStyle? separatorStyle;

  /// Space between `leading` and the first part. Default: 8 (scaled).
  final double? leadingGap;

  /// Space between two parts. Default: 0 (segments are adjacent).
  final double? partGap;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  FormattedInputTheme merge(FormattedInputTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return FormattedInputTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      background: background ?? fallback.background,
      hoveredBackground: hoveredBackground ?? fallback.hoveredBackground,
      borderColor: borderColor ?? fallback.borderColor,
      borderWidth: borderWidth ?? fallback.borderWidth,
      borderRadius: borderRadius ?? fallback.borderRadius,
      padding: padding ?? fallback.padding,
      height: height ?? fallback.height,
      textStyle: textStyle == null
          ? fallback.textStyle
          : (fallback.textStyle?.merge(textStyle) ?? textStyle),
      placeholderStyle: placeholderStyle == null
          ? fallback.placeholderStyle
          : (fallback.placeholderStyle?.merge(placeholderStyle) ??
                placeholderStyle),
      separatorStyle: separatorStyle == null
          ? fallback.separatorStyle
          : (fallback.separatorStyle?.merge(separatorStyle) ?? separatorStyle),
      leadingGap: leadingGap ?? fallback.leadingGap,
      partGap: partGap ?? fallback.partGap,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is FormattedInputTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.background == background &&
        other.hoveredBackground == hoveredBackground &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.height == height &&
        other.textStyle == textStyle &&
        other.placeholderStyle == placeholderStyle &&
        other.separatorStyle == separatorStyle &&
        other.leadingGap == leadingGap &&
        other.partGap == partGap;
  }

  @override
  int get hashCode => Object.hashAll(<Object?>[
    themeDensity,
    themeSpacing,
    themeShadows,
    background,
    hoveredBackground,
    borderColor,
    borderWidth,
    borderRadius,
    padding,
    height,
    textStyle,
    placeholderStyle,
    separatorStyle,
    leadingGap,
    partGap,
  ]);
}

/// Token-derived baseline; every unset override field falls through here.
const FormattedInputTheme formattedInputDefaults = FormattedInputTheme(
  background: ThemedColor.ref(ColorRef.input, alpha: 0.3),
  hoveredBackground: ThemedColor.ref(ColorRef.input, alpha: 0.5),
  borderColor: ThemedColor.ref(ColorRef.input),
  borderWidth: 1,
  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  height: 36,
  leadingGap: 8,
  partGap: 0,
);

/// Resolved visual values for one formatted input build.
class FormattedInputSurface {
  /// Creates a resolved surface.
  const FormattedInputSurface({
    required this.decoration,
    required this.borderRadius,
    required this.padding,
    required this.height,
    required this.textStyle,
    required this.placeholderStyle,
    required this.separatorStyle,
    required this.leadingGap,
    required this.partGap,
    required this.cursorColor,
  });

  /// Field surface decoration (fill + border), excluding the focus ring.
  final BoxDecoration decoration;

  /// Corner radius of the focus ring.
  final BorderRadiusGeometry borderRadius;

  /// Density-resolved inner padding.
  final EdgeInsetsGeometry padding;

  /// Field height.
  final double height;

  /// Resolved segment text style.
  final TextStyle textStyle;

  /// Resolved placeholder style.
  final TextStyle placeholderStyle;

  /// Resolved separator style.
  final TextStyle separatorStyle;

  /// Space between `leading` and the first part.
  final double leadingGap;

  /// Space between two parts.
  final double partGap;

  /// Resolved cursor colour.
  final Color cursorColor;
}

/// Resolves the four theme legs into concrete build values.
FormattedInputSurface resolveFormattedInputSurface(
  BuildContext context, {
  FormattedInputTheme? widgetTheme,
  Set<WidgetState> states = const <WidgetState>{},
  TextStyle? textStyle,
}) {
  final ShadcnThemeData theme = ShadcnTheme.of(context);
  final ShadcnColors colors = theme.colors;
  final FormattedInputTheme resolved =
      resolveComponentStyle<FormattedInputTheme, FormattedInputTheme>(
        context,
        widget: widgetTheme,
        select: (t) => t,
        defaults: formattedInputDefaults,
      );
  Color? colorOf(ThemedColor? value) => value?.resolve(colors);
  final Color? border = colorOf(resolved.borderColor);
  final Color? fill = colorOf(
    states.contains(WidgetState.hovered)
        ? resolved.hoveredBackground
        : resolved.background,
  );
  final BorderRadiusGeometry radius =
      resolved.borderRadius ?? theme.borderRadiusMd;
  final TextStyle text = resolveEditableTextStyle(
    context,
    base: theme.typography.small.merge(theme.typography.mono),
    overrides: <TextStyle?>[resolved.textStyle, textStyle],
    color: colors.foreground,
  );
  return FormattedInputSurface(
    decoration: BoxDecoration(
      color: fill,
      borderRadius: radius,
      border: border == null
          ? null
          : Border.all(color: border, width: resolved.borderWidth ?? 1),
    ),
    borderRadius: radius,
    padding: resolveEdgeInsets(
      resolved.padding ??
          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      theme.density.baseContentPadding * theme.scaling,
    ),
    height: resolved.height ?? 36,
    textStyle: text,
    placeholderStyle:
        resolved.placeholderStyle ??
        theme.typography.small.copyWith(color: colors.mutedForeground),
    separatorStyle:
        resolved.separatorStyle ?? text.copyWith(color: colors.mutedForeground),
    leadingGap: resolved.leadingGap ?? 8,
    partGap: resolved.partGap ?? 0,
    cursorColor: colors.ring,
  );
}
