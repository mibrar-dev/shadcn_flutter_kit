// Registry-owned theme data for the `input` component: the [InputTheme]
// container, the token-derived `inputDefaults` and the build-time
// [resolveInputSurface] helper.
//
// User-owned overrides live in `input_theme.dart`; CLI updates may replace
// this file. The widget reads the resolved theme through
// `resolveComponentStyle<InputTheme, InputTheme>` from `theme/theme.dart`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../primitives/text_editing/editable_text_style.dart';
import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';

/// One input's visual contract.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields. There are no variants and
/// no size enum; [height] is the field's minimum height.
class InputTheme extends ComponentThemeData implements Mergeable<InputTheme> {
  /// Creates an input theme.
  const InputTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.background,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.hintStyle,
    this.cursorColor,
    this.height,
  });

  /// Per-state fill of the input surface.
  final StateValue<ThemedColor>? background;

  /// Per-state border color; null draws no border. The focus ring is a
  /// separate `FocusOutline`, not a border row.
  final StateValue<ThemedColor>? borderColor;

  /// Border width used when [borderColor] resolves non-null.
  final double? borderWidth;

  /// Corner radius; null resolves `theme.borderRadiusMd` at build.
  final BorderRadiusGeometry? borderRadius;

  /// Inner padding; null resolves the 12x8 default.
  final EdgeInsetsGeometry? padding;

  /// Text style override; its color wins over the foreground token.
  final TextStyle? textStyle;

  /// Hint/placeholder style override.
  final TextStyle? hintStyle;

  /// Cursor color; null resolves the `primary` token.
  final ThemedColor? cursorColor;

  /// Minimum field height; null resolves 36.
  final double? height;

  /// Returns a copy with the given fields replaced.
  InputTheme copyWith({
    ValueGetter<StateValue<ThemedColor>?>? background,
    ValueGetter<StateValue<ThemedColor>?>? borderColor,
    ValueGetter<double?>? borderWidth,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<TextStyle?>? textStyle,
    ValueGetter<TextStyle?>? hintStyle,
    ValueGetter<ThemedColor?>? cursorColor,
    ValueGetter<double?>? height,
  }) {
    return InputTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      background: background == null ? this.background : background(),
      borderColor: borderColor == null ? this.borderColor : borderColor(),
      borderWidth: borderWidth == null ? this.borderWidth : borderWidth(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      padding: padding == null ? this.padding : padding(),
      textStyle: textStyle == null ? this.textStyle : textStyle(),
      hintStyle: hintStyle == null ? this.hintStyle : hintStyle(),
      cursorColor: cursorColor == null ? this.cursorColor : cursorColor(),
      height: height == null ? this.height : height(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  InputTheme merge(InputTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return InputTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      background: background?.merge(fallback.background) ?? fallback.background,
      borderColor:
          borderColor?.merge(fallback.borderColor) ?? fallback.borderColor,
      borderWidth: borderWidth ?? fallback.borderWidth,
      borderRadius: borderRadius ?? fallback.borderRadius,
      padding: padding ?? fallback.padding,
      // TextStyle.merge lets the argument win; merge fallback over this style
      // so the receiver's fields stay.
      textStyle: textStyle == null
          ? fallback.textStyle
          : (fallback.textStyle?.merge(textStyle) ?? textStyle),
      hintStyle: hintStyle == null
          ? fallback.hintStyle
          : (fallback.hintStyle?.merge(hintStyle) ?? hintStyle),
      cursorColor: cursorColor ?? fallback.cursorColor,
      height: height ?? fallback.height,
    );
  }

  /// State scales and colors step at t < 0.5; scalars are lerped.
  static InputTheme lerp(InputTheme a, InputTheme b, double t) {
    return InputTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      background: t < 0.5 ? a.background : b.background,
      borderColor: t < 0.5 ? a.borderColor : b.borderColor,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      hintStyle: TextStyle.lerp(a.hintStyle, b.hintStyle, t),
      cursorColor: t < 0.5 ? a.cursorColor : b.cursorColor,
      height: lerpDouble(a.height, b.height, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is InputTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.background == background &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.textStyle == textStyle &&
        other.hintStyle == hintStyle &&
        other.cursorColor == cursorColor &&
        other.height == height;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    background,
    borderColor,
    borderWidth,
    borderRadius,
    padding,
    textStyle,
    hintStyle,
    cursorColor,
    height,
  );
}

// ---------------------------------------------------------------------------
// Defaults (registry-owned, tokens only).
//
// shadcn v4 input: `bg-transparent` in light, `bg-input/30` in dark, always
// with a `border-input` border. The fill is token-based (input @0 in light)
// so overrides can still hook the row. Disabled is an explicit a0 fill:
// unlike `Button`, the input is not dimmed with a whole-control opacity, so
// the disabled surface itself fades out. Error state is not a field: the
// widget synthesises a destructive `borderColor` leg while `errorText` is set
// (design §2.3).
// ---------------------------------------------------------------------------

/// Light fill: transparent (input @0 rest/hovered/focused, a0 disabled).
const StateValue<ThemedColor> _inputLightBackground = StateValue<ThemedColor>(
  rest: ThemedColor.ref(ColorRef.input, alpha: 0),
  hovered: ThemedColor.ref(ColorRef.input, alpha: 0),
  focused: ThemedColor.ref(ColorRef.input, alpha: 0),
  disabled: ThemedColor.ref(ColorRef.input, alpha: 0),
);

/// Dark fill: `bg-input/30` (input token is 15% white, @0.3 ≈ 4.5% white).
const StateValue<ThemedColor> _inputDarkBackground = StateValue<ThemedColor>(
  rest: ThemedColor.ref(ColorRef.input, alpha: 0.3),
  hovered: ThemedColor.ref(ColorRef.input, alpha: 0.5),
  focused: ThemedColor.ref(ColorRef.input, alpha: 0.3),
  disabled: ThemedColor.ref(ColorRef.input, alpha: 0),
);

const StateValue<ThemedColor> _inputBorder = StateValue<ThemedColor>(
  rest: ThemedColor.ref(ColorRef.input),
);

/// Input content padding: shadcn `px-3 py-2`, density-scaled.
const EdgeInsetsGeometry inputDefaultPadding = EdgeInsetsDensity.pxSymmetric(
  horizontal: 12,
  vertical: 8,
);

/// Token-derived baseline; every unset override field falls through here.
///
/// Light baseline (`bg-transparent`); dark uses [inputDarkDefaults].
const InputTheme inputDefaults = InputTheme(
  background: _inputLightBackground,
  borderColor: _inputBorder,
  borderWidth: 1,
  padding: inputDefaultPadding,
  cursorColor: ThemedColor.ref(ColorRef.primary),
  height: 36,
);

/// Dark baseline (`bg-input/30`); picked by [resolveInputSurface] when the
/// ambient brightness is dark.
const InputTheme inputDarkDefaults = InputTheme(
  background: _inputDarkBackground,
  borderColor: _inputBorder,
  borderWidth: 1,
  padding: inputDefaultPadding,
  cursorColor: ThemedColor.ref(ColorRef.primary),
  height: 36,
);

// ---------------------------------------------------------------------------
// Build-time resolution.
// ---------------------------------------------------------------------------

/// Resolved visual values for one input build.
class InputSurface {
  /// Creates a resolved surface.
  const InputSurface({
    required this.decoration,
    required this.borderRadius,
    required this.padding,
    required this.textStyle,
    required this.hintStyle,
    required this.cursorColor,
    required this.backgroundCursorColor,
    required this.selectionColor,
    required this.errorStyle,
    required this.minHeight,
    required this.gap,
  });

  /// Field surface decoration.
  final BoxDecoration decoration;

  /// Corner radius of the focus ring.
  final BorderRadiusGeometry borderRadius;

  /// Density-resolved inner padding.
  final EdgeInsetsGeometry padding;

  /// Resolved text style.
  final TextStyle textStyle;

  /// Resolved placeholder style.
  final TextStyle hintStyle;

  /// Resolved cursor color.
  final Color cursorColor;

  /// Cursor color painted when the field is not focused.
  final Color backgroundCursorColor;

  /// Selection highlight color.
  final Color selectionColor;

  /// Error message style.
  final TextStyle errorStyle;

  /// Minimum field height.
  final double minHeight;

  /// Spacing between adornments and error text.
  final double gap;
}

/// Resolves the four theme legs plus the widget-leg overrides into concrete
/// build values.
///
/// A non-null [errorText] synthesises a destructive border leg on top of
/// [widgetTheme] (design §2.3).
InputSurface resolveInputSurface(
  BuildContext context, {
  InputTheme? widgetTheme,
  String? errorText,
  Set<WidgetState> states = const <WidgetState>{},
  TextStyle? style,
  Color? cursorColor,
  BoxDecoration? decoration,
  Border? border,
  BorderRadiusGeometry? borderRadius,
  bool? filled,
  EdgeInsetsGeometry? padding,
}) {
  final theme = ShadcnTheme.of(context);
  final colors = theme.colors;

  InputTheme? widgetLeg = widgetTheme;
  if (errorText != null) {
    widgetLeg = const InputTheme(
      borderColor: StateValue<ThemedColor>(
        rest: ThemedColor.ref(ColorRef.destructive),
      ),
    ).merge(widgetLeg);
  }
  // shadcn v4: transparent in light, input/30 in dark. The per-brightness
  // baseline keeps user overrides working in both modes.
  final InputTheme effectiveDefaults = colors.brightness == Brightness.dark
      ? inputDarkDefaults
      : inputDefaults;
  final resolved = resolveComponentStyle<InputTheme, InputTheme>(
    context,
    widget: widgetLeg,
    select: (t) => t,
    defaults: effectiveDefaults,
  );

  Color? colorFor(StateValue<ThemedColor>? value) =>
      value?.resolve(states)?.resolve(colors);
  final Color? borderColor = colorFor(resolved.borderColor);
  final double borderWidth = resolved.borderWidth ?? 1;
  final BorderRadiusGeometry radius =
      borderRadius ?? resolved.borderRadius ?? theme.borderRadiusMd;
  final BoxDecoration surface =
      decoration ??
      BoxDecoration(
        color: filled == true ? colors.muted : colorFor(resolved.background),
        border:
            border ??
            (borderColor != null && borderWidth > 0
                ? Border.all(color: borderColor, width: borderWidth)
                : null),
        borderRadius: radius,
      );

  final TextStyle textStyle = resolveEditableTextStyle(
    context,
    base: theme.typography.small,
    overrides: <TextStyle?>[resolved.textStyle, style],
    color: colors.foreground,
  );
  final TextStyle hintStyle = resolveEditableTextStyle(
    context,
    base: theme.typography.small,
    overrides: <TextStyle?>[resolved.hintStyle],
    color: colors.mutedForeground,
  );

  return InputSurface(
    decoration: surface,
    borderRadius: radius,
    padding: resolveEdgeInsets(
      padding ?? resolved.padding ?? inputDefaultPadding,
      theme.density.baseContentPadding * theme.scaling,
    ),
    textStyle: textStyle,
    hintStyle: hintStyle,
    cursorColor:
        cursorColor ?? resolved.cursorColor?.resolve(colors) ?? colors.primary,
    backgroundCursorColor: colors.border,
    selectionColor:
        DefaultSelectionStyle.of(context).selectionColor ??
        colors.primary.withValues(alpha: 0.2),
    errorStyle: theme.typography.xSmall.copyWith(color: colors.destructive),
    minHeight: resolved.height ?? 36,
    gap: theme.spacing.xs,
  );
}
