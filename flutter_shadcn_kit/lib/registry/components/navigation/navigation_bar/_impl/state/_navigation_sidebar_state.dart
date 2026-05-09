// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../navigation_bar.dart';

/// _NavigationSidebarState defines a reusable type for this registry module.
class _NavigationSidebarState extends State<NavigationSidebar>
    with NavigationContainerMixin {
  /// Executes `getDefaultConstraints` behavior for this component/composite.
  BoxConstraints getDefaultConstraints(BuildContext context, ThemeData theme) {
    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    return BoxConstraints(
      minWidth: (200 * scaling).toDouble(),
      maxWidth: (200 * scaling).toDouble(),
    );
  }

  /// Executes `_childPadding` behavior for this component/composite.
  EdgeInsets _childPadding(EdgeInsets padding, Axis direction) {
    if (direction == Axis.vertical) {
      return EdgeInsets.only(left: padding.left, right: padding.right);
    }
    return EdgeInsets.only(top: padding.top, bottom: padding.bottom);
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
    List<Widget> children = wrapChildren(context, widget.children);
    var parentPadding =
        widget.padding ??
        (EdgeInsets.symmetric(
          vertical: theme.density.baseGap * scaling,
          horizontal: theme.density.baseContentPadding * scaling * 0.75,
        ));
    var directionality = Directionality.of(context);
    var resolvedPadding = parentPadding.resolve(directionality);

    /// Stores `direction` state/configuration for this implementation.
    const direction = Axis.vertical;
    return Data.inherit(
      data: NavigationControlData(
        containerType: NavigationContainerType.sidebar,
        parentLabelType: widget.labelType,
        parentLabelPosition: widget.labelPosition,
        parentLabelSize: widget.labelSize,
        parentPadding: resolvedPadding,
        direction: direction,
        onSelected: _onSelected,
        selectedIndex: widget.index,
        expanded: widget.expanded,
        childCount: children.length,
        spacing: widget.spacing ?? 0,
        keepCrossAxisSize: widget.keepCrossAxisSize,
        keepMainAxisSize: widget.keepMainAxisSize,
      ),
      child: ConstrainedBox(
        constraints:
            widget.constraints ?? getDefaultConstraints(context, theme),
        child: SurfaceBlur(
          surfaceBlur: widget.surfaceBlur,
          child: Container(
            color: widget.backgroundColor,
            child: ClipRect(
              child: RepaintBoundary(
                child: CustomScrollView(
                  clipBehavior: Clip.none,
                  shrinkWrap: true,
                  scrollDirection: direction,
                  slivers: [
                    /// Creates a `SliverGap` instance.
                    SliverGap(_startPadding(resolvedPadding, direction)),
                    ...children
                        .map((e) {
                          return SliverPadding(
                                padding: _childPadding(
                                  resolvedPadding,
                                  direction,
                                ),
                                sliver: e,
                              )
                              /// Stores `Widget` state/configuration for this implementation.
                              as Widget;
                        })
                        .toList()
                        .joinSeparator(SliverGap(widget.spacing ?? 0)),

                    /// Creates a `SliverGap` instance.
                    SliverGap(_endPadding(resolvedPadding, direction)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
