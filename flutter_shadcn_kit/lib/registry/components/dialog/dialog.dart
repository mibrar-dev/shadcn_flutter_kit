import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/captured_wrapper.dart';
import '../../foundation/constants.dart';
import '../../foundation/data.dart';
import '../../primitives/localizations/localizations.dart';
import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import 'dialog_style.dart';

/// Lookup key of the decorated surface of the dialog card.
const ValueKey<String> kDialogSurfaceKey = ValueKey<String>(
  'shadcn.dialog.surface',
);

/// Barrier color used when neither the call nor any theme leg sets one.
const Color kDialogFallbackBarrierColor = Color(0x80000000);

/// Resolves the dialog theme for [context]: defaults, app, scoped, widget leg.
DialogTheme _resolve(BuildContext context, DialogTheme? widgetTheme) =>
    resolveComponentStyle<DialogTheme, DialogTheme>(
      context,
      widget: widgetTheme,
      select: (dialogTheme) => dialogTheme,
      defaults: dialogDefaults,
    );

/// Re-injects the themes and data captured when the dialog was opened.
Widget _wrapCaptured(Widget child, CapturedThemes? themes, CapturedData? data) {
  if (themes != null) child = themes.wrap(child);
  if (data != null) child = data.wrap(child);
  return child;
}

/// Pushes a shadcn modal dialog on a [Navigator] and returns its result.
///
/// The returned future completes with whatever the dialog passes to
/// [Navigator.pop], or `null` when it is dismissed through the barrier, the
/// Escape key or a route removal.
///
/// The dialog stays live while it is open: the card and the barrier resolve
/// [DialogTheme] on every build, so a light/dark or preset change restyles it.
///
/// ```dart
/// final confirmed = await showShadcnDialog<bool>(
///   context: context,
///   builder: (context) => MyContent(
///     onConfirm: () => Navigator.pop(context, true),
///   ),
/// );
/// ```
Future<T?> showShadcnDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool useRootNavigator = true,
  bool barrierDismissible = true,
  ThemedColor? barrierColor,
  String? barrierLabel,
  bool useSafeArea = true,
  RouteSettings? routeSettings,
  TraversalEdgeBehavior traversalEdgeBehavior =
      TraversalEdgeBehavior.closedLoop,
  AlignmentGeometry alignment = Alignment.center,
  bool fullScreen = false,
  DialogTheme? theme,
}) {
  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  // The route resolves every live value inside its own subtree; only the
  // transition duration is fixed here, because the framework reads it while
  // installing the route.
  final style = _resolve(context, theme);
  final duration = style.transitionDuration ?? kDefaultDuration;
  return navigator.push(
    ShadcnDialogRoute<T>(
      builder: builder,
      widgetTheme: theme,
      duration: duration,
      barrierColorOverride: barrierColor,
      barrierLabel: barrierLabel,
      barrierDismissible: barrierDismissible,
      useSafeArea: useSafeArea,
      alignment: alignment,
      fullScreen: fullScreen,
      openerFocus: FocusManager.instance.primaryFocus,
      themes: InheritedTheme.capture(from: context, to: navigator.context),
      data: Data.capture(from: context, to: navigator.context),
      settings: routeSettings,
      traversalEdgeBehavior: traversalEdgeBehavior,
    ),
  );
}

/// Modal route of a shadcn dialog.
///
/// Extends the widgets [ModalRoute] directly: the modal scope, the initial
/// focus and the barrier plumbing all come from the framework route. The card
/// is built by [_DialogShell], the barrier by [_DialogBarrier], and the
/// transition is a scale plus a fade. Both private widgets read this route.
class ShadcnDialogRoute<T> extends ModalRoute<T> {
  /// Creates a dialog route. Only [duration] is resolved by the caller; every
  /// other value is read from this route's subtree on each build.
  ShadcnDialogRoute({
    required this.builder,
    required this.widgetTheme,
    required this.duration,
    required this.barrierDismissible,
    required this.useSafeArea,
    required this.alignment,
    required this.fullScreen,
    required this.openerFocus,
    this.barrierColorOverride,
    this.barrierLabel,
    this.themes,
    this.data,
    super.settings,
    super.traversalEdgeBehavior,
  });

  /// Builds the dialog content (the card itself is the shell).
  final WidgetBuilder builder;

  /// Widget leg of the [DialogTheme] resolver; the other legs are read from
  /// this route's subtree.
  final DialogTheme? widgetTheme;

  /// Open and close transition duration, resolved when the route was pushed.
  final Duration duration;

  /// Barrier color override; `null` resolves [DialogTheme.barrierColor].
  final ThemedColor? barrierColorOverride;

  /// Whether tapping the barrier pops the dialog.
  @override
  final bool barrierDismissible;

  /// Semantic label of the dismissible barrier; `null` resolves
  /// [ShadcnLocalizations.dialogDismiss].
  @override
  final String? barrierLabel;

  /// Whether the content respects the device safe area.
  final bool useSafeArea;

  /// Alignment of the card inside the route when not full screen.
  final AlignmentGeometry alignment;

  /// Whether the dialog fills the route (no radius, border, shadow, inset).
  final bool fullScreen;

  /// Focus node focused before the dialog opened, restored on close.
  final FocusNode? openerFocus;

  /// Themes captured from the opening context. Re-injected into the barrier
  /// and the card, so a theme below the navigator stays visible in the route.
  final CapturedThemes? themes;

  /// Data captured from the opening context.
  final CapturedData? data;

  /// Always null: [buildModalBarrier] resolves the color itself so it follows
  /// the ambient theme.
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

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // Captured themes wrap the shell widget itself, not its build result.
    return _wrapCaptured(_DialogShell(this), themes, data);
  }

  /// Resolves the barrier on every barrier build, so a light/dark switch or a
  /// preset change restyles an open dialog.
  @override
  Widget buildModalBarrier() {
    final barrier = _DialogBarrier(
      this,
      animation: animation,
      curve: barrierCurve,
    );
    return _wrapCaptured(barrier, themes, data);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final scale = CurvedAnimation(
      parent: animation.drive(Tween<double>(begin: 0.7, end: 1.0)),
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
    final opacity = CurvedAnimation(parent: animation, curve: Curves.easeOut);
    return ScaleTransition(
      scale: scale,
      child: FadeTransition(opacity: opacity, child: child),
    );
  }
}

/// Modal barrier of a dialog; resolves its theme on every build.
class _DialogBarrier extends StatelessWidget {
  const _DialogBarrier(
    this.route, {
    required this.animation,
    required this.curve,
  });

  final ShadcnDialogRoute<dynamic> route;

  /// Route animation driving the fade in of the barrier color.
  final Animation<double>? animation;

  /// Curve of that fade.
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final ambient = ShadcnTheme.of(context);
    final style = _resolve(context, route.widgetTheme);
    final resolved =
        (route.barrierColorOverride ?? style.barrierColor)?.resolve(
          ambient.colors,
        ) ??
        kDialogFallbackBarrierColor;
    final Animation<Color?> fade = animation == null
        ? AlwaysStoppedAnimation<Color?>(resolved)
        : ColorTween(
            begin: resolved.withValues(alpha: 0),
            end: resolved,
          ).chain(CurveTween(curve: curve)).animate(animation!);
    final barrier = AnimatedModalBarrier(
      color: fade,
      dismissible: route.barrierDismissible,
      semanticsLabel:
          route.barrierLabel ?? ShadcnLocalizations.of(context).dialogDismiss,
      barrierSemanticsDismissible: true,
    );
    return barrier;
  }
}

/// Private shell of a dialog. Not part of the public API.
class _DialogShell extends StatefulWidget {
  const _DialogShell(this.route);

  final ShadcnDialogRoute<dynamic> route;

  @override
  State<_DialogShell> createState() => _DialogShellState();
}

class _DialogShellState extends State<_DialogShell> {
  final FocusScopeNode _focusNode = FocusScopeNode(debugLabel: 'ShadcnDialog');

  ShadcnDialogRoute<dynamic> get route => widget.route;

  @override
  void dispose() {
    _focusNode.dispose();
    final opener = route.openerFocus;
    if (opener != null && opener.canRequestFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (opener.context != null && opener.canRequestFocus) {
          opener.requestFocus();
        }
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ambient = ShadcnTheme.of(context);
    final style = _resolve(context, route.widgetTheme);
    final colors = ambient.colors;
    final density = ambient.density.baseContentPadding * ambient.scaling;
    final fullScreen = route.fullScreen;
    final borderWidth = fullScreen ? 0.0 : style.borderWidth ?? 0.0;
    final borderColor = style.borderColor?.resolve(colors);
    final shadows = fullScreen
        ? null
        : style.shadows ??
              (style.themeShadows ?? ambient.tokens.shadows).shadowLg;
    Widget card = DecoratedBox(
      key: kDialogSurfaceKey,
      decoration: BoxDecoration(
        color: style.background?.resolve(colors),
        borderRadius: fullScreen
            ? null
            : style.borderRadius ?? ambient.borderRadiusLg,
        border: borderWidth == 0 || borderColor == null
            ? null
            : Border.all(color: borderColor, width: borderWidth),
        boxShadow: shadows == null || shadows.isEmpty ? null : shadows,
      ),
      child: Padding(
        padding: resolveEdgeInsets(style.padding ?? EdgeInsets.zero, density),
        child: Builder(builder: route.builder),
      ),
    );
    final maxWidth = fullScreen ? null : style.maxWidth;
    if (maxWidth != null) {
      card = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: card,
      );
    }
    if (!fullScreen) {
      card = Align(alignment: route.alignment, child: card);
      // Gap between the screen edge and the card; zero when full screen.
      final inset = resolveEdgeInsets(
        style.insetPadding ?? EdgeInsets.zero,
        density,
      );
      card = Padding(padding: inset, child: card);
    }
    if (route.useSafeArea) {
      card = SafeArea(child: card);
    }
    card = FocusScope(
      node: _focusNode,
      autofocus: true,
      onKeyEvent: _onKeyEvent,
      child: card,
    );
    card = Shortcuts(
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          DismissIntent: CallbackAction<DismissIntent>(onInvoke: _dismiss),
        },
        child: card,
      ),
    );
    return card;
  }

  /// Traps Tab inside the dialog: cycles through its own focusable descendants
  /// and never leaks focus to the route below.
  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (event.logicalKey != LogicalKeyboardKey.tab) {
      return KeyEventResult.ignored;
    }
    final targets = _focusNode.traversalDescendants.toList();
    if (targets.isEmpty) return KeyEventResult.ignored;
    final current = FocusManager.instance.primaryFocus;
    final index = current == null ? -1 : targets.indexOf(current);
    final backwards = HardwareKeyboard.instance.isShiftPressed;
    final closedLoop =
        (route.traversalEdgeBehavior ?? TraversalEdgeBehavior.closedLoop) ==
        TraversalEdgeBehavior.closedLoop;
    var next = index;
    if (index < 0) {
      next = backwards ? targets.length - 1 : 0;
    } else if (backwards) {
      next = index - 1;
      if (next < 0) next = closedLoop ? targets.length - 1 : index;
    } else {
      next = index + 1;
      if (next >= targets.length) next = closedLoop ? 0 : index;
    }
    if (next != index) targets[next].requestFocus();
    return KeyEventResult.handled;
  }

  /// Escape closes the dialog, but only when the barrier is dismissible.
  Object? _dismiss(DismissIntent intent) {
    if (!route.barrierDismissible) return null;
    final navigator = Navigator.of(context);
    if (navigator.canPop()) navigator.pop();
    return null;
  }
}
