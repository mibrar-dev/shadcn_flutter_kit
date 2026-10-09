// The `page_route` component: the widgets-only replacement for
// `MaterialPageRoute` / `MaterialPage`.
//
// Ported from `components/navigation/page_route/**`. Fixes: the old
// `canTransitionTo` returned false for every route that was not a
// `ShadcnPageRoute`, so pushing a dialog (or any other route) on top of a page
// skipped its exit transition; and the two `static final Animatable` fields
// were lazily-initialised global state.

import 'package:flutter/widgets.dart';

/// How long a [ShadcnPageRoute] takes to push or pop.
const Duration kShadcnPageTransitionDuration = Duration(milliseconds: 300);

/// The shadcn page transition: a fade combined with a short vertical slide.
///
/// Shared by [ShadcnPageRoute] and [ShadcnPage] so a route and a declarative
/// page look identical. Built from one [SlideTransition], so a page adds
/// exactly one [Transform] to the tree.
///
/// The tween pairs are instance fields rather than `static final`: they are
/// `Animatable`s, which cannot be `const`, and a lazily-initialised static
/// would be global mutable state.
class ShadcnPageTransition extends StatelessWidget {
  /// Creates a shadcn page transition.
  const ShadcnPageTransition({
    super.key,
    required this.animation,
    required this.child,
  });

  /// Drives the incoming page.
  final Animation<double> animation;

  /// The page content.
  final Widget child;

  /// The fade curve.
  static const Curve _curve = Curves.easeOutCubic;

  /// How far the incoming page starts below its final position.
  static const Offset _slideFrom = Offset(0, 0.02);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation.drive(CurveTween(curve: _curve)),
      child: SlideTransition(
        position: animation.drive(
          Tween<Offset>(
            begin: _slideFrom,
            end: Offset.zero,
          ).chain(CurveTween(curve: _curve)),
        ),
        child: child,
      ),
    );
  }
}

/// A route that displays a full-screen page with the shadcn transition.
///
/// The registry replacement for `MaterialPageRoute`; it depends on nothing
/// outside `package:flutter/widgets.dart`.
///
/// ```dart
/// Navigator.of(context).push(
///   ShadcnPageRoute(builder: (context) => const SettingsPage()),
/// );
/// ```
///
/// See also:
///
/// * [ShadcnPage], the [Page] equivalent for declarative navigation (Router,
///   `go_router`, `Navigator.pages`).
class ShadcnPageRoute<T> extends PageRoute<T> {
  /// Creates a page route that renders [builder] with the shadcn transition.
  ShadcnPageRoute({
    required this.builder,
    super.settings,
    this.maintainState = true,
    super.fullscreenDialog,
    this._opaque = true,
    this.transitionDuration = kShadcnPageTransitionDuration,
    this.barrierLabel,
  });

  /// Builds the primary content of the route.
  final WidgetBuilder builder;

  /// Whether routes behind this one stop being built once the transition
  /// finishes.
  final bool _opaque;

  @override
  final bool maintainState;

  @override
  final Duration transitionDuration;

  @override
  final String? barrierLabel;

  @override
  bool get opaque => _opaque;

  @override
  Color? get barrierColor => null;

  /// Whether this route animates into [nextRoute].
  ///
  /// The old implementation answered `nextRoute is ShadcnPageRoute`, so pushing
  /// a dialog, a drawer or any other route on top of a page skipped the page's
  /// exit transition. The framework default (`true`) is used instead.
  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ShadcnPageTransition(animation: animation, child: child);
  }

  @override
  String get debugLabel {
    final String? name = settings.name;
    return name == null ? super.debugLabel : '${super.debugLabel}($name)';
  }
}

/// A [Page] that creates a [ShadcnPageRoute].
///
/// The registry replacement for `MaterialPage`, for use with declarative
/// navigation APIs such as [Navigator.pages] or `go_router`.
///
/// ```dart
/// Navigator(
///   pages: [
///     ShadcnPage(key: const ValueKey('home'), child: const HomePage()),
///     if (showSettings)
///       ShadcnPage(key: const ValueKey('settings'), child: const SettingsPage()),
///   ],
///   onDidRemovePage: (page) {},
/// );
/// ```
class ShadcnPage<T> extends Page<T> {
  /// Creates a page backed by a [ShadcnPageRoute].
  const ShadcnPage({
    required this.child,
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.transitionDuration = kShadcnPageTransitionDuration,
    super.key,
    super.canPop,
    super.onPopInvoked,
    super.name,
    super.arguments,
    super.restorationId,
  });

  /// The content to show for this page.
  final Widget child;

  /// Whether to keep the page's state alive while it is covered.
  final bool maintainState;

  /// Whether the page is presented as a modal dialog.
  final bool fullscreenDialog;

  /// How long the push and pop animation runs for.
  final Duration transitionDuration;

  @override
  Route<T> createRoute(BuildContext context) {
    return ShadcnPageRoute<T>(
      builder: (context) => child,
      settings: this,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      transitionDuration: transitionDuration,
    );
  }
}
