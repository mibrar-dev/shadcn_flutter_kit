// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/widgets.dart';

import '../../../shared/theme/theme.dart';

part '_impl/core/selectable_text.dart';

/// {@template selectable_text_theme}
/// Theme data for [SelectableText] to customize cursor and selection behavior.
/// {@endtemplate}
class SelectableTextTheme extends ComponentThemeData {
  /// Width of the text cursor in logical pixels.
  ///
  /// If `null`, uses the default cursor width from the platform or theme.
  final double? cursorWidth;

  /// Height of the text cursor in logical pixels.
  ///
  /// If `null`, the cursor height matches the line height of the text.
  final double? cursorHeight;

  /// Corner radius of the text cursor.
  ///
  /// If `null`, the cursor has square corners (no rounding).
  final Radius? cursorRadius;

  /// Color of the text cursor.
  ///
  /// If `null`, uses the theme's primary color or platform default.
  final Color? cursorColor;

  /// How tall the selection highlight boxes should be.
  ///
  /// Determines vertical sizing behavior for text selection highlights.
  /// If `null`, uses platform or theme defaults.
  final ui.BoxHeightStyle? selectionHeightStyle;

  /// How wide the selection highlight boxes should be.
  ///
  /// Determines horizontal sizing behavior for text selection highlights.
  /// If `null`, uses platform or theme defaults.
  final ui.BoxWidthStyle? selectionWidthStyle;

  /// Whether to enable interactive text selection (e.g., selecting with mouse/touch).
  ///
  /// When `true`, users can select text by dragging. When `false`, text
  /// selection gestures are disabled. If `null`, uses platform defaults.
  final bool? enableInteractiveSelection;

  /// {@macro selectable_text_theme}
  const SelectableTextTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.cursorWidth,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionHeightStyle,
    this.selectionWidthStyle,
    this.enableInteractiveSelection,
  });

  /// Creates a copy of this theme with optionally replaced values.
  ///
  /// Uses [ValueGetter] functions to allow nullable value replacement.
  /// Properties not provided retain their current values.
  ///
  /// Parameters:
  /// - [cursorWidth]: Optional getter for new cursor width
  /// - [cursorHeight]: Optional getter for new cursor height
  /// - [cursorRadius]: Optional getter for new cursor radius
  /// - [cursorColor]: Optional getter for new cursor color
  /// - [selectionHeightStyle]: Optional getter for new selection height style
  /// - [selectionWidthStyle]: Optional getter for new selection width style
  /// - [enableInteractiveSelection]: Optional getter for new interactive selection state
  ///
  /// Returns a new [SelectableTextTheme] with updated values.
  SelectableTextTheme copyWith({
    ValueGetter<double?>? cursorWidth,
    ValueGetter<double?>? cursorHeight,
    ValueGetter<Radius?>? cursorRadius,
    ValueGetter<Color?>? cursorColor,
    ValueGetter<ui.BoxHeightStyle?>? selectionHeightStyle,
    ValueGetter<ui.BoxWidthStyle?>? selectionWidthStyle,
    ValueGetter<bool?>? enableInteractiveSelection,
  }) {
    return SelectableTextTheme(
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

  @override
  int get hashCode => Object.hash(
    cursorWidth,
    cursorHeight,
    cursorRadius,
    cursorColor,
    selectionHeightStyle,
    selectionWidthStyle,
    enableInteractiveSelection,
  );

  /// Compares two selectable values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SelectableTextTheme &&
        other.cursorWidth == cursorWidth &&
        other.cursorHeight == cursorHeight &&
        other.cursorRadius == cursorRadius &&
        other.cursorColor == cursorColor &&
        other.selectionHeightStyle == selectionHeightStyle &&
        other.selectionWidthStyle == selectionWidthStyle &&
        other.enableInteractiveSelection == enableInteractiveSelection;
  }

  /// Returns a debug string for this selectable value.
  @override
  String toString() {
    return 'SelectableTextTheme(cursorWidth: $cursorWidth, cursorHeight: $cursorHeight, cursorRadius: $cursorRadius, cursorColor: $cursorColor, selectionHeightStyle: $selectionHeightStyle, selectionWidthStyle: $selectionWidthStyle, enableInteractiveSelection: $enableInteractiveSelection)';
  }
}
