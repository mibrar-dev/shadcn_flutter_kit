// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tab_pane.dart';

/// TabPaneState defines a reusable type for this registry module.
class TabPaneState<T> extends State<TabPane<T>> {
  final ScrollController _scrollController = ScrollController();

  /// Drag gesture identifier for tab interactions.
  static const kTabDrag = #tabDrag;

  Widget _childBuilder(
    BuildContext context,
    TabContainerData data,
    Widget child,
  ) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<TabPaneTheme>(context);

    /// Stores `isFocused` state/configuration for this implementation.
    final isFocused = data.index == data.selected;
    final backgroundColor =
        widget.backgroundColor ??
        compTheme?.backgroundColor ??
        theme.colorScheme.card;

    /// Stores `border` state/configuration for this implementation.
    final border = widget.border ?? compTheme?.border;

    /// Stores `borderColor` state/configuration for this implementation.
    final borderColor = border?.color ?? theme.colorScheme.border;

    /// Stores `borderWidth` state/configuration for this implementation.
    final borderWidth = border?.width ?? 1;
    final borderRadius =
        (widget.borderRadius ?? compTheme?.borderRadius ?? theme.borderRadiusLg)
            .optionallyResolve(context);
    return Builder(
      builder: (context) {
        var tabGhost = Data.maybeOf<_TabGhostData>(context);
        return SizedBox(
          height: double.infinity,
          child: CustomPaint(
            painter: _TabItemPainter(
              borderRadius: borderRadius,
              backgroundColor: backgroundColor,
              isFocused: isFocused || tabGhost != null,
              borderColor: borderColor,
              borderWidth: borderWidth,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: theme.density.baseGap * theme.scaling,
              ),
              child: IntrinsicWidth(child: child),
            ),
          ),
        );
      },
    );
  }

  /// Executes `_buildTabItems` behavior for this component/composite.
  List<TabChild> _buildTabItems() {
    /// Stores `children` state/configuration for this implementation.
    List<TabChild> children = [];
    for (int i = 0; i < widget.items.length; i++) {
      children.add(widget.itemBuilder(context, widget.items[i], i));
    }
    return children;
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<TabPaneTheme>(context);
    final BorderRadiusGeometry borderRadius =
        widget.borderRadius ?? compTheme?.borderRadius ?? theme.borderRadiusLg;
    final BorderRadius resolvedBorderRadius = borderRadius.optionallyResolve(
      context,
    );
    final backgroundColor =
        widget.backgroundColor ??
        compTheme?.backgroundColor ??
        theme.colorScheme.card;

    /// Stores `border` state/configuration for this implementation.
    final border = widget.border ?? compTheme?.border;
    final barHeight =
        widget.barHeight ?? compTheme?.barHeight ?? (32 * theme.scaling);
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(
        context,
      ).copyWith(scrollbars: false, overscroll: false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        verticalDirection: VerticalDirection.up,
        children: [
          /// Creates a `Flexible` instance.
          Flexible(
            child: OutlinedContainer(
              borderRadius: resolvedBorderRadius,
              backgroundColor: backgroundColor,
              child: widget.child,
            ),
          ),

          /// Creates a `Container` instance.
          Container(
            height: barHeight,
            padding: EdgeInsets.only(
              left: resolvedBorderRadius.bottomLeft.x,
              right: resolvedBorderRadius.bottomRight.x,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// Creates a `Padding` instance.
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: theme.density.baseGap * theme.scaling * 0.25,
                  ),
                  child: Row(
                    spacing: theme.density.baseGap * theme.scaling * 0.25,
                    children: widget.leading,
                  ),
                ),

                /// Creates a `Flexible` instance.
                Flexible(
                  child: FadeScroll(
                    startOffset: resolvedBorderRadius.bottomLeft.x,
                    endOffset: resolvedBorderRadius.bottomRight.x,
                    gradient: [Colors.white.withAlpha(0)],
                    endCrossOffset: border?.width ?? 1,
                    controller: _scrollController,
                    child: ClipRect(
                      clipper: _ClipRectWithAdjustment(border?.width ?? 1),
                      child: SortableLayer(
                        clipBehavior: Clip.none,
                        lock: true,
                        child: SortableDropFallback<T>(
                          onAccept: (value) {
                            if (value is! TabPaneData<T>) {
                              return;
                            }

                            /// Stores `wasFocused` state/configuration for this implementation.
                            bool wasFocused = widget.focused == value.data;

                            /// Stores `tabs` state/configuration for this implementation.
                            List<TabPaneData<T>> tabs = widget.items;
                            tabs.swapItem(value, tabs.length);
                            widget.onSort?.call(tabs);
                            if (wasFocused) {
                              widget.onFocused(tabs.length - 1);
                            }
                          },
                          child: ScrollableSortableLayer(
                            controller: _scrollController,
                            child: TabContainer(
                              selected: widget.focused,
                              onSelect: widget.onFocused,
                              builder: (context, children) {
                                return ListView.separated(
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  clipBehavior: Clip.none,
                                  padding: EdgeInsets.only(
                                    left: resolvedBorderRadius.bottomLeft.x,
                                    right: resolvedBorderRadius.bottomRight.x,
                                  ),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        widget.onFocused(index);
                                      },
                                      child: Sortable<T>(
                                        key: ValueKey(index),
                                        data: widget.items[index],
                                        enabled: widget.onSort != null,
                                        onDragStart: () {
                                          widget.onFocused(index);
                                        },
                                        onAcceptLeft: (value) {
                                          if (value is! TabPaneData<T>) {
                                            return;
                                          }
                                          List<TabPaneData<T>> tabs =
                                              widget.items;
                                          tabs.swapItem(value, index);
                                          widget.onSort?.call(tabs);
                                          widget.onFocused(index);
                                        },
                                        onAcceptRight: (value) {
                                          if (value is! TabPaneData<T>) {
                                            return;
                                          }
                                          List<TabPaneData<T>> tabs =
                                              widget.items;
                                          tabs.swapItem(value, index + 1);
                                          widget.onSort?.call(tabs);
                                          widget.onFocused(index);
                                        },
                                        ghost: Data.inherit(
                                          data: _TabGhostData(),
                                          child: children[index],
                                        ),
                                        child: children[index],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    bool beforeIsFocused =
                                        widget.focused == index;
                                    bool afterIsFocused =
                                        widget.focused == index + 1;
                                    if (!beforeIsFocused && !afterIsFocused) {
                                      return VerticalDivider(
                                        indent:
                                            theme.density.baseGap *
                                            theme.scaling,
                                        endIndent: 8 * theme.scaling,
                                        width: 8 * theme.scaling,
                                      );
                                    }
                                    return SizedBox(
                                      width:
                                          theme.density.baseGap * theme.scaling,
                                    );
                                  },
                                  itemCount: children.length,
                                );
                              },
                              childBuilder: _childBuilder,
                              children: _buildTabItems(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                /// Creates a `Padding` instance.
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: theme.density.baseGap * theme.scaling * 0.25,
                  ),
                  child: Row(
                    spacing: theme.density.baseGap * theme.scaling * 0.25,
                    children: widget.trailing,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
