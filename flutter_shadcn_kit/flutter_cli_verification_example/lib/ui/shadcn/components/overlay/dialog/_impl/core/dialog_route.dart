part of '../../dialog.dart';

/// DialogRoute defines a reusable type for this registry module.
class DialogRoute<T> extends RawDialogRoute<T> {
  /// Captured data from the launching context.
  final CapturedData? data;

  /// Alignment for positioning the dialog.
  final AlignmentGeometry alignment;

  /// Whether the dialog should display in full-screen mode.
  final bool fullScreen;

  /// Creates a [DialogRoute].
  ///
  /// Parameters:
  /// - [context] (`BuildContext`, required): Build context.
  /// - [builder] (`WidgetBuilder`, required): Dialog content builder.
  /// - [themes] (`CapturedThemes?`, optional): Captured theme data.
  /// - [barrierColor] (`Color`, default: transparent): Barrier color.
  /// - [barrierDismissible] (`bool?`, optional): Whether tapping barrier dismisses dialog.
  /// - [barrierLabel] (`String?`, optional): Semantic label for barrier.
  /// - [useSafeArea] (`bool`, default: `true`): Whether to respect safe area.
  /// - [settings] (`RouteSettings?`, optional): Route settings.
  /// - [anchorPoint] (`Offset?`, optional): Anchor point for route.
  /// - [traversalEdgeBehavior] (`TraversalEdgeBehavior?`, optional): Traversal behavior.
  /// - [alignment] (`AlignmentGeometry`, required): Dialog alignment.
  /// - [transitionBuilder] (`RouteTransitionsBuilder`, required): Transition builder.
  /// - [fullScreen] (`bool`, default: `false`): Full-screen mode.
  /// - [data] (`CapturedData?`, optional): Captured data.
  DialogRoute({
    required BuildContext context,
    required WidgetBuilder builder,
    CapturedThemes? themes,
    super.barrierColor = const Color.fromRGBO(0, 0, 0, 0),
    super.barrierDismissible,
    String? barrierLabel,
    bool useSafeArea = true,
    super.settings,
    super.anchorPoint,
    super.traversalEdgeBehavior,
    required this.alignment,
    required super.transitionBuilder,
    this.fullScreen = false,
    this.data,
  }) : super(
         pageBuilder:
             (
               BuildContext buildContext,
               Animation<double> animation,
               Animation<double> secondaryAnimation,
             ) {
               final Widget pageChild = Builder(
                 builder: (context) {
                   final theme = Theme.of(context);
/// Stores `scaling` state/configuration for this implementation.
                   final scaling = theme.scaling;
                   return Padding(
                     padding: fullScreen
                         ? EdgeInsets.zero
                         : EdgeInsets.all(
                             theme.density.baseContentPadding * scaling,
                           ),
                     child: builder(context),
                   );
                 },
               );
               Widget dialog = themes?.wrap(pageChild) ?? pageChild;
               if (data != null) {
                 dialog = data.wrap(dialog);
               }
               if (useSafeArea) {
                 dialog = SafeArea(child: dialog);
               }
               if (!fullScreen) {
                 dialog = Align(
                   alignment: alignment,
                   child: dialog,
                 );
               }
               return dialog;
             },
         barrierLabel: barrierLabel ?? 'Dismiss',
         transitionDuration: const Duration(milliseconds: 150),
       );
}
