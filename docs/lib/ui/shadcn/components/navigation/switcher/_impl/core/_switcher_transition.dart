// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../switcher.dart';

/// _SwitcherTransition defines a reusable type for this registry module.
class _SwitcherTransition extends MultiChildRenderObjectWidget {
  /// Stores `progress` state/configuration for this implementation.
  final double progress;

  /// Stores `direction` state/configuration for this implementation.
  final AxisDirection direction;

  /// Stores `absolute` state/configuration for this implementation.
  final bool absolute;

  /// Creates a `_SwitcherTransition` instance.
  const _SwitcherTransition({
    required this.progress,
    required this.direction,
    required this.absolute,
    required super.children,
  });

  @override
  /// Executes `createRenderObject` behavior for this component/composite.
  _RenderSwitcherTransition createRenderObject(BuildContext context) {
    return _RenderSwitcherTransition()
      ..progress = progress
      ..direction = direction
      ..absolute = absolute;
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderSwitcherTransition renderObject,
  ) {
    if (renderObject.progress != progress ||
        renderObject.direction != direction ||
        renderObject.absolute != absolute) {
      renderObject.progress = progress;
      renderObject.direction = direction;
      renderObject.absolute = absolute;
      renderObject.markNeedsLayout();
    }
  }
}
