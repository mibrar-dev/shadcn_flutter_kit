import 'package:flutter/widgets.dart';

import '../motion/motion_scope.dart';
import '../state/docs_state.dart';
import '../ui/shadcn/components/page_route/page_route.dart';
import 'palette_route.dart';

export 'palette_route.dart';

/// Logical pages of the docs site (shadcn-site sitemap, P6 spec §1).
enum DocsRoute {
  /// `/` — landing.
  landing,

  /// `/docs` — introduction (docs shell root).
  introduction,

  /// `/docs/installation` — getting started.
  installation,

  /// `/docs/theming` — token tables and snippets.
  theming,

  /// `/docs/dark-mode` — mode toggle explanation.
  darkMode,

  /// `/docs/cli` — CLI reference.
  cli,

  /// `/docs/components` — link-grid index.
  components,

  /// `/docs/components/:id` — one component template instance.
  component,

  /// `/themes` — preset rail + live preview.
  themes,

  /// Anything else; rendered as a not-found page.
  notFound,
}

/// A parsed URL: the route plus its parameter.
@immutable
class DocsRouteConfiguration {
  const DocsRouteConfiguration._(this.route, {this.componentId, this.raw});

  /// The page to show.
  final DocsRoute route;

  /// Component id for [DocsRoute.component].
  final String? componentId;

  /// Original location for [DocsRoute.notFound].
  final String? raw;

  /// `/`.
  static const DocsRouteConfiguration landing = DocsRouteConfiguration._(
    DocsRoute.landing,
  );

  /// `/docs`.
  static const DocsRouteConfiguration introduction = DocsRouteConfiguration._(
    DocsRoute.introduction,
  );

  /// `/docs/installation`.
  static const DocsRouteConfiguration installation = DocsRouteConfiguration._(
    DocsRoute.installation,
  );

  /// `/docs/theming`.
  static const DocsRouteConfiguration theming = DocsRouteConfiguration._(
    DocsRoute.theming,
  );

  /// `/docs/dark-mode`.
  static const DocsRouteConfiguration darkMode = DocsRouteConfiguration._(
    DocsRoute.darkMode,
  );

  /// `/docs/cli`.
  static const DocsRouteConfiguration cli = DocsRouteConfiguration._(
    DocsRoute.cli,
  );

  /// `/docs/components`.
  static const DocsRouteConfiguration components = DocsRouteConfiguration._(
    DocsRoute.components,
  );

  /// `/themes`.
  static const DocsRouteConfiguration themes = DocsRouteConfiguration._(
    DocsRoute.themes,
  );

  /// `/docs/components/<id>`.
  static DocsRouteConfiguration component(String id) =>
      DocsRouteConfiguration._(DocsRoute.component, componentId: id);

  /// Any unknown location.
  static DocsRouteConfiguration notFound(String location) =>
      DocsRouteConfiguration._(DocsRoute.notFound, raw: location);

  /// The base-href the site is deployed under (GitHub Pages:
  /// `/shadcn_flutter_kit/`).
  static const String kDocsBasePath = 'shadcn_flutter_kit';

  /// Parses [location] (query/fragment ignored).
  ///
  /// Accepts an in-app location (`/themes`), an absolute URL (a deep link from
  /// search results) and a location carrying the deploy base-href
  /// (`/shadcn_flutter_kit/docs/cli`); all three resolve to the same page.
  static DocsRouteConfiguration parse(String? location) {
    final Uri uri = Uri.parse(location ?? '/');
    final List<String> segments = uri.pathSegments
        .where((String s) => s.isNotEmpty)
        .toList(growable: false);
    final List<String> path =
        segments.isNotEmpty && segments.first == kDocsBasePath
        ? segments.sublist(1)
        : segments;
    if (path.isEmpty) {
      return landing;
    }
    if (path.length == 1 && path[0] == 'themes') {
      return themes;
    }
    if (path[0] == 'docs') {
      if (path.length == 1) {
        return introduction;
      }
      switch (path[1]) {
        case 'installation':
          return installation;
        case 'theming':
          return theming;
        case 'dark-mode':
          return darkMode;
        case 'cli':
          return cli;
        case 'components':
          if (path.length == 2) {
            return components;
          }
          if (path.length == 3 && path[2].isNotEmpty) {
            return component(path[2]);
          }
      }
    }
    return notFound(location ?? '/');
  }

  /// Canonical in-app location.
  String get location => switch (route) {
    DocsRoute.landing => '/',
    DocsRoute.introduction => '/docs',
    DocsRoute.installation => '/docs/installation',
    DocsRoute.theming => '/docs/theming',
    DocsRoute.darkMode => '/docs/dark-mode',
    DocsRoute.cli => '/docs/cli',
    DocsRoute.components => '/docs/components',
    DocsRoute.component => '/docs/components/$componentId',
    DocsRoute.themes => '/themes',
    DocsRoute.notFound => raw ?? '/',
  };

  /// Human label (pager, document title).
  String get title => switch (route) {
    DocsRoute.landing => 'shadcn_flutter_kit',
    DocsRoute.introduction => 'Introduction',
    DocsRoute.installation => 'Getting started',
    DocsRoute.theming => 'Theming',
    DocsRoute.darkMode => 'Dark mode',
    DocsRoute.cli => 'CLI reference',
    DocsRoute.components => 'Components',
    DocsRoute.component => componentId ?? 'Component',
    DocsRoute.themes => 'Themes',
    DocsRoute.notFound => 'Not found',
  };

  @override
  bool operator ==(Object other) =>
      other is DocsRouteConfiguration &&
      other.route == route &&
      other.componentId == componentId &&
      other.raw == raw;

  @override
  int get hashCode => Object.hash(route, componentId, raw);
}

/// Parses the browser URL into a [DocsRouteConfiguration].
class DocsRouteInformationParser
    extends RouteInformationParser<DocsRouteConfiguration> {
  /// Creates the parser.
  const DocsRouteInformationParser();

  @override
  Future<DocsRouteConfiguration> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    return DocsRouteConfiguration.parse(routeInformation.uri.toString());
  }

  @override
  RouteInformation? restoreRouteInformation(
    DocsRouteConfiguration configuration,
  ) {
    return RouteInformation(uri: Uri.parse(configuration.location));
  }
}

/// Builds the widget for one route (D3/D4 own the real pages).
typedef DocsPageBuilder =
    Widget Function(BuildContext context, DocsRouteConfiguration config);

/// Builds the palette panel; [close] pops the overlay route.
typedef DocsPaletteBuilder =
    Widget Function(BuildContext context, VoidCallback close);

/// Wraps the docs navigator in the app shell; [navigator] becomes its home.
typedef DocsShellBuilder =
    Widget Function(BuildContext context, Widget navigator);

/// Exposes the active [DocsRouterDelegate] to pages.
class DocsRouterScope extends InheritedWidget {
  /// Creates the scope.
  const DocsRouterScope({
    super.key,
    required this.delegate,
    required super.child,
  });

  /// The delegate driving navigation.
  final DocsRouterDelegate delegate;

  /// Nearest delegate.
  static DocsRouterDelegate of(BuildContext context) {
    final DocsRouterScope? scope = context
        .dependOnInheritedWidgetOfExactType<DocsRouterScope>();
    assert(scope != null, 'DocsRouterScope is missing above this context');
    return scope!.delegate;
  }

  /// Nearest delegate, or null when the scope is absent (standalone tests).
  static DocsRouterDelegate? maybeOf(BuildContext context) {
    return context.getInheritedWidgetOfExactType<DocsRouterScope>()?.delegate;
  }

  @override
  bool updateShouldNotify(DocsRouterScope oldWidget) =>
      oldWidget.delegate != delegate;
}

/// Rebuilds the docs navigator whenever the [delegate] changes.
///
/// The app shell (`WidgetsApp`) creates its home route once; a navigator
/// widget captured inside that route builder would never see a new page
/// stack. This host listens to the delegate and rebuilds
/// [DocsRouterDelegate.buildNavigator] on every notification.
class DocsRouterHost extends StatelessWidget {
  /// Creates the host.
  const DocsRouterHost({super.key, required this.delegate});

  /// The delegate whose page stack is rendered.
  final DocsRouterDelegate delegate;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: delegate,
      builder: (BuildContext context, Widget? child) =>
          delegate.buildNavigator(),
    );
  }
}

/// A [RouterDelegate] over a page stack, using the registry [ShadcnPageRoute]
/// transition for every page.
///
/// In-app links call [navigate] (which reports a browser history entry through
/// `Router.navigate`); deep links and browser back/forward arrive through
/// [setNewRoutePath] and replace the stack. The palette is an imperative
/// overlay route pushed on the same navigator, so the browser back button
/// closes it and focus restoration comes from the route lifecycle.
class DocsRouterDelegate extends RouterDelegate<DocsRouteConfiguration>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<DocsRouteConfiguration> {
  /// Creates the delegate.
  ///
  /// The builder arguments are assigned in the body (private fields cannot use
  /// initializing formals with public named parameters).
  DocsRouterDelegate({
    required this.state,
    required DocsPageBuilder pageBuilder,
    required DocsPaletteBuilder paletteBuilder,
    required DocsShellBuilder shellBuilder,
    GlobalKey<NavigatorState>? navigatorKey,
  }) : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>() {
    _pageBuilder = pageBuilder;
    _paletteBuilder = paletteBuilder;
    _shellBuilder = shellBuilder;
    state.addListener(_onStateChanged);
  }

  /// Theme/mode state; forwarded so shell rebuilds on preset changes.
  final DocsState state;
  late final DocsPageBuilder _pageBuilder;
  late final DocsPaletteBuilder _paletteBuilder;
  late final DocsShellBuilder _shellBuilder;

  /// Navigator key (required by [PopNavigatorRouterDelegateMixin]).
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final List<_RouteEntry> _stack = <_RouteEntry>[
    _RouteEntry(DocsRouteConfiguration.landing, 0),
  ];
  int _serial = 0;
  bool _paletteOpen = false;

  @override
  DocsRouteConfiguration get currentConfiguration => _stack.last.config;

  void _onStateChanged() => notifyListeners();

  @override
  Future<void> setNewRoutePath(DocsRouteConfiguration configuration) async {
    if (configuration == currentConfiguration && _stack.length == 1) {
      return;
    }
    _stack
      ..clear()
      ..add(_RouteEntry(configuration, ++_serial));
    notifyListeners();
  }

  /// Pushes [configuration] as a new page and browser history entry.
  void navigate(BuildContext context, DocsRouteConfiguration configuration) {
    if (configuration == currentConfiguration) {
      return;
    }
    Router.navigate(context, () {
      _stack.add(_RouteEntry(configuration, ++_serial));
      notifyListeners();
    });
  }

  /// Convenience wrapper over [navigate] for a location string.
  void go(BuildContext context, String location) {
    navigate(context, DocsRouteConfiguration.parse(location));
  }

  /// Pops the top page (used by pagers); no-op on the initial page.
  void pop(BuildContext context) {
    if (_stack.length < 2) {
      return;
    }
    Router.navigate(context, () => popRoute());
  }

  @override
  Widget build(BuildContext context) {
    return _shellBuilder(context, DocsRouterHost(delegate: this));
  }

  /// Builds the docs navigator for the current page stack.
  ///
  /// Called from [DocsRouterHost], which listens to this delegate — the shell
  /// route is created once by the app, so the navigator must rebuild itself
  /// instead of being captured in a route builder closure.
  Widget buildNavigator() {
    return DocsRouterScope(
      delegate: this,
      child: Navigator(
        key: navigatorKey,
        pages: <Page<dynamic>>[
          for (final _RouteEntry entry in _stack)
            ShadcnPage<void>(
              key: entry.key,
              // The reference site has no route transition (spec §5.2):
              // in-app navigation is instant. The registry page stays for
              // structure; only the palette keeps an enter animation.
              transitionDuration: Duration.zero,
              child: Builder(
                builder: (BuildContext context) =>
                    _pageBuilder(context, entry.config),
              ),
            ),
        ],
        onDidRemovePage: (Page<dynamic> page) {
          if (_stack.length <= 1) {
            return;
          }
          _stack.removeWhere((_RouteEntry entry) => entry.key == page.key);
          notifyListeners();
        },
      ),
    );
  }

  /// Opens (or toggles) the command palette overlay (mockup 09).
  void openPalette() {
    final NavigatorState? navigator = navigatorKey.currentState;
    final BuildContext? context = navigatorKey.currentContext;
    if (navigator == null || context == null) {
      return;
    }
    if (_paletteOpen) {
      closePalette();
      return;
    }
    _paletteOpen = true;
    final bool reduceMotion = MotionScope.of(context);
    final FocusNode? previousFocus = FocusManager.instance.primaryFocus;
    navigator
        .push<void>(
          DocsPaletteRoute(
            reduceMotion: reduceMotion,
            builder: (BuildContext context) =>
                _paletteBuilder(context, closePalette),
          ),
        )
        .whenComplete(() {
          _paletteOpen = false;
          if (previousFocus != null && previousFocus.context != null) {
            previousFocus.requestFocus();
          }
        });
  }

  /// Closes the palette if it is open.
  void closePalette() {
    if (!_paletteOpen) {
      return;
    }
    navigatorKey.currentState?.maybePop();
  }

  @override
  void dispose() {
    state.removeListener(_onStateChanged);
    super.dispose();
  }
}

class _RouteEntry {
  _RouteEntry(this.config, int serial)
    : key = ValueKey<String>('${config.location}@$serial');

  final DocsRouteConfiguration config;
  final ValueKey<String> key;
}
