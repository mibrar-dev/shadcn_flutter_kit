// Registry-owned theme data for the `table` component: the per-cell
// [TableCellTheme], the table-level [TableTheme] and the token-derived
// defaults.
//
// User-owned overrides live in `table_theme.dart`; CLI updates may replace
// this file. Colours are token references so a table follows preset switches;
// alpha multiplies the token's own alpha.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// State-aware styling of one table cell.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining states/fields.
class TableCellTheme implements Mergeable<TableCellTheme> {
  /// Creates a cell theme.
  const TableCellTheme({
    this.background,
    this.foreground,
    this.borderColor,
    this.borderWidth,
    this.textStyle,
    this.padding,
    this.minHeight,
  });

  /// Per-state fill of the cell.
  final StateValue<ThemedColor>? background;

  /// Per-state text colour.
  final StateValue<ThemedColor>? foreground;

  /// Per-state bottom-border colour; null draws no border.
  final StateValue<ThemedColor>? borderColor;

  /// Bottom-border width used when [borderColor] resolves non-null.
  final double? borderWidth;

  /// Text style override; its colour is ignored (taken from [foreground]).
  final TextStyle? textStyle;

  /// Inner padding; null adds none.
  final EdgeInsetsGeometry? padding;

  /// Minimum cell height; null adds none.
  final double? minHeight;

  /// Returns a copy with the given fields replaced.
  TableCellTheme copyWith({
    ValueGetter<StateValue<ThemedColor>?>? background,
    ValueGetter<StateValue<ThemedColor>?>? foreground,
    ValueGetter<StateValue<ThemedColor>?>? borderColor,
    ValueGetter<double?>? borderWidth,
    ValueGetter<TextStyle?>? textStyle,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<double?>? minHeight,
  }) {
    return TableCellTheme(
      background: background == null ? this.background : background(),
      foreground: foreground == null ? this.foreground : foreground(),
      borderColor: borderColor == null ? this.borderColor : borderColor(),
      borderWidth: borderWidth == null ? this.borderWidth : borderWidth(),
      textStyle: textStyle == null ? this.textStyle : textStyle(),
      padding: padding == null ? this.padding : padding(),
      minHeight: minHeight == null ? this.minHeight : minHeight(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  TableCellTheme merge(TableCellTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return TableCellTheme(
      background: background?.merge(fallback.background) ?? fallback.background,
      foreground: foreground?.merge(fallback.foreground) ?? fallback.foreground,
      borderColor:
          borderColor?.merge(fallback.borderColor) ?? fallback.borderColor,
      borderWidth: borderWidth ?? fallback.borderWidth,
      textStyle: textStyle == null
          ? fallback.textStyle
          : (fallback.textStyle?.merge(textStyle) ?? textStyle),
      padding: padding ?? fallback.padding,
      minHeight: minHeight ?? fallback.minHeight,
    );
  }

  /// State scales step at `t < 0.5`; dimensions are lerped.
  static TableCellTheme lerp(TableCellTheme a, TableCellTheme b, double t) {
    return TableCellTheme(
      background: t < 0.5 ? a.background : b.background,
      foreground: t < 0.5 ? a.foreground : b.foreground,
      borderColor: t < 0.5 ? a.borderColor : b.borderColor,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      minHeight: lerpDouble(a.minHeight, b.minHeight, t),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TableCellTheme &&
        other.background == background &&
        other.foreground == foreground &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.textStyle == textStyle &&
        other.padding == padding &&
        other.minHeight == minHeight;
  }

  @override
  int get hashCode => Object.hash(
    background,
    foreground,
    borderColor,
    borderWidth,
    textStyle,
    padding,
    minHeight,
  );
}

/// Table-level surface, border and resize-handle styling.
class TableTheme extends ComponentThemeData implements Mergeable<TableTheme> {
  /// Creates a table theme.
  const TableTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.background,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.cellTheme,
    this.resizerThickness,
    this.resizerColor,
  });

  /// Fill of the table surface.
  final ThemedColor? background;

  /// Outer border colour; null draws no border.
  final ThemedColor? borderColor;

  /// Outer border width used when [borderColor] resolves non-null.
  final double? borderWidth;

  /// Outer corner radius; null resolves the ambient `radiusMd`.
  final BorderRadiusGeometry? borderRadius;

  /// Padding around the grid; null adds none.
  final EdgeInsetsGeometry? padding;

  /// Base cell theme merged under every row's own theme.
  final TableCellTheme? cellTheme;

  /// Thickness of the resize handles.
  final double? resizerThickness;

  /// Colour of an active resize handle.
  final ThemedColor? resizerColor;

  /// Returns a copy with the given fields replaced.
  TableTheme copyWith({
    ValueGetter<ThemedColor?>? background,
    ValueGetter<ThemedColor?>? borderColor,
    ValueGetter<double?>? borderWidth,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<TableCellTheme?>? cellTheme,
    ValueGetter<double?>? resizerThickness,
    ValueGetter<ThemedColor?>? resizerColor,
  }) {
    return TableTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      background: background == null ? this.background : background(),
      borderColor: borderColor == null ? this.borderColor : borderColor(),
      borderWidth: borderWidth == null ? this.borderWidth : borderWidth(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      padding: padding == null ? this.padding : padding(),
      cellTheme: cellTheme == null ? this.cellTheme : cellTheme(),
      resizerThickness: resizerThickness == null
          ? this.resizerThickness
          : resizerThickness(),
      resizerColor: resizerColor == null ? this.resizerColor : resizerColor(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  TableTheme merge(TableTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return TableTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      background: background ?? fallback.background,
      borderColor: borderColor ?? fallback.borderColor,
      borderWidth: borderWidth ?? fallback.borderWidth,
      borderRadius: borderRadius ?? fallback.borderRadius,
      padding: padding ?? fallback.padding,
      cellTheme: cellTheme?.merge(fallback.cellTheme) ?? fallback.cellTheme,
      resizerThickness: resizerThickness ?? fallback.resizerThickness,
      resizerColor: resizerColor ?? fallback.resizerColor,
    );
  }

  /// Colours step at `t = 0.5`; geometry and cell theme are lerped.
  static TableTheme lerp(TableTheme a, TableTheme b, double t) {
    return TableTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      background: t < 0.5 ? a.background : b.background,
      borderColor: t < 0.5 ? a.borderColor : b.borderColor,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
      borderRadius: t < 0.5 ? a.borderRadius : b.borderRadius,
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      cellTheme: a.cellTheme == null || b.cellTheme == null
          ? (t < 0.5 ? a.cellTheme : b.cellTheme)
          : TableCellTheme.lerp(a.cellTheme!, b.cellTheme!, t),
      resizerThickness: lerpDouble(a.resizerThickness, b.resizerThickness, t),
      resizerColor: t < 0.5 ? a.resizerColor : b.resizerColor,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TableTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.background == background &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.cellTheme == cellTheme &&
        other.resizerThickness == resizerThickness &&
        other.resizerColor == resizerColor;
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
    cellTheme,
    resizerThickness,
    resizerColor,
  );
}

/// Shared cell padding: shadcn `p-2` (8 px all sides).
const EdgeInsetsGeometry tableCellPadding = EdgeInsets.all(8);

/// Header/footer padding: shadcn `px-2` (the header height comes from
/// [tableHeaderCellDefaults]' `minHeight`).
const EdgeInsetsGeometry tableHeadCellPadding = EdgeInsets.symmetric(
  horizontal: 8,
);

/// Default body-cell styling: bottom border, `muted/50` hover fill.
const TableCellTheme tableCellDefaults = TableCellTheme(
  background: StateValue<ThemedColor>(
    hovered: ThemedColor.ref(ColorRef.muted, alpha: 0.5),
  ),
  foreground: StateValue<ThemedColor>(
    rest: ThemedColor.ref(ColorRef.foreground),
    disabled: ThemedColor.ref(ColorRef.mutedForeground),
  ),
  borderColor: StateValue<ThemedColor>(rest: ThemedColor.ref(ColorRef.border)),
  borderWidth: 1,
  padding: tableCellPadding,
);

/// Default header-cell styling: shadcn v4 `TableHead` (`h-10 px-2`, medium
/// `foreground` text).
const TableCellTheme tableHeaderCellDefaults = TableCellTheme(
  background: StateValue<ThemedColor>(
    hovered: ThemedColor.ref(ColorRef.muted, alpha: 0.5),
  ),
  foreground: StateValue<ThemedColor>(
    rest: ThemedColor.ref(ColorRef.foreground),
  ),
  borderColor: StateValue<ThemedColor>(rest: ThemedColor.ref(ColorRef.border)),
  borderWidth: 1,
  textStyle: TextStyle(fontWeight: FontWeight.w500),
  padding: tableHeadCellPadding,
  minHeight: 40,
);

/// Default footer-cell styling: medium muted-foreground text, no border.
const TableCellTheme tableFooterCellDefaults = TableCellTheme(
  background: StateValue<ThemedColor>(
    hovered: ThemedColor.ref(ColorRef.muted, alpha: 0.5),
  ),
  foreground: StateValue<ThemedColor>(
    rest: ThemedColor.ref(ColorRef.mutedForeground),
  ),
  borderWidth: 0,
  padding: tableHeadCellPadding,
);

/// Token-derived baseline values; unset override fields fall through here.
///
/// `borderRadius` stays null because its default comes from the ambient token
/// scale (`radiusMd`) and is resolved at build time.
const TableTheme tableDefaults = TableTheme(
  background: ThemedColor.ref(ColorRef.card),
  resizerThickness: 4,
  resizerColor: ThemedColor.ref(ColorRef.primary),
);

/// Merges the row default with the table-level cell theme; the table leg wins
/// per field.
TableCellTheme mergeTableCellTheme(
  TableCellTheme rowTheme, {
  TableCellTheme? tableTheme,
}) {
  return tableTheme == null ? rowTheme : tableTheme.merge(rowTheme);
}
