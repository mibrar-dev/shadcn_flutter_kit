// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../scaffold.dart';

/// _RenderScaffoldPadding defines a reusable type for this registry module.
class _RenderScaffoldPadding extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _ScaffoldParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _ScaffoldParentData> {
  /// Stores `_paddingType` state/configuration for this implementation.
  final _ScaffoldPaddingType _paddingType;

  /// Creates a `_RenderScaffoldPadding` instance.
  _RenderScaffoldPadding({
    _ScaffoldPaddingType paddingType = _ScaffoldPaddingType.header,
  }) : _paddingType = paddingType;

  /// Executes `findParent` behavior for this component/composite.
  _ScaffoldRenderFlex? findParent() {
    /// Stores `parent` state/configuration for this implementation.
    RenderObject? parent = this;
    while (parent != null) {
      if (parent is _ScaffoldRenderFlex) {
        return parent;
      }
      parent = parent.parent;
    }
    return null;
  }

  /// Stores `currentParent` state/configuration for this implementation.
  _ScaffoldRenderFlex? currentParent;

  @override
  /// Executes `attach` behavior for this component/composite.
  void attach(PipelineOwner owner) {
    super.attach(owner);
    var scaffoldParent = findParent();
    currentParent = scaffoldParent;
    scaffoldParent?._headerSize.addListener(markNeedsLayout);
    scaffoldParent?._footerSize.addListener(markNeedsLayout);
  }

  @override
  /// Executes `detach` behavior for this component/composite.
  void detach() {
    /// Stores `scaffoldParent` state/configuration for this implementation.
    var scaffoldParent = currentParent;
    scaffoldParent?._headerSize.removeListener(markNeedsLayout);
    scaffoldParent?._footerSize.removeListener(markNeedsLayout);
    super.detach();
  }

  @override
  /// Executes `performLayout` behavior for this component/composite.
  void performLayout() {
    _ScaffoldRenderFlex? parentData = findParent();
    assert(parentData != null, 'Must be a child of a Scaffold');

    /// Stores `constraints` state/configuration for this implementation.
    BoxConstraints constraints;
    switch (_paddingType) {
      case _ScaffoldPaddingType.header:
        constraints = this.constraints.copyWith(
          minHeight: parentData!._headerSize.value,
          maxHeight: parentData._headerSize.value,
        );
        break;
      case _ScaffoldPaddingType.footer:
        constraints = this.constraints.copyWith(
          minHeight: parentData!._footerSize.value,
          maxHeight: parentData._footerSize.value,
        );
        break;
    }

    /// Stores `child` state/configuration for this implementation.
    final child = firstChild;
    if (child != null) {
      child.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(child.size);
      (child.parentData as BoxParentData).offset = Offset.zero;
    } else {
      size = constraints.biggest;
    }
  }

  @override
  /// Executes `paint` behavior for this component/composite.
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}
