// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../overlay_configuration.dart';

/// Describes *what* overlay to show and *how*, independent of the specific
/// mechanism (popover, drawer, sheet, dialog, menu, tooltip) — upstream
/// parity with `shadcn_flutter`'s `OverlayConfiguration`.
///
/// The content to show is *not* part of the configuration — it's supplied
/// separately as the [WidgetBuilder] argument to [show]/[showOverlay], so a
/// configuration object can be built, overridden, or passed around
/// independently of what it's going to display.
///
/// Registry adaptation: the native upstream presentation mechanisms
/// (drawer/sheet/dialog routes) don't exist in the registry's
/// `OverlayManager`/`PopoverController` architecture, so [show] delegates to
/// a [PopoverController] presentation with the closest mapping (documented
/// per subclass; arch-divergent overrides are marked `@Deprecated`). The
/// goal of this additive port is API compile-parity, not pixel-parity.
abstract class OverlayConfiguration {
  /// Creates an [OverlayConfiguration].
  const OverlayConfiguration();

  /// Presents the overlay using this configuration's mechanism, with
  /// [builder] as its content.
  OverlayCompleter<T?> show<T>(BuildContext context, WidgetBuilder builder);

  /// Returns an equivalent configuration adapted for the current platform,
  /// e.g. a [PopoverConfiguration] becomes a [DrawerConfiguration] on
  /// mobile. Returns `this` by default (no adaptation).
  OverlayConfiguration adaptiveConversion(BuildContext context) => this;

  /// A copy of this configuration whose [adaptiveConversion] is a no-op,
  /// regardless of the `adaptive` flag passed where it's shown.
  OverlayConfiguration get nonAdaptive => this;

  /// Finds the [OverlayConfiguration] responsible for presenting the overlay
  /// [context] is inside of, if any.
  static OverlayConfiguration? maybeOf(BuildContext context) =>
      Data.maybeOf<OverlayConfiguration>(context);
}

/// Unified entry point for presenting any [OverlayConfiguration] — upstream
/// parity with `shadcn_flutter`'s `showOverlay`.
///
/// When [adaptive] is true (the default), [configuration] is first passed
/// through [OverlayConfiguration.adaptiveConversion].
OverlayCompleter<T?> showOverlay<T>(
  BuildContext context,
  OverlayConfiguration configuration, {
  required WidgetBuilder builder,
  bool adaptive = true,
}) {
  final resolved = adaptive
      ? configuration.adaptiveConversion(context)
      : configuration;
  return resolved.show<T>(context, builder);
}

/// Adapter bridging a [PopoverController] presentation to the shared
/// [OverlayCompleter] interface, so configuration [show] methods can return
/// the registry-native completer type.
class DelegatedOverlayCompleter<T> implements OverlayCompleter<T> {
  final PopoverController _controller;
  final Completer<T?> _done = Completer<T?>();
  bool _completed = false;

  DelegatedOverlayCompleter(this._controller);

  void _complete([T? value]) {
    if (_completed) return;
    _completed = true;
    if (!_done.isCompleted) _done.complete(value);
  }

  @override
  void remove() => close();

  @override
  void dispose() {
    _controller.dispose();
    _complete();
  }

  @override
  bool get isCompleted => _completed;

  @override
  bool get isAnimationCompleted => _completed;

  @override
  Future<T?> get future => _done.future;

  @override
  Future<void> get animationFuture => _done.future.then((_) {});

  /// Closes the delegated overlay (upstream-parity convenience; not part of
  /// the registry-native [OverlayCompleter] interface).
  void close([bool immediate = false]) {
    _controller.close(immediate);
    _complete();
  }

  /// Schedules closure for the next frame (upstream-parity convenience).
  void closeLater() {
    _controller.closeLater();
    // Completion is reported when the controller's show-future resolves.
  }

  /// Closes with a result value (upstream-parity convenience).
  void closeWithResult<X>([X? value]) {
    _controller.close();
    if (value is T) {
      _complete(value);
    } else {
      _complete();
    }
  }
}

/// Presents [builder] through a fresh [PopoverController] and wraps it in a
/// [DelegatedOverlayCompleter], publishing [configuration] into the
/// content's subtree so `OverlayConfiguration.maybeOf(context)` keeps
/// working inside overlay content.
DelegatedOverlayCompleter<T?> _presentWithPopover<T>(
  BuildContext context,
  OverlayConfiguration configuration,
  WidgetBuilder builder, {
  required AlignmentGeometry alignment,
  AlignmentGeometry? anchorAlignment,
  PopoverConstraint widthConstraint = PopoverConstraint.flexible,
  PopoverConstraint heightConstraint = PopoverConstraint.flexible,
  bool modal = true,
  Offset? offset,
  EdgeInsetsGeometry? margin,
  bool follow = true,
  bool consumeOutsideTaps = true,
  bool allowInvertHorizontal = true,
  bool allowInvertVertical = true,
  bool dismissBackdropFocus = true,
  Duration? showDuration,
  Duration? dismissDuration,
  OverlayBarrier? overlayBarrier,
}) {
  final controller = PopoverController();
  final completer = DelegatedOverlayCompleter<T?>(controller);
  Widget wrappedBuilder(BuildContext innerContext) {
    return Data<OverlayConfiguration>.inherit(
      data: configuration,
      child: Builder(builder: builder),
    );
  }

  controller
      .show<T?>(
        context: context,
        builder: wrappedBuilder,
        alignment: alignment,
        anchorAlignment: anchorAlignment,
        widthConstraint: widthConstraint,
        heightConstraint: heightConstraint,
        modal: modal,
        offset: offset,
        margin: margin,
        follow: follow,
        consumeOutsideTaps: consumeOutsideTaps,
        allowInvertHorizontal: allowInvertHorizontal,
        allowInvertVertical: allowInvertVertical,
        dismissBackdropFocus: dismissBackdropFocus,
        showDuration: showDuration,
        hideDuration: dismissDuration,
        overlayBarrier: overlayBarrier,
      )
      .then(completer._complete);
  return completer;
}

/// [OverlayConfiguration] that presents its content as a popover — upstream
/// parity with `shadcn_flutter`'s `PopoverConfiguration`.
///
/// This is the closest-to-native configuration in the registry port:
/// [show] delegates to [PopoverController.show] with a 1:1 parameter
/// mapping. On mobile, [adaptiveConversion] maps to a bottom
/// [DrawerConfiguration] (matching upstream adaptive behavior).
class PopoverConfiguration extends OverlayConfiguration {
  /// The [Anchor] to position/track against, if using anchor-based
  /// positioning instead of the [BuildContext] passed to [show].
  /// Accepted for upstream parity; the registry popover anchors to the
  /// calling context (stored, documented).
  final Anchor? anchor;

  /// Popover alignment relative to the anchor.
  final AlignmentGeometry alignment;

  /// Explicit position, overrides [alignment] if provided. Accepted for
  /// upstream parity (stored; the registry popover resolves position from
  /// [alignment]/[offset]).
  final Offset? position;

  /// Anchor alignment point.
  final AlignmentGeometry? anchorAlignment;

  /// Width constraint mode.
  final PopoverConstraint widthConstraint;

  /// Height constraint mode.
  final PopoverConstraint heightConstraint;

  /// Widget key for the popover overlay. Accepted for upstream parity
  /// (stored; the registry manages its own handler keys).
  final Key? key;

  /// Whether to use the root overlay. Accepted for upstream parity
  /// (stored; the registry resolves the manager from context).
  final bool rootOverlay;

  /// Whether the popover is modal.
  final bool modal;

  /// Whether tapping the barrier dismisses the popover.
  final bool barrierDismissable;

  /// Clipping behavior for the popover content. Accepted for upstream
  /// parity (stored; documented).
  final Clip clipBehavior;

  /// Region grouping identifier. Accepted for upstream parity (stored).
  final Object? regionGroupId;

  /// Additional position offset.
  final Offset? offset;

  /// Transition origin alignment.
  final AlignmentGeometry? transitionAlignment;

  /// Popover margin.
  final EdgeInsetsGeometry? margin;

  /// Whether the popover follows the anchor if it moves.
  final bool follow;

  /// Whether outside taps are consumed.
  final bool consumeOutsideTaps;

  /// Callback invoked on every follow tick.
  final ValueChanged<PopoverOverlayWidgetState>? onTickFollow;

  /// Whether horizontal inversion is allowed when space is constrained.
  final bool allowInvertHorizontal;

  /// Whether vertical inversion is allowed when space is constrained.
  final bool allowInvertVertical;

  /// Whether to dismiss when backdrop gains focus.
  final bool dismissBackdropFocus;

  /// Show animation duration.
  final Duration? showDuration;

  /// Dismiss animation duration.
  final Duration? dismissDuration;

  /// Custom barrier configuration.
  final OverlayBarrier? overlayBarrier;

  /// Creates a [PopoverConfiguration].
  const PopoverConfiguration({
    this.anchor,
    required this.alignment,
    this.position,
    this.anchorAlignment,
    this.widthConstraint = PopoverConstraint.flexible,
    this.heightConstraint = PopoverConstraint.flexible,
    this.key,
    this.rootOverlay = true,
    this.modal = true,
    this.barrierDismissable = true,
    this.clipBehavior = Clip.none,
    this.regionGroupId,
    this.offset,
    this.transitionAlignment,
    this.margin,
    this.follow = true,
    this.consumeOutsideTaps = true,
    this.onTickFollow,
    this.allowInvertHorizontal = true,
    this.allowInvertVertical = true,
    this.dismissBackdropFocus = true,
    this.showDuration,
    this.dismissDuration,
    this.overlayBarrier,
  });

  @override
  OverlayConfiguration adaptiveConversion(BuildContext context) {
    if (isMobile(Theme.of(context).platform)) {
      return DrawerConfiguration(
        anchor: anchor,
        position: OverlayPosition.bottom,
        barrierDismissible: barrierDismissable,
      );
    }
    return this;
  }

  @override
  OverlayConfiguration get nonAdaptive => PopoverConfiguration(
        anchor: anchor,
        alignment: alignment,
        position: position,
        anchorAlignment: anchorAlignment,
        widthConstraint: widthConstraint,
        heightConstraint: heightConstraint,
        key: key,
        rootOverlay: rootOverlay,
        modal: modal,
        barrierDismissable: barrierDismissable,
        clipBehavior: clipBehavior,
        regionGroupId: regionGroupId,
        offset: offset,
        transitionAlignment: transitionAlignment,
        margin: margin,
        follow: follow,
        consumeOutsideTaps: consumeOutsideTaps,
        onTickFollow: onTickFollow,
        allowInvertHorizontal: allowInvertHorizontal,
        allowInvertVertical: allowInvertVertical,
        dismissBackdropFocus: dismissBackdropFocus,
        showDuration: showDuration,
        dismissDuration: dismissDuration,
        overlayBarrier: overlayBarrier,
      );

  @override
  OverlayCompleter<T?> show<T>(BuildContext context, WidgetBuilder builder) {
    return _presentWithPopover<T>(
      context,
      this,
      builder,
      alignment: alignment,
      anchorAlignment: anchorAlignment,
      widthConstraint: widthConstraint,
      heightConstraint: heightConstraint,
      modal: modal,
      offset: offset,
      margin: margin,
      follow: follow,
      consumeOutsideTaps: consumeOutsideTaps,
      allowInvertHorizontal: allowInvertHorizontal,
      allowInvertVertical: allowInvertVertical,
      dismissBackdropFocus: dismissBackdropFocus,
      showDuration: showDuration,
      dismissDuration: dismissDuration,
      overlayBarrier: overlayBarrier,
    );
  }
}

/// [OverlayConfiguration] that presents its content as a drawer — upstream
/// parity with `shadcn_flutter`'s `DrawerConfiguration`.
///
/// Registry adaptation: the native drawer route mechanism doesn't exist in
/// the `OverlayManager`/`PopoverController` architecture, so [show]
/// delegates to a modal popover presentation. Marked deprecated to signal
/// the behavioral difference; for native drawer behavior use the `drawer`
/// component directly.
class DrawerConfiguration extends OverlayConfiguration {
  /// The [Anchor] to resolve against. Accepted for upstream parity (stored).
  final Anchor? anchor;

  /// The edge the drawer slides in from. Accepted for upstream parity
  /// (stored; the delegated popover aligns to the matching edge).
  final OverlayPosition position;

  /// Whether the drawer expands to fill available space. Accepted for
  /// upstream parity (stored).
  final bool expands;

  /// Whether the drawer can be dragged to dismiss. Accepted for upstream
  /// parity (stored).
  final bool draggable;

  /// Whether tapping the barrier dismisses the drawer.
  final bool barrierDismissible;

  /// Custom backdrop builder. Accepted for upstream parity (stored).
  final WidgetBuilder? backdropBuilder;

  /// Whether to respect device safe areas. Accepted for upstream parity
  /// (stored).
  final bool useSafeArea;

  /// Whether to show a drag handle. Accepted for upstream parity (stored).
  final bool? showDragHandle;

  /// Corner radius for the drawer. Accepted for upstream parity (stored).
  final BorderRadiusGeometry? borderRadius;

  /// Size of the drag handle. Accepted for upstream parity (stored).
  final Size? dragHandleSize;

  /// Whether to scale/transform the backdrop. Accepted for upstream parity
  /// (stored).
  final bool transformBackdrop;

  /// Opacity for surface effects. Accepted for upstream parity (stored).
  final double? surfaceOpacity;

  /// Blur intensity for surface effects. Accepted for upstream parity
  /// (stored).
  final double? surfaceBlur;

  /// Color of the modal barrier.
  final Color? barrierColor;

  /// Custom animation controller. Accepted for upstream parity (stored).
  final AnimationController? animationController;

  /// Whether to automatically open on creation. Accepted for upstream
  /// parity (stored).
  final bool autoOpen;

  /// Size constraints for the drawer.
  final BoxConstraints? constraints;

  /// Alignment within constraints.
  final AlignmentGeometry? alignment;

  /// Creates a [DrawerConfiguration].
  const DrawerConfiguration({
    this.anchor,
    this.position = OverlayPosition.bottom,
    this.expands = false,
    this.draggable = true,
    this.barrierDismissible = true,
    this.backdropBuilder,
    this.useSafeArea = true,
    this.showDragHandle,
    this.borderRadius,
    this.dragHandleSize,
    this.transformBackdrop = true,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.barrierColor,
    this.animationController,
    this.autoOpen = true,
    this.constraints,
    this.alignment,
  });

  AlignmentGeometry _edgeAlignment() {
    return switch (position) {
      OverlayPosition.left => Alignment.centerLeft,
      OverlayPosition.right => Alignment.centerRight,
      OverlayPosition.top => Alignment.topCenter,
      OverlayPosition.bottom => Alignment.bottomCenter,
      OverlayPosition.start => AlignmentDirectional.centerStart,
      OverlayPosition.end => AlignmentDirectional.centerEnd,
    };
  }

  @override
  @Deprecated(
    'Delegates to a modal PopoverController presentation; '
    'for native drawer behavior use the drawer component directly.',
  )
  OverlayCompleter<T?> show<T>(BuildContext context, WidgetBuilder builder) {
    return _presentWithPopover<T>(
      context,
      this,
      builder,
      alignment: alignment ?? _edgeAlignment(),
      modal: true,
      overlayBarrier: barrierColor == null
          ? null
          : OverlayBarrier(barrierColor: barrierColor),
    );
  }
}

/// [OverlayConfiguration] that presents its content as a minimally-styled,
/// full-extent sheet — upstream parity with `shadcn_flutter`'s
/// `SheetConfiguration`.
///
/// Already the mobile-appropriate mechanism upstream, so
/// [adaptiveConversion] is the identity. Registry adaptation: [show]
/// delegates to a modal popover presentation (marked deprecated; for native
/// sheet behavior use the `drawer` component or `pinned_sheet`).
class SheetConfiguration extends OverlayConfiguration {
  /// The [Anchor] to resolve against. Accepted for upstream parity (stored).
  final Anchor? anchor;

  /// The edge the sheet slides in from. Accepted for upstream parity
  /// (stored; the delegated popover aligns to the matching edge).
  final OverlayPosition position;

  /// Whether tapping the barrier dismisses the sheet.
  final bool barrierDismissible;

  /// Whether to transform the backdrop. Accepted for upstream parity
  /// (stored).
  final bool transformBackdrop;

  /// Custom backdrop builder. Accepted for upstream parity (stored).
  final WidgetBuilder? backdropBuilder;

  /// Color of the modal barrier.
  final Color? barrierColor;

  /// Whether the sheet can be dragged to dismiss. Accepted for upstream
  /// parity (stored).
  final bool draggable;

  /// Custom animation controller. Accepted for upstream parity (stored).
  final AnimationController? animationController;

  /// Whether to automatically open on creation. Accepted for upstream
  /// parity (stored).
  final bool autoOpen;

  /// Size constraints for the sheet.
  final BoxConstraints? constraints;

  /// Alignment within constraints.
  final AlignmentGeometry? alignment;

  /// Whether to respect device safe areas. Accepted for upstream parity
  /// (stored).
  final bool useSafeArea;

  /// Creates a [SheetConfiguration].
  const SheetConfiguration({
    this.anchor,
    this.position = OverlayPosition.bottom,
    this.barrierDismissible = true,
    this.transformBackdrop = false,
    this.backdropBuilder,
    this.barrierColor,
    this.draggable = false,
    this.animationController,
    this.autoOpen = true,
    this.constraints,
    this.alignment,
    this.useSafeArea = false,
  });

  AlignmentGeometry _edgeAlignment() {
    return switch (position) {
      OverlayPosition.left => Alignment.centerLeft,
      OverlayPosition.right => Alignment.centerRight,
      OverlayPosition.top => Alignment.topCenter,
      OverlayPosition.bottom => Alignment.bottomCenter,
      OverlayPosition.start => AlignmentDirectional.centerStart,
      OverlayPosition.end => AlignmentDirectional.centerEnd,
    };
  }

  @override
  @Deprecated(
    'Delegates to a modal PopoverController presentation; '
    'for native sheet behavior use pinned_sheet or the drawer component.',
  )
  OverlayCompleter<T?> show<T>(BuildContext context, WidgetBuilder builder) {
    return _presentWithPopover<T>(
      context,
      this,
      builder,
      alignment: alignment ?? _edgeAlignment(),
      modal: true,
      overlayBarrier: barrierColor == null
          ? null
          : OverlayBarrier(barrierColor: barrierColor),
    );
  }
}

/// [OverlayConfiguration] that presents its content as a modal dialog —
/// upstream parity with `shadcn_flutter`'s `DialogConfiguration`.
///
/// Dialogs are an intentional choice regardless of platform, so
/// [adaptiveConversion] is the identity. Registry adaptation: [show]
/// delegates to a centered modal popover presentation (marked deprecated;
/// for native dialogs use the `dialog`/`alert_dialog` components).
class DialogConfiguration extends OverlayConfiguration {
  /// Whether to use the root navigator. Accepted for upstream parity
  /// (stored).
  final bool useRootNavigator;

  /// Whether tapping outside dismisses the dialog.
  final bool barrierDismissible;

  /// Color of the backdrop barrier.
  final Color? barrierColor;

  /// Semantic label for the barrier. Accepted for upstream parity (stored).
  final String? barrierLabel;

  /// Whether to respect device safe areas. Accepted for upstream parity
  /// (stored).
  final bool useSafeArea;

  /// Settings for the route. Accepted for upstream parity (stored).
  final RouteSettings? routeSettings;

  /// Anchor point for transitions. Accepted for upstream parity (stored).
  final Offset? anchorPoint;

  /// Focus traversal edge behavior. Accepted for upstream parity (stored).
  final TraversalEdgeBehavior? traversalEdgeBehavior;

  /// Dialog alignment, defaults to center.
  final AlignmentGeometry? alignment;

  /// Whether to display in full-screen mode. Accepted for upstream parity
  /// (stored).
  final bool fullScreen;

  /// Creates a [DialogConfiguration].
  const DialogConfiguration({
    this.useRootNavigator = true,
    this.barrierDismissible = true,
    this.barrierColor,
    this.barrierLabel,
    this.useSafeArea = true,
    this.routeSettings,
    this.anchorPoint,
    this.traversalEdgeBehavior,
    this.alignment,
    this.fullScreen = false,
  });

  @override
  @Deprecated(
    'Delegates to a centered modal PopoverController presentation; '
    'for native dialogs use the dialog/alert_dialog components.',
  )
  OverlayCompleter<T?> show<T>(BuildContext context, WidgetBuilder builder) {
    return _presentWithPopover<T>(
      context,
      this,
      builder,
      alignment: alignment ?? Alignment.center,
      modal: true,
      overlayBarrier: OverlayBarrier(
        barrierColor:
            barrierColor ?? const Color.fromRGBO(0, 0, 0, 0.5),
      ),
    );
  }
}

/// [OverlayConfiguration] that presents its content as a menu — upstream
/// parity with `shadcn_flutter`'s `MenuConfiguration`.
///
/// Presents as an anchored popover on desktop and as a bottom sheet on
/// mobile upstream. Registry adaptation: [show] branches the same way —
/// mobile delegates to a bottom [SheetConfiguration]-style popover, desktop
/// to a [PopoverConfiguration]-style popover (marked deprecated; for native
/// menus use the `menu` component).
class MenuConfiguration extends OverlayConfiguration {
  /// Menu alignment relative to the anchor.
  final AlignmentGeometry alignment;

  /// Explicit position, overrides [alignment] if provided. Accepted for
  /// upstream parity (stored).
  final Offset? position;

  /// Anchor alignment point.
  final AlignmentGeometry? anchorAlignment;

  /// Width constraint mode.
  final PopoverConstraint widthConstraint;

  /// Height constraint mode.
  final PopoverConstraint heightConstraint;

  /// Widget key for the menu overlay. Accepted for upstream parity (stored).
  final Key? key;

  /// Whether to use the root overlay. Accepted for upstream parity (stored).
  final bool rootOverlay;

  /// Whether the menu is modal.
  final bool modal;

  /// Whether tapping the barrier dismisses the menu.
  final bool barrierDismissable;

  /// Clipping behavior. Accepted for upstream parity (stored).
  final Clip clipBehavior;

  /// Region grouping identifier. Accepted for upstream parity (stored).
  final Object? regionGroupId;

  /// Additional position offset.
  final Offset? offset;

  /// Transition origin alignment.
  final AlignmentGeometry? transitionAlignment;

  /// Menu margin.
  final EdgeInsetsGeometry? margin;

  /// Whether the menu follows the anchor if it moves.
  final bool follow;

  /// Whether outside taps are consumed.
  final bool consumeOutsideTaps;

  /// Callback invoked on every follow tick.
  final ValueChanged<PopoverOverlayWidgetState>? onTickFollow;

  /// Whether horizontal inversion is allowed when space is constrained.
  final bool allowInvertHorizontal;

  /// Whether vertical inversion is allowed when space is constrained.
  final bool allowInvertVertical;

  /// Whether to dismiss when backdrop gains focus.
  final bool dismissBackdropFocus;

  /// Show animation duration.
  final Duration? showDuration;

  /// Dismiss animation duration.
  final Duration? dismissDuration;

  /// Custom barrier configuration.
  final OverlayBarrier? overlayBarrier;

  /// Creates a [MenuConfiguration].
  const MenuConfiguration({
    this.alignment = Alignment.center,
    this.position,
    this.anchorAlignment,
    this.widthConstraint = PopoverConstraint.flexible,
    this.heightConstraint = PopoverConstraint.flexible,
    this.key,
    this.rootOverlay = true,
    this.modal = true,
    this.barrierDismissable = true,
    this.clipBehavior = Clip.none,
    this.regionGroupId,
    this.offset,
    this.transitionAlignment,
    this.margin,
    this.follow = true,
    this.consumeOutsideTaps = true,
    this.onTickFollow,
    this.allowInvertHorizontal = true,
    this.allowInvertVertical = true,
    this.dismissBackdropFocus = true,
    this.showDuration,
    this.dismissDuration,
    this.overlayBarrier,
  });

  @override
  @Deprecated(
    'Delegates to a PopoverController presentation; '
    'for native menus use the menu component.',
  )
  OverlayCompleter<T?> show<T>(BuildContext context, WidgetBuilder builder) {
    if (isMobile(Theme.of(context).platform)) {
      return _presentWithPopover<T>(
        context,
        this,
        builder,
        alignment: Alignment.bottomCenter,
        modal: modal,
      );
    }
    return _presentWithPopover<T>(
      context,
      this,
      builder,
      alignment: alignment,
      anchorAlignment: anchorAlignment,
      widthConstraint: widthConstraint,
      heightConstraint: heightConstraint,
      modal: modal,
      offset: offset,
      margin: margin,
      follow: follow,
      consumeOutsideTaps: consumeOutsideTaps,
      allowInvertHorizontal: allowInvertHorizontal,
      allowInvertVertical: allowInvertVertical,
      dismissBackdropFocus: dismissBackdropFocus,
      showDuration: showDuration,
      dismissDuration: dismissDuration,
      overlayBarrier: overlayBarrier,
    );
  }
}

/// [OverlayConfiguration] that presents its content as a tooltip — upstream
/// parity with `shadcn_flutter`'s `TooltipConfiguration`.
///
/// Presents as a real popover (`modal: false`) on desktop and as a
/// simplified fixed-position overlay on mobile upstream. Registry
/// adaptation: both branches delegate to a non-modal popover presentation
/// (tooltips never become bottom drawers, matching upstream).
class TooltipConfiguration extends OverlayConfiguration {
  /// The [Anchor] to resolve against. Accepted for upstream parity (stored).
  final Anchor? anchor;

  /// Tooltip alignment relative to the anchor.
  final AlignmentGeometry alignment;

  /// Explicit position, overrides [alignment] if provided. Accepted for
  /// upstream parity (stored).
  final Offset? position;

  /// Anchor alignment point.
  final AlignmentGeometry? anchorAlignment;

  /// Additional position offset.
  final Offset? offset;

  /// Whether the tooltip follows the anchor if it moves. Only honored on
  /// desktop; the mobile presentation never follows (upstream parity).
  final bool follow;

  /// Widget key for the tooltip overlay. Accepted for upstream parity
  /// (stored).
  final Key? key;

  /// Show animation duration.
  final Duration? showDuration;

  /// Dismiss animation duration.
  final Duration? dismissDuration;

  /// Creates a [TooltipConfiguration].
  const TooltipConfiguration({
    this.anchor,
    this.alignment = Alignment.center,
    this.position,
    this.anchorAlignment,
    this.offset,
    this.follow = true,
    this.key,
    this.showDuration,
    this.dismissDuration,
  });

  @override
  OverlayCompleter<T?> show<T>(BuildContext context, WidgetBuilder builder) {
    final mobile = isMobile(Theme.of(context).platform);
    return _presentWithPopover<T>(
      context,
      this,
      builder,
      alignment: alignment,
      anchorAlignment: anchorAlignment,
      modal: false,
      offset: offset,
      follow: mobile ? false : follow,
      consumeOutsideTaps: false,
      dismissBackdropFocus: false,
      showDuration: showDuration,
      dismissDuration: dismissDuration,
    );
  }
}
