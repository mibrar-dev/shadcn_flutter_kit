// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../navigation_bar.dart';

/// _NavigationRailState defines a reusable type for this registry module.
class _NavigationRailState extends State<NavigationRail>
    with NavigationContainerMixin {
  AlignmentGeometry get _alignment {
    switch ((widget.alignment, widget.direction)) {
      /// Creates a `case` instance.
      case (NavigationRailAlignment.start, Axis.horizontal):
        return AlignmentDirectional.centerStart;

      /// Creates a `case` instance.
      case (NavigationRailAlignment.center, Axis.horizontal):
        return AlignmentDirectional.topCenter;

      /// Creates a `case` instance.
      case (NavigationRailAlignment.end, Axis.horizontal):
        return AlignmentDirectional.centerEnd;

      /// Creates a `case` instance.
      case (NavigationRailAlignment.start, Axis.vertical):
        return AlignmentDirectional.topCenter;

      /// Creates a `case` instance.
      case (NavigationRailAlignment.center, Axis.vertical):
        return AlignmentDirectional.center;

      /// Creates a `case` instance.
      case (NavigationRailAlignment.end, Axis.vertical):
        return AlignmentDirectional.bottomCenter;
    }
  }

  /// Executes `_onSelected` behavior for this component/composite.
  void _onSelected(int index) {
    widget.onSelected?.call(index);
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    var parentPadding =
        widget.padding ??
        (EdgeInsets.symmetric(
          vertical: theme.density.baseGap * scaling,
          horizontal: theme.density.baseContentPadding * scaling * 0.75,
        ));
    var directionality = Directionality.of(context);
    var resolvedPadding = parentPadding.resolve(directionality);
    return RepaintBoundary(
      child: Data.inherit(
        data: NavigationControlData(
          containerType: NavigationContainerType.rail,
          parentLabelType: widget.labelType,
          parentLabelPosition: widget.labelPosition,
          parentLabelSize: widget.labelSize,
          parentPadding: resolvedPadding,
          direction: widget.direction,
          selectedIndex: widget.index,
          onSelected: _onSelected,
          expanded: widget.expanded,
          childCount: widget.children.length,
          spacing: widget.spacing ?? (theme.density.baseGap * scaling),
          keepCrossAxisSize: widget.keepCrossAxisSize,
          keepMainAxisSize: widget.keepMainAxisSize,
        ),
        child: SurfaceBlur(
          surfaceBlur: widget.surfaceBlur,
          child: Container(
            color:
                widget.backgroundColor ??
                (theme.colorScheme.background.scaleAlpha(
                  widget.surfaceOpacity ?? 1,
                )),
            alignment: _alignment,
            child: SingleChildScrollView(
              scrollDirection: widget.direction,
              padding: resolvedPadding,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return _wrapIntrinsic(
                    /// Creates a `Flex` instance.
                    Flex(
                      direction: widget.direction,
                      crossAxisAlignment: _crossAxisAlignment(
                        constraints,
                        widget.direction,
                      ),
                      children: wrapChildren(context, widget.children),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Executes `_crossAxisAlignment` behavior for this component/composite.
  CrossAxisAlignment _crossAxisAlignment(
    BoxConstraints constraints,
    Axis direction,
  ) {
    final canStretch = direction == Axis.horizontal
        ? constraints.hasBoundedHeight
        : constraints.hasBoundedWidth;
    if (!canStretch) {
      return CrossAxisAlignment.center;
    }
    return CrossAxisAlignment.stretch;
  }

  /// Executes `_wrapIntrinsic` behavior for this component/composite.
  Widget _wrapIntrinsic(Widget child) {
    if (widget.direction == Axis.horizontal) {
      return IntrinsicHeight(child: child);
    }
    return IntrinsicWidth(child: child);
  }
}
