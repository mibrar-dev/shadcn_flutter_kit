// The app shell (spec §2.0) and the docs layout grid (spec §2.2).
//
// Shell: header + content + conditional one-line footer. The footer renders
// only on `/` (landing) and not-found, matching the reference's
// `body:has([data-slot=docs])` / `/create` hiding rules.
//
// Docs layout: `lg:` grid `[288, 1fr]` with an 8 px container gutter; the
// article (with its own TOC column on `xl`) fills the rest.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../routing/docs_router.dart';
import '../state/docs_state.dart';
import 'docs_footer.dart';
import 'docs_header.dart';
import 'docs_sidebar.dart';
import 'docs_tokens.dart';

/// Wraps the navigator with the site header/footer and the mobile popper.
class DocsAppShell extends StatefulWidget {
  /// Creates the shell.
  const DocsAppShell({
    super.key,
    required this.delegate,
    required this.state,
    required this.child,
  });

  /// Router delegate (navigation + palette + current route).
  final DocsRouterDelegate delegate;

  /// Theme state (header toggle).
  final DocsState state;

  /// The navigator subtree.
  final Widget child;

  @override
  State<DocsAppShell> createState() => _DocsAppShellState();
}

class _DocsAppShellState extends State<DocsAppShell> {
  bool _mobileNavOpen = false;

  void _toggleMobileNav() {
    setState(() => _mobileNavOpen = !_mobileNavOpen);
  }

  void _closeMobileNav() {
    if (_mobileNavOpen) {
      setState(() => _mobileNavOpen = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.delegate,
      builder: (BuildContext context, Widget? _) {
        final DocsRouteConfiguration config =
            widget.delegate.currentConfiguration;
        final double width = MediaQuery.sizeOf(context).width;
        final double headerHeight = width >= 1024
            ? DocsMetrics.headerHeightLg
            : DocsMetrics.headerHeightSm;
        final bool showFooter =
            config.route == DocsRoute.landing ||
            config.route == DocsRoute.notFound;
        final Widget shell = Column(
          children: <Widget>[
            DocsHeader(
              delegate: widget.delegate,
              state: widget.state,
              currentLocation: config.location,
              mobileNavOpen: _mobileNavOpen,
              onToggleMobileNav: _toggleMobileNav,
            ),
            Expanded(child: widget.child),
            if (showFooter)
              DocsFooter(
                onDocs: () => widget.delegate.go(context, '/docs'),
                onCli: () => widget.delegate.go(context, '/docs/cli'),
              ),
          ],
        );
        final Widget content = !_mobileNavOpen
            ? shell
            : Stack(
                children: <Widget>[
                  shell,
                  Positioned(
                    top: headerHeight,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _closeMobileNav,
                    ),
                  ),
                  Positioned(
                    top: headerHeight,
                    left: 0,
                    right: 0,
                    child: DocsMobileNav(
                      delegate: widget.delegate,
                      currentLocation: config.location,
                      onNavigate: _closeMobileNav,
                    ),
                  ),
                ],
              );
        // Escape closes the popper. The binding lives at the shell level (an
        // ancestor of the focused node) because the popper itself is a sibling
        // branch and would never see the key event.
        return CallbackShortcuts(
          bindings: <ShortcutActivator, VoidCallback>{
            const SingleActivator(LogicalKeyboardKey.escape): () {
              if (_mobileNavOpen) {
                _closeMobileNav();
              }
            },
          },
          child: FocusTraversalGroup(child: content),
        );
      },
    );
  }
}

/// The docs grid: sidebar (≥`lg`) + article column.
class DocsLayout extends StatelessWidget {
  /// Creates the layout.
  const DocsLayout({super.key, required this.child});

  /// The article column (usually a `DocsArticle`).
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final String location =
        DocsRouterScope.maybeOf(context)?.currentConfiguration.location ??
        '/docs';
    final Widget content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DocsMetrics.containerGutter,
      ),
      child: width >= 1024
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DocsSidebar(activeLocation: location),
                Expanded(child: child),
              ],
            )
          : child,
    );
    return FocusTraversalGroup(child: content);
  }
}
