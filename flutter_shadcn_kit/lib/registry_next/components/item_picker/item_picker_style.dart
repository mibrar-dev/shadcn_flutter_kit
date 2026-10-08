// Registry-owned theme data for the `item_picker` component.
//
// User-owned overrides live in `item_picker_theme.dart`; CLI updates may
// replace this file.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Theme of the item picker grid/list body.
///
/// Every field is nullable: `null` means "inherit", and the resolver fills
/// the gap from the next leg (defaults < app < scoped < widget). Surfaces
/// come from the dialog/popover presentation, so this theme only sizes the
/// item body.
class ItemPickerTheme extends ComponentThemeData
    implements Mergeable<ItemPickerTheme> {
  /// Creates an item picker theme.
  const ItemPickerTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.constraints,
    this.padding,
    this.spacing,
  });

  /// Bounds of the item body. Default: at most 320x320.
  final BoxConstraints? constraints;

  /// Padding around the items. Default: 8 on every side.
  final EdgeInsetsGeometry? padding;

  /// Gap between grid cells. Default: 4.
  final double? spacing;

  /// Returns a copy with the given fields replaced.
  ItemPickerTheme copyWith({
    ValueGetter<BoxConstraints?>? constraints,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<double?>? spacing,
  }) {
    return ItemPickerTheme(
      constraints: constraints == null ? this.constraints : constraints(),
      padding: padding == null ? this.padding : padding(),
      spacing: spacing == null ? this.spacing : spacing(),
    );
  }

  /// Receiver wins per field; [fallback] only fills null cells.
  @override
  ItemPickerTheme merge(ItemPickerTheme? fallback) {
    if (fallback == null) return this;
    return ItemPickerTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      constraints: constraints ?? fallback.constraints,
      padding: padding ?? fallback.padding,
      spacing: spacing ?? fallback.spacing,
    );
  }

  /// Geometry interpolates; the rest steps at `t = 0.5`.
  static ItemPickerTheme lerp(ItemPickerTheme a, ItemPickerTheme b, double t) {
    double? scale(double? x, double? y) {
      if (x == null) return y;
      if (y == null) return x;
      return x + (y - x) * t;
    }

    return ItemPickerTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      constraints: BoxConstraints.lerp(a.constraints, b.constraints, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      spacing: scale(a.spacing, b.spacing),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ItemPickerTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.constraints == constraints &&
        other.padding == padding &&
        other.spacing == spacing;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    constraints,
    padding,
    spacing,
  );
}

/// Built-in item picker defaults.
const ItemPickerTheme itemPickerDefaults = ItemPickerTheme(
  constraints: BoxConstraints(maxWidth: 320, maxHeight: 320),
  padding: EdgeInsets.all(8),
  spacing: 4,
);
