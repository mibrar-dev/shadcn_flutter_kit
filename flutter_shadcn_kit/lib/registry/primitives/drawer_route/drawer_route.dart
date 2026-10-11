// Edge-anchored modal panel machinery, shared by the `drawer` component and
// reusable by any panel that slides in from a screen edge.
//
// Extracted from the component so its files stay within the layout budget
// (the same escape hatch `primitives/slider/` used). The panel shell is in
// `drawer_panel.dart`; this file holds the position enum, the theme surface the
// shell needs, the scope data and the overlay completer.

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/tokens.dart';
import '../overlay.dart';

/// Edge a drawer or sheet slides in from.
///
/// `start`/`end` follow the ambient [TextDirection]; [resolve] maps them to a
/// physical edge before the shell builds.
enum OverlayPosition {
  /// Left edge.
  left,

  /// Right edge.
  right,

  /// Top edge.
  top,

  /// Bottom edge.
  bottom,

  /// Leading edge (left in LTR, right in RTL).
  start,

  /// Trailing edge (right in LTR, left in RTL).
  end;

  /// Resolves `start`/`end` against [direction]; other values are unchanged.
  OverlayPosition resolve(TextDirection direction) {
    switch (this) {
      case OverlayPosition.start:
        return direction == TextDirection.ltr
            ? OverlayPosition.left
            : OverlayPosition.right;
      case OverlayPosition.end:
        return direction == TextDirection.ltr
            ? OverlayPosition.right
            : OverlayPosition.left;
      case OverlayPosition.left:
      case OverlayPosition.right:
      case OverlayPosition.top:
      case OverlayPosition.bottom:
        return this;
    }
  }

  /// Whether the panel slides in along the horizontal axis.
  bool get isHorizontal =>
      this == OverlayPosition.left || this == OverlayPosition.right;

  /// Whether the panel is anchored to the top edge.
  bool get isTop => this == OverlayPosition.top;

  /// Whether the panel is anchored to the leading edge.
  bool get isLeading =>
      this == OverlayPosition.left || this == OverlayPosition.top;

  /// Alignment of the panel inside the route.
  AlignmentGeometry get alignment => switch (this) {
    OverlayPosition.left => Alignment.centerLeft,
    OverlayPosition.right => Alignment.centerRight,
    OverlayPosition.top => Alignment.topCenter,
    OverlayPosition.bottom => Alignment.bottomCenter,
    OverlayPosition.start || OverlayPosition.end => Alignment.center,
  };

  /// Start offset of the slide transition (the closed position).
  Offset get slideOffset => switch (this) {
    OverlayPosition.left => const Offset(-1, 0),
    OverlayPosition.right => const Offset(1, 0),
    OverlayPosition.top => const Offset(0, -1),
    OverlayPosition.bottom => const Offset(0, 1),
    OverlayPosition.start || OverlayPosition.end => Offset.zero,
  };

  /// Sign applied to a drag delta that closes the panel.
  double get dismissDragSign =>
      this == OverlayPosition.left || this == OverlayPosition.top ? 1.0 : -1.0;
}

/// The resolved surface the panel shell paints.
///
/// Implemented by the component's `DrawerTheme`; the shell resolves it live on
/// every build so a light/dark or preset switch restyles an open panel.
abstract class DrawerRouteTheme {
  /// Panel fill.
  ThemedColor? get background;

  /// Panel content colour.
  ThemedColor? get foreground;

  /// Inner-edge border colour.
  ThemedColor? get borderColor;

  /// Border width.
  double? get borderWidth;

  /// Inner-corner radius.
  BorderRadius? get borderRadius;

  /// Panel padding.
  EdgeInsetsGeometry? get padding;

  /// Barrier colour.
  ThemedColor? get barrierColor;

  /// Panel extent along its slide axis.
  double? get maxSize;

  /// Whether the drag handle is drawn.
  bool? get showDragHandle;

  /// Drag handle size.
  Size? get dragHandleSize;

  /// Drag handle colour.
  ThemedColor? get dragHandleColor;

  /// Open/close transition duration.
  Duration? get transitionDuration;

  /// Drop shadows.
  List<BoxShadow>? get shadows;

  /// Ambient shadow-scale override carried by the component theme.
  ShadowScale? get themeShadows;
}

/// Marks the subtree as living inside a drawer panel and carries its edge.
class DrawerPanelScope extends InheritedWidget {
  /// Creates a panel scope.
  const DrawerPanelScope({
    super.key,
    required this.position,
    required super.child,
  });

  /// The physical edge the panel is anchored to.
  final OverlayPosition position;

  /// The nearest panel scope, or null.
  static DrawerPanelScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DrawerPanelScope>();

  @override
  bool updateShouldNotify(DrawerPanelScope oldWidget) =>
      oldWidget.position != position;
}

/// Handle to an open drawer: completion, removal and animation futures.
class DrawerOverlayCompleter<T> implements OverlayCompleter<T> {
  /// Creates a completer over a pushed route.
  DrawerOverlayCompleter(this._future, this._animation, this._remove) {
    _future.whenComplete(() => _completed = true);
  }

  final Future<T?> _future;
  final Animation<double> _animation;
  final VoidCallback _remove;
  bool _completed = false;

  @override
  void remove() => _remove();

  @override
  void dispose() => _remove();

  @override
  bool get isCompleted => _completed;

  @override
  bool get isAnimationCompleted =>
      _animation.status == AnimationStatus.completed;

  @override
  Future<T?> get future => _future;

  @override
  Future<void> get animationFuture =>
      _animation.status == AnimationStatus.completed
      ? Future<void>.value()
      : _future.then((_) {});
}
