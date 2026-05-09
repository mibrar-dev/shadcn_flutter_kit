// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../table.dart';

/// Type alias for `CellPredicate` used by public or internal APIs.
typedef CellPredicate = bool Function(int index, int span);

/// Low-level table layout widget.
///
/// Provides raw table layout functionality with support for frozen rows/columns
/// and scrolling. Used internally by higher-level table widgets.
///
/// Example:
/// ```dart
/// RawTableLayout(
///   width: (index) => FlexTableSize(),
///   height: (index) => FixedTableSize(50),
///   clipBehavior: Clip.hardEdge,
///   children: [...],
/// )
/// ```
