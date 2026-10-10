// Registry-owned theme data for the `divider` component: the [DividerTheme]
// container and its token-derived `dividerDefaults`.
//
// shadcn separator: `bg-border shrink-0 h-px w-full` (or `h-full w-px` for a
// vertical one). User-owned overrides live in `divider_theme.dart`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';

/// Where a [Divider.label] sits on the cross axis.
enum DividerLabelAlignment { start, center, end }

/// Default rule thickness: shadcn `h-px`.
const double dividerDefaultThickness = 1;

/// Default rule size when no explicit extent is given.
const double dividerDefaultExtent = 1;

/// Fallback label text style before [DividerTheme.labelStyle] narrows it.
const TextStyle dividerDefaultLabelStyle = TextStyle(fontSize: 12);

/// Theme container for the divider component.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class DividerTheme extends ComponentThemeData
    implements Mergeable<DividerTheme> {
  /// Creates a divider theme.
  const DividerTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.color,
    this.thickness,
    this.extent,
    this.indent,
    this.endIndent,
    this.labelPadding,
    this.labelAlignment,
    this.labelStyle,
  });

  /// Rule colour. Default: the `border` token.
  final ThemedColor? color;

  /// Stroke width of the rule. Default: 1.
  final double? thickness;

  /// Cross-axis extent of the whole divider: its height when horizontal, its
  /// width when vertical. Default: [dividerDefaultExtent].
  final double? extent;

  /// Space before the rule, measured from the leading edge. Default: 0.
  final double? indent;

  /// Space after the rule, measured from the trailing edge. Default: 0.
  final double? endIndent;

  /// Padding around [Divider.label]: shadcn's `px-2` label gutter (8) as
  /// density multipliers, resolved by `Divider`. Default:
  /// [dividerDefaultLabelPadding].
  final EdgeInsetsGeometry? labelPadding;

  /// Cross-axis placement of [Divider.label]. Default:
  /// [DividerLabelAlignment.center].
  final DividerLabelAlignment? labelAlignment;

  /// Label text style; its colour falls back to the `mutedForeground` token.
  final TextStyle? labelStyle;

  /// Returns a copy with the given fields replaced.
  DividerTheme copyWith({
    ValueGetter<ThemedColor?>? color,
    ValueGetter<double?>? thickness,
    ValueGetter<double?>? extent,
    ValueGetter<double?>? indent,
    ValueGetter<double?>? endIndent,
    ValueGetter<EdgeInsetsGeometry?>? labelPadding,
    ValueGetter<DividerLabelAlignment?>? labelAlignment,
    ValueGetter<TextStyle?>? labelStyle,
  }) {
    return DividerTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      color: color == null ? this.color : color(),
      thickness: thickness == null ? this.thickness : thickness(),
      extent: extent == null ? this.extent : extent(),
      indent: indent == null ? this.indent : indent(),
      endIndent: endIndent == null ? this.endIndent : endIndent(),
      labelPadding: labelPadding == null ? this.labelPadding : labelPadding(),
      labelAlignment: labelAlignment == null
          ? this.labelAlignment
          : labelAlignment(),
      labelStyle: labelStyle == null ? this.labelStyle : labelStyle(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  DividerTheme merge(DividerTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return DividerTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      color: color ?? fallback.color,
      thickness: thickness ?? fallback.thickness,
      extent: extent ?? fallback.extent,
      indent: indent ?? fallback.indent,
      endIndent: endIndent ?? fallback.endIndent,
      labelPadding: labelPadding ?? fallback.labelPadding,
      labelAlignment: labelAlignment ?? fallback.labelAlignment,
      // `TextStyle.merge` lets the argument win, so the fallback is merged
      // under the receiver to keep this leg's fields.
      labelStyle: labelStyle == null
          ? fallback.labelStyle
          : (fallback.labelStyle?.merge(labelStyle) ?? labelStyle),
    );
  }

  /// Colours and the label alignment step at `t = 0.5`; dimensions and padding
  /// are lerped.
  static DividerTheme lerp(DividerTheme a, DividerTheme b, double t) {
    return DividerTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      color: t < 0.5 ? a.color : b.color,
      thickness: lerpDouble(a.thickness, b.thickness, t),
      extent: lerpDouble(a.extent, b.extent, t),
      indent: lerpDouble(a.indent, b.indent, t),
      endIndent: lerpDouble(a.endIndent, b.endIndent, t),
      labelPadding: EdgeInsetsGeometry.lerp(a.labelPadding, b.labelPadding, t),
      labelAlignment: t < 0.5 ? a.labelAlignment : b.labelAlignment,
      labelStyle: TextStyle.lerp(a.labelStyle, b.labelStyle, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is DividerTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.color == color &&
        other.thickness == thickness &&
        other.extent == extent &&
        other.indent == indent &&
        other.endIndent == endIndent &&
        other.labelPadding == labelPadding &&
        other.labelAlignment == labelAlignment &&
        other.labelStyle == labelStyle;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    color,
    thickness,
    extent,
    indent,
    endIndent,
    labelPadding,
    labelAlignment,
    labelStyle,
  );
}

/// Default padding around a divider label: shadcn's separator label gutter,
/// 8 logical pixels on both sides (shadcn `px-2`), stored as density
/// multipliers and resolved by `Divider` against
/// `density.baseContentPadding * scaling`.
const EdgeInsetsGeometry dividerDefaultLabelPadding =
    EdgeInsetsDensity.pxSymmetric(horizontal: 8);

/// Token-derived baseline values; unset override fields fall through here.
const DividerTheme dividerDefaults = DividerTheme(
  color: ThemedColor.ref(ColorRef.border),
  thickness: dividerDefaultThickness,
  extent: dividerDefaultExtent,
  indent: 0,
  endIndent: 0,
  labelPadding: dividerDefaultLabelPadding,
  labelAlignment: DividerLabelAlignment.center,
  labelStyle: dividerDefaultLabelStyle,
);
