// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../scaffold.dart';

/// _ScaffoldFlex defines a reusable type for this registry module.
class _ScaffoldFlex extends MultiChildRenderObjectWidget {
  /// Stores `floatingHeader` state/configuration for this implementation.
  final bool floatingHeader;

  /// Stores `floatingFooter` state/configuration for this implementation.
  final bool floatingFooter;

  /// Creates a `_ScaffoldFlex` instance.
  const _ScaffoldFlex({
    super.children,
    required this.floatingHeader,
    required this.floatingFooter,
  });

  @override
  /// Executes `createRenderObject` behavior for this component/composite.
  RenderObject createRenderObject(BuildContext context) {
    return _ScaffoldRenderFlex(
      floatingHeader: floatingHeader,
      floatingFooter: floatingFooter,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _ScaffoldRenderFlex renderObject,
  ) {
    /// Stores `needsLayout` state/configuration for this implementation.
    bool needsLayout = false;
    if (renderObject._floatingHeader != floatingHeader) {
      renderObject._floatingHeader = floatingHeader;
      needsLayout = true;
    }
    if (renderObject._floatingFooter != floatingFooter) {
      renderObject._floatingFooter = floatingFooter;
      needsLayout = true;
    }
    if (needsLayout) {
      renderObject.markNeedsLayout();
    }
  }
}
