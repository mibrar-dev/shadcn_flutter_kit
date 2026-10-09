// The `tabs` component: the pill [Tabs] strip and the sortable IDE-style
// [TabPane]. Indexing ([TabContainer]/[TabItem]) and the [TabButton]
// pressable live in `primitives/tab_container.dart`.
//
// Absorbs `tab_container` (byte-identical) and `tab_pane` (reconciled to the
// `tabs` copy); `tab_list` is deleted, its underline look with it — the
// shadcn default is the pill. Arrow keys walk tabs via `roving_group`;
// reorder via `sortable`; overflow fades via `FadeScroll`.

import 'package:flutter/widgets.dart';

import '../../primitives/fade_scroll.dart';
import '../../primitives/roving_group.dart';
import '../../primitives/tab_container.dart';
import '../../theme/theme.dart';
import '../sortable/sortable.dart';
import 'tabs_style.dart';

export '../../primitives/tab_container.dart'
    show TabButton, TabContainer, TabContainerData, TabItem, TabShell;
export 'tabs_style.dart';

/// A shadcn pill tab strip on a muted container.
///
/// Controlled: [index] selects, [onChanged] reports taps and arrow keys;
/// null [onChanged] disables the strip. Arrow keys walk enabled tabs and
/// activate on landing.
class Tabs extends StatefulWidget {
  /// Creates a tab strip.
  const Tabs({
    super.key,
    required this.index,
    required this.children,
    this.onChanged,
    this.expand = false,
    this.theme,
    this.containerTheme,
  });

  final int index;
  final List<TabItem> children;
  final ValueChanged<int>? onChanged;
  final bool expand;
  final TabsTheme? theme;

  /// Container layout defaults; resolved and forwarded to [TabContainer].
  final TabContainerTheme? containerTheme;

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  final RovingGroupRegistry<int> _registry = RovingGroupRegistry<int>();
  final Map<int, FocusNode> _nodes = <int, FocusNode>{};

  @override
  void dispose() {
    for (final node in _nodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ambient = ShadcnTheme.of(context);
    final style = resolveComponentStyle<TabsTheme, TabsTheme>(
      context,
      widget: widget.theme,
      select: (t) => t,
      defaults: tabsDefaults,
    );
    _registry.direction = Axis.horizontal;
    _registry.onSelect = widget.onChanged;
    final container =
        resolveComponentStyle<TabContainerTheme, TabContainerTheme>(
          context,
          widget: widget.containerTheme,
          select: (t) => t,
          defaults: tabContainerDefaults,
        );
    for (final stale
        in _nodes.keys.where((k) => k >= widget.children.length).toList()) {
      _nodes.remove(stale)?.dispose();
    }
    return _registry.scope(
      child: TabContainer(
        selected: widget.index,
        onSelect: widget.onChanged,
        builder:
            container.builder ??
            ((context, tabs) => Container(
              decoration: BoxDecoration(
                color:
                    (style.containerColor ?? tabsDefaults.containerColor!) //
                        .resolve(const <WidgetState>{})!
                        .resolve(ambient.colors),
                borderRadius: style.borderRadius ?? ambient.borderRadiusLg,
              ),
              padding: style.containerPadding ?? tabsDefaults.containerPadding!,
              child: IntrinsicHeight(
                child: Row(
                  mainAxisSize: widget.expand
                      ? MainAxisSize.max
                      : MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: tabs,
                ),
              ),
            )),
        childBuilder: (context, data, child) =>
            _tab(ambient, style, data, child),
        children: widget.children,
      ),
    );
  }

  Widget _tab(
    ShadcnThemeData ambient,
    TabsTheme style,
    TabContainerData data,
    Widget label,
  ) {
    final selected = data.index == data.selected;
    final enabled = data.onSelect != null;
    final node = _nodes.putIfAbsent(
      data.index,
      () => FocusNode(debugLabel: 'Tab'),
    );
    _registry.register(
      RovingItem<int>(
        key: data.index,
        value: data.index,
        enabled: enabled,
        selected: selected,
        requestFocus: node.requestFocus,
      ),
    );
    final base = style.textStyle ?? tabsDefaults.textStyle ?? const TextStyle();
    final labelColor =
        ((selected ? style.selectedLabelColor : style.labelColor) ??
                (selected
                    ? tabsDefaults.selectedLabelColor!
                    : tabsDefaults.labelColor!))
            .resolve(const <WidgetState>{})!
            .resolve(ambient.colors);
    final button = TabButton(
      selected: selected,
      enabled: enabled,
      focusNode: node,
      shortcuts: _registry.shortcuts,
      actions: _registry.actions,
      onPressed: enabled ? () => data.onSelect?.call(data.index) : null,
      child: Container(
        decoration: BoxDecoration(
          color: selected
              ? (style.selectedColor ?? tabsDefaults.selectedColor!) //
                    .resolve(const <WidgetState>{})
                    ?.resolve(ambient.colors)
              : null,
          borderRadius: style.borderRadius ?? ambient.borderRadiusMd,
        ),
        padding: style.tabPadding ?? tabsDefaults.tabPadding!,
        // Pill triggers fill the strip (h-9 = 36, p-[3px]): 30px boxes.
        // Upstream is h-[calc(100%-1px)] (29); the 1px compensates its
        // transparent border, which these borderless pills omit.
        // Horizontal padding only (px-2); the label centers in the box.
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 30, minWidth: 0),
          child: Center(
            child: DefaultTextStyle.merge(
              style: base.copyWith(color: labelColor),
              textAlign: TextAlign.center,
              child: label,
            ),
          ),
        ),
      ),
    );
    return widget.expand ? Expanded(child: button) : button;
  }
}

/// Sortable data backing one [TabPane] tab.
class TabPaneData<T> extends SortableData<T> {
  /// Wraps tab [data] for drag-reorder.
  const TabPaneData(super.data);
}

/// Builds the content of one [TabPane] tab: a plain widget (not a [TabItem],
/// which would read tab data outside the container scope in the drag ghost).
typedef TabPaneItemBuilder<T> =
    Widget Function(BuildContext context, TabPaneData<T> item, int index);

/// An IDE-style tab bar over a content card: sortable tabs, scrollable with
/// edge fades on overflow, dividers between idle tabs.
///
/// Controlled: [focused] selects, [onFocused] reports taps and drop
/// landings. Null [onSort] renders a static bar. Reorder never mutates
/// [items]: the new order is a copy handed to [onSort].
class TabPane<T> extends StatefulWidget {
  /// Creates a tab pane.
  const TabPane({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.focused = 0,
    required this.onFocused,
    this.onSort,
    this.theme,
    this.containerTheme,
    required this.child,
  });

  final List<TabPaneData<T>> items;
  final TabPaneItemBuilder<T> itemBuilder;
  final int focused;
  final ValueChanged<int> onFocused;
  final ValueChanged<List<TabPaneData<T>>>? onSort;
  final TabPaneTheme? theme;

  /// Container layout defaults; resolved and forwarded to [TabContainer].
  final TabContainerTheme? containerTheme;
  final Widget child;

  @override
  State<TabPane<T>> createState() => _TabPaneState<T>();
}

class _TabPaneState<T> extends State<TabPane<T>> {
  final ScrollController _scrolling = ScrollController();
  bool _sorting = false;

  @override
  void dispose() {
    _scrolling.dispose();
    super.dispose();
  }

  void _move(TabPaneData<T> dragged, int target) {
    // [target] is pre-removal coordinates (the tab under the pointer still
    // counts); removing [dragged] shifts everything after it one slot left.
    final List<TabPaneData<T>> items = widget.items;
    final int from = items.indexOf(dragged);
    final List<TabPaneData<T>> next = List<TabPaneData<T>>.of(items)
      ..remove(dragged);
    int at = target;
    if (from >= 0 && from < target) at -= 1;
    next.insert(at.clamp(0, next.length), dragged);
    widget.onSort?.call(next);
    widget.onFocused(next.indexOf(dragged));
  }

  @override
  Widget build(BuildContext context) {
    final ambient = ShadcnTheme.of(context);
    final style = resolveComponentStyle<TabPaneTheme, TabPaneTheme>(
      context,
      widget: widget.theme,
      select: (t) => t,
      defaults: tabPaneDefaults,
    );
    final background = (style.background ?? tabPaneDefaults.background!)
        .resolve(ambient.colors);
    final borderColor = (style.borderColor ?? tabPaneDefaults.borderColor!)
        .resolve(ambient.colors);
    final borderWidth = style.borderWidth ?? tabPaneDefaults.borderWidth ?? 1;
    final radius = style.borderRadius ?? ambient.borderRadiusLg;
    final barHeight = style.barHeight ?? tabPaneDefaults.barHeight ?? 32;
    final spacing = style.tabSpacing ?? tabPaneDefaults.tabSpacing ?? 4;
    final container =
        resolveComponentStyle<TabContainerTheme, TabContainerTheme>(
          context,
          widget: widget.containerTheme,
          select: (t) => t,
          defaults: tabContainerDefaults,
        );
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(
        context,
      ).copyWith(scrollbars: false, overscroll: false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        verticalDirection: VerticalDirection.up,
        children: [
          Flexible(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: background,
                border: Border.all(color: borderColor, width: borderWidth),
                borderRadius: radius,
              ),
              child: widget.child,
            ),
          ),
          SizedBox(
            height: barHeight,
            child: FadeScroll(
              controller: _scrolling,
              endCrossOffset: borderWidth,
              child: SingleChildScrollView(
                controller: _scrolling,
                scrollDirection: Axis.horizontal,
                physics: _sorting ? const NeverScrollableScrollPhysics() : null,
                child: SortableLayer(
                  lock: true,
                  child: TabContainer(
                    selected: widget.focused,
                    onSelect: widget.onFocused,
                    builder:
                        container.builder ??
                        ((context, tabs) => Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: _separated(tabs, spacing, borderColor),
                        )),
                    childBuilder: (context, data, child) => TabShell(
                      focused: data.index == data.selected,
                      background: background,
                      borderColor: borderColor,
                      borderWidth: borderWidth,
                      radius: radius,
                      child: child,
                    ),
                    children: [
                      for (int i = 0; i < widget.items.length; i++) _tab(i),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// One sortable tab: tap selects, pan reorders ([itemBuilder] content
  /// renders inside the indexing [TabItem] so the shell paints once).
  TabItem _tab(int i) {
    final TabPaneData<T> item = widget.items[i];
    return TabItem(
      child: Sortable<T>(
        key: ValueKey<int>(i),
        data: item,
        enabled: widget.onSort != null,
        onDragStart: () {
          widget.onFocused(i);
          setState(() => _sorting = true);
        },
        onDragEnd: () => setState(() => _sorting = false),
        onDragCancel: () => setState(() => _sorting = false),
        onAcceptLeft: (SortableData<T> dragged) {
          if (dragged is TabPaneData<T>) _move(dragged, i);
        },
        onAcceptRight: (SortableData<T> dragged) {
          if (dragged is TabPaneData<T>) _move(dragged, i + 1);
        },
        child: Builder(
          builder: (BuildContext context) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => widget.onFocused(i),
            child: widget.itemBuilder(context, item, i),
          ),
        ),
      ),
    );
  }

  List<Widget> _separated(
    List<Widget> tabs,
    double spacing,
    Color borderColor,
  ) {
    final out = <Widget>[];
    for (int i = 0; i < tabs.length; i++) {
      if (i > 0) {
        // 1px token dividers between idle tabs (no Material divider);
        // neighbours of the focused tab just breathe.
        final nearFocus = widget.focused == i || widget.focused == i - 1;
        out.add(
          nearFocus
              ? SizedBox(width: spacing)
              : Container(
                  width: 1,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: borderColor,
                ),
        );
        if (!nearFocus) out.add(SizedBox(width: spacing));
      }
      out.add(tabs[i]);
    }
    return out;
  }
}
