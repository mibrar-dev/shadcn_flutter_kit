// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../table.dart';

/// ResizableTableTheme defines a reusable type for this registry module.
class ResizableTableTheme extends ComponentThemeData {
  /// Base theme configuration for the table.
  final TableTheme? tableTheme;

  /// Thickness of the resize handle in pixels.
  final double? resizerThickness;

  /// Color of the resize handle.
  final Color? resizerColor;

  /// Creates a [ResizableTableTheme].
  const ResizableTableTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.tableTheme,
    this.resizerThickness,
    this.resizerColor,
  });

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResizableTableTheme &&
        other.tableTheme == tableTheme &&
        other.resizerThickness == resizerThickness &&
        other.resizerColor == resizerColor;
  }

  @override
  int get hashCode {
    return Object.hash(tableTheme, resizerThickness, resizerColor);
  }

  /// Creates a copy of this theme with the given fields replaced.
  ///
  /// Parameters:
  /// - [tableTheme] (`ValueGetter<TableTheme?>?`, optional): New table theme.
  /// - [resizerThickness] (`ValueGetter<double?>?`, optional): New resizer thickness.
  /// - [resizerColor] (`ValueGetter<Color?>?`, optional): New resizer color.
  ///
  /// Returns: A new [ResizableTableTheme] with updated properties.
  ResizableTableTheme copyWith({
    ValueGetter<TableTheme?>? tableTheme,
    ValueGetter<double?>? resizerThickness,
    ValueGetter<Color?>? resizerColor,
  }) {
    return ResizableTableTheme(
      tableTheme: tableTheme == null ? this.tableTheme : tableTheme(),
      resizerThickness: resizerThickness == null
          ? this.resizerThickness
          : resizerThickness(),
      resizerColor: resizerColor == null ? this.resizerColor : resizerColor(),
    );
  }
}
