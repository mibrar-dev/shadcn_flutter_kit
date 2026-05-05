part of '../../overlay.dart';

/// OverlayManager defines a reusable type for this registry module.
abstract class OverlayManager implements OverlayHandler {
/// Stores `_current` state/configuration for this implementation.
  static OverlayManager? _current;
/// Stores `_didWarnFallback` state/configuration for this implementation.
  static bool _didWarnFallback = false;

/// Executes `_register` behavior for this component/composite.
  static void _register(OverlayManager manager) {
    _current = manager;
  }

/// Executes `_unregister` behavior for this component/composite.
  static void _unregister(OverlayManager manager) {
    if (_current == manager) {
      _current = null;
    }
  }

  /// Gets the overlay manager from the widget tree.
  ///
  /// Searches for an [OverlayManager] in the build context and throws
  /// an assertion error if not found.
  ///
  /// Parameters:
  /// - [context] (BuildContext, required): Build context
  ///
  /// Returns the [OverlayManager] instance.
  static OverlayManager of(BuildContext context) {
    var manager = Data.maybeOf<OverlayManager>(context) ?? _current;
    if (manager == null) {
/// Creates a `assert` instance.
      assert(() {
        if (!_didWarnFallback) {
          _didWarnFallback = true;
/// Creates a `debugPrint` instance.
          debugPrint(
            'shadcn_flutter: No OverlayManagerLayer found. '
            'Falling back to per-widget overlay handling. '
            'Wrap your app with OverlayManagerLayer or ShadcnLayer to avoid '
            'multiple overlay stacks and improve performance.',
          );
        }
        return true;
      }());
      return const _FallbackOverlayManager();
    }
    return manager;
  }

  @override
  OverlayCompleter<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    AlignmentGeometry alignment = Alignment.center,
    Offset? position,
    AlignmentGeometry? anchorAlignment,
    PopoverConstraint widthConstraint = PopoverConstraint.flexible,
    PopoverConstraint heightConstraint = PopoverConstraint.flexible,
    Key? key,
    bool rootOverlay = true,
    bool modal = true,
    bool barrierDismissable = true,
    Clip clipBehavior = Clip.none,
    Object? regionGroupId,
    Offset? offset,
    AlignmentGeometry? transitionAlignment,
    EdgeInsetsGeometry? margin,
    bool follow = true,
    bool consumeOutsideTaps = true,
    ValueChanged<PopoverOverlayWidgetState>? onTickFollow,
    bool allowInvertHorizontal = true,
    bool allowInvertVertical = true,
    bool dismissBackdropFocus = true,
    Duration? showDuration,
    Duration? dismissDuration,
    OverlayBarrier? overlayBarrier,
    LayerLink? layerLink,
  });

  /// Shows a tooltip overlay.
  ///
  /// Specialized method for displaying tooltips with appropriate defaults
  /// for tooltip behavior (non-modal, brief display, etc.).
  ///
  /// Parameters similar to [show] method. See [show] for full parameter documentation.
  ///
  /// Returns an [OverlayCompleter] for managing the tooltip lifecycle.
  OverlayCompleter<T?> showTooltip<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    AlignmentGeometry alignment = Alignment.center,
    Offset? position,
    AlignmentGeometry? anchorAlignment,
    PopoverConstraint widthConstraint = PopoverConstraint.flexible,
    PopoverConstraint heightConstraint = PopoverConstraint.flexible,
    Key? key,
    bool rootOverlay = true,
    bool modal = true,
    bool barrierDismissable = true,
    Clip clipBehavior = Clip.none,
    Object? regionGroupId,
    Offset? offset,
    AlignmentGeometry? transitionAlignment,
    EdgeInsetsGeometry? margin,
    bool follow = true,
    bool consumeOutsideTaps = true,
    ValueChanged<PopoverOverlayWidgetState>? onTickFollow,
    bool allowInvertHorizontal = true,
    bool allowInvertVertical = true,
    bool dismissBackdropFocus = true,
    Duration? showDuration,
    Duration? dismissDuration,
    OverlayBarrier? overlayBarrier,
    LayerLink? layerLink,
  });

  /// Shows a menu overlay.
  ///
  /// Specialized method for displaying menus with appropriate defaults
  /// for menu behavior (dismissible, follows anchor, etc.).
  ///
  /// Parameters similar to [show] method. See [show] for full parameter documentation.
  ///
  /// Returns an [OverlayCompleter] for managing the menu lifecycle.
  OverlayCompleter<T?> showMenu<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    AlignmentGeometry alignment = Alignment.center,
    Offset? position,
    AlignmentGeometry? anchorAlignment,
    PopoverConstraint widthConstraint = PopoverConstraint.flexible,
    PopoverConstraint heightConstraint = PopoverConstraint.flexible,
    Key? key,
    bool rootOverlay = true,
    bool modal = true,
    bool barrierDismissable = true,
    Clip clipBehavior = Clip.none,
    Object? regionGroupId,
    Offset? offset,
    AlignmentGeometry? transitionAlignment,
    EdgeInsetsGeometry? margin,
    bool follow = true,
    bool consumeOutsideTaps = true,
    ValueChanged<PopoverOverlayWidgetState>? onTickFollow,
    bool allowInvertHorizontal = true,
    bool allowInvertVertical = true,
    bool dismissBackdropFocus = true,
    Duration? showDuration,
    Duration? dismissDuration,
    OverlayBarrier? overlayBarrier,
    LayerLink? layerLink,
  });
}
