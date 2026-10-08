// The `resizable` component: split panes with draggable dividers. Ported from
// `components/layout/resizable`; the pane model and the interactive handle
// live in `primitives/resizable_pane.dart` and `primitives/resizable_handle.dart`.

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../foundation/resizable_item.dart';
import '../../foundation/resizer.dart';
import '../../primitives/localizations/localizations.dart';
import '../../primitives/resizable_handle.dart';
import '../../primitives/resizable_pane.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'resizable_style.dart';

export '../../primitives/resizable_handle.dart';
export '../../primitives/resizable_pane.dart';
export 'resizable_style.dart';

/// Configuration for one pane inside a [ResizablePanelGroup].
class ResizablePanel extends StatelessWidget {
  const ResizablePanel({
    super.key,
    required this.child,
    this.defaultSize,
    this.flex,
    this.minSize,
    this.maxSize,
    this.collapsedSize,
    this.collapsed = false,
    this.controller,
  });

  final Widget child;

  final double? defaultSize;

  final double? flex;

  final double? minSize;

  final double? maxSize;

  final double? collapsedSize;

  final bool collapsed;

  final ResizablePaneController? controller;

  @override
  Widget build(BuildContext context) => ClipRect(child: child);
}

/// A container of [ResizablePanel]s separated by [ResizableHandle]s.
class ResizablePanelGroup extends StatefulWidget {
  const ResizablePanelGroup({
    super.key,
    this.direction = Axis.horizontal,
    required this.children,
    this.theme,
  });

  final Axis direction;

  final List<Widget> children;

  final ResizableTheme? theme;

  @override
  State<ResizablePanelGroup> createState() => _ResizablePanelGroupState();
}

class _ResizablePanelGroupState extends State<ResizablePanelGroup> {
  final List<_PaneEntry> _panes = <_PaneEntry>[];
  final Set<int> _hovered = <int>{};
  final Set<int> _dragging = <int>{};
  double _flexSpace = 0;
  double _mainMax = 0;
  Resizer? _session;

  @override
  void initState() {
    super.initState();
    _syncPanes();
  }

  @override
  void didUpdateWidget(ResizablePanelGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncPanes();
  }

  @override
  void dispose() {
    for (final _PaneEntry entry in _panes) {
      entry.controller.removeListener(_onControllerChanged);
      if (entry.owns) {
        entry.controller.dispose();
      }
    }
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  _PaneEntry _createEntry(ResizablePanel pane) {
    final ResizablePaneController controller =
        pane.controller ??
        ResizablePaneController(
          size: pane.defaultSize,
          flex: pane.defaultSize != null ? null : (pane.flex ?? 1),
          collapsed: pane.collapsed,
        );
    controller.addListener(_onControllerChanged);
    return _PaneEntry(
      pane: pane,
      controller: controller,
      owns: pane.controller == null,
    );
  }

  void _syncPanes() {
    final List<ResizablePanel> panes = widget.children
        .whereType<ResizablePanel>()
        .toList();
    final List<_PaneEntry> next = <_PaneEntry>[];
    for (int i = 0; i < panes.length; i++) {
      final ResizablePanel pane = panes[i];
      final _PaneEntry? entry = i < _panes.length ? _panes[i] : null;
      final bool reuse =
          entry != null &&
          (pane.controller != null
              ? identical(entry.controller, pane.controller)
              : entry.owns);
      if (reuse) {
        entry.pane = pane;
        next.add(entry);
      } else {
        if (entry != null) {
          entry.controller.removeListener(_onControllerChanged);
          if (entry.owns) {
            entry.controller.dispose();
          }
        }
        next.add(_createEntry(pane));
      }
    }
    for (int i = panes.length; i < _panes.length; i++) {
      final _PaneEntry entry = _panes[i];
      entry.controller.removeListener(_onControllerChanged);
      if (entry.owns) {
        entry.controller.dispose();
      }
    }
    _panes
      ..clear()
      ..addAll(next);
  }

  @override
  Widget build(BuildContext context) {
    final ResizableTheme theme =
        resolveComponentStyle<ResizableTheme, ResizableTheme>(
          context,
          widget: widget.theme,
          select: (ResizableTheme t) => t,
          defaults: resizableDefaults,
        );
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    final String handleLabel = ShadcnLocalizations.of(context).resizableHandle;
    final bool horizontal = widget.direction == Axis.horizontal;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double mainMax = horizontal
            ? constraints.maxWidth
            : constraints.maxHeight;
        _mainMax = mainMax;
        double dividerTotal = 0;
        for (final ResizableHandle handle
            in widget.children.whereType<ResizableHandle>()) {
          dividerTotal += handle.thickness ?? theme.handleThickness ?? 1;
        }
        double fixed = 0;
        double flexSum = 0;
        for (final _PaneEntry entry in _panes) {
          if (entry.controller.isFlexible) {
            flexSum += entry.controller.value;
          } else {
            fixed += _paneSize(entry, mainMax);
          }
        }
        _flexSpace = flexSum > 0
            ? math.max(0, (mainMax - fixed - dividerTotal) / flexSum)
            : 0;

        final List<double> extents = <double>[
          for (final _PaneEntry entry in _panes) _paneSize(entry, mainMax),
        ];
        final List<Widget> flexChildren = <Widget>[];
        final List<Widget> draggers = <Widget>[];
        int paneIndex = 0;
        int handleIndex = 0;
        double offset = 0;
        for (final Widget child in widget.children) {
          if (child is ResizablePanel) {
            final double extent = paneIndex < extents.length
                ? extents[paneIndex]
                : 0;
            flexChildren.add(
              SizedBox(
                width: horizontal ? extent : null,
                height: horizontal ? null : extent,
                child: child,
              ),
            );
            offset += extent;
            paneIndex++;
          } else if (child is ResizableHandle) {
            final double thickness =
                child.thickness ?? theme.handleThickness ?? 1;
            final double hit = child.hitThickness ?? theme.hitThickness ?? 10;
            final int index = handleIndex;
            final ThemedColor gripColor =
                child.gripColor ??
                theme.gripColor ??
                const ThemedColor.ref(ColorRef.border);
            final Size gripSize =
                child.gripSize ?? theme.gripSize ?? const Size(4, 16);
            flexChildren.add(
              SizedBox(
                width: horizontal ? thickness : null,
                height: horizontal ? null : thickness,
                child: ColoredBox(
                  color: _dividerColor(child, theme, colors, index),
                ),
              ),
            );
            draggers.add(
              Positioned(
                left: horizontal ? offset + thickness / 2 - hit / 2 : 0,
                right: horizontal ? null : 0,
                top: horizontal ? 0 : offset + thickness / 2 - hit / 2,
                bottom: horizontal ? 0 : null,
                width: horizontal ? hit : null,
                height: horizontal ? null : hit,
                child: ResizableHandleView(
                  axis: widget.direction,
                  enabled: child.enabled,
                  withHandle: child.withHandle,
                  gripColor: gripColor.resolve(colors),
                  gripSize: gripSize,
                  active: _hovered.contains(index) || _dragging.contains(index),
                  semanticsLabel: handleLabel,
                  cursor: child.cursor,
                  focusNode: child.focusNode,
                  autofocus: child.autofocus,
                  onHoverChanged: (bool value) => setState(
                    () => value ? _hovered.add(index) : _hovered.remove(index),
                  ),
                  onStep: (double delta) => _stepDivider(index, delta),
                  onEdge: (bool end) => _edgeDivider(index, end),
                  onDragStart: () => _onDragStart(index),
                  onDragUpdate: (double delta) => _onDragUpdate(index, delta),
                  onDragEnd: () => _onDragEnd(index),
                  onDragCancel: () => _onDragCancel(index),
                ),
              ),
            );
            offset += thickness;
            handleIndex++;
          }
        }
        return Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Flex(
              direction: widget.direction,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: flexChildren,
            ),
            ...draggers,
          ],
        );
      },
    );
  }

  double _paneSize(_PaneEntry entry, double mainMax) {
    if (entry.controller.collapsed) {
      return entry.pane.collapsedSize ?? 0;
    }
    if (entry.controller.isFlexible) {
      return entry.controller.value * _flexSpace;
    }
    return entry.controller.computeSize(
      mainMax,
      minSize: entry.pane.minSize,
      maxSize: entry.pane.maxSize,
    );
  }

  Color _dividerColor(
    ResizableHandle handle,
    ResizableTheme theme,
    ShadcnColors colors,
    int index,
  ) {
    return resolveResizableHandleColor(
      colors,
      override: handle.color,
      handleColor: theme.handleColor ?? resizableDefaults.handleColor!,
      states: <WidgetState>{
        if (_hovered.contains(index)) WidgetState.hovered,
        if (_dragging.contains(index)) WidgetState.pressed,
      },
    );
  }

  void _stepDivider(int index, double delta) {
    final Resizer session = Resizer(_items());
    session.dragDivider(index + 1, delta);
    _applyControllers(session.items);
    setState(() {});
  }

  void _onDragStart(int index) {
    _session = Resizer(_items());
    setState(() => _dragging.add(index));
  }

  void _onDragUpdate(int index, double delta) {
    final Resizer? session = _session;
    if (session == null) {
      return;
    }
    session.dragDivider(index + 1, delta);
    _applyControllers(session.items);
  }

  void _onDragEnd(int index) {
    _session = null;
    setState(() => _dragging.remove(index));
  }

  void _onDragCancel(int index) {
    final Resizer? session = _session;
    if (session != null) {
      session.reset();
      _applyControllers(session.items);
    }
    _session = null;
    setState(() => _dragging.remove(index));
  }

  void _edgeDivider(int index, bool end) {
    final Resizer session = Resizer(_items());
    session.dragDivider(
      index + 1,
      resizableEdgeDelta(session.items, index, end, _mainMax),
    );
    _applyControllers(session.items);
    setState(() {});
  }

  List<ResizablePaneHandle> get _handles => <ResizablePaneHandle>[
    for (final _PaneEntry entry in _panes)
      ResizablePaneHandle(
        controller: entry.controller,
        minSize: entry.pane.minSize,
        maxSize: entry.pane.maxSize,
        collapsedSize: entry.pane.collapsedSize,
      ),
  ];

  List<ResizableItem> _items() =>
      ResizablePaneLayout(_handles).items(_flexSpace);

  void _applyControllers(List<ResizableItem> items) =>
      ResizablePaneLayout(_handles).apply(items, _flexSpace);
}

class _PaneEntry {
  _PaneEntry({
    required this.pane,
    required this.controller,
    required this.owns,
  });

  ResizablePanel pane;
  final ResizablePaneController controller;
  final bool owns;
}
