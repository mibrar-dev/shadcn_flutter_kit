// The `switcher` component: a swipeable view that animates between children.
//
// Ported from `components/navigation/switcher/**` (four `part`s plus a custom
// render object). Fixes, all verified against the old source:
//   * `_dragging` was set in `onPanStart` without `setState`, so the first drag
//     frame still animated over `duration` instead of following the finger.
//   * `_snapIndex` called `onIndexChanged` even when the snapped index equalled
//     the previous one, so a one-pixel drag notified the caller.
//   * `widget.index` was never clamped, so `index: 5` with three children
//     indexed past the end of the list and threw a RangeError on the first
//     frame.
//   * `context.size!` was a null assertion on the State's own context, so a pan
//     inside an unbounded or not-yet-laid-out slot crashed. The extent now comes
//     from a [LayoutBuilder] and every axis has a zero guard.
//   * The render object's `absolute` branch was unreachable and `paint` /
//     `hitTestChildren` overrode mixin methods with the mixin implementations.

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'switcher_style.dart';

export 'switcher_style.dart';

/// A swipeable container that transitions between child widgets.
///
/// ```dart
/// Switcher(
///   index: currentIndex,
///   direction: AxisDirection.right,
///   onIndexChanged: (int index) => setState(() => currentIndex = index),
///   children: pages,
/// )
/// ```
///
/// The fractional position lives in an [AnimationController]: a drag writes its
/// value directly and a release animates it to the nearest integer. Setting
/// [index] from outside cancels any in-flight drag.
class Switcher extends StatefulWidget {
  /// Creates a switcher.
  const Switcher({
    super.key,
    this.index = 0,
    required this.direction,
    required this.children,
    this.onIndexChanged,
    this.duration,
    this.curve,
    this.theme,
  }) : assert(children.length > 0, 'Switcher needs at least one child.');

  /// Index of the active child; values outside `0..children.length - 1` are
  /// clamped.
  final int index;

  /// Called when a drag snaps to an index other than the current one.
  final ValueChanged<int>? onIndexChanged;

  /// Axis the transition runs along; `right` means "the next child enters from
  /// the right".
  final AxisDirection direction;

  /// The pages to switch between; never empty.
  ///
  /// The **length** must not change after the first build: the position lives
  /// in an [AnimationController] whose range is fixed when it is created.
  /// Changing it asserts in debug; build a new [KeyedSubtree] (or give the
  /// [Switcher] a new `Key`) to swap the page list.
  final List<Widget> children;

  /// Snap-back duration; null uses [SwitcherTheme.duration].
  final Duration? duration;

  /// Snap-back curve; null uses [SwitcherTheme.curve].
  final Curve? curve;

  /// Widget-leg theme override, merged on top of the other legs.
  final SwitcherTheme? theme;

  /// Largest valid position, `children.length - 1`.
  double get _maxIndex => (children.length - 1).toDouble();

  @override
  State<Switcher> createState() => _SwitcherState();
}

class _SwitcherState extends State<Switcher>
    with SingleTickerProviderStateMixin {
  /// `unbounded` because the position is a fractional *index*, not a 0..1
  /// progress; the default 0..1 bounds would clamp the last page to page 1.
  late final AnimationController _position = AnimationController.unbounded(
    vsync: this,
    value: widget.index.clamp(0.0, widget._maxIndex).toDouble(),
  );

  /// Laid-out extent used to normalise drag deltas; zero until the first
  /// layout pass with bounded constraints.
  Size _viewport = Size.zero;

  /// `children.length` at the first build. The controller's range is fixed
  /// then, so a different length is a programming error (asserted in [build] —
  /// not in `didUpdateWidget`, which would abort the rebuild between the two
  /// hooks and corrupt element deactivation).
  int _childCount = 0;

  /// Theme resolved during the last build; [_snap] needs it outside `build`.
  Duration _duration = switcherDefaults.duration!;
  Curve _curve = switcherDefaults.curve!;

  @override
  void initState() {
    super.initState();
    _childCount = widget.children.length;
  }

  @override
  void didUpdateWidget(covariant Switcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      // An external index change wins over an in-flight drag.
      _position
        ..duration = _duration
        ..animateTo(
          widget.index.clamp(0.0, widget._maxIndex).toDouble(),
          curve: _curve,
        );
    }
  }

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  void _snap() {
    _position.duration = _duration;
    final double target = _position.value
        .roundToDouble()
        .clamp(0.0, widget._maxIndex)
        .toDouble();
    _position.animateTo(target, curve: _curve);
    final int snapped = target.toInt();
    // The old code notified on every gesture, even when the index did not
    // change (a jittery one-pixel drag).
    if (snapped != widget.index) {
      widget.onIndexChanged?.call(snapped);
    }
  }

  /// Fraction of the viewport that [delta] covers along the switch axis.
  double _deltaFor(Offset delta) {
    final bool vertical =
        widget.direction == AxisDirection.up ||
        widget.direction == AxisDirection.down;
    final double extent = vertical ? _viewport.height : _viewport.width;
    if (extent <= 0) {
      return 0;
    }
    final double distance = vertical ? delta.dy : delta.dx;
    final bool forward =
        widget.direction == AxisDirection.down ||
        widget.direction == AxisDirection.right;
    return (forward ? distance : -distance) / extent;
  }

  @override
  Widget build(BuildContext context) {
    assert(
      widget.children.length == _childCount,
      'Switcher.children must keep its length after the first build; the '
      'position range is fixed when the controller is created. Swap the page '
      'list with a new Key instead.',
    );
    final SwitcherTheme resolved =
        resolveComponentStyle<SwitcherTheme, SwitcherTheme>(
          context,
          widget: widget.theme,
          select: (t) => t,
          defaults: switcherDefaults,
        );
    _duration = widget.duration ?? resolved.duration!;
    _curve = widget.curve ?? resolved.curve!;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.hasBoundedWidth && constraints.hasBoundedHeight) {
          _viewport = constraints.biggest;
        }
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          // The old code set a flag here without rebuilding, so the first drag
          // frame still ran the snap animation.
          onPanStart: (_) => _position.stop(),
          onPanUpdate: (details) =>
              _position.value = (_position.value + _deltaFor(details.delta))
                  .clamp(0.0, widget._maxIndex),
          onPanEnd: (_) => _snap(),
          onPanCancel: _snap,
          child: AnimatedBuilder(
            animation: _position,
            builder: (context, _) => _buildPair(_position.value),
          ),
        );
      },
    );
  }

  Widget _buildPair(double position) {
    final int from = position.floor();
    final int to = position.ceil();
    final double progress = position - from;
    return _SwitcherTransition(
      progress: progress,
      direction: widget.direction,
      children: <Widget>[
        if (progress < 1)
          Opacity(
            key: ValueKey<int>(from),
            opacity: 1 - progress,
            child: widget.children[from],
          ),
        if (progress > 0)
          Opacity(
            key: ValueKey<int>(to),
            opacity: progress,
            child: widget.children[to],
          ),
      ],
    );
  }
}

/// Lays out the outgoing and the incoming child and slides them along
/// [direction].
class _SwitcherTransition extends MultiChildRenderObjectWidget {
  /// Creates a transition over one or two children.
  const _SwitcherTransition({
    required this.progress,
    required this.direction,
    required super.children,
  }) : assert(children.length > 0 && children.length <= 2);

  /// 0 = only the outgoing child, 1 = only the incoming child.
  final double progress;

  /// Axis and sense of the slide.
  final AxisDirection direction;

  @override
  _RenderSwitcherTransition createRenderObject(BuildContext context) {
    return _RenderSwitcherTransition()
      ..progress = progress
      ..direction = direction;
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderSwitcherTransition renderObject,
  ) {
    renderObject
      ..progress = progress
      ..direction = direction;
  }
}

class _SwitcherParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderSwitcherTransition extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _SwitcherParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _SwitcherParentData> {
  double progress = 0;
  AxisDirection direction = AxisDirection.down;

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! _SwitcherParentData) {
      child.parentData = _SwitcherParentData();
    }
  }

  @override
  void performLayout() {
    final RenderBox? from = firstChild;
    if (from == null) {
      size = constraints.constrain(Size.zero);
      return;
    }
    final RenderBox? to = childAfter(from);
    from.layout(constraints, parentUsesSize: true);
    to?.layout(constraints, parentUsesSize: true);

    final Size fromSize = from.size;
    final Size toSize = to?.size ?? fromSize;
    final (Offset fromOffset, Offset toOffset) = _offsets(fromSize, toSize);
    (from.parentData! as _SwitcherParentData).offset = fromOffset;
    if (to != null) {
      (to.parentData! as _SwitcherParentData).offset = toOffset;
    }
    size = constraints.constrain(
      Size(
        _lerp(fromSize.width, toSize.width),
        _lerp(fromSize.height, toSize.height),
      ),
    );
  }

  double _lerp(double a, double b) => a + (b - a) * progress;

  /// Slide offsets for the outgoing and the incoming child.
  ///
  /// The outgoing child slides out of view along [direction] and the incoming
  /// one slides in from the far side; both are centred in the interpolated
  /// size so children of different sizes stay aligned.
  (Offset, Offset) _offsets(Size fromSize, Size toSize) {
    final double lerpedWidth = _lerp(fromSize.width, toSize.width);
    final double lerpedHeight = _lerp(fromSize.height, toSize.height);
    final double centerX = (lerpedWidth - fromSize.width) / 2;
    final double centerY = (lerpedHeight - fromSize.height) / 2;
    final double forwardOffset = switch (direction) {
      AxisDirection.down => Offset(0, toSize.height).dy,
      AxisDirection.up => Offset(0, -fromSize.height).dy,
      AxisDirection.right => Offset(toSize.width, 0).dx,
      AxisDirection.left => Offset(-fromSize.width, 0).dx,
    };
    final double backOffset = switch (direction) {
      AxisDirection.down => Offset(0, -toSize.height).dy,
      AxisDirection.up => Offset(0, fromSize.height).dy,
      AxisDirection.right => Offset(-toSize.width, 0).dx,
      AxisDirection.left => Offset(fromSize.width, 0).dx,
    };
    return switch (direction) {
      AxisDirection.down || AxisDirection.up => (
        Offset(centerX, _lerp(0, forwardOffset)),
        Offset(centerX, _lerp(backOffset, 0)),
      ),
      AxisDirection.right || AxisDirection.left => (
        Offset(_lerp(0, forwardOffset), centerY),
        Offset(_lerp(backOffset, 0), centerY),
      ),
    };
  }
}
