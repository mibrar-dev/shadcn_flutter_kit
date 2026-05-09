// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../flex.dart';

/// Patched [widgets.Stack] that supports child paint order.
class Stack extends widgets.Stack {
  /// Creates a `Stack` instance.
  const Stack({
    super.key,
    super.alignment,
    super.textDirection,
    super.fit,
    super.clipBehavior,
    super.children,
  });

  @override
  /// Executes `createRenderObject` behavior for this component/composite.
  RenderStack createRenderObject(widgets.BuildContext context) {
    assert(_debugCheckHasDirectionality(context));
    return RenderStack(
      alignment: alignment,
      textDirection: textDirection ?? widgets.Directionality.maybeOf(context),
      fit: fit,
      clipBehavior: clipBehavior,
    );
  }

  @override
  void updateRenderObject(
    widgets.BuildContext context,
    covariant RenderStack renderObject,
  ) {
    assert(_debugCheckHasDirectionality(context));
    renderObject
      ..alignment = alignment
      ..textDirection = textDirection ?? widgets.Directionality.maybeOf(context)
      ..fit = fit
      ..clipBehavior = clipBehavior;
  }

  /// Executes `_debugCheckHasDirectionality` behavior for this component/composite.
  bool _debugCheckHasDirectionality(widgets.BuildContext context) {
    if (alignment is! widgets.AlignmentDirectional) {
      return true;
    }

    /// Creates a `assert` instance.
    assert(
      textDirection != null || widgets.Directionality.maybeOf(context) != null,
      'Stack alignment requires a TextDirection',
    );
    return true;
  }
}
