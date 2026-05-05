part of '../../dialog.dart';

/// FullScreenDialogOverlayHandler defines a reusable type for this registry module.
class FullScreenDialogOverlayHandler extends OverlayHandler {
  /// Checks if the current context is within a dialog overlay.
  ///
  /// Returns `true` if the context is inside a dialog managed by
  /// this overlay handler.
  static bool isDialogOverlay(BuildContext context) {
    return Model.maybeOf<bool>(context, #shadcn_flutter_dialog_overlay) == true;
  }

  /// Creates a [FullScreenDialogOverlayHandler].
  ///
  /// Example:
  /// ```dart
  /// const FullScreenDialogOverlayHandler()
  /// ```
  const FullScreenDialogOverlayHandler();
  @override
  OverlayCompleter<T> show<T>({
    required BuildContext context,
    required AlignmentGeometry alignment,
    required WidgetBuilder builder,
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
  }) {
    var navigatorState = Navigator.of(context, rootNavigator: rootOverlay);
    final CapturedThemes themes = InheritedTheme.capture(
      from: context,
      to: navigatorState.context,
    );
    final CapturedData data = Data.capture(
      from: context,
      to: navigatorState.context,
    );
    var dialogRoute = DialogRoute<T>(
      context: context,
      fullScreen: true,
      builder: (context) {
        final theme = Theme.of(context);
/// Stores `surfaceOpacity` state/configuration for this implementation.
        final surfaceOpacity = theme.surfaceOpacity;
        var child = _DialogOverlayWrapper(
          route: ModalRoute.of(context) as DialogRoute<T>,
          child: Builder(
            builder: (context) {
              return builder(context);
            },
          ),
        );
        if (overlayBarrier != null) {
          return MultiModel(
            data: const [Model(#shadcn_flutter_dialog_overlay, true)],
            child: ModalBackdrop(
              modal: modal,
              surfaceClip: ModalBackdrop.shouldClipSurface(surfaceOpacity),
              borderRadius: overlayBarrier.borderRadius,
              padding: overlayBarrier.padding,
              barrierColor:
                  overlayBarrier.barrierColor ??
/// Creates a `Color.fromRGBO` instance.
                  const Color.fromRGBO(0, 0, 0, 0.8),
              child: child,
            ),
          );
        }
        return MultiModel(
          data: const [Model(#shadcn_flutter_dialog_overlay, true)],
          child: child,
        );
      },
      themes: themes,
      barrierDismissible: barrierDismissable,
      barrierColor: overlayBarrier == null
          ? const Color.fromRGBO(0, 0, 0, 0.8)
          : Colors.transparent,
      barrierLabel: 'Dismiss',
      useSafeArea: true,
      data: data,
      traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return _buildShadcnDialogTransitions(
          context,
          BorderRadius.zero,
          Alignment.center,
          animation,
          secondaryAnimation,
          true,
          child,
        );
      },
      alignment: Alignment.center,
    );
    navigatorState.push(dialogRoute);
    return DialogOverlayCompleter(dialogRoute);
  }
}

/// Completer that manages the lifecycle of a dialog overlay.
///
/// Provides control over dialog animations, completion status, and disposal.
/// Wraps a [DialogRoute] to offer a consistent interface for managing
/// dialog lifecycles through the overlay system.
///
/// Features:
/// - Animation state monitoring
/// - Future-based completion handling
/// - Proper resource disposal
/// - Route management integration
///
/// Example:
/// ```dart
/// final completer = DialogOverlayCompleter(dialogRoute);
/// await completer.future; // Wait for dialog completion
/// completer.remove(); // Programmatically close dialog
/// ```
