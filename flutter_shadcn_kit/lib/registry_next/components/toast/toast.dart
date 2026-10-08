// The `toast` component: transient, non-blocking notifications anchored to a
// screen edge. The stack and controller are the shared
// `primitives/toast_queue`; this file owns the widget, context lookup, stack
// placement and the swipe/close affordances.

import 'package:flutter/widgets.dart';

import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/toast_queue/toast_controller.dart';
import '../../primitives/toast_queue/toast_entry.dart';
import '../../primitives/toast_queue/toast_exit.dart';
import '../../primitives/toast_queue/toast_placement.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'toast_style.dart';

export 'toast_style.dart';
export '../../primitives/toast_queue/toast_controller.dart';
export '../../primitives/toast_queue/toast_placement.dart';

ToastController? toastControllerOf(BuildContext context) =>
    context.dependOnInheritedWidgetOfExactType<_ToastScope>()?.controller;

String showToast(
  BuildContext context, {
  required ToastBuilder builder,
  ToastPlacement placement = ToastPlacement.bottomTrailing,
  Duration? duration,
  bool autoDismiss = true,
  String? id,
  VoidCallback? onDismissed,
}) {
  final _ToastScope? scope = context
      .dependOnInheritedWidgetOfExactType<_ToastScope>();
  assert(scope != null, 'No ToastLayer found above this context');
  return scope!.controller.showToast(
    builder: builder,
    placement: placement,
    duration: duration ?? scope.theme.duration,
    autoDismiss: autoDismiss,
    id: id,
    onDismissed: onDismissed,
  );
}

class _ToastScope extends InheritedWidget {
  const _ToastScope({
    required this.controller,
    required this.theme,
    required super.child,
  });

  final ToastController controller;
  final ToastTheme theme;

  @override
  bool updateShouldNotify(_ToastScope oldWidget) =>
      !identical(oldWidget.controller, controller) || oldWidget.theme != theme;
}

class ToastLayer extends StatefulWidget {
  const ToastLayer({
    super.key,
    required this.child,
    this.controller,
    this.theme,
  });

  final Widget child;

  final ToastController? controller;

  final ToastTheme? theme;

  @override
  State<ToastLayer> createState() => _ToastLayerState();
}

class _ToastLayerState extends State<ToastLayer> {
  ToastController? _owned;
  final Map<ToastSlot, int> _slotCounts = <ToastSlot, int>{};

  ToastController get _controller => widget.controller ?? _owned!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) _owned = ToastController();
    _controller.addListener(_reconcileSlots);
  }

  @override
  void didUpdateWidget(covariant ToastLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == oldWidget.controller) {
      return;
    }
    (oldWidget.controller ?? _owned)!.removeListener(_reconcileSlots);
    if (oldWidget.controller == null) {
      _owned?.dispose();
      _owned = null;
    }
    if (widget.controller == null) _owned = ToastController();
    _slotCounts.clear();
    _controller.addListener(_reconcileSlots);
  }

  @override
  void dispose() {
    _controller.removeListener(_reconcileSlots);
    _owned?.dispose();
    super.dispose();
  }

  void _reconcileSlots() {
    for (final ToastPlacement placement in ToastPlacement.values) {
      final ToastSlot slot = ToastSlot(placement);
      final List<ToastEntry<ToastBuilder>> live = _controller
          .entriesIn(slot)
          .where((ToastEntry<ToastBuilder> entry) => !entry.isExiting)
          .toList(growable: false);
      final int previous = _slotCounts[slot] ?? 0;
      _slotCounts[slot] = live.length;
      if (live.length > 1) {
        _controller.pauseSlot(
          slot,
          selector: (entry) => entry.id != live.first.id,
        );
      } else if (previous > 1) {
        _controller.resumeSlot(slot);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ToastTheme theme = resolveComponentStyle<ToastTheme, ToastTheme>(
      context,
      widget: widget.theme,
      select: (t) => t,
      defaults: toastDefaults,
    );
    return _ToastScope(
      controller: _controller,
      theme: theme,
      child: ListenableBuilder(
        listenable: _controller,
        builder: (BuildContext context, Widget? child) {
          final List<ToastEntry<ToastBuilder>> entries = _controller.entries;
          if (entries.isEmpty) {
            return widget.child;
          }
          return Stack(
            children: <Widget>[
              widget.child,
              ..._toastWidgets(context, theme, entries),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _toastWidgets(
    BuildContext context,
    ToastTheme theme,
    List<ToastEntry<ToastBuilder>> entries,
  ) {
    final groups = <ToastPlacement, List<ToastEntry<ToastBuilder>>>{};
    for (final entry in entries) {
      groups
          .putIfAbsent(entry.slot.placement, () => <ToastEntry<ToastBuilder>>[])
          .add(entry);
    }
    final media = MediaQuery.maybePaddingOf(context) ?? EdgeInsets.zero;
    return <Widget>[
      for (final group in groups.entries)
        _positionedGroup(context, group.key, group.value, theme, media),
    ];
  }

  Widget _positionedGroup(
    BuildContext context,
    ToastPlacement placement,
    List<ToastEntry<ToastBuilder>> entries,
    ToastTheme theme,
    EdgeInsets media,
  ) {
    final inset = (theme.offset ?? const EdgeInsets.all(24)).resolve(
      Directionality.of(context),
    );
    final ltr = Directionality.of(context) == TextDirection.ltr;
    final leading = placement.isLeading;
    final onLeft = placement.isCenter ? false : (leading ? ltr : !ltr);
    final onRight = placement.isCenter ? false : (leading ? !ltr : ltr);
    return Positioned(
      top: placement.isTop ? inset.top + media.top : 0,
      bottom: placement.isTop ? 0 : inset.bottom + media.bottom,
      left: placement.isCenter ? 0 : (onLeft ? inset.left + media.left : null),
      right: placement.isCenter
          ? 0
          : (onRight ? inset.right + media.right : null),
      child: ToastSlotColumn<ToastBuilder>(
        queue: _controller,
        entries: entries,
        placement: placement,
        gap: theme.gap ?? 8,
        collapse: true,
        cardBuilder: (BuildContext context, ToastEntry<ToastBuilder> entry) =>
            _ToastCard(controller: _controller, entry: entry, theme: theme),
      ),
    );
  }
}

class _ToastCard extends StatefulWidget {
  const _ToastCard({
    required this.controller,
    required this.entry,
    required this.theme,
  });

  final ToastController controller;
  final ToastEntry<ToastBuilder> entry;
  final ToastTheme theme;

  @override
  State<_ToastCard> createState() => _ToastCardState();
}

class _ToastCardState extends State<_ToastCard>
    with SingleTickerProviderStateMixin {
  static const double _dismissThreshold = 72;
  static const double _dismissVelocity = 800;

  late final AnimationController _animation;
  Offset _drag = Offset.zero;
  bool _dragging = false;

  ToastEntry<ToastBuilder> get _entry => widget.entry;

  Set<ToastSwipeDirection> get _directions =>
      _entry.slot.placement.dismissDirections;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration:
          widget.theme.animationDuration ?? const Duration(milliseconds: 250),
    )..forward();
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  void _dismiss() => widget.controller.dismiss(_entry.id);

  void _setInteracting(bool value) =>
      widget.controller.setInteracting(_entry.id, value);

  void _onPanUpdate(DragUpdateDetails details) {
    _dragging = true;
    final horizontal =
        _directions.contains(ToastSwipeDirection.left) ||
        _directions.contains(ToastSwipeDirection.right);
    final vertical =
        _directions.contains(ToastSwipeDirection.up) ||
        _directions.contains(ToastSwipeDirection.down);
    _drag = Offset(
      horizontal ? _drag.dx + details.delta.dx : 0,
      vertical ? _drag.dy + details.delta.dy : 0,
    );
  }

  void _onPanEnd(DragEndDetails details) {
    final double dx = _drag.dx;
    final double dy = _drag.dy;
    final bool horizontal = dx.abs() >= dy.abs();
    final double distance = horizontal ? dx.abs() : dy.abs();
    final double velocity = horizontal
        ? details.velocity.pixelsPerSecond.dx.abs()
        : details.velocity.pixelsPerSecond.dy.abs();
    final ToastSwipeDirection direction = horizontal
        ? (dx >= 0 ? ToastSwipeDirection.right : ToastSwipeDirection.left)
        : (dy >= 0 ? ToastSwipeDirection.down : ToastSwipeDirection.up);
    _dragging = false;
    if (_directions.contains(direction) &&
        (distance >= _dismissThreshold || velocity >= _dismissVelocity)) {
      _dismiss();
      return;
    }
    setState(() => _drag = Offset.zero);
  }

  @override
  Widget build(BuildContext context) {
    final ambient = ShadcnTheme.of(context);
    final colors = ambient.colors;
    final theme = widget.theme;
    final border = theme.borderColor?.resolve(colors);
    final borderWidth = theme.borderWidth ?? 0;
    final shadows =
        theme.shadows ??
        (theme.themeShadows ?? ambient.tokens.shadows).shadowLg;

    Widget card = DecoratedBox(
      decoration: BoxDecoration(
        color: theme.background?.resolve(colors),
        borderRadius: theme.borderRadius ?? ambient.borderRadiusMd,
        border: border == null || borderWidth <= 0
            ? null
            : Border.all(color: border, width: borderWidth),
        boxShadow: shadows.isEmpty ? null : shadows,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: theme.maxWidth ?? 380),
        child: Padding(
          padding: theme.padding ?? const EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: DefaultTextStyle.merge(
                  style: TextStyle(color: theme.foreground?.resolve(colors)),
                  child: _entry.data(context),
                ),
              ),
              if (theme.showCloseButton ?? true) ...<Widget>[
                const SizedBox(width: 8),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _dismiss,
                  child: Icon(
                    LucideIcons.x,
                    size: 16,
                    color: colors.mutedForeground,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    card = AnimatedSlide(
      duration: _dragging ? Duration.zero : const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      offset: Offset(_drag.dx / 300, _drag.dy / 200),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: card,
      ),
    );

    if (theme.pauseOnHover ?? true) {
      card = Listener(
        onPointerDown: (_) => _setInteracting(true),
        onPointerUp: (_) => _setInteracting(false),
        onPointerCancel: (_) => _setInteracting(false),
        child: MouseRegion(
          onEnter: (_) => _setInteracting(true),
          onExit: (_) => _setInteracting(false),
          child: card,
        ),
      );
    }

    return FadeTransition(
      opacity: CurvedAnimation(parent: _animation, curve: Curves.easeOut),
      child: card,
    );
  }
}
