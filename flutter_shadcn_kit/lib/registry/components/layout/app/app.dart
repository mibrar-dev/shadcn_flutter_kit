// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' as material;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/widgets.dart';

import '../../../shared/primitives/overlay.dart';
import '../../../shared/localizations/shadcn_localizations.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/constants.dart';
import 'component_theme_global_configs.dart';

part '_impl/core/shadcn_ui.dart';

/// Minimal app wrapper that wires up shadcn theme + overlay handling.
class ShadcnApp extends StatelessWidget {
  static bool _globalThemesRegistered = false;

  const ShadcnApp({
    super.key,
    this.navigatorKey,
    this.home,
    this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.pageRouteBuilder,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.builder,
    this.title = '',
    this.color,
    this.theme = const ThemeData(),
    this.darkTheme,
    this.themeMode = ThemeMode.system,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior,
    this.scaling,
    this.popoverHandler,
    this.tooltipHandler,
    this.menuHandler,
    this.enableThemeAnimation = false,
    this.materialFallback = true,
    this.preloadComponentThemeGlobals = true,
    this.routeInformationProvider,
    this.routeInformationParser,
    this.routerDelegate,
    this.backButtonDispatcher,
  });

  const ShadcnApp.router({
    super.key,
    this.routeInformationProvider,
    this.routeInformationParser,
    this.routerDelegate,
    this.backButtonDispatcher,
    this.builder,
    this.title = '',
    this.color,
    this.theme = const ThemeData(),
    this.darkTheme,
    this.themeMode = ThemeMode.system,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior,
    this.scaling,
    this.popoverHandler,
    this.tooltipHandler,
    this.menuHandler,
    this.enableThemeAnimation = false,
    this.materialFallback = true,
    this.preloadComponentThemeGlobals = true,
  }) : navigatorKey = null,
       home = null,
       routes = const <String, WidgetBuilder>{},
       initialRoute = null,
       onGenerateRoute = null,
       onGenerateInitialRoutes = null,
       onUnknownRoute = null,
       pageRouteBuilder = null,
       navigatorObservers = const <NavigatorObserver>[];

  final GlobalKey<NavigatorState>? navigatorKey;
  final Widget? home;
  final Map<String, WidgetBuilder> routes;
  final String? initialRoute;
  final RouteFactory? onGenerateRoute;
  final InitialRouteListFactory? onGenerateInitialRoutes;
  final RouteFactory? onUnknownRoute;
  final PageRouteFactory? pageRouteBuilder;
  final List<NavigatorObserver> navigatorObservers;
  final TransitionBuilder? builder;
  final String title;
  final Color? color;
  final ThemeData theme;
  final ThemeData? darkTheme;
  final ThemeMode themeMode;
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final LocaleListResolutionCallback? localeListResolutionCallback;
  final LocaleResolutionCallback? localeResolutionCallback;
  final Iterable<Locale> supportedLocales;
  final bool showPerformanceOverlay;
  final bool showSemanticsDebugger;
  final bool debugShowCheckedModeBanner;
  final bool debugShowMaterialGrid;
  final Map<ShortcutActivator, Intent>? shortcuts;
  final Map<Type, Action<Intent>>? actions;
  final String? restorationScopeId;
  final ScrollBehavior? scrollBehavior;
  final AdaptiveScaling? scaling;
  final OverlayHandler? popoverHandler;
  final OverlayHandler? tooltipHandler;
  final OverlayHandler? menuHandler;
  final bool enableThemeAnimation;
  final bool materialFallback;
  final bool preloadComponentThemeGlobals;

  final RouteInformationProvider? routeInformationProvider;
  final RouteInformationParser<Object>? routeInformationParser;
  final RouterDelegate<Object>? routerDelegate;
  final BackButtonDispatcher? backButtonDispatcher;

  ThemeData _resolveTheme(BuildContext context) {
    final platformBrightness =
        MediaQuery.maybeOf(context)?.platformBrightness ?? Brightness.light;
    final useDark =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            platformBrightness == Brightness.dark);
    var resolved = useDark ? (darkTheme ?? theme) : theme;
    if (scaling != null) {
      resolved = scaling!.scale(resolved);
    }
    return resolved;
  }

  Widget _wrapWithTheme(
    BuildContext context,
    Widget child,
    ThemeData themeData,
  ) {
    Widget wrapped = Theme(
      data: themeData,
      child: ShadcnUI(child: child),
    );
    if (!enableThemeAnimation) {
      return _wrapWithMaterialFallback(wrapped);
    }
    wrapped = TweenAnimationBuilder<ThemeData>(
      tween: ThemeDataTween(begin: themeData, end: themeData),
      duration: kDefaultDuration,
      builder: (context, value, themedChild) {
        return Theme(data: value, child: themedChild ?? child);
      },
      child: ShadcnUI(child: child),
    );
    return _wrapWithMaterialFallback(wrapped);
  }

  Widget _wrapWithMaterialFallback(Widget child) {
    if (!materialFallback) {
      return child;
    }
    return material.Material(
      type: material.MaterialType.transparency,
      child: child,
    );
  }

  Iterable<LocalizationsDelegate<dynamic>>
  get _effectiveLocalizationsDelegates {
    final delegates = <LocalizationsDelegate<dynamic>>[
      if (localizationsDelegates != null) ...localizationsDelegates!,
      ...ShadcnLocalizations.localizationsDelegates,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];
    final seen = <Type>{};
    return delegates
        .where((delegate) => seen.add(delegate.runtimeType))
        .toList(growable: false);
  }

  Locale get _resolvedLocale {
    if (locale != null) {
      return locale!;
    }
    final supported = supportedLocales.toList();
    if (supported.isEmpty) {
      return const Locale('en', 'US');
    }
    final platformLocale = WidgetsBinding.instance.platformDispatcher.locale;
    for (final candidate in supported) {
      if (candidate.languageCode == platformLocale.languageCode &&
          (candidate.countryCode == null ||
              candidate.countryCode == platformLocale.countryCode)) {
        return candidate;
      }
    }
    return supported.first;
  }

  @override
  Widget build(BuildContext context) {
    if (preloadComponentThemeGlobals && !_globalThemesRegistered) {
      registerComponentThemeGlobalConfigs();
      _globalThemesRegistered = true;
    }
    final resolvedTheme = _resolveTheme(context);
    Widget appBuilder(BuildContext context, Widget? child) {
      final built = builder != null ? builder!(context, child) : child;
      final safeChild = built ?? const SizedBox.shrink();
      return Localizations(
        locale: _resolvedLocale,
        delegates: _effectiveLocalizationsDelegates.toList(),
        child: OverlayManagerLayer(
          popoverHandler: popoverHandler ?? OverlayHandler.popover,
          tooltipHandler: tooltipHandler ?? OverlayHandler.popover,
          menuHandler: menuHandler ?? OverlayHandler.popover,
          child: _wrapWithTheme(context, safeChild, resolvedTheme),
        ),
      );
    }

    if (routerDelegate != null && routeInformationParser != null) {
      return WidgetsApp.router(
        routeInformationProvider: routeInformationProvider,
        routeInformationParser: routeInformationParser!,
        routerDelegate: routerDelegate!,
        backButtonDispatcher: backButtonDispatcher,
        color: color ?? resolvedTheme.colorScheme.primary,
        title: title,
        builder: appBuilder,
        locale: locale,
        localizationsDelegates: _effectiveLocalizationsDelegates,
        localeListResolutionCallback: localeListResolutionCallback,
        localeResolutionCallback: localeResolutionCallback,
        supportedLocales: supportedLocales,
        showPerformanceOverlay: showPerformanceOverlay,
        showSemanticsDebugger: showSemanticsDebugger,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        shortcuts: shortcuts,
        actions: actions,
        restorationScopeId: restorationScopeId,
      );
    }

    return WidgetsApp(
      navigatorKey: navigatorKey,
      color: color ?? resolvedTheme.colorScheme.primary,
      title: title,
      home: home,
      routes: routes,
      initialRoute: initialRoute,
      onGenerateRoute: onGenerateRoute,
      onGenerateInitialRoutes: onGenerateInitialRoutes,
      onUnknownRoute: onUnknownRoute,
      pageRouteBuilder: pageRouteBuilder ?? _defaultPageRouteBuilder,
      navigatorObservers: navigatorObservers,
      builder: appBuilder,
      locale: locale,
      localizationsDelegates: _effectiveLocalizationsDelegates,
      localeListResolutionCallback: localeListResolutionCallback,
      localeResolutionCallback: localeResolutionCallback,
      supportedLocales: supportedLocales,
      showPerformanceOverlay: showPerformanceOverlay,
      showSemanticsDebugger: showSemanticsDebugger,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      shortcuts: shortcuts,
      actions: actions,
      restorationScopeId: restorationScopeId,
    );
  }
}

PageRoute<T> _defaultPageRouteBuilder<T>(
  RouteSettings settings,
  WidgetBuilder builder,
) => PageRouteBuilder<T>(
  settings: settings,
  pageBuilder: (context, animation, secondaryAnimation) => builder(context),
);
