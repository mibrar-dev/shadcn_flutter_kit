// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../scaffold.dart';

/// _ScaffoldRenderFlex defines a reusable type for this registry module.
class _ScaffoldRenderFlex extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, _ScaffoldParentData> {
  /// Creates a `_ScaffoldRenderFlex` instance.
  _ScaffoldRenderFlex({
    required bool floatingHeader,
    required bool floatingFooter,
  }) : _floatingHeader = floatingHeader,
       _floatingFooter = floatingFooter;

  /// Stores `_floatingHeader` state/configuration for this implementation.
  bool _floatingHeader = false;

  /// Stores `_floatingFooter` state/configuration for this implementation.
  bool _floatingFooter = false;

  final ValueNotifier<double> _headerSize = ValueNotifier(0);
  final ValueNotifier<double> _footerSize = ValueNotifier(0);

  @override
  /// Executes `setupParentData` behavior for this component/composite.
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! _ScaffoldParentData) {
      child.parentData = _ScaffoldParentData();
    }
  }

  @override
  /// Executes `paint` behavior for this component/composite.
  void paint(PaintingContext context, Offset offset) {
    // There is gonna be only 3 children
    // 1. header
    // 2. content
    // 3. footer
    // By default, the paint order is 1, 2, 3
    // but with this custom implementation, we can change the order to 2, 1, 3
    // which means the header will be painted after the content
    // and the footer will be painted after the header
    /// Stores `header` state/configuration for this implementation.
    RenderBox header = firstChild!;
    RenderBox content = (header.parentData as _ScaffoldParentData).nextSibling!;
    RenderBox footer = (content.parentData as _ScaffoldParentData).nextSibling!;

    /// Creates a `context.paintChild` instance.
    context.paintChild(
      content,
      (content.parentData as BoxParentData).offset + offset,
    );

    /// Creates a `context.paintChild` instance.
    context.paintChild(
      header,
      (header.parentData as BoxParentData).offset + offset,
    );

    /// Creates a `context.paintChild` instance.
    context.paintChild(
      footer,
      (footer.parentData as BoxParentData).offset + offset,
    );
  }

  /// Executes `_hitTestBox` behavior for this component/composite.
  bool _hitTestBox(BoxHitTestResult result, RenderBox child, Offset position) {
    /// Stores `childParentData` state/configuration for this implementation.
    final BoxParentData childParentData = child.parentData as BoxParentData;
    final bool isHit = result.addWithPaintOffset(
      offset: childParentData.offset,
      position: position,
      hitTest: (BoxHitTestResult result, Offset transformed) {
        assert(transformed == position - childParentData.offset);
        return child.hitTest(result, position: transformed);
      },
    );
    return isHit;
  }

  @override
  /// Executes `hitTestChildren` behavior for this component/composite.
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    /// Stores `header` state/configuration for this implementation.
    RenderBox header = firstChild!;
    RenderBox content = (header.parentData as _ScaffoldParentData).nextSibling!;
    RenderBox footer = (content.parentData as _ScaffoldParentData).nextSibling!;
    if (_hitTestBox(result, header, position)) {
      return true;
    }
    if (_hitTestBox(result, footer, position)) {
      return true;
    }
    if (_hitTestBox(result, content, position)) {
      return true;
    }
    return false;
  }

  @override
  /// Executes `performLayout` behavior for this component/composite.
  void performLayout() {
    /// Stores `header` state/configuration for this implementation.
    RenderBox header = firstChild!;
    RenderBox content = (header.parentData as _ScaffoldParentData).nextSibling!;
    RenderBox footer = (content.parentData as _ScaffoldParentData).nextSibling!;

    /// Stores `constraints` state/configuration for this implementation.
    final constraints = this.constraints;

    /// Creates a `header.layout` instance.
    header.layout(
      /// Creates a `constraints.copyWith` instance.
      constraints.copyWith(minHeight: 0, maxHeight: double.infinity),
      parentUsesSize: true,
    );

    /// Creates a `footer.layout` instance.
    footer.layout(
      /// Creates a `constraints.copyWith` instance.
      constraints.copyWith(minHeight: 0, maxHeight: double.infinity),
      parentUsesSize: true,
    );

    /// Stores `contentConstraints` state/configuration for this implementation.
    BoxConstraints contentConstraints;

    /// Stores `contentOffset` state/configuration for this implementation.
    Offset contentOffset;

    /// Stores `footerSize` state/configuration for this implementation.
    double footerSize = footer.size.height;

    /// Stores `headerSize` state/configuration for this implementation.
    double headerSize = header.size.height;

    switch ((_floatingHeader, _floatingFooter)) {
      /// Creates a `case` instance.
      case (true, true): // floating header and footer
        contentConstraints = constraints;
        contentOffset = Offset.zero;
        break;

      /// Creates a `case` instance.
      case (true, false): // floating header
        contentConstraints = constraints.deflate(
          /// Creates a `EdgeInsets.only` instance.
          EdgeInsets.only(bottom: footerSize),
        );
        contentOffset = Offset.zero;
        break;

      /// Creates a `case` instance.
      case (false, true): // floating footer
        contentConstraints = constraints.deflate(
          /// Creates a `EdgeInsets.only` instance.
          EdgeInsets.only(top: headerSize),
        );
        contentOffset = Offset(0, headerSize);
        break;

      /// Creates a `case` instance.
      case (false, false):
        contentConstraints = constraints.deflate(
          /// Creates a `EdgeInsets.only` instance.
          EdgeInsets.only(top: headerSize, bottom: footerSize),
        );
        contentOffset = Offset(0, headerSize);
        break;
    }

    /// Creates a `content.layout` instance.
    content.layout(
      /// Creates a `ScaffoldBoxConstraints.fromBoxConstraints` instance.
      ScaffoldBoxConstraints.fromBoxConstraints(
        constraints: contentConstraints,
        headerHeight: headerSize,
        footerHeight: footerSize,
      ),
    );
    size = constraints.biggest;
    (content.parentData as BoxParentData).offset = contentOffset;
    (footer.parentData as BoxParentData).offset = Offset(
      0,
      constraints.biggest.height - footerSize,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _headerSize.value = headerSize;
      _footerSize.value = footerSize;
    });
  }
}
