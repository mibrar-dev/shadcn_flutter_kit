// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../sortable.dart';

/// SortableDropFallback defines a reusable type for this registry module.
class SortableDropFallback<T> extends StatefulWidget {
  /// Callback invoked when a sortable item is dropped on this fallback zone.
  ///
  /// Type: `ValueChanged<SortableData<T>>?`. Receives the dropped item's data
  /// and should handle the drop operation. Only called if [canAccept] validation
  /// passes or is null.
  final ValueChanged<SortableData<T>>? onAccept;

  /// Predicate to determine if dropped data can be accepted by this fallback zone.
  ///
  /// Type: `Predicate<SortableData<T>>?`. If null, all sortable items are accepted.
  /// Return true to accept the drop, false to reject it.
  final Predicate<SortableData<T>>? canAccept;

  /// The child widget that defines the drop zone area.
  ///
  /// Type: `Widget`. This widget's bounds determine the area where drops can
  /// be detected. The child is rendered normally with an invisible overlay
  /// for drop detection.
  final Widget child;

  /// Creates a [SortableDropFallback] drop zone.
  ///
  /// Configures a fallback drop zone that can accept sortable items dropped
  /// outside of specific sortable widget drop zones.
  ///
  /// Parameters:
  /// - [key] (Key?): Widget identifier for the widget tree
  /// - [child] (Widget, required): The widget that defines the drop zone area
  /// - [onAccept] (`ValueChanged<SortableData<T>>?`, optional): Handler for accepted drops
  /// - [canAccept] (`Predicate<SortableData<T>>?`, optional): Validation for drops
  ///
  /// Example:
  /// ```dart
  /// SortableDropFallback<String>(
  ///   canAccept: (data) => data.data.contains('removable'),
  ///   onAccept: (data) => removeFromList(data.data),
  ///   child: Icon(Icons.delete, size: 48),
  /// )
  /// ```
  const SortableDropFallback({
    super.key,
    required this.child,
    this.onAccept,
    this.canAccept,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<SortableDropFallback<T>> createState() =>
      _SortableDropFallbackState<T>();
}
