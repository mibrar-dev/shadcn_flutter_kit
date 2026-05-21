// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../sortable.dart';

/// SortableData defines a reusable type for this registry module.
class SortableData<T> {
  /// The actual data being wrapped for sorting operations.
  ///
  /// Type: `T`. This is the data that will be passed to drop handlers and
  /// validation predicates. Can be any type that represents the sortable item.
  final T data;

  /// Creates a [SortableData] wrapper for the given data.
  ///
  /// Wraps the provided data in an immutable container that can be used with
  /// sortable widgets for drag-and-drop operations.
  ///
  /// Parameters:
  /// - [data] (T, required): The data to wrap for sorting operations
  ///
  /// Example:
  /// ```dart
  /// // Wrapping different data types
  /// SortableData('text_item')
  /// SortableData(42)
  /// SortableData(MyCustomObject(id: 1))
  /// ```
  const SortableData(this.data);

  @override
  @nonVirtual
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) => super == other;

  @override
  @nonVirtual
  /// Stores `hashCode` state/configuration for this implementation.
  int get hashCode => super.hashCode;

  @override
  /// Executes `toString` behavior for this component/composite.
  String toString() => 'SortableData($data)';
}

/// A layer widget that manages drag-and-drop sessions for sortable widgets.
///
/// SortableLayer is a required wrapper that coordinates drag-and-drop operations
/// between multiple sortable widgets. It provides the infrastructure for managing
/// drag sessions, rendering ghost elements during dragging, and handling drop
/// animations.
///
/// The layer maintains the drag state and provides a rendering context for ghost
/// widgets that follow the cursor during drag operations. It also manages drop
/// animations and cleanup when drag operations complete.
///
/// Features:
/// - Centralized drag session management across multiple sortable widgets
/// - Ghost widget rendering with cursor following during drag operations
/// - Configurable drop animations with custom duration and curves
/// - Boundary locking to constrain drag operations within the layer bounds
/// - Automatic cleanup and state management for drag sessions
///
/// All sortable widgets must be descendants of a SortableLayer to function properly.
/// The layer should be placed at a level that encompasses all related sortable widgets.
///
/// Example:
/// ```dart
/// SortableLayer(
///   lock: true, // Constrain dragging within bounds
///   dropDuration: Duration(milliseconds: 300),
///   dropCurve: Curves.easeOut,
///   child: Column(
///     children: [
///       Sortable(...),
///       Sortable(...),
///       Sortable(...),
///     ],
///   ),
/// )
/// ```
