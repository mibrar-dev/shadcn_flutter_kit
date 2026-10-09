// The edge-panel modal route. Extends the widgets [ModalRoute]; the panel
// shell lives in `drawer_shell.dart`. The component supplies the live theme
// through [ShadcnDrawerRoute.themeOf].

import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../localizations/localizations.dart';
import 'drawer_route.dart';
import 'drawer_shell.dart';

const Color kDrawerFallbackBarrierColor = Color(0x80000000);

class ShadcnDrawerRoute<T> extends ModalRoute<T> {
  ShadcnDrawerRoute({
    required this.builder,
    required this.position,
    required this.themeOf,
    required this.duration,
    required this.barrierDismissible,
    required this.useSafeArea,
    required this.expands,
    required this.draggable,
    required this.showDragHandle,
    required this.isSheet,
    required this.openerFocus,
    this.borderRadius,
    this.maxSize,
    this.barrierLabel,
    this.themes,
    this.data,
    super.settings,
    super.traversalEdgeBehavior,
  });

  final WidgetBuilder builder;

  final OverlayPosition position;

  final DrawerRouteTheme Function(BuildContext context) themeOf;

  final Duration duration;

  /// Whether the barrier tap / Escape pops the panel.
  @override
  final bool barrierDismissible;

  /// Semantic label of the dismissible barrier.
  @override
  final String? barrierLabel;

  final bool useSafeArea;
  final bool expands;
  final bool draggable;
  final bool showDragHandle;
  final bool isSheet;
  final FocusNode? openerFocus;
  final BorderRadius? borderRadius;
  final double? maxSize;
  final CapturedThemes? themes;
  final CapturedData? data;

  @override
  Color? get barrierColor => null;

  @override
  bool get opaque => false;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => duration;

  @override
  Duration get reverseTransitionDuration => duration;

  AnimationController? get dragController => controller;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _wrapPanel(DrawerRouteShell(this), themes, data);
  }

  @override
  Widget buildModalBarrier() {
    return _wrapPanel(
      Builder(
        builder: (BuildContext context) {
          final DrawerRouteTheme style = themeOf(context);
          final ShadcnColors colors = ShadcnTheme.of(context).colors;
          final Color color =
              style.barrierColor?.resolve(colors) ??
              kDrawerFallbackBarrierColor;
          // Fade with the route so the barrier follows a scrub and stays live
          // across a light/dark or preset switch.
          return AnimatedModalBarrier(
            color: ColorTween(begin: color.withValues(alpha: 0), end: color)
                .animate(
                  CurvedAnimation(
                    parent:
                        animation ?? const AlwaysStoppedAnimation<double>(1),
                    curve: Curves.easeOut,
                  ),
                ),
            dismissible: barrierDismissible,
            semanticsLabel:
                barrierLabel ?? ShadcnLocalizations.of(context).dialogDismiss,
            barrierSemanticsDismissible: true,
          );
        },
      ),
      themes,
      data,
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // The panel slides by its own extent inside the shell, so it follows a
    // scrub exactly; the route adds no transition of its own.
    return child;
  }
}

Widget _wrapPanel(Widget child, CapturedThemes? themes, CapturedData? data) {
  if (themes != null) child = themes.wrap(child);
  if (data != null) child = data.wrap(child);
  return child;
}
