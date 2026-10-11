// The sortable drag-session layer: owns the sessions, renders the ghost and
// settles it into place on drop. Extracted from the `sortable` component so
// its files stay within the layout budget; reusable by any pan-reorder
// surface.

import 'package:flutter/widgets.dart';

import '../foundation/data.dart';
import 'drag_sort.dart';

/// Wraps a value so a sortable item can be identified during a drag.
class SortableData<T> {
  /// Creates sortable data.
  const SortableData(this.data);

  /// The wrapped value.
  final T data;
}

/// One drag session owned by a [SortableLayer].
class SortableSession {
  /// Creates a session.
  SortableSession({
    required this.data,
    required this.size,
    required this.bounds,
    required this.ghost,
    required this.offset,
  });

  /// The value being dragged.
  final Object data;

  /// The dragged item's size.
  final Size size;

  /// The dragged item's layer-space bounds.
  final DragBounds bounds;

  /// The widget rendered under the pointer.
  final Widget ghost;

  /// The current layer-space translation of the ghost.
  final ValueNotifier<Offset> offset;
}

/// Coordinates drag sessions between sortable items and renders the ghost.
///
/// On drop, the ghost glides to its landing position over [dropDuration]
/// (200ms by default) with [dropCurve] (`easeOut` by default) instead of
/// snapping. The settle is skipped when animations are disabled or
/// [dropDuration] is [Duration.zero].
class SortableLayer extends StatefulWidget {
  /// Creates a sortable layer.
  const SortableLayer({
    super.key,
    this.lock = false,
    this.clipBehavior,
    this.dropDuration,
    this.dropCurve,
    required this.child,
  });

  /// Whether dragging is constrained to the layer bounds.
  final bool lock;

  /// Clip behaviour; defaults to `hardEdge` when [lock] is set.
  final Clip? clipBehavior;

  /// Drop settle duration; null resolves 200ms, `Duration.zero` disables it.
  final Duration? dropDuration;

  /// Drop settle curve; null resolves `Curves.easeOut`.
  final Curve? dropCurve;

  /// The subtree containing the sortable items.
  final Widget child;

  @override
  State<SortableLayer> createState() => SortableLayerState();
}

/// State of [SortableLayer]. Public only so the `sortable` component can call
/// [pushSession], [removeSession] and [settle]; not part of the user API.
class SortableLayerState extends State<SortableLayer>
    with SingleTickerProviderStateMixin {
  final List<SortableSession> _sessions = <SortableSession>[];
  late final AnimationController _controller = AnimationController(vsync: this);
  SortableSession? _settling;
  Offset _from = Offset.zero;
  Offset _to = Offset.zero;
  Curve _curve = Curves.easeOut;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSettleTick);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Duration get _dropDuration =>
      widget.dropDuration ?? const Duration(milliseconds: 200);

  Curve get _dropCurve => widget.dropCurve ?? Curves.easeOut;

  /// Adds [session] and renders its ghost.
  void pushSession(SortableSession session) {
    session.offset.addListener(_tick);
    _sessions.add(session);
    setState(() {});
  }

  /// Removes [session] and stops listening to it.
  void removeSession(SortableSession session) {
    session.offset.removeListener(_tick);
    if (_sessions.remove(session)) {
      session.offset.dispose();
    }
    if (mounted) {
      setState(() {});
    }
  }

  /// Settles [session] to [to] (a layer-space translation) and then removes it.
  ///
  /// When [animate] is false, animations are disabled or [dropDuration] is
  /// zero, the session is removed immediately.
  void settle(SortableSession session, Offset to, {required bool animate}) {
    final bool disabled =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (!animate || disabled || _dropDuration == Duration.zero) {
      removeSession(session);
      return;
    }
    _settling = session;
    _from = session.offset.value;
    _to = to;
    _curve = _dropCurve;
    _controller.duration = _dropDuration;
    _controller.forward(from: 0);
  }

  void _onSettleTick() {
    final SortableSession? session = _settling;
    if (session == null) {
      return;
    }
    session.offset.value = Offset.lerp(
      _from,
      _to,
      _curve.transform(_controller.value),
    )!;
    if (_controller.status == AnimationStatus.completed) {
      _settling = null;
      removeSession(session);
    }
  }

  void _tick() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Data<SortableLayerState>.inherit(
      data: this,
      child: Stack(
        clipBehavior:
            widget.clipBehavior ?? (widget.lock ? Clip.hardEdge : Clip.none),
        children: <Widget>[
          widget.child,
          for (final SortableSession session in _sessions)
            Positioned(
              left: session.bounds.minOffset.dx + session.offset.value.dx,
              top: session.bounds.minOffset.dy + session.offset.value.dy,
              width: session.size.width,
              height: session.size.height,
              child: IgnorePointer(child: session.ghost),
            ),
        ],
      ),
    );
  }
}
