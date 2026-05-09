// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../hover_card.dart';

/// _HoverCardState defines a reusable type for this registry module.
class _HoverCardState extends State<HoverCard> {
  /// Stores `_controller` state/configuration for this implementation.
  late PopoverController _controller;

  /// Stores `_hoverCount` state/configuration for this implementation.
  int _hoverCount = 0;

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
    _controller.disposePopovers();
    super.dispose();
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final compTheme = ComponentTheme.maybeOf<HoverCardTheme>(context);
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
              !_controller.hasOpenPopover &&
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
            _controller.close();
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
                _controller.close();
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
