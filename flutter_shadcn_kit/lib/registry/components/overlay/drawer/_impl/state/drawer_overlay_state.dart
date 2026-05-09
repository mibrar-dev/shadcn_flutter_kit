// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../drawer.dart';

/// DrawerOverlayState defines a reusable type for this registry module.
class DrawerOverlayState extends State<DrawerOverlay> {
  /// Stores `_layerData` state/configuration for this implementation.
  DrawerLayerData? _layerData;

  /// Stores `_entries` state/configuration for this implementation.
  final List<DrawerOverlayEntry> _entries = [];

  /// Key for the backdrop widget to enable transformations.
  final GlobalKey backdropKey = GlobalKey();

  /// Adds a drawer overlay entry to the list of active entries.
  ///
  /// Updates the widget state to include the new entry, triggering a rebuild
  /// to display the drawer overlay.
  ///
  /// Parameters:
  /// - [entry] (`DrawerOverlayEntry`, required): The drawer entry to add.
  ///
  /// Example:
  /// ```dart
  /// final entry = DrawerOverlayEntry(
  ///   builder: (context) => MyDrawerContent(),
  /// );
  /// drawerState.addEntry(entry);
  /// ```
  void addEntry(DrawerOverlayEntry entry) {
    /// Creates a `setState` instance.
    setState(() {
      _entries.add(entry);
    });
  }

  /// Computes the size of the drawer overlay area.
  ///
  /// Returns the size of the overlay's render box. Used for positioning
  /// and sizing drawer content.
  ///
  /// Throws [AssertionError] if overlay is not ready (no size available).
  ///
  /// Returns [Size] of the overlay area.
  Size computeSize() {
    /// Stores `size` state/configuration for this implementation.
    Size? size = context.size;
    assert(size != null, 'DrawerOverlay is not ready');
    return size!;
  }

  /// Removes a drawer entry from the overlay stack.
  ///
  /// Triggers a rebuild to update the overlay display after removing
  /// the specified entry.
  ///
  /// Parameters:
  /// - [entry] (DrawerOverlayEntry, required): Entry to remove
  void removeEntry(DrawerOverlayEntry entry) {
    if (mounted) {
      /// Creates a `setState` instance.
      setState(() {
        _entries.remove(entry);
      });
    }
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final parentLayer = Data.maybeOf<DrawerLayerData>(context);
    _layerData = DrawerLayerData(this, parentLayer);
    DrawerOverlay._registerLayer(_layerData!);
    Widget child = KeyedSubtree(key: backdropKey, child: widget.child);

    /// Stores `index` state/configuration for this implementation.
    int index = 0;
    for (final entry in _entries) {
      child = DrawerEntryWidget(
        key: entry.key, // to make the overlay state persistent
        builder: entry.builder,
        backdrop: child,
        barrierBuilder: entry.barrierBuilder,
        modal: entry.modal,
        themes: entry.themes,
        completer: entry.completer,
        position: entry.position,
        backdropBuilder: entry.backdropBuilder,
        animationController: entry.animationController,
        stackIndex: index++,
        totalStack: _entries.length,
        data: entry.data,
        useSafeArea: entry.useSafeArea,
        autoOpen: entry.autoOpen,
      );
    }
    return PopScope(
      // prevent from popping when there is an overlay
      // instead, the overlay should be closed first
      // once everything is closed, then this can be popped
      canPop: _entries.isEmpty,
      onPopInvokedWithResult: (didPop, result) {
        if (_entries.isNotEmpty) {
          /// Stores `last` state/configuration for this implementation.
          var last = _entries.last;
          if (last.barrierDismissible) {
            /// Stores `state` state/configuration for this implementation.
            var state = last.key.currentState;
            if (state != null) {
              state.close(result);
            } else {
              last.completer.complete(result);
            }
          }
        }
      },
      child: ForwardableData(data: _layerData!, child: child),
    );
  }

  @override
  /// Executes `dispose` behavior for this component/composite.
  void dispose() {
    if (_layerData != null) {
      DrawerOverlay._clearLayer(_layerData!);
    }
    super.dispose();
  }
}

/// Widget representing a single drawer entry in the overlay stack.
///
/// Manages the lifecycle and rendering of an individual drawer overlay,
/// including its backdrop, barrier, and animated transitions.
