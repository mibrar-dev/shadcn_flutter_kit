// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../sortable.dart';

/// _SortableDropLocation enumerates fixed values used by this implementation.
enum _SortableDropLocation { top, left, right, bottom }

_SortableDropLocation? _getPosition(
  Offset position,
  Size size, {
  bool acceptTop = false,
  bool acceptLeft = false,
  bool acceptRight = false,
  bool acceptBottom = false,
}) {
  /// Stores `dx` state/configuration for this implementation.
  double dx = position.dx;

  /// Stores `dy` state/configuration for this implementation.
  double dy = position.dy;

  /// Stores `width` state/configuration for this implementation.
  double width = size.width;

  /// Stores `height` state/configuration for this implementation.
  double height = size.height;
  if (acceptTop && !acceptBottom) {
    return _SortableDropLocation.top;
  } else if (acceptBottom && !acceptTop) {
    return _SortableDropLocation.bottom;
  } else if (acceptLeft && !acceptRight) {
    return _SortableDropLocation.left;
  } else if (acceptRight && !acceptLeft) {
    return _SortableDropLocation.right;
  }
  if (acceptTop && dy <= height / 2) {
    return _SortableDropLocation.top;
  }
  if (acceptLeft && dx <= width / 2) {
    return _SortableDropLocation.left;
  }
  if (acceptRight && dx >= width / 2) {
    return _SortableDropLocation.right;
  }
  if (acceptBottom && dy >= height / 2) {
    return _SortableDropLocation.bottom;
  }
  return null;
}

/// A fallback drop zone for sortable items when dropped outside specific sortable widgets.
///
/// SortableDropFallback provides a catch-all drop zone that can accept sortable
/// items when they're dropped outside of any specific sortable widget drop zones.
/// This is useful for implementing deletion zones, creation areas, or general
/// drop handling areas.
///
/// The widget wraps its child with an invisible hit test layer that can detect
/// and accept dropped sortable items based on configurable acceptance criteria.
///
/// Example:
/// ```dart
/// SortableDropFallback<String>(
///   canAccept: (data) => data.data.startsWith('temp_'),
///   onAccept: (data) => deleteItem(data.data),
///   child: Container(
///     height: 100,
///     child: Center(child: Text('Drop here to delete')),
///   ),
/// )
/// ```
