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
    final key = _keyForIndex(index);
    if (key != null) widget.onSelectedKey?.call(key);
  }

  /// Key-based selection notify (upstream parity).
  void _onSelectedKey(Key? key) {
    widget.onSelectedKey?.call(key);
    final index = _indexForKey(key);
    if (index != null) widget.onSelected?.call(index);
  }

  /// Resolves a child key for an index (compat bridge).
  Key? _keyForIndex(int index) {
    final items = widget.children;
    if (index < 0 || index >= items.length) return null;
    return items[index].key;
  }

  /// Resolves a child index for a key (compat bridge).
  int? _indexForKey(Key? key) {
    if (key == null) return null;
    for (var i = 0; i < widget.children.length; i++) {
      if (widget.children[i].key == key) return i;
    }
    return null;
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    List<Widget> children = wrapChildren(context, widget.children);
    final headerChildren = widget.header ?? const <Widget>[];
    final footerChildren = widget.footer ?? const <Widget>[];
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
        onSelectedKey: _onSelectedKey,
        selectedIndex: widget.index,
        selectedKey: widget.selectedKey,
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
                    if (headerChildren.isNotEmpty)
                      ...headerChildren.map(
                        (e) => SliverToBoxAdapter(child: e) as Widget,
                      ),
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
                    if (footerChildren.isNotEmpty)
                      ...footerChildren.map(
                        (e) => SliverToBoxAdapter(child: e) as Widget,
                      ),
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
