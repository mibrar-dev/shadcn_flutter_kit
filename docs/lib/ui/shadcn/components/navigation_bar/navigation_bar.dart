// The `navigation_bar` component: [NavigationBar] (bar, rail and sidebar in
// one widget).
//
// Ported from `components/navigation/navigation_bar/**` (35 files). The
// `material.dart` import is gone; `Data.maybeOf`/`Data.inherit` map to the
// foundation `Data` API; the item widgets and their theme slice live in
// `primitives/navigation` (P4-B22, Q7) and are re-exported here.
//
// Clean break: `NavigationRail`/`NavigationSidebar` are
// `NavigationBar(container: ...)`, `NavigationButton` is
// `NavigationItem(onPressed:)`, and `NavigationSlot`, `NavigationGap`,
// `NavigationWidget`, the key-selection API, surface blur and the size-keeping
// flags are dropped.

import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../foundation/platform.dart';
import '../../primitives/navigation/navigation_items.dart';
import '../../primitives/roving_group.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../overflow_marquee/overflow_marquee.dart';
import '../tooltip/tooltip.dart';
import 'navigation_bar_style.dart';

export 'navigation_bar_style.dart';
export '../../primitives/navigation/navigation_item_row.dart'
    show NavigationItemRow;
export '../../primitives/navigation/navigation_items.dart'
    show
        NavigationBarItem,
        NavigationChildData,
        NavigationCollapsible,
        NavigationControlData,
        NavigationItem,
        NavigationSlot,
        navigationCollapsibleChildrenKey;
export '../../primitives/navigation/navigation_sections.dart'
    show NavigationDivider, NavigationGap, NavigationGroup, NavigationLabel;

/// A navigation container: horizontal bar, compact rail or sidebar.
class NavigationBar extends StatefulWidget {
  /// Creates a navigation container.
  const NavigationBar({
    super.key,
    required this.children,
    this.container = NavigationContainerType.bar,
    this.direction,
    this.alignment,
    this.spacing,
    this.labelType,
    this.labelPosition,
    this.labelSize,
    this.padding,
    this.constraints,
    this.index,
    this.onSelected,
    this.backgroundColor,
    this.expanded = true,
    this.header = const <Widget>[],
    this.footer = const <Widget>[],
    this.theme,
  });

  /// The navigation items.
  final List<NavigationBarItem> children;
  final NavigationContainerType container;
  final Axis? direction;
  final MainAxisAlignment? alignment;
  final double? spacing;
  final NavigationLabelType? labelType;
  final NavigationLabelPosition? labelPosition;
  final NavigationLabelSize? labelSize;
  final EdgeInsetsGeometry? padding;
  final BoxConstraints? constraints;

  /// Selected item index.
  final int? index;

  /// Called with the selected item's index.
  final ValueChanged<int>? onSelected;
  final ThemedColor? backgroundColor;

  /// Whether labels follow the expanded state (`NavigationLabelType.expanded`).
  final bool expanded;
  final List<Widget> header;
  final List<Widget> footer;
  final NavigationBarTheme? theme;

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  final RovingGroupRegistry<int> _roving = RovingGroupRegistry<int>();

  void _select(int index) => widget.onSelected?.call(index);

  @override
  void initState() {
    super.initState();
    _roving.onSelect = _select;
  }

  List<Widget> _wrapChildren() {
    var index = 0;
    final List<Widget> out = <Widget>[];
    for (var i = 0; i < widget.children.length; i++) {
      final NavigationBarItem child = widget.children[i];
      out.add(
        Data<NavigationChildData>.inherit(
          data: (index: child.selectable ? index++ : null, actualIndex: i),
          child: child,
        ),
      );
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final NavigationBarTheme style =
        resolveComponentStyle<NavigationBarTheme, NavigationBarTheme>(
          context,
          widget: widget.theme,
          select: (NavigationBarTheme t) => t,
          defaults: navigationBarDefaults,
        );
    final NavigationContainerType container = widget.container;
    final Axis direction =
        widget.direction ??
        style.direction ??
        (container == NavigationContainerType.bar
            ? Axis.horizontal
            : Axis.vertical);
    final MainAxisAlignment alignment =
        widget.alignment ?? style.alignment ?? MainAxisAlignment.center;
    final NavigationLabelType labelType =
        widget.labelType ??
        style.labelType ??
        (container == NavigationContainerType.sidebar
            ? NavigationLabelType.expanded
            : NavigationLabelType.none);
    final NavigationControlData data = (
      container: container,
      direction: direction,
      labelType: labelType,
      labelPosition:
          widget.labelPosition ??
          style.labelPosition ??
          NavigationLabelPosition.bottom,
      labelSize:
          widget.labelSize ?? style.labelSize ?? NavigationLabelSize.small,
      selectedIndex: widget.index,
      onSelected: _select,
      expanded: widget.expanded,
      itemStyle: style.itemStyle ?? navigationItemDefaults,
      activeItemStyle: style.activeItemStyle ?? navigationActiveItemDefaults,
      tooltipWrapper: (Widget child, Widget label) => Tooltip(
        waitDuration: isMobile(ambient.platform)
            ? kTooltipWaitDuration
            : Duration.zero,
        tooltip: (BuildContext context) => label,
        child: child,
      ),
      marqueeWrapper: (Widget label) => OverflowMarquee(child: label),
    );
    final EdgeInsetsGeometry padding =
        widget.padding ??
        style.padding ??
        const EdgeInsets.symmetric(vertical: 8, horizontal: 12);
    _roving.direction = direction;
    final Widget body = _body(
      ambient,
      container,
      direction,
      alignment,
      padding,
      _wrapChildren(),
    );
    return RepaintBoundary(
      child: Data<NavigationControlData>.inherit(
        data: data,
        child: _roving.scope(child: _surface(ambient, style, container, body)),
      ),
    );
  }

  Widget _body(
    ShadcnThemeData ambient,
    NavigationContainerType container,
    Axis direction,
    MainAxisAlignment alignment,
    EdgeInsetsGeometry padding,
    List<Widget> children,
  ) {
    Widget content = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool stretch = direction == Axis.horizontal
            ? constraints.hasTightHeight
            : constraints.hasTightWidth;
        return Flex(
          direction: direction,
          mainAxisAlignment: container == NavigationContainerType.bar
              ? alignment
              : MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: stretch
              ? CrossAxisAlignment.stretch
              : CrossAxisAlignment.center,
          children: children,
        );
      },
    );
    if (container == NavigationContainerType.bar) {
      return Padding(padding: padding, child: content);
    }
    content = SingleChildScrollView(
      scrollDirection: direction,
      padding: padding,
      child: content,
    );
    if (widget.header.isNotEmpty || widget.footer.isNotEmpty) {
      content = Flex(
        direction: direction,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ...widget.header,
          Expanded(child: content),
          ...widget.footer,
        ],
      );
    }
    final BoxConstraints? constraints =
        widget.constraints ??
        (container == NavigationContainerType.sidebar
            ? BoxConstraints(
                minWidth: 200 * ambient.scaling,
                maxWidth: 200 * ambient.scaling,
              )
            : null);
    return constraints == null
        ? content
        : ConstrainedBox(constraints: constraints, child: content);
  }

  Widget _surface(
    ShadcnThemeData ambient,
    NavigationBarTheme style,
    NavigationContainerType container,
    Widget child,
  ) {
    final Color? background =
        (widget.backgroundColor ?? style.backgroundColor)?.resolve(
          ambient.colors,
        ) ??
        (container == NavigationContainerType.sidebar
            ? null
            : ambient.colors.background);
    return background == null
        ? child
        : ColoredBox(color: background, child: child);
  }
}
