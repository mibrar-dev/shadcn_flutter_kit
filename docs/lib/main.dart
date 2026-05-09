import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaml/yaml.dart';

import 'pages/docs/colors_page.dart';
import 'pages/docs/components_page.dart';
import 'pages/docs/complete_guide_page.dart';
import 'pages/docs/component_detail_page.dart';
import 'pages/docs/icons_page.dart';
import 'pages/docs/installation_page.dart';
import 'pages/docs/registry_guide_page.dart';
import 'pages/docs/app_setup_page.dart';
import 'pages/docs/cli_reference_page.dart';
import 'pages/docs/introduction_page.dart';
import 'pages/docs/layout_page.dart';
import 'pages/docs/components/material_example.dart';
import 'pages/docs/state_page.dart';
import 'pages/docs/theme_page.dart';
import 'pages/docs/typography_page.dart';
import 'pages/docs/web_preloader_page.dart';
import 'pages/docs/components/error_system/error_system_quick_start_page.dart';
import 'theme/docs_theme.dart';
import 'theme/theme_controller.dart';
import 'web_bridge.dart';
import 'ui/shadcn/components/form/history/history.dart';
import 'ui/shadcn/components/display/keyboard_shortcut/keyboard_shortcut.dart';
import 'ui/shadcn/components/layout/app/app.dart' as shadcn_app;
import 'ui/shadcn/components/overlay/drawer/drawer.dart';
import 'ui/shadcn/components/overlay/eye_dropper/eye_dropper.dart';
import 'ui/shadcn/components/utility/error_system/error_system.dart';
import 'ui/shadcn/shared/theme/color_scheme.dart' as shadcn_colors;
import 'ui/shadcn/shared/theme/preset_themes.dart';
import 'ui/shadcn/shared/theme/theme.dart' as shadcn_theme;

const bool enableWebSemantics = bool.fromEnvironment(
  'ENABLE_WEB_SEMANTICS',
  defaultValue: false,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb && enableWebSemantics) {
    SemanticsBinding.instance.ensureSemantics();
  }

  final docsConfig = await _loadDocsConfig();
  final prefs = await SharedPreferences.getInstance();
  final settings = await _loadSettings(prefs);

  runApp(
    _DeferredFirstFrameApp(
      child: DocsRoot(docsConfig: docsConfig, settings: settings, prefs: prefs),
    ),
  );
  _notifyWebAppReady();
}

class _DeferredFirstFrameApp extends StatefulWidget {
  const _DeferredFirstFrameApp({required this.child});

  final Widget child;

  @override
  State<_DeferredFirstFrameApp> createState() => _DeferredFirstFrameAppState();
}

class _DeferredFirstFrameAppState extends State<_DeferredFirstFrameApp> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _ready = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _ready ? widget.child : const SizedBox.shrink();
  }
}

Future<Map<String, Object?>> _loadDocsConfig() async {
  try {
    final raw = await rootBundle.loadString('docs.json');
    return jsonDecode(raw) as Map<String, Object?>;
  } catch (_) {
    return {'flavor': 'local'};
  }
}

Future<DocsSettings> _loadSettings(SharedPreferences prefs) async {
  final presetId = prefs.getString(kPrefsThemePresetId) ?? 'zinc';
  final themeMode = prefs.getString(kPrefsThemeMode) ?? 'dark';
  final brightness = themeMode == 'dark' ? Brightness.dark : Brightness.light;
  shadcn_colors.ColorScheme scheme;
  final customRaw =
      prefs.getString(
        brightness == Brightness.dark
            ? kPrefsCustomSchemeDark
            : kPrefsCustomSchemeLight,
      ) ??
      prefs.getString(kPrefsCustomScheme);
  if (presetId == 'custom' && customRaw != null) {
    scheme = shadcn_colors.ColorScheme.fromMap(
      jsonDecode(customRaw) as Map<String, dynamic>,
    );
  } else {
    scheme = _schemeForPreset(presetId, brightness);
  }
  final hasRadiusPref = prefs.containsKey(kPrefsRadius);
  final presetTokens = _tokensForPreset(presetId, brightness);
  final resolvedRadius = hasRadiusPref
      ? (prefs.getDouble(kPrefsRadius) ?? presetTokens.radius)
      : (presetId == 'custom' ? 0.1 : presetTokens.radius);
  final resolvedDensity = _densityFromPrefs(prefs) ?? presetTokens.density;
  final storedPath = prefs.getString('initialPath');
  return DocsSettings(
    colorScheme: scheme,
    radius: resolvedRadius,
    scaling: prefs.getDouble(kPrefsScaling) ?? 1.0,
    surfaceOpacity: normalizeDocsSurfaceOpacity(
      prefs.getDouble(kPrefsSurfaceOpacity) ?? 1.0,
    ),
    surfaceBlur: prefs.getDouble(kPrefsSurfaceBlur) ?? 0.0,
    density: resolvedDensity,
    initialPath: storedPath ?? '/',
    presetId: presetId,
    brightness: brightness,
  );
}

class DocsSettings {
  final shadcn_colors.ColorScheme colorScheme;
  final double radius;
  final double scaling;
  final double surfaceOpacity;
  final double surfaceBlur;
  final shadcn_theme.Density density;
  final String initialPath;
  final String presetId;
  final Brightness brightness;

  const DocsSettings({
    required this.colorScheme,
    required this.radius,
    required this.scaling,
    required this.surfaceOpacity,
    required this.surfaceBlur,
    required this.density,
    required this.initialPath,
    required this.presetId,
    required this.brightness,
  });
}

class DocsRoot extends StatefulWidget {
  final Map<String, Object?> docsConfig;
  final DocsSettings settings;
  final SharedPreferences prefs;

  const DocsRoot({
    super.key,
    required this.docsConfig,
    required this.settings,
    required this.prefs,
  });

  @override
  State<DocsRoot> createState() => _DocsRootState();
}

class _DocsRootState extends State<DocsRoot> {
  late DocsThemeController controller;
  late GoRouter router;
  late final HubAppScope _appErrorScope = HubAppScope('docs.app');
  Brightness? _lastBrightness;
  shadcn_colors.ColorScheme? _lastScheme;
  static const _pageTransitionDuration = Duration(milliseconds: 180);
  static const _pageReverseTransitionDuration = Duration(milliseconds: 120);

  String _fromKebabCase(String value) {
    return value.replaceAll('-', '_');
  }

  @override
  void initState() {
    super.initState();
    final presetTokens = _tokensForPreset(
      widget.settings.presetId,
      widget.settings.brightness,
    );
    final themeData = DocsThemeData(
      colorScheme: widget.settings.colorScheme,
      radius: widget.settings.radius,
      scaling: widget.settings.scaling,
      surfaceOpacity: widget.settings.surfaceOpacity,
      surfaceBlur: widget.settings.surfaceBlur,
      density: widget.settings.density,
      spacing: widget.settings.density.toSpacingScale(),
      tracking: presetTokens.tracking,
      shadows: presetTokens.shadows,
    );
    controller = DocsThemeController(
      initialData: themeData,
      prefs: widget.prefs,
      presetId: widget.settings.presetId,
      brightness: widget.settings.brightness,
    );

    router = GoRouter(
      initialLocation: widget.settings.initialPath,
      routes: [
        GoRoute(
          path: '/',
          name: 'introduction',
          pageBuilder: (context, state) =>
              _buildTransitionPage(state, const IntroductionPage()),
        ),
        GoRoute(
          path: '/installation',
          name: 'installation',
          pageBuilder: (context, state) =>
              _buildTransitionPage(state, const InstallationPage()),
        ),
        GoRoute(
          path: '/complete-guide',
          name: 'complete-guide',
          pageBuilder: (context, state) =>
              _buildTransitionPage(state, const CompleteGuidePage()),
        ),
        GoRoute(
          path: '/app-setup',
          name: 'app-setup',
          pageBuilder: (context, state) =>
              _buildTransitionPage(state, const AppSetupPage()),
        ),
        GoRoute(
          path: '/registry-guide',
          name: 'registry-guide',
          pageBuilder: (context, state) =>
              _buildTransitionPage(state, const RegistryGuidePage()),
        ),
        GoRoute(
          path: '/cli/:id',
          name: 'cli_reference',
          pageBuilder: (context, state) => _buildTransitionPage(
            state,
            CliReferencePage(
              pageId: state.pathParameters['id'] ?? 'cli-overview',
            ),
          ),
        ),
        GoRoute(
          path: '/theme',
          name: 'theme',
          pageBuilder: (context, state) =>
              _buildTransitionPage(state, const ThemePage()),
        ),
        GoRoute(
          path: '/typography',
          name: 'typography',
          pageBuilder: (context, state) =>
              _buildTransitionPage(state, const TypographyPage()),
        ),
        GoRoute(
          path: '/layout',
          name: 'layout',
          pageBuilder: (context, state) =>
              _buildTransitionPage(state, const LayoutPage()),
        ),
        GoRoute(
          path: '/icons',
          name: 'icons',
          pageBuilder: (context, state) =>
              _buildTransitionPage(state, const IconsPage()),
        ),
        GoRoute(
          path: '/colors',
          name: 'colors',
          pageBuilder: (context, state) =>
              _buildTransitionPage(state, const ColorsPage()),
        ),
        GoRoute(
          path: '/material',
          name: 'material',
          pageBuilder: (context, state) =>
              _buildTransitionPage(state, const MaterialExample()),
        ),
        GoRoute(
          path: '/state',
          name: 'state',
          pageBuilder: (context, state) =>
              _buildTransitionPage(state, const StatePage()),
        ),
        GoRoute(
          path: '/web_preloader',
          name: 'web_preloader',
          pageBuilder: (context, state) =>
              _buildTransitionPage(state, const WebPreloaderPage()),
        ),
        GoRoute(
          path: '/components',
          name: 'components',
          pageBuilder: (context, state) =>
              _buildTransitionPage(state, const ComponentsPage()),
        ),
        GoRoute(
          path: '/components/error-system/quick-start',
          name: 'error_system_quick_start',
          pageBuilder: (context, state) =>
              _buildTransitionPage(state, const ErrorSystemQuickStartPage()),
        ),
        GoRoute(
          path: '/components/:id',
          name: 'component_detail',
          pageBuilder: (context, state) => _buildTransitionPage(
            state,
            ComponentDetailPage(
              componentId: _fromKebabCase(state.pathParameters['id'] ?? ''),
            ),
          ),
        ),
      ],
    );
  }

  CustomTransitionPage<void> _buildTransitionPage(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: ScreenErrorScope(child: child),
      transitionDuration: _pageTransitionDuration,
      reverseTransitionDuration: _pageReverseTransitionDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        final fade = Tween<double>(begin: 0, end: 1).animate(curve);
        final slide = Tween<Offset>(
          begin: const Offset(0, 0.02),
          end: Offset.zero,
        ).animate(curve);
        return FadeTransition(
          opacity: fade,
          child: SlideTransition(position: slide, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DocsThemeControllerScope(
      controller: controller,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final data = controller.data;
          _notifyWebThemeChanged(data);
          return DocsThemeScope(
            data: data,
            child: shadcn_app.ShadcnApp.router(
              debugShowCheckedModeBanner: false,
              title: 'shadcn/ui Registry Flutter Widget',
              theme: data.toShadcnTheme(),
              routeInformationProvider: router.routeInformationProvider,
              routeInformationParser: router.routeInformationParser,
              routerDelegate: router.routerDelegate,
              backButtonDispatcher: router.backButtonDispatcher,
              builder: (context, child) => KeyboardShortcutDisplayMapper(
                child: AppErrorGate.scope(
                  scope: _appErrorScope,
                  child: Stack(
                    children: [
                      DrawerOverlay(
                        child: RecentColorsScope(
                          child: EyeDropperLayer(
                            child: Material(
                              type: MaterialType.transparency,
                              child: child ?? const SizedBox.shrink(),
                            ),
                          ),
                        ),
                      ),
                      const Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: SafeArea(
                          bottom: false,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            child: AppErrorBanner(
                              watchScopes: ['docs.app.banner'],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _notifyWebThemeChanged(DocsThemeData data) {
    if (!kIsWeb) return;
    final brightness = data.colorScheme.brightness;
    if (_lastBrightness == brightness && _lastScheme == data.colorScheme) {
      return;
    }
    _lastBrightness = brightness;
    _lastScheme = data.colorScheme;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _dispatchWebThemeEvent(data);
    });
  }
}

void _notifyWebAppReady() {
  if (!kIsWeb) return;
  SchedulerBinding.instance.addPostFrameCallback((_) {
    dispatchWebAppReady();
  });
}

void _dispatchWebThemeEvent(DocsThemeData data) {
  if (!kIsWeb) return;
  dispatchWebThemeChanged({
    'background': _toHexColor(data.colorScheme.background),
    'foreground': _toHexColor(data.colorScheme.foreground),
    'primary': _toHexColor(data.colorScheme.primary),
  });
}

String _toHexColor(Color color) {
  final value = color.toARGB32().toRadixString(16).padLeft(8, '0');
  return '#${value.substring(2)}';
}

shadcn_colors.ColorScheme _schemeForPreset(
  String presetId,
  Brightness brightness,
) {
  final preset = DocsThemeController.presets.firstWhere(
    (preset) => preset.id == presetId,
    orElse: () => DocsThemeController.presets.first,
  );
  return brightness == Brightness.dark ? preset.dark : preset.light;
}

RegistryThemePresetTokens _tokensForPreset(
  String presetId,
  Brightness brightness,
) {
  final preset = DocsThemeController.presets.firstWhere(
    (preset) => preset.id == presetId,
    orElse: () => DocsThemeController.presets.first,
  );
  return brightness == Brightness.dark ? preset.darkTokens : preset.lightTokens;
}

shadcn_theme.Density? _densityFromPrefs(SharedPreferences prefs) {
  final container = prefs.getDouble(kPrefsDensityBaseContainerPadding);
  final gap = prefs.getDouble(kPrefsDensityBaseGap);
  final content = prefs.getDouble(kPrefsDensityBaseContentPadding);
  if (container == null || gap == null || content == null) {
    return null;
  }
  return shadcn_theme.Density(
    baseContainerPadding: container,
    baseGap: gap,
    baseContentPadding: content,
  );
}

String getReleaseTagName() {
  return 'Release';
}

String? loadPackageVersion(String rawLock) {
  final lock = loadYaml(rawLock);
  if (lock is! YamlMap) {
    return null;
  }
  final packages = lock['packages'];
  if (packages is! YamlMap) {
    return null;
  }
  final dep = packages['shadcn_flutter'];
  if (dep is! YamlMap) {
    return null;
  }
  final version = dep['version'];
  return version is String ? version : null;
}
