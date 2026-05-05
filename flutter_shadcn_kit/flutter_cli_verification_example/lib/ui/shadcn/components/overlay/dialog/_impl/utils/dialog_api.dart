part of '../../dialog.dart';

Future<T?> showDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool useRootNavigator = true,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useSafeArea = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  TraversalEdgeBehavior? traversalEdgeBehavior,
  AlignmentGeometry? alignment,
  bool fullScreen = false,
}) {
  var navigatorState = Navigator.of(context, rootNavigator: useRootNavigator);
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
    builder: (context) {
      return _DialogOverlayWrapper(
        route: ModalRoute.of(context) as DialogRoute<T>,
        child: Builder(
          builder: (context) {
            return builder(context);
          },
        ),
      );
    },
    themes: themes,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor ?? const Color.fromRGBO(0, 0, 0, 0),
    barrierLabel: barrierLabel,
    useSafeArea: useSafeArea,
    settings: routeSettings,
    anchorPoint: anchorPoint,
    data: data,
    traversalEdgeBehavior:
        traversalEdgeBehavior ?? TraversalEdgeBehavior.closedLoop,
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return _buildShadcnDialogTransitions(
        context,
        BorderRadius.zero,
        alignment ?? Alignment.center,
        animation,
        secondaryAnimation,
        fullScreen,
        child,
      );
    },
    alignment: alignment ?? Alignment.center,
  );
  return navigatorState.push(dialogRoute);
}
