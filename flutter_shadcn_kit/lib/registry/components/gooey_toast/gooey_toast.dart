// The `gooey_toast` component: gooey-style transient notifications whose
// compact pill morphs into an expanded body. The stack and controller are the
// shared `primitives/toast_queue`; the metaball machinery lives in
// `primitives/gooey/`. This file owns the API, the queue wiring and the card.

import 'package:flutter/widgets.dart';

import '../../primitives/gooey/gooey_content.dart';
import '../../primitives/gooey/gooey_stack.dart';
import '../../primitives/gooey/gooey_surface.dart';
import '../../primitives/gooey/gooey_swipe.dart';
import '../../primitives/toast_queue/toast_entry.dart';
import '../../primitives/toast_queue/toast_exit.dart';
import '../../primitives/toast_queue/toast_placement.dart';
import '../../primitives/toast_queue/toast_queue.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'gooey_toast_style.dart';

export 'gooey_toast_style.dart';
export '../../primitives/toast_queue/toast_entry.dart' show ToastEntry;
export '../../primitives/toast_queue/toast_placement.dart'
    show ToastPlacement, ToastSwipeDirection;

/// Horizontal anchor of a gooey toast.
enum GooeyToastPosition {
  left,
  center,
  right;

  /// Horizontal alignment of the compact pill inside the surface.
  Alignment get alignment => switch (this) {
    GooeyToastPosition.left => Alignment.centerLeft,
    GooeyToastPosition.center => Alignment.center,
    GooeyToastPosition.right => Alignment.centerRight,
  };
}

/// Vertical growth direction of the expanded body.
enum GooeyToastExpandDirection { top, bottom }

/// Strategy when a new toast is shown in an occupied slot.
enum GooeyToastNewToastBehavior {
  /// Adds the new toast to the same slot stack.
  stack,

  /// Removes the existing toasts in the slot first.
  dismissPrevious,

  /// Updates the newest toast in the slot in place.
  transition,
}

/// Auto expand/collapse policy of a shown toast.
class GooeyAutopilot {
  /// Creates an autopilot policy.
  const GooeyAutopilot({this.expandDelay, this.collapseDelay});

  final Duration? expandDelay;

  final Duration? collapseDelay;

  Duration get resolvedExpandDelay =>
      expandDelay ?? const Duration(milliseconds: 150);

  Duration get resolvedCollapseDelay =>
      collapseDelay ?? const Duration(milliseconds: 4000);
}

class GooeyToastAction {
  /// Creates an action.
  const GooeyToastAction({required this.label, required this.onPressed});

  final String label;

  final VoidCallback onPressed;
}

/// Content and behaviour of one gooey toast.
class GooeyToastOptions {
  /// Creates toast options.
  const GooeyToastOptions({
    required this.title,
    this.description,
    this.state = GooeyToastState.success,
    this.position = GooeyToastPosition.left,
    this.expandDirection = GooeyToastExpandDirection.bottom,
    this.duration,
    this.icon,
    this.expandedChild,
    this.action,
    this.autopilot = const GooeyAutopilot(),
    this.persistUntilDismissed = false,
    this.onExpansionChanged,
  });

  final String title;

  final String? description;

  final GooeyToastState state;

  final GooeyToastPosition position;

  final GooeyToastExpandDirection expandDirection;

  final Duration? duration;

  final IconData? icon;

  final Widget? expandedChild;

  final GooeyToastAction? action;

  final GooeyAutopilot? autopilot;

  final bool persistUntilDismissed;

  final ValueChanged<bool>? onExpansionChanged;

  ToastPlacement get placement {
    final bool top = expandDirection == GooeyToastExpandDirection.bottom;
    return switch (position) {
      GooeyToastPosition.left =>
        top ? ToastPlacement.topLeading : ToastPlacement.bottomLeading,
      GooeyToastPosition.center =>
        top ? ToastPlacement.topCenter : ToastPlacement.bottomCenter,
      GooeyToastPosition.right =>
        top ? ToastPlacement.topTrailing : ToastPlacement.bottomTrailing,
    };
  }
}

/// Owns a gooey toast stack; a thin `show` surface over [ToastQueue].
///
/// Defaults to [singlePerSlot] `false` so the default behaviour is
/// [GooeyToastNewToastBehavior.stack]; `dismissPrevious` is handled per call.
class GooeyToastController extends ToastQueue<GooeyToastOptions> {
  GooeyToastController({
    super.defaultDuration = const Duration(milliseconds: 6000),
    super.singlePerSlot = false,
  });

  String showGooeyToast(
    GooeyToastOptions options, {
    String? id,
    GooeyToastNewToastBehavior behavior = GooeyToastNewToastBehavior.stack,
    Duration? duration,
    bool autoDismiss = true,
    VoidCallback? onDismissed,
  }) {
    final ToastSlot slot = ToastSlot(options.placement);
    final Duration? resolvedDuration = duration ?? options.duration;
    final bool resolvedAutoDismiss =
        autoDismiss && !options.persistUntilDismissed;
    if (behavior == GooeyToastNewToastBehavior.transition) {
      final List<ToastEntry<GooeyToastOptions>> live = entriesIn(slot)
          .where((ToastEntry<GooeyToastOptions> entry) => !entry.isExiting)
          .toList(growable: false);
      if (live.isNotEmpty) {
        update(
          live.first.id,
          data: options,
          duration: resolvedDuration,
          autoDismiss: resolvedAutoDismiss,
        );
        return live.first.id;
      }
    } else if (behavior == GooeyToastNewToastBehavior.dismissPrevious) {
      dismissSlot(slot);
    }
    return show(
      placement: options.placement,
      data: options,
      id: id,
      duration: resolvedDuration,
      autoDismiss: resolvedAutoDismiss,
      onDismissed: onDismissed == null ? null : (String _) => onDismissed(),
    ).id;
  }
}

class _GooeyToastScope extends InheritedWidget {
  const _GooeyToastScope({
    required this.controller,
    required this.theme,
    required super.child,
  });

  final GooeyToastController controller;
  final GooeyToastTheme theme;

  @override
  bool updateShouldNotify(_GooeyToastScope oldWidget) =>
      !identical(oldWidget.controller, controller) || oldWidget.theme != theme;
}

/// The nearest [GooeyToastController] from a [GooeyToastLayer].
GooeyToastController? gooeyToastControllerOf(BuildContext context) =>
    context.dependOnInheritedWidgetOfExactType<_GooeyToastScope>()?.controller;

String showGooeyToast(
  BuildContext context,
  GooeyToastOptions options, {
  String? id,
  GooeyToastNewToastBehavior behavior = GooeyToastNewToastBehavior.stack,
  Duration? duration,
  VoidCallback? onDismissed,
}) {
  final _GooeyToastScope? scope = context
      .dependOnInheritedWidgetOfExactType<_GooeyToastScope>();
  assert(scope != null, 'No GooeyToastLayer found above this context');
  return scope!.controller.showGooeyToast(
    options,
    id: id,
    behavior: behavior,
    duration: duration ?? scope.theme.duration,
    onDismissed: onDismissed,
  );
}

/// Hosts a [GooeyToastController] and renders its stack above [child].
class GooeyToastLayer extends StatefulWidget {
  /// Creates a gooey toast layer.
  const GooeyToastLayer({
    super.key,
    required this.child,
    this.controller,
    this.theme,
  });

  /// Content below the toasts.
  final Widget child;

  /// Injected controller; one is owned when null.
  final GooeyToastController? controller;

  /// Widget-leg theme override.
  final GooeyToastTheme? theme;

  @override
  State<GooeyToastLayer> createState() => _GooeyToastLayerState();
}

class _GooeyToastLayerState extends State<GooeyToastLayer> {
  GooeyToastController? _owned;

  GooeyToastController get _controller => widget.controller ?? _owned!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _owned = GooeyToastController();
    }
  }

  @override
  void didUpdateWidget(covariant GooeyToastLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == oldWidget.controller) {
      return;
    }
    if (oldWidget.controller == null) {
      _owned?.dispose();
      _owned = null;
    }
    if (widget.controller == null) {
      _owned = GooeyToastController();
    }
  }

  @override
  void dispose() {
    _owned?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GooeyToastTheme theme =
        resolveComponentStyle<GooeyToastTheme, GooeyToastTheme>(
          context,
          widget: widget.theme,
          select: (GooeyToastTheme t) => t,
          defaults: gooeyToastDefaults,
        );
    return _GooeyToastScope(
      controller: _controller,
      theme: theme,
      child: GooeyStack<GooeyToastOptions>(
        queue: _controller,
        child: widget.child,
        builder:
            (
              BuildContext context,
              ToastEntry<GooeyToastOptions> entry,
              int index,
            ) => _GooeyToastCard(
              key: ValueKey<String>(entry.id),
              entry: entry,
              controller: _controller,
              theme: theme,
            ),
      ),
    );
  }
}

class _GooeyToastCard extends StatelessWidget {
  const _GooeyToastCard({
    super.key,
    required this.entry,
    required this.controller,
    required this.theme,
  });

  final ToastEntry<GooeyToastOptions> entry;
  final GooeyToastController controller;
  final GooeyToastTheme theme;

  @override
  Widget build(BuildContext context) {
    final GooeyToastOptions options = entry.data;
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final ShadcnColors colors = ambient.colors;
    final Color tone = options.state.tone(theme, colors);
    final TextStyle titleStyle = theme.titleStyle!.copyWith(
      color: theme.titleStyle!.color ?? tone,
    );
    final ThemedColor description = theme.descriptionColor!;
    final TextStyle descriptionStyle = theme.descriptionStyle!.copyWith(
      color: theme.descriptionStyle!.color ?? description.resolve(colors),
    );
    final double surfaceBlur = (ambient.surfaceBlur ?? 0)
        .clamp(0.0, 36.0)
        .toDouble();
    final Color baseFill = theme.fill!.resolve(colors);
    final double blurFactor = 1 - (surfaceBlur / 36) * 0.35;
    final double fillAlpha =
        (baseFill.a *
                (ambient.surfaceOpacity ?? 1).clamp(0.0, 1.0) *
                blurFactor)
            .clamp(0.0, 1.0)
            .toDouble();
    final bool loading = options.state == GooeyToastState.loading;
    final GooeyAutopilot? autopilot = options.autopilot;
    final Widget surface = GooeySurface(
      title: options.title,
      titleStyle: titleStyle,
      morphKey: '${options.title}|${options.state.name}',
      leading: GooeyStateIcon(
        icon: options.icon ?? options.state.icon,
        color: tone,
        loading: loading,
      ),
      description: options.expandedChild == null ? options.description : null,
      descriptionStyle: descriptionStyle,
      body: options.expandedChild,
      action: options.action == null
          ? null
          : GooeyActionChip(
              label: options.action!.label,
              color: tone,
              onPressed: options.action!.onPressed,
            ),
      expandable: !loading,
      width: theme.width!,
      fill: ThemedColor.value(baseFill.withValues(alpha: 1.0)),
      fillAlpha: fillAlpha,
      roundness: theme.shapeStyle!.roundness(
        theme.roundness!,
        kGooeySurfacePillHeight,
      ),
      compactAlignment: options.position.alignment,
      expandUp: options.expandDirection == GooeyToastExpandDirection.top,
      enableGooeyBlur: theme.enableGooeyBlur!,
      surfaceBlur: surfaceBlur,
      openDuration: theme.animationStyle!.duration,
      openCurve: theme.animationStyle!.curve,
      bodyAnimation: theme.bodyAnimationStyle!.animation(),
      expandDelay: autopilot?.resolvedExpandDelay,
      collapseDelay: autopilot?.resolvedCollapseDelay,
      onInteractionChanged: (bool interacting) =>
          controller.setInteracting(entry.id, interacting),
      onExpansionChanged: options.onExpansionChanged,
    );
    return ToastExitTransition<GooeyToastOptions>(
      queue: controller,
      entry: entry,
      direction: entry.slot.placement.exitDirection,
      child: GooeySwipe(
        directions: entry.slot.placement.dismissDirections,
        onDismissed: () => controller.dismiss(entry.id),
        child: surface,
      ),
    );
  }
}
