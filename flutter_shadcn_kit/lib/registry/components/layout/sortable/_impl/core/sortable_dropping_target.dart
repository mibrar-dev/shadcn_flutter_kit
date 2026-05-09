// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../sortable.dart';

/// _DroppingTarget defines a reusable type for this registry module.
class _DroppingTarget<T> {
  /// Stores `source` state/configuration for this implementation.
  final _SortableState<T> source;

  /// Stores `candidate` state/configuration for this implementation.
  final ValueNotifier<_SortableDraggingSession<T>?> candidate;

  /// Stores `location` state/configuration for this implementation.
  final _SortableDropLocation location;

  /// Creates a `_DroppingTarget` instance.
  _DroppingTarget({
    required this.source,
    required this.candidate,
    required this.location,
  });

  /// Executes `dispose` behavior for this component/composite.
  void dispose(_SortableDraggingSession<T> target) {
    if (candidate.value == target) {
      candidate.value = null;
    }
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _DroppingTarget<T> &&
        other.source == source &&
        other.candidate == candidate &&
        other.location == location;
  }

  @override
  int get hashCode => Object.hash(source, candidate, location);

  @override
  /// Executes `toString` behavior for this component/composite.
  String toString() => '_DroppingTarget($source, $location)';
}
