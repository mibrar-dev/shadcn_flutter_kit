// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tooltip.dart';

/// _InstantTooltipState defines a reusable type for this registry module.
class _InstantTooltipState extends State<InstantTooltip> {
  final PopoverController _controller = PopoverController();
  OverlayCompleter? _adaptiveCompleter;

  /// Whether to present through the adaptive configuration system.
  ///
  /// Matches upstream: only when explicitly opted in via
  /// [InstantTooltip.adaptiveOverlay] on a mobile platform. Desktop
  /// presentation is unchanged.
  bool _useAdaptive(BuildContext context) {
    return widget.adaptiveOverlay && isMobile(Theme.of(context).platform);
  }

  void _closeAll() {
    _adaptiveCompleter?.remove();
    _adaptiveCompleter = null;
    _controller.close();
  }

  @override
  /// Executes `dispose` behavior for this component/composite.
  void dispose() {
    _adaptiveCompleter?.remove();
    _controller.dispose();
    super.dispose();
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final overlayManager = OverlayManager.of(context);
    return MouseRegion(
      onEnter: (event) {
        _controller.close(true);
        if (_useAdaptive(context)) {
          _adaptiveCompleter?.remove();
          _adaptiveCompleter = showOverlay(
            context,
            TooltipConfiguration(
              alignment: widget.tooltipAlignment,
              anchorAlignment: widget.tooltipAnchorAlignment,
            ),
            builder: widget.tooltipBuilder,
            adaptive: true,
          );
          return;
        }

        /// Creates a `_controller.show` instance.
        _controller.show(
          context: context,
          modal: false,
          builder: widget.tooltipBuilder,
          alignment: widget.tooltipAlignment,
          anchorAlignment: widget.tooltipAnchorAlignment,
          dismissBackdropFocus: false,
          showDuration: Duration.zero,
          hideDuration: Duration.zero,
          overlayBarrier: const OverlayBarrier(barrierColor: Color(0x00000000)),
          handler: OverlayManagerAsTooltipOverlayHandler(
            overlayManager: overlayManager,
          ),
        );
      },
      onExit: (event) {
        _closeAll();
      },
      hitTestBehavior: widget.behavior,
      child: widget.child,
    );
  }
}
