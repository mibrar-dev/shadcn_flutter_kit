// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../table.dart';

/// TableTheme defines a reusable type for this registry module.
class TableTheme extends ComponentThemeData {
  /// Border configuration for the entire table.
  ///
  /// Type: `Border?`. Defines the outer border of the table container.
  /// If null, uses the default theme border or no border.
  final Border? border;

  /// Border radius for the table corners.
  ///
  /// Type: `BorderRadiusGeometry?`. Controls corner rounding of the table
  /// container. If null, uses the theme's default radius.
  final BorderRadiusGeometry? borderRadius;

  /// Background color for the table container.
  ///
  /// Type: `Color?`. Used as the background color behind all table content.
  /// If null, uses the theme's default background color.
  final Color? backgroundColor;

  /// Default theme for all table cells.
  ///
  /// Type: `TableCellTheme?`. Provides default styling for table cells
  /// including padding, borders, and text styles. Individual cells can
  /// override this theme.
  final TableCellTheme? cellTheme;

  /// Creates a [TableTheme].
  ///
  /// All parameters are optional and will fall back to theme defaults
  /// when not provided.
  ///
  /// Parameters:
  /// - [border] (Border?, optional): Table container border
  /// - [backgroundColor] (Color?, optional): Table background color
  /// - [borderRadius] (BorderRadiusGeometry?, optional): Corner radius
  /// - [cellTheme] (TableCellTheme?, optional): Default cell styling
  ///
  /// Example:
  /// ```dart
  /// TableTheme(
  ///   border: Border.all(color: Colors.grey),
  ///   borderRadius: BorderRadius.circular(4.0),
  ///   backgroundColor: Colors.white,
  /// );
  /// ```
  const TableTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.border,
    this.backgroundColor,
    this.borderRadius,
    this.cellTheme,
  });

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TableTheme &&
        other.border == border &&
        other.backgroundColor == backgroundColor &&
        other.cellTheme == cellTheme;
  }

  @override
  int get hashCode {
    return Object.hash(border, backgroundColor, cellTheme);
  }

  /// Creates a copy of this theme with the given values replaced.
  ///
  /// Returns a new [TableTheme] instance with the same values as this theme,
  /// except for any parameters that are explicitly provided. Use [ValueGetter]
  /// functions to specify new values.
  ///
  /// Parameters are [ValueGetter] functions that return the new value when called.
  /// This allows for conditional value setting and proper null handling.
  ///
  /// Example:
  /// ```dart
  /// final newTheme = originalTheme.copyWith(
  ///   backgroundColor: () => Colors.blue.shade50,
  ///   border: () => Border.all(color: Colors.blue),
  /// );
  /// ```
  TableTheme copyWith({
    ValueGetter<Border?>? border,
    ValueGetter<Color?>? backgroundColor,
    ValueGetter<TableCellTheme?>? cellTheme,
  }) {
    return TableTheme(
      border: border == null ? this.border : border(),
      backgroundColor: backgroundColor == null
          ? this.backgroundColor
          : backgroundColor(),
      cellTheme: cellTheme == null ? this.cellTheme : cellTheme(),
    );
  }
}

/// Defines size constraints for table columns or rows.
///
/// Specifies minimum and maximum size limits that can be applied
/// to table dimensions. Used with [ResizableTable] to control
/// resize boundaries.
///
/// Example:
/// ```dart
/// ConstrainedTableSize(
///   min: 50.0,  // Minimum 50 pixels
///   max: 300.0, // Maximum 300 pixels
/// )
/// ```
