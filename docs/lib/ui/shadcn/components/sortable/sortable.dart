// The `sortable` component: drag-and-drop reordering primitives.
//
// Ported from the canonical `components/layout/sortable`; the `form/sortable`
// stub's change model is superseded by `primitives/drag_sort.dart` (deleted,
// not merged). `SortableLayer` (in `primitives/sortable_layer.dart`) owns the
// sessions, the ghost and the drop settle animation; `Sortable<T>` reports
// per-edge drop intents.

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../foundation/util.dart';
import '../../primitives/drag_sort.dart';
import '../../primitives/sortable_layer.dart';

export '../../primitives/sortable_layer.dart';

/// A draggable item that accepts drops on its four edges.
class Sortable<T> extends StatefulWidget {
  /// Creates a sortable item.
  const Sortable({
    super.key,
    this.enabled = true,
    required this.data,
    this.canAcceptTop,
    this.canAcceptLeft,
    this.canAcceptRight,
    this.canAcceptBottom,
    this.onAcceptTop,
    this.onAcceptLeft,
    this.onAcceptRight,
    this.onAcceptBottom,
    this.ghost,
    this.fallback,
    this.candidateFallback,
    this.onDragStart,
    this.onDragEnd,
    this.onDragCancel,
    this.behavior = HitTestBehavior.deferToChild,
    this.onDropFailed,
    required this.child,
  });

  /// Whether drag interactions are enabled.
  final bool enabled;

  /// The value identifying this item.
  final SortableData<T> data;

  /// Whether a drop on the top edge is accepted.
  final Predicate<SortableData<T>>? canAcceptTop;

  /// Whether a drop on the left edge is accepted.
  final Predicate<SortableData<T>>? canAcceptLeft;

  /// Whether a drop on the right edge is accepted.
  final Predicate<SortableData<T>>? canAcceptRight;

  /// Whether a drop on the bottom edge is accepted.
  final Predicate<SortableData<T>>? canAcceptBottom;

  /// Called when data is dropped on the top edge.
  final ValueChanged<SortableData<T>>? onAcceptTop;

  /// Called when data is dropped on the left edge.
  final ValueChanged<SortableData<T>>? onAcceptLeft;

  /// Called when data is dropped on the right edge.
  final ValueChanged<SortableData<T>>? onAcceptRight;

  /// Called when data is dropped on the bottom edge.
  final ValueChanged<SortableData<T>>? onAcceptBottom;

  /// Widget rendered in the layer while dragging.
  final Widget? ghost;

  /// Widget shown in place of the child while dragging.
  final Widget? fallback;

  /// Widget shown when this item is the current drop candidate.
  final Widget? candidateFallback;

  /// Called when a drag starts.
  final VoidCallback? onDragStart;

  /// Called when a drag ends (after the accept callback).
  final VoidCallback? onDragEnd;

  /// Called when a drag is cancelled.
  final VoidCallback? onDragCancel;

  /// Hit-test behaviour of the drag gesture.
  final HitTestBehavior behavior;

  /// Called when a drop lands on no valid target.
  final VoidCallback? onDropFailed;

  /// The item content.
  final Widget child;

  @override
  State<Sortable<T>> createState() => _SortableState<T>();
}

class _SortableState<T> extends State<Sortable<T>> {
  SortableSession? _session;

  /// Layer owning [_session]; kept so dispose can end the session without a
  /// `BuildContext` (unmounted by then, and `Data.maybeFind` asserts on it).
  SortableLayerState? _layerRef;
  _SortableState<T>? _target;
  DragDropEdge? _edge;
  final ValueNotifier<bool> _candidate = ValueNotifier<bool>(false);

  @override
  void dispose() {
    final SortableSession? session = _session;
    final SortableLayerState? layer = _layerRef;
    _session = null;
    _layerRef = null;
    _clearTarget();
    if (session != null) {
      // Never touches `context` here: the element is already unmounted
      // (`Data.maybeFind` asserts on that) while `State.mounted` is still
      // true, so neither check is reliable — the stored layer reference is.
      // `removeSession` guards its own `mounted` for setState, covering
      // both teardown and rebuild-remount with an active drag.
      layer?.removeSession(session);
    }
    _candidate.dispose();
    super.dispose();
  }

  SortableLayerState? _layer() => Data.maybeFind<SortableLayerState>(context);

  void _onPanStart(DragStartDetails details) {
    if (!widget.enabled) {
      return;
    }
    final SortableLayerState? layer = _layer();
    assert(layer != null, 'Sortable must be a descendant of SortableLayer');
    final RenderBox box = context.findRenderObject()! as RenderBox;
    final RenderBox layerBox = layer!.context.findRenderObject()! as RenderBox;
    final SortableSession session = SortableSession(
      data: widget.data,
      size: box.size,
      bounds: DragBounds.fromTransform(
        box.getTransformTo(layerBox),
        box.size,
        layerBox.size,
      ),
      ghost: widget.ghost ?? widget.child,
      offset: ValueNotifier<Offset>(Offset.zero),
    );
    _session = session;
    _layerRef = layer;
    layer.pushSession(session);
    setState(() {});
    widget.onDragStart?.call();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final SortableSession? session = _session;
    if (session == null) {
      return;
    }
    session.offset.value = session.bounds.clampTranslation(
      session.offset.value,
      details.delta,
    );
    _updateTarget(session);
  }

  void _updateTarget(SortableSession session) {
    final SortableLayerState? layer = _layer();
    if (layer == null) {
      return;
    }
    final RenderBox layerBox = layer.context.findRenderObject()! as RenderBox;
    final BoxHitTestResult result = BoxHitTestResult();
    layerBox.hitTest(
      result,
      position: session.bounds.probePosition(session.offset.value),
    );
    _SortableState<T>? found;
    Offset local = Offset.zero;
    for (final HitTestEntry entry in result.path) {
      final HitTestTarget target = entry.target;
      if (target is RenderMetaData && target.metaData is _SortableState<T>) {
        final _SortableState<T> candidate =
            target.metaData as _SortableState<T>;
        if (candidate != this) {
          found = candidate;
          local = (entry as BoxHitTestEntry).localPosition;
          break;
        }
      }
    }
    if (found == null) {
      _clearTarget();
      return;
    }
    final RenderBox targetBox = found.context.findRenderObject()! as RenderBox;
    final DragDropEdge? edge = resolveDragDropEdge(
      local,
      targetBox.size,
      acceptTop: found.widget.onAcceptTop != null,
      acceptLeft: found.widget.onAcceptLeft != null,
      acceptRight: found.widget.onAcceptRight != null,
      acceptBottom: found.widget.onAcceptBottom != null,
    );
    if (edge == null) {
      _clearTarget();
      return;
    }
    if (!identical(_target, found)) {
      _clearTarget();
      _target = found;
      found._candidate.value = true;
    }
    _edge = edge;
  }

  void _clearTarget() {
    _target?._candidate.value = false;
    _target = null;
    _edge = null;
  }

  void _onPanEnd(DragEndDetails details) {
    final SortableSession? session = _session;
    if (session == null) {
      return;
    }
    final _SortableState<T>? target = _target;
    final DragDropEdge? edge = _edge;
    Offset landing = Offset.zero;
    if (target != null && edge != null) {
      landing = _landing(session, target);
      final Sortable<T> t = target.widget;
      final Predicate<SortableData<T>>? predicate = switch (edge) {
        DragDropEdge.top => t.canAcceptTop,
        DragDropEdge.left => t.canAcceptLeft,
        DragDropEdge.right => t.canAcceptRight,
        DragDropEdge.bottom => t.canAcceptBottom,
      };
      if (predicate == null || predicate(session.data as SortableData<T>)) {
        final ValueChanged<SortableData<T>>? callback = switch (edge) {
          DragDropEdge.top => t.onAcceptTop,
          DragDropEdge.left => t.onAcceptLeft,
          DragDropEdge.right => t.onAcceptRight,
          DragDropEdge.bottom => t.onAcceptBottom,
        };
        callback?.call(session.data as SortableData<T>);
      }
    } else {
      widget.onDropFailed?.call();
    }
    _endSession(session, landing);
    widget.onDragEnd?.call();
  }

  void _onPanCancel() {
    final SortableSession? session = _session;
    if (session == null) {
      return;
    }
    _endSession(session, Offset.zero);
    widget.onDragCancel?.call();
  }

  Offset _landing(SortableSession session, _SortableState<T> target) {
    final RenderBox? layerBox =
        _layer()?.context.findRenderObject() as RenderBox?;
    final RenderBox? targetBox =
        target.context.findRenderObject() as RenderBox?;
    if (layerBox == null || targetBox == null) {
      return Offset.zero;
    }
    return MatrixUtils.transformPoint(
          targetBox.getTransformTo(layerBox),
          Offset.zero,
        ) -
        session.bounds.minOffset;
  }

  void _endSession(SortableSession session, Offset landing) {
    _clearTarget();
    _layerRef = null;
    setState(() => _session = null);
    _layer()?.settle(session, landing, animate: true);
  }

  @override
  Widget build(BuildContext context) {
    return MetaData(
      metaData: this,
      behavior: HitTestBehavior.translucent,
      child: Data<_SortableState<T>>.inherit(
        data: this,
        child: GestureDetector(
          behavior: widget.behavior,
          onPanStart: widget.enabled ? _onPanStart : null,
          onPanUpdate: widget.enabled ? _onPanUpdate : null,
          onPanEnd: widget.enabled ? _onPanEnd : null,
          onPanCancel: widget.enabled ? _onPanCancel : null,
          child: ValueListenableBuilder<bool>(
            valueListenable: _candidate,
            builder: (BuildContext context, bool candidate, Widget? child) {
              if (_session != null) {
                return widget.fallback ??
                    Opacity(opacity: 0.4, child: widget.child);
              }
              if (candidate) {
                return widget.candidateFallback ?? widget.child;
              }
              return widget.child;
            },
          ),
        ),
      ),
    );
  }
}

/// A drag handle that starts the parent [Sortable]'s drag.
class SortableDragHandle extends StatelessWidget {
  /// Creates a drag handle.
  const SortableDragHandle({
    super.key,
    required this.child,
    this.enabled = true,
    this.behavior,
    this.cursor,
  });

  /// The handle content.
  final Widget child;

  /// Whether the handle starts a drag.
  final bool enabled;

  /// Hit-test behaviour of the handle gesture.
  final HitTestBehavior? behavior;

  /// Mouse cursor when hovering the handle.
  final MouseCursor? cursor;

  @override
  Widget build(BuildContext context) {
    final _SortableState<Object?>? state =
        Data.maybeOf<_SortableState<Object?>>(context);
    if (state == null || !enabled) {
      return MouseRegion(cursor: MouseCursor.defer, child: child);
    }
    return MouseRegion(
      cursor: cursor ?? SystemMouseCursors.grab,
      child: GestureDetector(
        behavior: behavior ?? HitTestBehavior.opaque,
        onPanStart: state._onPanStart,
        onPanUpdate: state._onPanUpdate,
        onPanEnd: state._onPanEnd,
        onPanCancel: state._onPanCancel,
        child: child,
      ),
    );
  }
}
