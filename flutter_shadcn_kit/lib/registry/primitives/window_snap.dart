// The window snap bar: the preset strip that slides in while a window is
// dragged near the top edge of a `WindowHost`.
//
// Restored from `components/layout/window/_impl/core/_window_layer_group.dart`
// (P4-B23 round 2): the old inline snap-bar layouts (halves, 70/30, thirds,
// 2-3-2, quarters) plus the maximize strip now live here, so the host file
// stays within the ~400-line budget.

import 'package:flutter/widgets.dart';

import '../foundation/constants.dart';
import '../theme/theme.dart';
import 'window_manager.dart';

/// The six snap layouts, each a list of relative rects (0..1) that tile the
/// host. Hovering any rect applies that rect as the window's snap target.
const List<List<Rect>> windowSnapPresets = <List<Rect>>[
  <Rect>[Rect.fromLTWH(0, 0, 0.5, 1), Rect.fromLTWH(0.5, 0, 0.5, 1)],
  <Rect>[Rect.fromLTWH(0, 0, 0.7, 1), Rect.fromLTWH(0.7, 0, 0.3, 1)],
  <Rect>[
    Rect.fromLTWH(0, 0, 0.5, 1),
    Rect.fromLTWH(0.5, 0, 0.5, 0.5),
    Rect.fromLTWH(0.5, 0.5, 0.5, 0.5),
  ],
  <Rect>[
    Rect.fromLTWH(0, 0, 0.5, 0.5),
    Rect.fromLTWH(0.5, 0, 0.5, 0.5),
    Rect.fromLTWH(0, 0.5, 0.5, 0.5),
    Rect.fromLTWH(0.5, 0.5, 0.5, 0.5),
  ],
  <Rect>[
    Rect.fromLTWH(0, 0, 1 / 3, 1),
    Rect.fromLTWH(1 / 3, 0, 1 / 3, 1),
    Rect.fromLTWH(2 / 3, 0, 1 / 3, 1),
  ],
  <Rect>[
    Rect.fromLTWH(0, 0, 2 / 7, 1),
    Rect.fromLTWH(2 / 7, 0, 3 / 7, 1),
    Rect.fromLTWH(5 / 7, 0, 2 / 7, 1),
  ],
];

/// The maximize target shown when a drag reaches the top edge itself.
const WindowSnapStrategy windowMaximizeSnapStrategy = WindowSnapStrategy(
  relativeBounds: Rect.fromLTWH(0, 0, 1, 1),
  shouldMinifyWindow: false,
);

/// Slides the preset bar in while a window is dragged near the top edge.
///
/// Place it as the last child of a `Stack` covering the window host: it
/// renders a top strip (maximize target + bar reveal) plus the bar itself.
/// While the strip is hovered the dragged window snaps to full screen unless
/// the pointer moves onto a preset cell, which takes over the target.
class WindowSnapBar extends StatefulWidget {
  /// Creates the snap bar.
  const WindowSnapBar({
    super.key,
    required this.drag,
    required this.titleBarHeight,
    required this.viewportSize,
  });

  /// Drag state of the host; the bar is only active while a drag is running.
  final WindowDragController drag;

  /// Height of the reveal strip along the top edge.
  final double titleBarHeight;

  /// Size of the host, used for the preset aspect ratio.
  final Size viewportSize;

  @override
  State<WindowSnapBar> createState() => _WindowSnapBarState();
}

class _WindowSnapBarState extends State<WindowSnapBar> {
  static const double _barHeight = 100;

  bool _hovering = false;

  @override
  void initState() {
    super.initState();
    widget.drag.addListener(_handleDragChanged);
  }

  @override
  void didUpdateWidget(covariant WindowSnapBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.drag != oldWidget.drag) {
      oldWidget.drag.removeListener(_handleDragChanged);
      widget.drag.addListener(_handleDragChanged);
    }
  }

  @override
  void dispose() {
    widget.drag.removeListener(_handleDragChanged);
    super.dispose();
  }

  void _handleDragChanged() {
    if (!mounted) {
      return;
    }
    if (widget.drag.window == null && _hovering) {
      setState(() => _hovering = false);
    } else {
      setState(() {});
    }
  }

  void _show(bool hovering) {
    if (!mounted || widget.drag.window == null) {
      return;
    }
    if (_hovering != hovering) {
      setState(() => _hovering = hovering);
    }
  }

  void _enterStrip() {
    if (widget.drag.window == null) {
      return;
    }
    _show(true);
    widget.drag.hover(windowMaximizeSnapStrategy);
  }

  void _leaveStrip() {
    if (widget.drag.window == null) {
      return;
    }
    _show(false);
    if (widget.drag.strategy == windowMaximizeSnapStrategy) {
      widget.drag.hover(null);
    }
  }

  void _leaveBar() {
    if (widget.drag.window == null) {
      return;
    }
    _show(false);
    widget.drag.hover(null);
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final bool dragging = widget.drag.window != null;
    final bool shown = dragging && _hovering;
    final double width = widget.viewportSize.width;
    final double height = widget.viewportSize.height;
    final double ratio = (width <= 0 || height <= 0) ? 1 : width / height;
    final double gap = theme.density.baseGap * theme.scaling;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          MouseRegion(
            opaque: false,
            hitTestBehavior: HitTestBehavior.translucent,
            onEnter: (_) => _enterStrip(),
            onHover: (_) => _enterStrip(),
            onExit: (_) => _leaveStrip(),
            child: SizedBox(
              height: widget.titleBarHeight,
              width: double.infinity,
            ),
          ),
          IgnorePointer(
            ignoring: !shown,
            child: AnimatedSlide(
              offset: Offset(0, shown ? 0 : -1),
              duration: kDefaultDuration,
              curve: Curves.easeInOut,
              child: AnimatedOpacity(
                opacity: shown ? 1 : 0,
                duration: kDefaultDuration,
                child: Padding(
                  padding: EdgeInsets.only(top: widget.titleBarHeight),
                  child: Align(
                    alignment: Alignment.topCenter,
                    heightFactor: 1,
                    child: MouseRegion(
                      onEnter: (_) => _show(true),
                      onHover: (_) => _show(true),
                      onExit: (_) => _leaveBar(),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: theme.colors.card,
                            border: Border.all(color: theme.colors.border),
                            borderRadius: theme.borderRadiusXl,
                            boxShadow: theme.tokens.shadows.shadowLg,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(gap),
                            child: SizedBox(
                              height: _barHeight - gap * 2,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  for (
                                    int index = 0;
                                    index < windowSnapPresets.length;
                                    index++
                                  ) ...<Widget>[
                                    if (index > 0) SizedBox(width: gap),
                                    AspectRatio(
                                      aspectRatio: ratio,
                                      child: _SnapPreset(
                                        key: ValueKey<String>(
                                          'windowSnapPreset-$index',
                                        ),
                                        drag: widget.drag,
                                        index: index,
                                        cells: windowSnapPresets[index],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One preset layout: a miniature stack of its snap cells.
class _SnapPreset extends StatelessWidget {
  const _SnapPreset({
    super.key,
    required this.drag,
    required this.index,
    required this.cells,
  });

  final WindowDragController drag;
  final int index;
  final List<Rect> cells;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size size = constraints.biggest;
        Rect absolute(Rect relative) => Rect.fromLTWH(
          relative.left * size.width,
          relative.top * size.height,
          relative.width * size.width,
          relative.height * size.height,
        );
        return Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            for (int cell = 0; cell < cells.length; cell++)
              Positioned.fromRect(
                rect: absolute(cells[cell]),
                child: _SnapCell(
                  key: ValueKey<String>('windowSnapCell-$index-$cell'),
                  drag: drag,
                  relativeBounds: cells[cell],
                ),
              ),
          ],
        );
      },
    );
  }
}

/// One snap target; hovering it previews and applies its [relativeBounds].
class _SnapCell extends StatefulWidget {
  const _SnapCell({
    super.key,
    required this.drag,
    required this.relativeBounds,
  });

  final WindowDragController drag;
  final Rect relativeBounds;

  @override
  State<_SnapCell> createState() => _SnapCellState();
}

class _SnapCellState extends State<_SnapCell> {
  bool _hovering = false;
  WindowSnapStrategy? _strategy;

  WindowSnapStrategy get _target =>
      _strategy ??= WindowSnapStrategy(relativeBounds: widget.relativeBounds);

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return MouseRegion(
      onEnter: (_) => _setHovering(true),
      onHover: (_) => _setHovering(true),
      onExit: (_) => _setHovering(false),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _hovering ? theme.colors.secondary : theme.colors.card,
            border: Border.all(color: theme.colors.border),
            borderRadius: theme.borderRadiusSm,
          ),
        ),
      ),
    );
  }

  void _setHovering(bool hovering) {
    if (widget.drag.window == null) {
      return;
    }
    if (_hovering != hovering) {
      setState(() => _hovering = hovering);
    }
    if (hovering) {
      widget.drag.hover(_target);
    } else if (widget.drag.strategy == _target) {
      widget.drag.hover(null);
    }
  }
}
