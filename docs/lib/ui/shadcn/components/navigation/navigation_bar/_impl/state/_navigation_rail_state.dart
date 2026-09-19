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
          selectedKey: widget.selectedKey,
          onSelected: _onSelected,
          onSelectedKey: _onSelectedKey,
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
            child: _buildBody(context, resolvedPadding, scaling),
          ),
        ),
      ),
    );
  }

  /// Builds the rail body with optional fixed header/footer sections
  /// (upstream parity). Without header/footer, keeps the legacy single
  /// scrollable layout.
  Widget _buildBody(
    BuildContext context,
    EdgeInsets resolvedPadding,
    double scaling,
  ) {
    final hasSections =
        (widget.header?.isNotEmpty ?? false) ||
        (widget.footer?.isNotEmpty ?? false);
    Widget scrollable = SingleChildScrollView(
      scrollDirection: widget.direction,
      padding: resolvedPadding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return _wrapIntrinsic(
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
    );
    Widget body;
    if (!hasSections) {
      body = scrollable;
    } else {
      final headerItems = widget.header ?? const <Widget>[];
      final footerItems = widget.footer ?? const <Widget>[];
      body = Flex(
        direction: widget.direction,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (headerItems.isNotEmpty)
            Flex(
              direction: widget.direction,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: headerItems,
            ),
          Expanded(child: scrollable),
          if (footerItems.isNotEmpty)
            Flex(
              direction: widget.direction,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: footerItems,
            ),
        ],
      );
    }
    if (widget.constraints != null) {
      body = ConstrainedBox(constraints: widget.constraints!, child: body);
    }
    if (widget.expandedSize != null || widget.collapsedSize != null) {
      final targetMinSize = widget.expanded
          ? (widget.expandedSize ?? 0.0)
          : (widget.collapsedSize ?? 0.0);
      final maxSize = widget.expandedSize ?? double.infinity;
      final direction = widget.direction;
      body = AnimatedValueBuilder<double>(
        value: targetMinSize,
        duration: kDefaultDuration,
        builder: (context, animatedMinSize, child) {
          final minSize = animatedMinSize;
          return ConstrainedBox(
            constraints: direction == Axis.vertical
                ? BoxConstraints(minWidth: minSize, maxWidth: maxSize)
                : BoxConstraints(minHeight: minSize, maxHeight: maxSize),
            child: child,
          );
        },
        child: body,
      );
    }
    return body;
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
