// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../sortable.dart';

/// ScrollableSortableLayer defines a reusable type for this registry module.
class ScrollableSortableLayer extends StatefulWidget {
  /// The child widget containing sortable items within a scrollable area.
  ///
  /// Type: `Widget`. Typically a scrollable widget like ListView or GridView
  /// that contains sortable items and uses the same controller.
  final Widget child;

  /// The scroll controller that manages the scrollable area.
  ///
  /// Type: `ScrollController`. Must be the same controller used by the scrollable
  /// widget in the child tree. This allows the layer to control scrolling during
  /// drag operations.
  final ScrollController controller;

  /// Distance from scroll area edges that triggers automatic scrolling.
  ///
  /// Type: `double`, default: `50.0`. When a dragged item comes within this
  /// distance of the top or bottom edge (for vertical scrolling), automatic
  /// scrolling begins. Larger values provide earlier scroll activation.
  final double scrollThreshold;

  /// Whether to allow scrolling beyond the normal scroll bounds.
  ///
  /// Type: `bool`, default: `false`. When true, drag operations can trigger
  /// scrolling past the normal scroll limits, similar to overscroll behavior.
  final bool overscroll;

  /// Creates a [ScrollableSortableLayer] with automatic scrolling support.
  ///
  /// Configures a sortable layer that provides automatic scrolling when dragged
  /// items approach the edges of the scrollable area.
  ///
  /// Parameters:
  /// - [key] (Key?): Widget identifier for the widget tree
  /// - [child] (Widget, required): The scrollable widget containing sortable items
  /// - [controller] (ScrollController, required): The scroll controller to manage
  /// - [scrollThreshold] (double, default: 50.0): Distance from edges for scroll trigger
  /// - [overscroll] (bool, default: false): Whether to allow overscroll behavior
  ///
  /// Example:
  /// ```dart
  /// final controller = ScrollController();
  ///
  /// ScrollableSortableLayer(
  ///   controller: controller,
  ///   scrollThreshold: 60.0,
  ///   overscroll: true,
  ///   child: ListView.builder(
  ///     controller: controller,
  ///     itemCount: items.length,
  ///     itemBuilder: (context, index) => Sortable<Item>(
  ///       data: SortableData(items[index]),
  ///       child: ItemWidget(items[index]),
  ///     ),
  ///   ),
  /// )
  /// ```
  const ScrollableSortableLayer({
    super.key,
    required this.child,
    required this.controller,
    this.scrollThreshold = 50,
    this.overscroll = false,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<ScrollableSortableLayer> createState() =>
      _ScrollableSortableLayerState();
}
