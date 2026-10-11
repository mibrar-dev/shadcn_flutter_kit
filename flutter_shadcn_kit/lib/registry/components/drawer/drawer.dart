// The `drawer` component: a modal panel that slides in from a screen edge,
// plus the `sheet` variant that expands along its edge.
//
// Ported from `components/overlay/drawer`. The old tree pushed entries into a
// custom `DrawerOverlay` layer stack with backdrop scaling; the new component
// follows the `dialog` pilot and pushes a widgets `ModalRoute` (one show
// path). The reusable route/shell machinery lives in `primitives/drawer_route/`
// so the component files stay within the layout budget. `SheetOverlayHandler`
// is no longer owned here: the `primitives/sheet_overlay` marker is provided
// around sheet content, and consumers read the marker from the primitive.
//
// Removed from the old component: the `data_widget` / `gap` dependencies, the
// Material import, the `DrawerOverlay` layer stack and its data types, the
// `surfaceOpacity` / `surfaceBlur` glass fields and the old completer.

import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../primitives/drawer_route/drawer_panel.dart';
import '../../primitives/drawer_route/drawer_route.dart';
import '../../theme/theme.dart';
import 'drawer_style.dart';

export 'drawer_style.dart';
export '../../primitives/drawer_route/drawer_route.dart'
    show DrawerOverlayCompleter, OverlayPosition;

/// Resolves the drawer theme for [context]: defaults, app, scoped, widget leg.
DrawerTheme _resolveDrawerTheme(
  BuildContext context,
  DrawerTheme? widgetTheme,
) {
  return resolveComponentStyle<DrawerTheme, DrawerTheme>(
    context,
    widget: widgetTheme,
    select: (theme) => theme,
    defaults: drawerDefaults,
  );
}

/// Pushes a panel route and returns its completer.
DrawerOverlayCompleter<T?> _pushPanel<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  required OverlayPosition position,
  required bool expands,
  required bool draggable,
  required bool isSheet,
  required bool barrierDismissible,
  required bool useSafeArea,
  required bool? showDragHandle,
  required BorderRadius? borderRadius,
  required double? maxSize,
  required String? barrierLabel,
  required bool useRootNavigator,
  required RouteSettings? routeSettings,
  required DrawerTheme? theme,
}) {
  final NavigatorState navigator = Navigator.of(
    context,
    rootNavigator: useRootNavigator,
  );
  final DrawerTheme style = _resolveDrawerTheme(context, theme);
  final ShadcnDrawerRoute<T> route = ShadcnDrawerRoute<T>(
    builder: builder,
    position: position,
    themeOf: (BuildContext context) => _resolveDrawerTheme(context, theme),
    duration: style.transitionDuration ?? const Duration(milliseconds: 250),
    barrierDismissible: barrierDismissible,
    useSafeArea: useSafeArea,
    expands: expands,
    draggable: draggable,
    showDragHandle: showDragHandle ?? style.showDragHandle ?? true,
    isSheet: isSheet,
    openerFocus: FocusManager.instance.primaryFocus,
    borderRadius: borderRadius,
    maxSize: maxSize,
    barrierLabel: barrierLabel,
    themes: InheritedTheme.capture(from: context, to: navigator.context),
    data: Data.capture(from: context, to: navigator.context),
    settings: routeSettings,
  );
  navigator.push(route);
  return DrawerOverlayCompleter<T?>(
    route.popped,
    route.animation ?? const AlwaysStoppedAnimation<double>(1),
    () => navigator.removeRoute(route),
  );
}

/// Opens a drawer and returns a handle to it.
DrawerOverlayCompleter<T?> openDrawerOverlay<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  OverlayPosition position = OverlayPosition.end,
  bool expands = false,
  bool draggable = true,
  bool barrierDismissible = true,
  bool useSafeArea = true,
  bool? showDragHandle,
  BorderRadius? borderRadius,
  double? maxSize,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  DrawerTheme? theme,
}) {
  return _pushPanel<T>(
    context: context,
    builder: builder,
    position: position,
    expands: expands,
    draggable: draggable,
    isSheet: false,
    barrierDismissible: barrierDismissible,
    useSafeArea: useSafeArea,
    showDragHandle: showDragHandle,
    borderRadius: borderRadius,
    maxSize: maxSize,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    theme: theme,
  );
}

/// Opens a drawer and completes with the value passed to `closeDrawer`.
Future<T?> openDrawer<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  OverlayPosition position = OverlayPosition.end,
  bool expands = false,
  bool draggable = true,
  bool barrierDismissible = true,
  bool useSafeArea = true,
  bool? showDragHandle,
  BorderRadius? borderRadius,
  double? maxSize,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  DrawerTheme? theme,
}) {
  return openDrawerOverlay<T>(
    context: context,
    builder: builder,
    position: position,
    expands: expands,
    draggable: draggable,
    barrierDismissible: barrierDismissible,
    useSafeArea: useSafeArea,
    showDragHandle: showDragHandle,
    borderRadius: borderRadius,
    maxSize: maxSize,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    theme: theme,
  ).future;
}

/// Opens a sheet and returns a handle to it.
DrawerOverlayCompleter<T?> openSheetOverlay<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  OverlayPosition position = OverlayPosition.bottom,
  bool expands = true,
  bool draggable = false,
  bool barrierDismissible = true,
  bool useSafeArea = true,
  bool? showDragHandle,
  BorderRadius? borderRadius,
  double? maxSize,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  DrawerTheme? theme,
}) {
  return _pushPanel<T>(
    context: context,
    builder: builder,
    position: position,
    expands: expands,
    draggable: draggable,
    isSheet: true,
    barrierDismissible: barrierDismissible,
    useSafeArea: useSafeArea,
    showDragHandle: showDragHandle,
    borderRadius: borderRadius,
    maxSize: maxSize,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    theme: theme,
  );
}

/// Opens a sheet and completes with the value passed to `closeSheet`.
Future<T?> openSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  OverlayPosition position = OverlayPosition.bottom,
  bool expands = true,
  bool draggable = false,
  bool barrierDismissible = true,
  bool useSafeArea = true,
  bool? showDragHandle,
  BorderRadius? borderRadius,
  double? maxSize,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  DrawerTheme? theme,
}) {
  return openSheetOverlay<T>(
    context: context,
    builder: builder,
    position: position,
    expands: expands,
    draggable: draggable,
    barrierDismissible: barrierDismissible,
    useSafeArea: useSafeArea,
    showDragHandle: showDragHandle,
    borderRadius: borderRadius,
    maxSize: maxSize,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    theme: theme,
  ).future;
}

/// Closes the drawer that [context] is inside, with an optional result.
Future<void> closeDrawer<T>(BuildContext context, [T? result]) {
  assert(
    DrawerPanelScope.maybeOf(context) != null,
    'No drawer found in the widget tree',
  );
  final NavigatorState navigator = Navigator.of(context);
  if (navigator.canPop()) {
    navigator.pop(result);
  }
  return Future.value();
}

/// Closes the sheet that [context] is inside, with an optional result.
Future<void> closeSheet<T>(BuildContext context, [T? result]) =>
    closeDrawer<T>(context, result);
