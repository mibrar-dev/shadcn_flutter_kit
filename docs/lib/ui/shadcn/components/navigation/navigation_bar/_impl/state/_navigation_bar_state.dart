// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../navigation_bar.dart';

/// _NavigationBarState defines a reusable type for this registry module.
class _NavigationBarState extends State<NavigationBar>
    with NavigationContainerMixin {
  /// Executes `_onSelected` behavior for this component/composite.
  void _onSelected(int index) {
    widget.onSelected?.call(index);
    final key = _keyForIndex(index);
    if (key != null) widget.onSelectedKey?.call(key);
  }

  /// Key-based selection notify (upstream parity).
  ///
  /// Forwards to [NavigationBar.onSelectedKey] and, when the key resolves
  /// to a child index, also invokes [NavigationBar.onSelected] as compat.
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
  /// Executes `didUpdateWidget` behavior for this component/composite.
  void didUpdateWidget(covariant NavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    final compTheme = widget.theme ?? ComponentTheme.maybeOf<NavigationBarTheme>(context);
    final alignment = styleValue(
      widgetValue: widget.alignment,
      themeValue: compTheme?.alignment,
      defaultValue: NavigationBarAlignment.center,
    );
    final direction = styleValue(
      widgetValue: widget.direction,
      themeValue: compTheme?.direction,
      defaultValue: Axis.horizontal,
    );
    final spacing = styleValue<double>(
      widgetValue: widget.spacing,
      themeValue: compTheme?.spacing,
      defaultValue: 8 * scaling,
    );
    final labelType = styleValue(
      widgetValue: widget.labelType,
      themeValue: compTheme?.labelType,
      defaultValue: NavigationLabelType.none,
    );
    final labelPosition = styleValue(
      widgetValue: widget.labelPosition,
      themeValue: compTheme?.labelPosition,
      defaultValue: NavigationLabelPosition.bottom,
    );
    final labelSize = styleValue(
      widgetValue: widget.labelSize,
      themeValue: compTheme?.labelSize,
      defaultValue: NavigationLabelSize.small,
    );
    final parentPadding = styleValue(
      widgetValue: widget.padding,
      themeValue: compTheme?.padding,
      defaultValue: EdgeInsets.symmetric(
        vertical: theme.density.baseGap * scaling,
        horizontal: theme.density.baseContentPadding * scaling * 0.75,
      ),
    );
    final backgroundColor = styleValue<Color?>(
      widgetValue: widget.backgroundColor,
      themeValue: compTheme?.backgroundColor,
      defaultValue: null,
    );

    /// Stores `expands` state/configuration for this implementation.
    final expands = widget.expands ?? true;

    /// Stores `expanded` state/configuration for this implementation.
    final expanded = widget.expanded ?? true;
    var directionality = Directionality.of(context);
    var resolvedPadding = parentPadding.resolve(directionality);
    List<Widget> rawChildren = wrapChildren(context, widget.children);

    /// Stores `children` state/configuration for this implementation.
    List<Widget> children = [];
    if (!expands) {
      children = List.of(rawChildren);
    } else {
      if (alignment == NavigationBarAlignment.spaceEvenly) {
        children.add(const Spacer());
        for (var i = 0; i < rawChildren.length; i++) {
          children.add(Expanded(child: rawChildren[i]));
        }
        children.add(const Spacer());
      } else if (alignment == NavigationBarAlignment.spaceAround) {
        children.add(const Spacer());
        for (var i = 0; i < rawChildren.length; i++) {
          children.add(Expanded(flex: 2, child: rawChildren[i]));
        }
        children.add(const Spacer());
      } else if (alignment == NavigationBarAlignment.spaceBetween) {
        for (var i = 0; i < rawChildren.length; i++) {
          if (i > 0) {
            children.add(const Spacer());
          }
          children.add(Expanded(flex: 2, child: rawChildren[i]));
        }
      } else {
        for (var i = 0; i < rawChildren.length; i++) {
          children.add(Expanded(child: rawChildren[i]));
        }
      }
    }
    Widget result = SurfaceBlur(
      surfaceBlur: widget.surfaceBlur,
      child: RepaintBoundary(
        child: Data.inherit(
          data: NavigationControlData(
            containerType: NavigationContainerType.bar,
            parentLabelType: labelType,
            parentLabelSize: labelSize,
            parentPadding: resolvedPadding,
            direction: direction,
            selectedIndex: widget.index,
            selectedKey: widget.selectedKey,
            onSelected: _onSelected,
            onSelectedKey: _onSelectedKey,
            parentLabelPosition: labelPosition,
            expanded: expanded,
            childCount: children.length,
            spacing: spacing,
            keepCrossAxisSize: widget.keepCrossAxisSize ?? false,
            keepMainAxisSize: widget.keepMainAxisSize ?? false,
          ),
            child: Container(
            color:
                backgroundColor ??
                theme.colorScheme.background.scaleAlpha(
                  widget.surfaceOpacity ?? 1,
                ),
            padding: resolvedPadding,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return _wrapIntrinsic(
                  /// Creates a `Flex` instance.
                  Flex(
                    direction: direction,
                    mainAxisAlignment: alignment.mainAxisAlignment,
                    crossAxisAlignment: _crossAxisAlignment(
                      constraints,
                      direction,
                    ),
                    children: children,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
    if (widget.expandedSize != null || widget.collapsedSize != null) {
      final targetMinSize = expanded
          ? (widget.expandedSize ?? 0.0)
          : (widget.collapsedSize ?? 0.0);
      final maxSize = widget.expandedSize ?? double.infinity;
      result = AnimatedValueBuilder<double>(
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
        child: result,
      );
    }
    return result;
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
