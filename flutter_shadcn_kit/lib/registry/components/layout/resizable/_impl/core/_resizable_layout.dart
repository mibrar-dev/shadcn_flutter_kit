// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../resizable.dart';

/// _ResizableLayout defines a reusable type for this registry module.
class _ResizableLayout extends MultiChildRenderObjectWidget {
  /// Stores `direction` state/configuration for this implementation.
  final Axis direction;

  /// Stores `onLayout` state/configuration for this implementation.
  final _ResizableLayoutCallback onLayout;

  /// Creates a `_ResizableLayout` instance.
  const _ResizableLayout({
    required this.direction,
    required super.children,
    required this.onLayout,
  });

  @override
  /// Executes `createRenderObject` behavior for this component/composite.
  RenderObject createRenderObject(BuildContext context) {
    return _RenderResizableLayout(direction, onLayout);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderResizableLayout renderObject,
  ) {
    /// Stores `needsLayout` state/configuration for this implementation.
    bool needsLayout = false;
    if (renderObject.direction != direction) {
      renderObject.direction = direction;
      needsLayout = true;
    }
    if (renderObject.onLayout != onLayout) {
      renderObject.onLayout = onLayout;
      needsLayout = true;
    }
    if (needsLayout) {
      renderObject.markNeedsLayout();
    }
  }
}
