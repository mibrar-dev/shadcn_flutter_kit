// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../table.dart';

/// TableCellTheme defines a reusable type for this registry module.
class TableCellTheme {
  /// State-aware border configuration for table cells.
  ///
  /// Type: `WidgetStateProperty<Border?>?`. Defines cell borders that can
  /// change based on interactive states. Useful for highlighting selected
  /// or hovered cells.
  final WidgetStateProperty<Border?>? border;

  /// State-aware background color for table cells.
  ///
  /// Type: `WidgetStateProperty<Color?>?`. Controls cell background colors
  /// that can change based on hover, selection, or other states.
  final WidgetStateProperty<Color?>? backgroundColor;

  /// State-aware text styling for table cell content.
  ///
  /// Type: `WidgetStateProperty<TextStyle?>?`. Controls text appearance
  /// including color, weight, size that can change based on cell states.
  final WidgetStateProperty<TextStyle?>? textStyle;

  /// Creates a [TableCellTheme].
  ///
  /// All parameters are optional and use [WidgetStateProperty] for
  /// state-aware styling.
  ///
  /// Parameters:
  /// - [border] (`WidgetStateProperty<Border?>?`, optional): State-aware borders
  /// - [backgroundColor] (`WidgetStateProperty<Color?>?`, optional): State-aware background
  /// - [textStyle] (`WidgetStateProperty<TextStyle?>?`, optional): State-aware text styling
  ///
  /// Example:
  /// ```dart
  /// TableCellTheme(
  ///   border: WidgetStateProperty.all(
  ///     Border.all(color: Colors.grey.shade300),
  ///   ),
  ///   backgroundColor: WidgetStateProperty.resolveWith((states) {
  ///     return states.contains(WidgetState.selected) ? Colors.blue.shade100 : null;
  ///   }),
  /// );
  /// ```
  const TableCellTheme({this.border, this.backgroundColor, this.textStyle});

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TableCellTheme &&
        other.border == border &&
        other.backgroundColor == backgroundColor &&
        other.textStyle == textStyle;
  }

  @override
  int get hashCode {
    return Object.hash(border, backgroundColor, textStyle);
  }

  /// Creates a copy of this cell theme with the given values replaced.
  ///
  /// Returns a new [TableCellTheme] instance with the same state properties
  /// as this theme, except for any parameters that are explicitly provided.
  /// Use [ValueGetter] functions to specify new state properties.
  ///
  /// Example:
  /// ```dart
  /// final newTheme = originalTheme.copyWith(
  ///   backgroundColor: () => WidgetStateProperty.all(Colors.yellow.shade50),
  ///   textStyle: () => WidgetStateProperty.all(TextStyle(fontWeight: FontWeight.bold)),
  /// );
  /// ```
  TableCellTheme copyWith({
    ValueGetter<WidgetStateProperty<Border>?>? border,
    ValueGetter<WidgetStateProperty<Color>?>? backgroundColor,
    ValueGetter<WidgetStateProperty<TextStyle>?>? textStyle,
  }) {
    return TableCellTheme(
      border: border == null ? this.border : border(),
      backgroundColor: backgroundColor == null
          ? this.backgroundColor
          : backgroundColor(),
      textStyle: textStyle == null ? this.textStyle : textStyle(),
    );
  }
}

/// Theme configuration for resizable tables.
///
/// Provides styling options for resizable table components including
/// the base table theme, resizer appearance, and interaction behavior.
///
/// Example:
/// ```dart
/// ResizableTableTheme(
///   tableTheme: TableTheme(...),
///   resizerThickness: 2.0,
///   resizerColor: Colors.blue,
/// )
/// ```
