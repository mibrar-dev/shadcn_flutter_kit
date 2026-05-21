// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../hidden.dart';

/// _HiddenLayout defines a reusable type for this registry module.
class _HiddenLayout extends SingleChildRenderObjectWidget {
  /// Creates a `_HiddenLayout` instance.
  const _HiddenLayout({
    required this.textDirection,
    required this.direction,
    required this.reverse,
    required this.progress,
    required this.keepCrossAxisSize,
    required this.keepMainAxisSize,
    super.child,
  });

  /// Stores `textDirection` state/configuration for this implementation.
  final TextDirection textDirection;

  /// Stores `direction` state/configuration for this implementation.
  final Axis direction;

  /// Stores `reverse` state/configuration for this implementation.
  final bool reverse;

  /// Stores `progress` state/configuration for this implementation.
  final double progress;

  /// Stores `keepCrossAxisSize` state/configuration for this implementation.
  final bool keepCrossAxisSize;

  /// Stores `keepMainAxisSize` state/configuration for this implementation.
  final bool keepMainAxisSize;

  @override
  /// Executes `createRenderObject` behavior for this component/composite.
  RenderObject createRenderObject(BuildContext context) {
    return _RenderHiddenLayout(
      textDirection: textDirection,
      direction: direction,
      reverse: reverse,
      progress: progress,
      keepCrossAxisSize: keepCrossAxisSize,
      keepMainAxisSize: keepMainAxisSize,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderHiddenLayout renderObject,
  ) {
    /// Stores `needsLayout` state/configuration for this implementation.
    bool needsLayout = false;
    if (renderObject.textDirection != textDirection) {
      renderObject.textDirection = textDirection;
      needsLayout = true;
    }
    if (renderObject.direction != direction) {
      renderObject.direction = direction;
      needsLayout = true;
    }
    if (renderObject.reverse != reverse) {
      renderObject.reverse = reverse;
      needsLayout = true;
    }
    if (renderObject.progress != progress) {
      renderObject.progress = progress;
      needsLayout = true;
    }
    if (renderObject.keepCrossAxisSize != keepCrossAxisSize) {
      renderObject.keepCrossAxisSize = keepCrossAxisSize;
      needsLayout = true;
    }
    if (renderObject.keepMainAxisSize != keepMainAxisSize) {
      renderObject.keepMainAxisSize = keepMainAxisSize;
      needsLayout = true;
    }
    if (needsLayout) {
      renderObject.markNeedsLayout();
    }
  }
}
