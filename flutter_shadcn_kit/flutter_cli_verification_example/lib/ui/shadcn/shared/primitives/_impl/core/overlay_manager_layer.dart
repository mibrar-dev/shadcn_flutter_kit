part of '../../overlay.dart';

/// OverlayManagerLayer defines a reusable type for this registry module.
class OverlayManagerLayer extends StatefulWidget {
  /// Handler for popover overlays.
  final OverlayHandler popoverHandler;

  /// Handler for tooltip overlays.
  final OverlayHandler tooltipHandler;

  /// Handler for menu overlays.
  final OverlayHandler menuHandler;

  /// Child widget wrapped by overlay management.
  final Widget child;

  /// Creates an overlay manager layer.
  ///
  /// Parameters:
  /// - [popoverHandler] (OverlayHandler, required): Handler for popover overlays
  /// - [tooltipHandler] (OverlayHandler, required): Handler for tooltip overlays
  /// - [menuHandler] (OverlayHandler, required): Handler for menu overlays
  /// - [child] (Widget, required): Child widget
  const OverlayManagerLayer({
    super.key,
    required this.popoverHandler,
    required this.tooltipHandler,
    required this.menuHandler,
    required this.child,
  });

  @override
/// Executes `createState` behavior for this component/composite.
  State<OverlayManagerLayer> createState() => _OverlayManagerLayerState();
}
