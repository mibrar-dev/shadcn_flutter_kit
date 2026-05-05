part of '../../hidden.dart';


/// _HiddenLayout defines a reusable type for this registry module.
class _HiddenLayout extends SingleChildRenderObjectWidget {
/// Stores `keepCrossAxisSize` state/configuration for this implementation.
  final bool keepCrossAxisSize;
/// Stores `keepMainAxisSize` state/configuration for this implementation.
  final bool keepMainAxisSize;
/// Stores `textDirection` state/configuration for this implementation.
  final TextDirection textDirection;
/// Stores `direction` state/configuration for this implementation.
  final Axis direction;
/// Stores `reverse` state/configuration for this implementation.
  final bool reverse;
/// Stores `progress` state/configuration for this implementation.
  final double progress;

/// Creates a `_HiddenLayout` instance.
  const _HiddenLayout({
    required this.keepCrossAxisSize,
    required this.keepMainAxisSize,
    required this.textDirection,
    required this.direction,
    required this.reverse,
    required this.progress,
    super.child,
  });

  @override
/// Executes `createRenderObject` behavior for this component/composite.
  RenderObject createRenderObject(BuildContext context) {
    return _HiddenLayoutRender(
      keepCrossAxisSize: keepCrossAxisSize,
      keepMainAxisSize: keepMainAxisSize,
      textDirection: textDirection,
      direction: direction,
      reverse: reverse,
      progress: progress,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _HiddenLayoutRender renderObject) {
    renderObject
      ..keepCrossAxisSize = keepCrossAxisSize
      ..keepMainAxisSize = keepMainAxisSize
      ..textDirection = textDirection
      ..direction = direction
      ..reverse = reverse
      ..progress = progress;
  }
}
