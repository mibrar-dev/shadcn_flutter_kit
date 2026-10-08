// Registry-owned theme data for the `checkbox` component: the state- and
// value-aware [CheckboxStyle] slice, the per-value [CheckboxTheme] container
// and the token-derived `checkboxDefaults` rows.
//
// The value rows (checked / unchecked / indeterminate) answer "what does the
// box look like", the `StateValue`s inside them answer "how does it react".
// User-owned overrides live in `checkbox_theme.dart`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// The three states a checkbox can hold.
enum CheckboxValue { checked, unchecked, indeterminate }

/// Fallback label text style before [CheckboxTheme.labelStyle] narrows it.
const TextStyle checkboxDefaultLabelStyle = TextStyle(fontSize: 14);

/// One checkbox value's styling slice.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining states/fields.
class CheckboxStyle implements Mergeable<CheckboxStyle> {
  /// Creates a checkbox style slice.
  const CheckboxStyle({
    this.background,
    this.borderColor,
    this.indicatorColor,
    this.size,
    this.indicatorSize,
    this.borderWidth,
    this.borderRadius,
    this.gap,
    this.padding,
    this.labelStyle,
  });

  /// Per-state fill of the box.
  final StateValue<ThemedColor>? background;

  /// Per-state border colour of the box; null draws no border.
  final StateValue<ThemedColor>? borderColor;

  /// Colour of the check mark / dash. Null hides the indicator.
  final ThemedColor? indicatorColor;

  /// Side length of the box; null resolves 16 at build.
  final double? size;

  /// Side length of the indicator glyph; null resolves `size * 0.75`.
  final double? indicatorSize;

  /// Border width; null resolves 1 at build.
  final double? borderWidth;

  /// Corner radius of the box; null resolves the ambient `radiusSm`.
  final BorderRadiusGeometry? borderRadius;

  /// Space between the box and [Checkbox.label]; null resolves 8.
  final double? gap;

  /// Padding between the control edge and its content; null resolves 2.
  final EdgeInsetsGeometry? padding;

  /// Label text style; its colour is taken from the ambient foreground unless
  /// the style carries one.
  final TextStyle? labelStyle;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  CheckboxStyle merge(CheckboxStyle? fallback) {
    if (fallback == null) {
      return this;
    }
    return CheckboxStyle(
      background: background?.merge(fallback.background) ?? fallback.background,
      borderColor:
          borderColor?.merge(fallback.borderColor) ?? fallback.borderColor,
      indicatorColor: indicatorColor ?? fallback.indicatorColor,
      size: size ?? fallback.size,
      indicatorSize: indicatorSize ?? fallback.indicatorSize,
      borderWidth: borderWidth ?? fallback.borderWidth,
      borderRadius: borderRadius ?? fallback.borderRadius,
      gap: gap ?? fallback.gap,
      padding: padding ?? fallback.padding,
      // `TextStyle.merge` lets the argument win, so the fallback is merged
      // under the receiver to keep this leg's fields.
      labelStyle: labelStyle == null
          ? fallback.labelStyle
          : (fallback.labelStyle?.merge(labelStyle) ?? labelStyle),
    );
  }

  /// State scales are stepped at t < 0.5; dimensions are lerped.
  static CheckboxStyle lerp(CheckboxStyle a, CheckboxStyle b, double t) {
    return CheckboxStyle(
      background: t < 0.5 ? a.background : b.background,
      borderColor: t < 0.5 ? a.borderColor : b.borderColor,
      indicatorColor: t < 0.5 ? a.indicatorColor : b.indicatorColor,
      size: lerpDouble(a.size, b.size, t),
      indicatorSize: lerpDouble(a.indicatorSize, b.indicatorSize, t),
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
      borderRadius: t < 0.5 ? a.borderRadius : b.borderRadius,
      gap: lerpDouble(a.gap, b.gap, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      labelStyle: TextStyle.lerp(a.labelStyle, b.labelStyle, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is CheckboxStyle &&
        other.background == background &&
        other.borderColor == borderColor &&
        other.indicatorColor == indicatorColor &&
        other.size == size &&
        other.indicatorSize == indicatorSize &&
        other.borderWidth == borderWidth &&
        other.borderRadius == borderRadius &&
        other.gap == gap &&
        other.padding == padding &&
        other.labelStyle == labelStyle;
  }

  @override
  int get hashCode => Object.hash(
    background,
    borderColor,
    indicatorColor,
    size,
    indicatorSize,
    borderWidth,
    borderRadius,
    gap,
    padding,
    labelStyle,
  );
}

/// Per-value theme container for the checkbox component.
class CheckboxTheme extends ComponentThemeData
    implements Mergeable<CheckboxTheme> {
  /// Creates a checkbox theme with one nullable slice per value.
  const CheckboxTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.checked,
    this.unchecked,
    this.indeterminate,
    this.labelStyle,
  });

  /// Style while [CheckboxValue.checked].
  final CheckboxStyle? checked;

  /// Style while [CheckboxValue.unchecked].
  final CheckboxStyle? unchecked;

  /// Style while [CheckboxValue.indeterminate].
  final CheckboxStyle? indeterminate;

  /// Label text style shared by every value; a value row wins over it.
  final TextStyle? labelStyle;

  /// The slice for [value], or null when this leg leaves it unset.
  CheckboxStyle? forValue(CheckboxValue value) {
    return switch (value) {
      CheckboxValue.checked => checked,
      CheckboxValue.unchecked => unchecked,
      CheckboxValue.indeterminate => indeterminate,
    };
  }

  /// Returns a copy with the given fields replaced.
  CheckboxTheme copyWith({
    ValueGetter<CheckboxStyle?>? checked,
    ValueGetter<CheckboxStyle?>? unchecked,
    ValueGetter<CheckboxStyle?>? indeterminate,
    ValueGetter<TextStyle?>? labelStyle,
  }) {
    return CheckboxTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      checked: checked == null ? this.checked : checked(),
      unchecked: unchecked == null ? this.unchecked : unchecked(),
      indeterminate: indeterminate == null
          ? this.indeterminate
          : indeterminate(),
      labelStyle: labelStyle == null ? this.labelStyle : labelStyle(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  CheckboxTheme merge(CheckboxTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return CheckboxTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      checked: checked?.merge(fallback.checked) ?? fallback.checked,
      unchecked: unchecked?.merge(fallback.unchecked) ?? fallback.unchecked,
      indeterminate:
          indeterminate?.merge(fallback.indeterminate) ??
          fallback.indeterminate,
      labelStyle: labelStyle == null
          ? fallback.labelStyle
          : (fallback.labelStyle?.merge(labelStyle) ?? labelStyle),
    );
  }

  /// Lerps each row; state scales step at t < 0.5.
  static CheckboxTheme lerp(CheckboxTheme a, CheckboxTheme b, double t) {
    CheckboxStyle? row(CheckboxStyle? x, CheckboxStyle? y) {
      if (x == null) {
        return y;
      }
      if (y == null) {
        return x;
      }
      return CheckboxStyle.lerp(x, y, t);
    }

    return CheckboxTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      checked: row(a.checked, b.checked),
      unchecked: row(a.unchecked, b.unchecked),
      indeterminate: row(a.indeterminate, b.indeterminate),
      labelStyle: TextStyle.lerp(a.labelStyle, b.labelStyle, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is CheckboxTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.checked == checked &&
        other.unchecked == unchecked &&
        other.indeterminate == indeterminate &&
        other.labelStyle == labelStyle;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    checked,
    unchecked,
    indeterminate,
    labelStyle,
  );
}

// ---------------------------------------------------------------------------
// Defaults (registry-owned, tokens only).
//
// shadcn checkbox: `size-4 shrink-0 rounded-[4px] border shadow-xs` with
// `data-[state=checked]:bg-primary data-[state=checked]:border-primary` and a
// `text-primary-foreground` indicator. Disabled states are intentionally
// absent: `StateValue` falls back to `rest` and `Checkbox` dims the whole
// control to 50% opacity. Pressed duplicates hovered because `StateValue
// .resolve` never falls back from one state to another.
// ---------------------------------------------------------------------------

/// Default checkbox box size: shadcn `size-4`.
const double checkboxDefaultSize = 16;

/// Default gap between the box and its label: shadcn `gap-2`.
const double checkboxDefaultGap = 8;

/// No padding around the control by default: shadcn `size-4` is exactly the
/// 16px box. The focus ring draws in an overflow stack outside the layout
/// (see `FocusOutline`), so it never clips and needs no inset here.
const EdgeInsetsGeometry checkboxDefaultPadding = EdgeInsets.zero;

const _checkedBg = StateValue(
  rest: ThemedColor.ref(ColorRef.primary),
  hovered: ThemedColor.ref(ColorRef.primary, alpha: 0.9),
  pressed: ThemedColor.ref(ColorRef.primary, alpha: 0.9),
);
const _checkedRow = CheckboxStyle(
  background: _checkedBg,
  borderColor: StateValue(rest: ThemedColor.ref(ColorRef.primary)),
  indicatorColor: ThemedColor.ref(ColorRef.primaryForeground),
  size: checkboxDefaultSize,
  gap: checkboxDefaultGap,
  padding: checkboxDefaultPadding,
  labelStyle: checkboxDefaultLabelStyle,
);

const _indeterminateRow = CheckboxStyle(
  background: _checkedBg,
  borderColor: StateValue(rest: ThemedColor.ref(ColorRef.primary)),
  indicatorColor: ThemedColor.ref(ColorRef.primaryForeground),
  size: checkboxDefaultSize,
  gap: checkboxDefaultGap,
  padding: checkboxDefaultPadding,
  labelStyle: checkboxDefaultLabelStyle,
);

const _uncheckedRow = CheckboxStyle(
  background: StateValue(rest: ThemedColor.ref(ColorRef.input, alpha: 0)),
  borderColor: StateValue(rest: ThemedColor.ref(ColorRef.input)),
  size: checkboxDefaultSize,
  gap: checkboxDefaultGap,
  padding: checkboxDefaultPadding,
  labelStyle: checkboxDefaultLabelStyle,
);

/// Token-derived baseline rows; every unset override field falls through here.
const CheckboxTheme checkboxDefaults = CheckboxTheme(
  checked: _checkedRow,
  unchecked: _uncheckedRow,
  indeterminate: _indeterminateRow,
  labelStyle: checkboxDefaultLabelStyle,
);
