// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../table.dart';

/// ConstrainedTableSize defines a reusable type for this registry module.
class ConstrainedTableSize {
  /// Minimum allowed size. Defaults to negative infinity (no minimum).
  final double min;

  /// Maximum allowed size. Defaults to positive infinity (no maximum).
  final double max;

  /// Creates a [ConstrainedTableSize] with optional min and max values.
  const ConstrainedTableSize({
    this.min = double.negativeInfinity,
    this.max = double.infinity,
  });
}

/// Theme configuration for individual table cells.
///
/// [TableCellTheme] provides state-aware styling options for table cells
/// using [WidgetStateProperty] to handle different interactive states like
/// hover, selected, disabled, etc. This enables rich visual feedback for
/// table interactions.
///
/// ## State-Aware Properties
/// All properties use [WidgetStateProperty] to support different visual
/// states:
/// - [WidgetState.hovered]: Mouse hover state
/// - [WidgetState.selected]: Cell/row selection state
/// - [WidgetState.disabled]: Disabled interaction state
/// - [WidgetState.pressed]: Active press state
///
/// Example:
/// ```dart
/// TableCellTheme(
///   backgroundColor: WidgetStateProperty.resolveWith((states) {
///     if (states.contains(WidgetState.hovered)) {
///       return Colors.blue.shade50;
///     }
///     return null;
///   }),
///   textStyle: WidgetStateProperty.all(
///     TextStyle(fontWeight: FontWeight.w500),
///   ),
/// );
/// ```
