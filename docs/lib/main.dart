// Entry point of the docs web app (P6 rebuild).
//
// Composition: a root `Router` owns URL/history (delegate + parser in
// `routing/docs_router.dart`); the delegate builds the registry `ShadcnApp`
// shell around a docs navigator. The shell installs the theme (with a
// 300ms ease-out-expo colour tween on preset/mode switches), the global
// keyboard shortcuts and the web-bridge events.
//
// Brightness defaults to the system (the reference's `next-themes` default);
// the header toggle stores an explicit mode. The platform listener below
// forwards system changes while no explicit mode is stored.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'generated/app_theme.dart';
import 'motion/ease.dart';
import 'motion/motion_scope.dart';
import 'pages/cli_reference.dart';
import 'pages/component_page.dart' deferred as component_page;
import 'pages/components_index_page.dart';
import 'pages/dark_mode_page.dart';
import 'pages/getting_started.dart';
import 'pages/introduction_page.dart';
import 'pages/landing_page.dart';
import 'pages/placeholder_page.dart';
import 'pages/themes.dart';
import 'pages/theming_page.dart';
import 'routing/deferred_page.dart';
import 'routing/docs_router.dart';
import 'state/docs_state.dart';
import 'ui/shadcn/components/app/app.dart';
import 'ui/shadcn/theme/color_tokens.dart';
import 'ui/shadcn/theme/theme.dart';
import 'web_bridge.dart';
import 'widgets/docs_shell.dart';
import 'widgets/palette.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final DocsState state = DocsState(
    resolveTheme: buildDocsTheme,
    systemBrightness:
        WidgetsBinding.instance.platformDispatcher.platformBrightness,
  )..restore();
  runApp(DocsApp(state: state));
}

/// The docs application root.
class DocsApp extends StatefulWidget {
  /// Creates the app.
  const DocsApp({super.key, required this.state});

  /// Theme/navigation state shared by the shell and the pages.
  final DocsState state;

  @override
  State<DocsApp> createState() => _DocsAppState();
}

class _DocsAppState extends State<DocsApp> with WidgetsBindingObserver {
  late final DocsRouterDelegate _delegate = DocsRouterDelegate(
    state: widget.state,
    pageBuilder: buildDocsPage,
    paletteBuilder: buildDocsPalette,
    shellBuilder: _buildShell,
  );

  // Owned here: `Router` does not create a provider, only `WidgetsApp` does.
  // Without this the initial URL is never parsed and URL reports are dropped.
  late final PlatformRouteInformationProvider _routeInformationProvider;

  @override
  void initState() {
    super.initState();
    _routeInformationProvider = PlatformRouteInformationProvider(
      initialRouteInformation: RouteInformation(
        uri: Uri.parse(
          WidgetsBinding.instance.platformDispatcher.defaultRouteName,
        ),
      ),
    );
    WidgetsBinding.instance.addObserver(this);
    widget.state.addListener(_onThemeChanged);
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      dispatchWebAppReady();
      _onThemeChanged();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.state.removeListener(_onThemeChanged);
    _delegate.dispose();
    _routeInformationProvider.dispose();
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    widget.state.setSystemBrightness(
      WidgetsBinding.instance.platformDispatcher.platformBrightness,
    );
  }

  void _onThemeChanged() {
    dispatchWebThemeChanged(_themeEventColors(widget.state.theme));
  }

  @override
  Widget build(BuildContext context) {
    return Router<DocsRouteConfiguration>(
      routeInformationProvider: _routeInformationProvider,
      routerDelegate: _delegate,
      routeInformationParser: const DocsRouteInformationParser(),
      backButtonDispatcher: RootBackButtonDispatcher(),
    );
  }

  Widget _buildShell(BuildContext context, Widget navigator) {
    final DocsState state = widget.state;
    return ShadcnApp(
      title: 'shadcn_flutter_kit docs',
      debugShowCheckedModeBanner: false,
      color: state.theme.colors.primary,
      theme: state.theme,
      themeMode: state.brightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light,
      // ShadcnApp merges `shortcuts`/`actions` over the WidgetsApp defaults
      // (Tab traversal, Enter/Space activation, Escape dismissal survive), so
      // only the docs-specific bindings are listed here.
      shortcuts: docsShortcuts,
      actions: <Type, Action<Intent>>{
        OpenDocsPaletteIntent: CallbackAction<OpenDocsPaletteIntent>(
          onInvoke: (OpenDocsPaletteIntent intent) {
            _delegate.openPalette();
            return null;
          },
        ),
      },
      builder: (BuildContext context, Widget? child) => MotionScope(
        child: Builder(
          builder: (BuildContext context) => AnimatedShadcnTheme(
            data: state.theme,
            // The preset/mode colour tween is our documented deviation; under
            // reduced motion it caps to 150 ms (plan §4) instead of 300 ms.
            duration: context.motionDuration(kDurationTheme),
            curve: kEaseOutExpo,
            child: child ?? const SizedBox.shrink(),
          ),
        ),
      ),
      // The home route is deliberately unnamed: the docs navigator must be the
      // only thing reporting URLs to the engine (the Router owns history).
      home: DocsAppShell(delegate: _delegate, state: state, child: navigator),
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) =>
          PageRouteBuilder<T>(
            settings: const RouteSettings(),
            pageBuilder:
                (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                ) => builder(context),
          ),
    );
  }
}

/// Opens the command palette from anywhere (⌘K / Ctrl+K).
class OpenDocsPaletteIntent extends Intent {
  /// Creates the intent.
  const OpenDocsPaletteIntent();
}

/// Global shortcut map handed to [ShadcnApp].
const Map<ShortcutActivator, Intent> docsShortcuts =
    <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.keyK, meta: true):
          OpenDocsPaletteIntent(),
      SingleActivator(LogicalKeyboardKey.keyK, control: true):
          OpenDocsPaletteIntent(),
    };

/// Maps a parsed route to its page widget.
///
/// D3 provides the landing, introduction and components index; D4 provides
/// the component template, themes customizer, installation and CLI reference;
/// D4b provides theming and dark mode. Only unknown URLs fall through to the
/// not-found page.
Widget buildDocsPage(BuildContext context, DocsRouteConfiguration config) {
  return switch (config.route) {
    DocsRoute.landing => const LandingPage(),
    DocsRoute.introduction => const IntroductionPage(),
    DocsRoute.components => const ComponentsIndexPage(),
    DocsRoute.component => DeferredPage(
      load: component_page.loadLibrary,
      builder: (BuildContext context) =>
          component_page.ComponentPage(componentId: config.componentId!),
    ),
    DocsRoute.themes => const ThemesPage(),
    DocsRoute.installation => const GettingStartedPage(),
    DocsRoute.theming => const ThemingPage(),
    DocsRoute.darkMode => const DarkModePage(),
    DocsRoute.cli => const CliReferencePage(),
    _ => DocsPlaceholderPage(config: config),
  };
}

/// Maps the palette overlay slot to its panel.
Widget buildDocsPalette(BuildContext context, VoidCallback close) {
  return DocsPalette(onClose: close);
}

// ---------------------------------------------------------------------------
// Web-bridge helpers.
// ---------------------------------------------------------------------------

Map<String, String> _themeEventColors(ShadcnThemeData data) {
  final ShadcnColors c = data.colors;
  return <String, String>{
    'background': _hex(c.background),
    'foreground': _hex(c.foreground),
    'card': _hex(c.card),
    'popover': _hex(c.popover),
    'primary': _hex(c.primary),
    'primaryForeground': _hex(c.primaryForeground),
    'secondary': _hex(c.secondary),
    'muted': _hex(c.muted),
    'mutedForeground': _hex(c.mutedForeground),
    'accent': _hex(c.accent),
    'destructive': _hex(c.destructive),
    'border': _hex(c.border),
    'input': _hex(c.input),
    'ring': _hex(c.ring),
    'radiusLg': data.radiusLg.toStringAsFixed(1),
  };
}

String _hex(Color color) {
  final String argb = color.toARGB32().toRadixString(16).padLeft(8, '0');
  return '#${argb.substring(2).toUpperCase()}';
}
