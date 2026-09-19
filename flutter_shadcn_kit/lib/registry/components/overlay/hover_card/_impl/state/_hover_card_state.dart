// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../hover_card.dart';

/// _HoverCardState defines a reusable type for this registry module.
class _HoverCardState extends State<HoverCard> {
  /// Stores `_controller` state/configuration for this implementation.
  late PopoverController _controller;

  /// Tracks a mobile adaptive presentation, if one is open.
  OverlayCompleter? _adaptiveCompleter;

  /// Stores `_hoverCount` state/configuration for this implementation.
  int _hoverCount = 0;

  /// Whether to present through the adaptive configuration system.
  ///
  /// Matches upstream: only when explicitly opted in via
  /// [HoverCard.adaptiveOverlay] on a mobile platform. Desktop
  /// presentation is unchanged.
  bool _useAdaptive(BuildContext context) {
    return widget.adaptiveOverlay && isMobile(Theme.of(context).platform);
  }

  /// Whether any presentation (desktop popover or adaptive) is open.
  bool get _hasOpenPresentation =>
      _adaptiveCompleter != null || _controller.hasOpenPopover;

  void _closeAll() {
    _adaptiveCompleter?.remove();
    _adaptiveCompleter = null;
    _controller.close();
  }

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    _controller = widget.controller ?? PopoverController();
  }

  @override
  /// Executes `didUpdateWidget` behavior for this component/composite.
  void didUpdateWidget(covariant HoverCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _controller = widget.controller ?? PopoverController();
    }
  }

  @override
  /// Executes `dispose` behavior for this component/composite.
  void dispose() {
    _adaptiveCompleter?.remove();
    _controller.disposePopovers();
    super.dispose();
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final compTheme = widget.theme ?? ComponentTheme.maybeOf<HoverCardTheme>(context);
    final debounce = styleValue(
      widgetValue: widget.debounce,
      themeValue: compTheme?.debounce,
      defaultValue: const Duration(milliseconds: 500),
    );
    final wait = styleValue(
      widgetValue: widget.wait,
      themeValue: compTheme?.wait,
      defaultValue: const Duration(milliseconds: 500),
    );
    final popoverAlignment = styleValue(
      widgetValue: widget.popoverAlignment,
      themeValue: compTheme?.popoverAlignment,
      defaultValue: Alignment.topCenter,
    );
    final anchorAlignment = styleValue(
      widgetValue: widget.anchorAlignment,
      themeValue: compTheme?.anchorAlignment,
      defaultValue: Alignment.bottomCenter,
    );
    final popoverOffset = styleValue(
      widgetValue: widget.popoverOffset,
      themeValue: compTheme?.popoverOffset,
      defaultValue: const Offset(0, 8),
    );
    final behavior = styleValue(
      widgetValue: widget.behavior,
      themeValue: compTheme?.behavior,
      defaultValue: HitTestBehavior.deferToChild,
    );

    return MouseRegion(
      hitTestBehavior: behavior,
      onEnter: (_) {
        /// Stores `count` state/configuration for this implementation.
        int count = ++_hoverCount;

        /// Creates a `Future.delayed` instance.
        Future.delayed(wait, () {
          if (count == _hoverCount &&
              !_hasOpenPresentation &&
              context.mounted) {
            /// Creates a `_showPopover` instance.
            _showPopover(
              context,
              alignment: popoverAlignment,
              anchorAlignment: anchorAlignment,
              offset: popoverOffset,
              debounce: debounce,
            );
          }
        });
      },
      onExit: (_) {
        /// Stores `count` state/configuration for this implementation.
        int count = ++_hoverCount;

        /// Creates a `Future.delayed` instance.
        Future.delayed(debounce, () {
          if (count == _hoverCount) {
            _closeAll();
          }
        });
      },
      child: GestureDetector(
        onLongPress: () {
          /// Creates a `_showPopover` instance.
          _showPopover(
            context,
            alignment: popoverAlignment,
            anchorAlignment: anchorAlignment,
            offset: popoverOffset,
            debounce: debounce,
          );
        },
        child: widget.child,
      ),
    );
  }

  void _showPopover(
    BuildContext context, {
    required AlignmentGeometry alignment,
    AlignmentGeometry? anchorAlignment,
    required Offset offset,
    required Duration debounce,
  }) {
    if (_useAdaptive(context)) {
      // Mobile adaptive presentation via the configuration system
      // (fixed, non-following overlay), matching upstream which presents
      // hover cards through TooltipConfiguration.
      _adaptiveCompleter?.remove();
      _adaptiveCompleter = showOverlay(
        context,
        TooltipConfiguration(
          alignment: alignment,
          anchorAlignment: anchorAlignment,
          offset: offset,
        ),
        builder: (context) {
          return MouseRegion(
            onEnter: (_) {
              _hoverCount++;
            },
            onExit: (_) {
              /// Stores `count` state/configuration for this implementation.
              int count = ++_hoverCount;

              /// Creates a `Future.delayed` instance.
              Future.delayed(debounce, () {
                if (count == _hoverCount) {
                  _closeAll();
                }
              });
            },
            child: widget.hoverBuilder(context),
          );
        },
        adaptive: true,
      );
      return;
    }
    /// Stores `handler` state/configuration for this implementation.
    OverlayHandler? handler = widget.handler;
    if (handler == null) {
      final overlayManager = OverlayManager.of(context);
      handler = OverlayManagerAsTooltipOverlayHandler(
        overlayManager: overlayManager,
      );
    }

    /// Creates a `_controller.show` instance.
    _controller.show(
      context: context,
      builder: (context) {
        return MouseRegion(
          onEnter: (_) {
            _hoverCount++;
          },
          onExit: (_) {
            /// Stores `count` state/configuration for this implementation.
            int count = ++_hoverCount;

            /// Creates a `Future.delayed` instance.
            Future.delayed(debounce, () {
              if (count == _hoverCount) {
                _closeAll();
              }
            });
          },
          child: widget.hoverBuilder(context),
        );
      },
      alignment: alignment,
      anchorAlignment: anchorAlignment,
      offset: offset,
      handler: handler,
    );
  }
}
