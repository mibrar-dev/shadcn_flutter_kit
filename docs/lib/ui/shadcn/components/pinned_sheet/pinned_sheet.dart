// The `pinned_sheet` component: an in-tree [PinnedSheet] driven by a
// [SheetController] snapping between [SheetStage]s (see
// `primitives/sheet_stage.dart`). Fixes vs old: glass gone, barrier alpha
// multiplies, peek uses handle width on horizontal sheets.

import 'package:flutter/widgets.dart';

import '../../foundation/constants.dart';
import '../../foundation/data.dart';
import '../../primitives/sheet_stage.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../backdrop_transform/backdrop_transform.dart';
import '../drawer_container/drawer_container.dart';

export '../../primitives/sheet_stage.dart';

/// Controls a [PinnedSheet]: reads position, drives it to a [SheetStage].
class SheetController extends ChangeNotifier {
  _PinnedSheetState? _state;

  bool get isAttached => _state != null;
  void _attach(_PinnedSheetState state) {
    _state = state;
    notifyListeners();
  }

  void _detach(_PinnedSheetState state) {
    if (identical(_state, state)) _state = null;
  }

  void _notify() => notifyListeners();
  double get offset => _state?.currentOffset ?? 0;
  double get fraction => _state?.currentFraction ?? 0;
  bool get isOpen => fraction > 0;

  SheetStage get stage => _state != null
      ? SheetStage.live(
          offset: () => _state!.currentOffset,
          resolution: () => _state!.resolution,
          backdrop: () => _state!.currentBackdropTransform,
        )
      : const SheetStage.closed();

  /// Animates to [stage] with the default duration/curve when assigned.
  set stage(SheetStage stage) => animateTo(stage);
  Future<void> animateTo(
    SheetStage stage, {
    Duration duration = kDefaultDuration,
    Curve curve = Curves.linear,
  }) {
    final state = _state;
    if (state == null) return Future<void>.value();
    return state.animateToStage(stage, duration: duration, curve: curve);
  }

  void jumpTo(SheetStage stage) => _state?.jumpToStage(stage);

  Future<void> open({
    Duration duration = kDefaultDuration,
    Curve curve = Curves.easeOut,
  }) =>
      animateTo(const SheetStage.expanded(), duration: duration, curve: curve);

  Future<void> close({
    Duration duration = kDefaultDuration,
    Curve curve = Curves.easeOut,
  }) => animateTo(const SheetStage.closed(), duration: duration, curve: curve);
}

/// An in-tree sheet: slides in from [position], drags, snaps to [stages].
///
/// Wrap [child] in a [DrawerContainer] for chrome; the sheet publishes a
/// [DrawerContainerData] ancestor for exactly that.
class PinnedSheet extends StatefulWidget {
  const PinnedSheet({
    super.key,
    this.position = OverlayPosition.bottom,
    required this.child,
    this.controller,
    this.stages = const [SheetStage.closed(), SheetStage.expanded()],
    this.initialStage,
    this.backdrop,
    this.backdropTransform,
    this.draggable = true,
    this.showDragHandle = true,
    this.expands = true,
    this.contentExpands = false,
    this.modal = false,
    this.barrierDismissible = true,
    this.barrierColor,
    this.borderRadius,
    this.dragHandleSize,
    this.constraints,
    this.duration = const Duration(milliseconds: 350),
  });

  final OverlayPosition position;
  final Widget child;
  final SheetController? controller;
  final List<SheetStage> stages;
  final SheetStage? initialStage;
  final Widget? backdrop;
  final BackdropTransform? backdropTransform;
  final bool draggable;
  final bool showDragHandle;
  final bool expands;
  final bool contentExpands;
  final bool modal;
  final bool barrierDismissible;
  final ThemedColor? barrierColor;
  final BorderRadius? borderRadius;
  final Size? dragHandleSize;
  final BoxConstraints? constraints;
  final Duration duration;

  @override
  State<PinnedSheet> createState() => _PinnedSheetState();
}

class _PinnedSheetState extends State<PinnedSheet>
    with TickerProviderStateMixin {
  AnimationController? _animation;
  double _offset = 0;
  double _axisExtent = 0;
  bool _settled = false;

  OverlayPosition get _position {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return switch (widget.position) {
      OverlayPosition.start =>
        rtl ? OverlayPosition.right : OverlayPosition.left,
      OverlayPosition.end => rtl ? OverlayPosition.left : OverlayPosition.right,
      _ => widget.position,
    };
  }

  bool _vertical(OverlayPosition p) =>
      p == OverlayPosition.top || p == OverlayPosition.bottom;

  /// Resolution context for stage math.
  SheetStageResolution get resolution {
    final position = _position;
    final vertical = _vertical(position);
    final handle = widget.dragHandleSize;
    return SheetStageResolution(
      size: vertical
          ? Size(double.infinity, _axisExtent)
          : Size(_axisExtent, double.infinity),
      position: position,
      dragHandleExtent: widget.showDragHandle
          ? (vertical ? (handle?.height ?? 16) : (handle?.width ?? 16))
          : 0,
    );
  }

  double get currentOffset => _offset;

  double get currentFraction =>
      _axisExtent <= 0 ? 0 : (_offset / _axisExtent).clamp(0.0, 1.0);

  double get currentBackdropTransform => currentFraction;

  double _targetFor(SheetStage stage) {
    if (_axisExtent <= 0) return 0;
    return stage.resolveDragOffset(resolution).clamp(0.0, _axisExtent);
  }

  Future<void> animateToStage(
    SheetStage stage, {
    Duration duration = kDefaultDuration,
    Curve curve = Curves.linear,
  }) {
    final double target = _targetFor(stage);
    _animation?.dispose();
    final AnimationController anim = _animation = AnimationController(
      vsync: this,
      duration: duration,
    );
    final Tween<double> tween = Tween<double>(begin: _offset, end: target);
    final CurvedAnimation curved = CurvedAnimation(parent: anim, curve: curve);
    anim.addListener(() {
      _offset = tween.evaluate(curved);
      widget.controller?._notify();
      if (mounted) setState(() {});
    });
    // A newer animateToStage/jumpTo disposes [anim] mid-flight; the orphaned
    // future completes as cancelled instead of surfacing an async error.
    return anim.forward().then<void>(
      (_) {
        if (!identical(_animation, anim)) return;
        _offset = target;
        widget.controller?._notify();
        if (mounted) setState(() {});
      },
      onError: (Object e, StackTrace s) {
        if (e is TickerCanceled) return;
        throw e;
      },
    );
  }

  void jumpToStage(SheetStage stage) {
    _animation?.stop();
    _offset = _targetFor(stage);
    widget.controller?._notify();
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);
  }

  @override
  void didUpdateWidget(covariant PinnedSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach(this);
      widget.controller?._attach(this);
    }
  }

  @override
  void dispose() {
    widget.controller?._detach(this);
    _animation?.dispose();
    super.dispose();
  }

  void _drag(OverlayPosition position, double dx, double dy) {
    final delta = switch (position) {
      OverlayPosition.bottom => -dy,
      OverlayPosition.top => dy,
      OverlayPosition.right => -dx,
      OverlayPosition.left => dx,
      _ => 0.0,
    };
    if (delta == 0) return;
    _animation?.stop();
    _offset = (_offset + delta).clamp(0.0, _axisExtent <= 0 ? 0 : _axisExtent);
    widget.controller?._notify();
    setState(() {});
  }

  void _snap() {
    if (widget.stages.isEmpty || _axisExtent <= 0) return;
    SheetStage nearest = widget.stages.first;
    double distance = (_targetFor(nearest) - _offset).abs();
    for (final stage in widget.stages.skip(1)) {
      final d = (_targetFor(stage) - _offset).abs();
      if (d < distance) {
        nearest = stage;
        distance = d;
      }
    }
    animateToStage(nearest, duration: widget.duration, curve: Curves.easeOut);
  }

  Widget _dragRegion({
    required bool vertical,
    required OverlayPosition position,
    required Widget child,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragUpdate: vertical
          ? (d) => _drag(position, d.delta.dx, d.delta.dy)
          : null,
      onHorizontalDragUpdate: vertical
          ? null
          : (d) => _drag(position, d.delta.dx, d.delta.dy),
      onVerticalDragEnd: vertical ? (_) => _snap() : null,
      onHorizontalDragEnd: vertical ? null : (_) => _snap(),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final position = _position;
    final vertical = _vertical(position);
    final ambient = ShadcnTheme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxExtent = vertical
            ? (constraints.hasBoundedHeight ? constraints.maxHeight : 0.0)
            : (constraints.hasBoundedWidth ? constraints.maxWidth : 0.0);
        if (maxExtent != _axisExtent) {
          _axisExtent = maxExtent;
        }
        // Settles during the first bounded build (zero extent waits for
        // bounds), so the first frame already shows the initial stage.
        if (!_settled && maxExtent > 0) {
          _settled = true;
          final List<SheetStage> stages = widget.stages;
          _offset = _targetFor(
            widget.initialStage ??
                (stages.isNotEmpty ? stages.first : const SheetStage.closed()),
          );
        } else {
          _offset = _offset.clamp(0.0, maxExtent);
        }
        final t = currentFraction;
        final hidden = (1 - t) * _axisExtent;
        final slide = switch (position) {
          OverlayPosition.bottom => Offset(0, hidden),
          OverlayPosition.top => Offset(0, -hidden),
          OverlayPosition.right => Offset(hidden, 0),
          OverlayPosition.left => Offset(-hidden, 0),
          _ => Offset(0, hidden),
        };
        Widget chrome = Data.inherit(
          data: DrawerContainerData(
            position: position,
            isSheet: true,
            expands: widget.expands,
            draggable: widget.draggable,
            showDragHandle: widget.showDragHandle,
            dragHandleSize: widget.dragHandleSize,
            borderRadius: widget.borderRadius,
            barrierColor: widget.barrierColor?.resolve(ambient.colors),
            constraints: widget.constraints,
          ),
          child: widget.child,
        );
        if (widget.contentExpands && _axisExtent > 0) {
          final visible = _offset.clamp(0.0, _axisExtent);
          chrome = SizedBox(
            width: vertical ? double.infinity : visible,
            height: vertical ? visible : double.infinity,
            child: ClipRect(child: chrome),
          );
        }
        if (widget.constraints != null) {
          chrome = ConstrainedBox(
            constraints: widget.constraints!,
            child: chrome,
          );
        }
        final edge = switch (position) {
          OverlayPosition.bottom => Alignment.bottomCenter,
          OverlayPosition.top => Alignment.topCenter,
          OverlayPosition.right => Alignment.centerRight,
          OverlayPosition.left => Alignment.centerLeft,
          _ => Alignment.bottomCenter,
        };
        Widget sliding = Align(
          alignment: edge,
          child: Transform.translate(offset: slide, child: chrome),
        );
        if (widget.draggable) {
          sliding = _dragRegion(
            vertical: vertical,
            position: position,
            child: sliding,
          );
        }
        final Widget? backdrop = widget.backdrop == null
            ? null
            : (widget.backdropTransform?.wrapBackdrop(
                    context,
                    widget.backdrop!,
                    t,
                  ) ??
                  widget.backdrop!);
        final barrier = widget.barrierColor?.resolve(ambient.colors);
        return Stack(
          fit: StackFit.passthrough,
          children: [
            if (backdrop != null) Positioned.fill(child: backdrop),
            if (widget.modal && barrier != null && t > 0)
              Positioned.fill(
                child: GestureDetector(
                  onTap: widget.barrierDismissible
                      ? () => animateToStage(
                          const SheetStage.closed(),
                          duration: widget.duration,
                          curve: Curves.easeOut,
                        )
                      : null,
                  // Alpha multiplies the token alpha (never replaces it).
                  child: ColoredBox(
                    color: barrier.withValues(
                      alpha: (barrier.a * t).clamp(0.0, 1.0),
                    ),
                  ),
                ),
              ),
            Positioned.fill(child: sliding),
          ],
        );
      },
    );
  }
}
