// Entry point of the docs web app (P6 rebuild).
//
// Composition: a root `Router` owns URL/history (delegate + parser in
// `routing/docs_router.dart`); the delegate builds the registry `ShadcnApp`
// shell around a docs navigator. The shell installs the theme (with a
// 300ms ease-out-expo colour tween on preset/mode switches), the global
// keyboard shortcuts and the web-bridge events.
//
// TEMPORARY (D1): the theme resolver and the route host below are stubs that
// D2 (generated data) and D3/D4 (real pages) replace — see the markers.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'generated/stub_docs_data.dart';
import 'motion/ease.dart';
import 'motion/motion_scope.dart';
import 'routing/docs_router.dart';
import 'state/docs_state.dart';
import 'ui/shadcn/components/app/app.dart';
import 'ui/shadcn/theme/color_tokens.dart';
import 'ui/shadcn/theme/theme.dart';
import 'web_bridge.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final DocsState state = DocsState(resolveTheme: buildStubDocsTheme)
    ..restore();
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

class _DocsAppState extends State<DocsApp> {
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
    widget.state.addListener(_onThemeChanged);
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      dispatchWebAppReady();
      _onThemeChanged();
    });
  }

  @override
  void dispose() {
    widget.state.removeListener(_onThemeChanged);
    _delegate.dispose();
    _routeInformationProvider.dispose();
    super.dispose();
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
        child: AnimatedShadcnTheme(
          data: state.theme,
          duration: kDurationTheme,
          curve: kEaseOutExpo,
          child: child ?? const SizedBox.shrink(),
        ),
      ),
      // The home route is deliberately unnamed: the docs navigator must be the
      // only thing reporting URLs to the engine (the Router owns history).
      home: navigator,
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

// ---------------------------------------------------------------------------
// TEMPORARY (D1): placeholder page host. D3 replaces landing / introduction /
// components-index, D4 replaces component / themes / installation / cli.
// ---------------------------------------------------------------------------

/// Maps a parsed route to its page widget.
Widget buildDocsPage(BuildContext context, DocsRouteConfiguration config) {
  return _DocsStubPage(
    title: config.title,
    body: switch (config.route) {
      DocsRoute.component =>
        'Template for “${config.componentId}” — D4 renders the generated '
            'API, install tabs and live preview here.',
      DocsRoute.themes => 'Preset gallery + live dashboard — D4.',
      DocsRoute.installation => 'Install timeline — D4.',
      DocsRoute.cli => 'CLI reference — D4.',
      DocsRoute.components => 'Filterable component index — D3.',
      DocsRoute.landing => 'Landing page — D3.',
      DocsRoute.introduction => 'Docs shell + introduction — D3.',
      DocsRoute.notFound => 'This URL does not match any docs route.',
    },
  );
}

/// Maps the palette overlay slot to its panel.
Widget buildDocsPalette(BuildContext context, VoidCallback close) {
  return _DocsPaletteStub(onClose: close);
}

class _DocsStubPage extends StatelessWidget {
  const _DocsStubPage({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ColoredBox(
      color: theme.colors.background,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(title, style: theme.typography.x3Large),
              const SizedBox(height: 8),
              Text(
                body,
                textAlign: TextAlign.center,
                style: theme.typography.sans.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocsPaletteStub extends StatelessWidget {
  const _DocsPaletteStub({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 96, left: 20, right: 20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: CallbackShortcuts(
            bindings: <ShortcutActivator, VoidCallback>{
              const SingleActivator(LogicalKeyboardKey.escape): onClose,
            },
            child: Focus(
              autofocus: true,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colors.popover,
                  border: Border.all(color: theme.colors.border),
                  borderRadius: theme.borderRadiusLg,
                  boxShadow: theme.tokens.shadows.shadowXl,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Command palette (D3) — Esc to close',
                    style: theme.typography.sans.copyWith(
                      color: theme.colors.mutedForeground,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
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
