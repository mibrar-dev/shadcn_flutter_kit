// Shared widget-test harness for the docs app (D3 pages/widgets).
//
// Pumps the real `DocsApp` with in-memory storage and a deterministic
// viewport; exposes helpers to navigate and open the palette.

import 'package:docs/generated/app_theme.dart';
import 'package:docs/main.dart';
import 'package:docs/routing/docs_router.dart';
import 'package:docs/state/docs_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory storage so tests never touch localStorage.
class MemoryDocsStorage extends DocsStorage {
  /// Creates a memory store, optionally pre-seeded.
  MemoryDocsStorage([Map<String, String>? seed])
    : values = <String, String>{...?seed};

  /// Stored key/value pairs.
  final Map<String, String> values;

  @override
  String? read(String key) => values[key];

  @override
  void write(String key, String value) => values[key] = value;
}

/// The [DocsState] of the last [pumpDocsApp] call.
late DocsState docsState;

/// Pumps the app at [width]×[height] (device pixel ratio 1).
Future<DocsRouterDelegate> pumpDocsApp(
  WidgetTester tester, {
  double width = 1400,
  double height = 900,
  Brightness platformBrightness = Brightness.dark,
  Map<String, String>? storage,
}) async {
  tester.view.physicalSize = Size(width, height);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  tester.platformDispatcher.platformBrightnessTestValue = platformBrightness;
  addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

  docsState = DocsState(
    resolveTheme: buildDocsTheme,
    storage: MemoryDocsStorage(storage),
    systemBrightness: platformBrightness,
  );
  addTearDown(docsState.dispose);
  await tester.pumpWidget(DocsApp(state: docsState));
  await tester.pumpAndSettle();
  return tester
      .widget<DocsRouterScope>(find.byType(DocsRouterScope).first)
      .delegate;
}

/// Navigates the pumped app to [location] and settles.
Future<void> goTo(
  WidgetTester tester,
  DocsRouterDelegate delegate,
  String location,
) async {
  delegate.go(tester.element(find.byType(Navigator).last), location);
  await tester.pumpAndSettle();
}
