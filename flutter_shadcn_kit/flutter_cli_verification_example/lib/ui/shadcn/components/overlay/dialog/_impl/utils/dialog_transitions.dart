part of '../../dialog.dart';

Widget _buildShadcnDialogTransitions(
  BuildContext context,
  BorderRadiusGeometry borderRadius,
  AlignmentGeometry alignment,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  bool fullScreen,
  Widget child,
) {
  var scaleTransition = ScaleTransition(
    scale: CurvedAnimation(
      parent: animation.drive(Tween<double>(begin: 0.7, end: 1.0)),
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    ),
    child: FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: child,
    ),
  );
  return FocusScope(
    child: fullScreen
        ? MultiModel(
            data: const [Model(ModalContainer.kFullScreenMode, true)],
            child: scaleTransition,
          )
        : Align(alignment: alignment, child: scaleTransition),
  );
}

/// Displays a dialog using the shadcn_flutter design system.
///
/// Shows a modal dialog with consistent styling and animation behavior.
/// The dialog is displayed over the current route and blocks interaction
/// with the content below. Supports both centered and full-screen modes.
///
/// Features:
/// - Consistent design system integration
/// - Smooth scale and fade animations
/// - Configurable alignment and barriers
/// - Theme and data inheritance
/// - Safe area handling
/// - Custom transition animations
///
/// Parameters:
/// - [context] (BuildContext, required): build context for navigation
/// - [builder] (WidgetBuilder, required): function that builds dialog content
/// - [useRootNavigator] (bool, default: true): whether to use root navigator
/// - [barrierDismissible] (bool, default: true): tap outside to dismiss
/// - [barrierColor] (Color?, optional): color of the backdrop barrier
/// - [barrierLabel] (String?, optional): semantic label for the barrier
/// - [useSafeArea] (bool, default: true): respect device safe areas
/// - [routeSettings] (RouteSettings?, optional): settings for the route
/// - [anchorPoint] (Offset?, optional): anchor point for transitions
/// - [traversalEdgeBehavior] (TraversalEdgeBehavior?, optional): focus traversal
/// - [alignment] (AlignmentGeometry?, optional): dialog alignment, defaults to center
/// - [fullScreen] (bool, default: false): whether to display in full-screen mode
///
/// Returns:
/// A [Future] that resolves to the result passed to [Navigator.pop].
///
/// Example:
/// ```dart
/// final result = await showDialog<String>(
///   context: context,
///   builder: (context) => AlertDialog(
///     title: Text('Confirm'),
///     content: Text('Are you sure?'),
///     actions: [
///       TextButton(
///         onPressed: () => Navigator.pop(context, 'cancel'),
///         child: Text('Cancel'),
///       ),
///       TextButton(
///         onPressed: () => Navigator.pop(context, 'ok'),
///         child: Text('OK'),
///       ),
///     ],
///   ),
/// );
/// ```
