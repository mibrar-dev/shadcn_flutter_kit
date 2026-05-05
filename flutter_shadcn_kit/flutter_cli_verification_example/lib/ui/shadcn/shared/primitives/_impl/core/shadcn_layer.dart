part of '../../overlay.dart';

/// ShadcnLayer defines a reusable type for this registry module.
class ShadcnLayer extends StatelessWidget {
/// Creates a `ShadcnLayer` instance.
  const ShadcnLayer({
    super.key,
    required this.child,
    this.theme,
    this.popoverHandler = OverlayHandler.popover,
    this.tooltipHandler = OverlayHandler.popover,
    this.menuHandler = OverlayHandler.popover,
  });

/// Stores `child` state/configuration for this implementation.
  final Widget child;
/// Stores `theme` state/configuration for this implementation.
  final ThemeData? theme;
/// Stores `popoverHandler` state/configuration for this implementation.
  final OverlayHandler popoverHandler;
/// Stores `tooltipHandler` state/configuration for this implementation.
  final OverlayHandler tooltipHandler;
/// Stores `menuHandler` state/configuration for this implementation.
  final OverlayHandler menuHandler;

  @override
/// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
/// Stores `wrapped` state/configuration for this implementation.
    Widget wrapped = child;
    if (theme != null) {
      wrapped = Theme(data: theme!, child: wrapped);
    }
    final hasManager =
        Data.maybeOf<OverlayManager>(context) ?? OverlayManager._current;
    if (hasManager != null) {
      return wrapped;
    }
    return OverlayManagerLayer(
      popoverHandler: popoverHandler,
      tooltipHandler: tooltipHandler,
      menuHandler: menuHandler,
      child: wrapped,
    );
  }
}

/// Layer widget managing different overlay handlers for the application.
///
/// Provides centralized overlay management for popovers, tooltips, and menus
/// with customizable handlers for each type.
