// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tooltip.dart';

/// _TooltipState defines a reusable type for this registry module.
class _TooltipState extends State<Tooltip> {
  final PopoverController _controller = PopoverController();

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Hover(
      waitDuration: widget.waitDuration,
      minDuration: widget.minDuration,
      showDuration: widget.showDuration,
      onHover: (hovered) {
        if (hovered) {
          /// Creates a `_controller.show` instance.
          _controller.show(
            context: context,
            modal: false,
            builder: (context) => widget.tooltip(context),
            alignment: widget.alignment,
            anchorAlignment: widget.anchorAlignment,
            dismissBackdropFocus: false,
            overlayBarrier: const OverlayBarrier(
              barrierColor: Color(0x00000000),
            ),
            handler: OverlayManagerAsTooltipOverlayHandler(
              overlayManager: OverlayManager.of(context),
            ),
          );
        } else {
          _controller.close();
        }
      },
      child: widget.child,
    );
  }
}

/// Tooltip that shows immediately on hover.
