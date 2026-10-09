// Registry-owned theme data for the `selectable` component: the
// [SelectableTextTheme] container and the token-derived `selectableDefaults`.
//
// User-owned overrides live in `selectable_theme.dart`; CLI updates may
// replace this file. The widget reads the resolved theme through
// `resolveComponentStyle<SelectableTextTheme, SelectableTextTheme>` from
// `theme/theme.dart`.

import 'dart:ui' show BoxHeightStyle, BoxWidthStyle, lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// One selectable text's visual contract.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class SelectableTextTheme extends ComponentThemeData
    implements Mergeable<SelectableTextTheme> {
  /// Creates a selectable text theme.
  const SelectableTextTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.textStyle,
    this.cursorWidth,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionHeightStyle,
    this.selectionWidthStyle,
    this.enableInteractiveSelection,
  });

  /// Base text style; its colour is used when non-null, otherwise the
  /// `foreground` token.
  final TextStyle? textStyle;

  /// Caret width; null resolves `2`.
  final double? cursorWidth;

  /// Caret height; null matches the line height.
  final double? cursorHeight;

  /// Caret corner radius; null is square.
  final Radius? cursorRadius;

  /// Caret colour; null resolves the `primary` token.
  final ThemedColor? cursorColor;

  /// Selection box height style; null resolves `BoxHeightStyle.tight`.
  final BoxHeightStyle? selectionHeightStyle;

  /// Selection box width style; null resolves `BoxWidthStyle.tight`.
  final BoxWidthStyle? selectionWidthStyle;

  /// Whether drag/double-tap/long-press selection is enabled; null resolves
  /// `true`.
  final bool? enableInteractiveSelection;

  /// Returns a copy with the given fields replaced.
  SelectableTextTheme copyWith({
    ValueGetter<TextStyle?>? textStyle,
    ValueGetter<double?>? cursorWidth,
    ValueGetter<double?>? cursorHeight,
    ValueGetter<Radius?>? cursorRadius,
    ValueGetter<ThemedColor?>? cursorColor,
    ValueGetter<BoxHeightStyle?>? selectionHeightStyle,
    ValueGetter<BoxWidthStyle?>? selectionWidthStyle,
    ValueGetter<bool?>? enableInteractiveSelection,
  }) {
    return SelectableTextTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      textStyle: textStyle == null ? this.textStyle : textStyle(),
      cursorWidth: cursorWidth == null ? this.cursorWidth : cursorWidth(),
      cursorHeight: cursorHeight == null ? this.cursorHeight : cursorHeight(),
      cursorRadius: cursorRadius == null ? this.cursorRadius : cursorRadius(),
      cursorColor: cursorColor == null ? this.cursorColor : cursorColor(),
      selectionHeightStyle: selectionHeightStyle == null
          ? this.selectionHeightStyle
          : selectionHeightStyle(),
      selectionWidthStyle: selectionWidthStyle == null
          ? this.selectionWidthStyle
          : selectionWidthStyle(),
      enableInteractiveSelection: enableInteractiveSelection == null
          ? this.enableInteractiveSelection
          : enableInteractiveSelection(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  SelectableTextTheme merge(SelectableTextTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return SelectableTextTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      textStyle: textStyle == null
          ? fallback.textStyle
          : (fallback.textStyle?.merge(textStyle) ?? textStyle),
      cursorWidth: cursorWidth ?? fallback.cursorWidth,
      cursorHeight: cursorHeight ?? fallback.cursorHeight,
      cursorRadius: cursorRadius ?? fallback.cursorRadius,
      cursorColor: cursorColor ?? fallback.cursorColor,
      selectionHeightStyle:
          selectionHeightStyle ?? fallback.selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle ?? fallback.selectionWidthStyle,
      enableInteractiveSelection:
          enableInteractiveSelection ?? fallback.enableInteractiveSelection,
    );
  }

  /// Colours, styles and enums step at t < 0.5; dimensions are lerped.
  static SelectableTextTheme lerp(
    SelectableTextTheme a,
    SelectableTextTheme b,
    double t,
  ) {
    return SelectableTextTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      cursorWidth: lerpDouble(a.cursorWidth, b.cursorWidth, t),
      cursorHeight: lerpDouble(a.cursorHeight, b.cursorHeight, t),
      cursorRadius: t < 0.5 ? a.cursorRadius : b.cursorRadius,
      cursorColor: t < 0.5 ? a.cursorColor : b.cursorColor,
      selectionHeightStyle: t < 0.5
          ? a.selectionHeightStyle
          : b.selectionHeightStyle,
      selectionWidthStyle: t < 0.5
          ? a.selectionWidthStyle
          : b.selectionWidthStyle,
      enableInteractiveSelection: t < 0.5
          ? a.enableInteractiveSelection
          : b.enableInteractiveSelection,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is SelectableTextTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.textStyle == textStyle &&
        other.cursorWidth == cursorWidth &&
        other.cursorHeight == cursorHeight &&
        other.cursorRadius == cursorRadius &&
        other.cursorColor == cursorColor &&
        other.selectionHeightStyle == selectionHeightStyle &&
        other.selectionWidthStyle == selectionWidthStyle &&
        other.enableInteractiveSelection == enableInteractiveSelection;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    textStyle,
    cursorWidth,
    cursorHeight,
    cursorRadius,
    cursorColor,
    selectionHeightStyle,
    selectionWidthStyle,
    enableInteractiveSelection,
  );
}

/// Token-derived baseline; every unset override field falls through here.
const SelectableTextTheme selectableDefaults = SelectableTextTheme(
  cursorWidth: 2,
  cursorColor: ThemedColor.ref(ColorRef.primary),
  selectionHeightStyle: BoxHeightStyle.tight,
  selectionWidthStyle: BoxWidthStyle.tight,
  enableInteractiveSelection: true,
);
