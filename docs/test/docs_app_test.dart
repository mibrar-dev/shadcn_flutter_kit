import 'package:docs/generated/stub_docs_data.dart';
import 'package:docs/main.dart';
import 'package:docs/motion/ease.dart';
import 'package:docs/routing/docs_router.dart';
import 'package:docs/state/docs_state.dart';
import 'package:docs/ui/shadcn/theme/theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory storage so the app test never touches localStorage.
class _MemoryStorage extends DocsStorage {
  final Map<String, String> values = <String, String>{};

  @override
  String? read(String key) => values[key];

  @override
  void write(String key, String value) => values[key] = value;
}

Future<DocsState> _pumpApp(WidgetTester tester) async {
  final DocsState state = DocsState(
    resolveTheme: buildStubDocsTheme,
    storage: _MemoryStorage(),
  );
  await tester.pumpWidget(DocsApp(state: state));
  await tester.pumpAndSettle();
  return state;
}

void main() {
  testWidgets('shell boots on the landing stub', (WidgetTester tester) async {
    final DocsState state = await _pumpApp(tester);
    addTearDown(state.dispose);
    expect(find.text('shadcn_flutter_kit'), findsOneWidget);
  });

  testWidgets('Ctrl+K opens the palette and Esc closes it', (
    WidgetTester tester,
  ) async {
    final DocsState state = await _pumpApp(tester);
    addTearDown(state.dispose);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.keyK);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.keyK);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();
    expect(find.textContaining('Command palette'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.textContaining('Command palette'), findsNothing);
  });

  testWidgets('navigation reports the new URL to the engine', (
    WidgetTester tester,
  ) async {
    final List<MethodCall> calls = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.navigation,
      (MethodCall call) async {
        calls.add(call);
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.navigation,
        null,
      ),
    );

    final DocsState state = await _pumpApp(tester);
    addTearDown(state.dispose);

    final DocsRouterDelegate delegate = tester
        .widget<DocsRouterScope>(find.byType(DocsRouterScope))
        .delegate;
    delegate.navigate(
      tester.element(find.byType(Navigator).last),
      DocsRouteConfiguration.themes,
    );
    await tester.pumpAndSettle();

    expect(find.text('Themes'), findsOneWidget);
    expect(
      calls.any(
        (MethodCall call) =>
            call.method == 'routeInformationUpdated' &&
            (call.arguments as Map<Object?, Object?>)['uri']
                .toString()
                .contains('/themes'),
      ),
      isTrue,
      reason: 'the router must report the new URL to the engine',
    );
  });

  testWidgets('preset/mode changes go through the 300ms animated theme', (
    WidgetTester tester,
  ) async {
    final DocsState state = await _pumpApp(tester);
    addTearDown(state.dispose);

    final AnimatedShadcnTheme animated = tester.widget<AnimatedShadcnTheme>(
      find.byType(AnimatedShadcnTheme),
    );
    expect(animated.duration, kDurationTheme);
    expect(animated.curve, kEaseOutExpo);
    expect(animated.data.brightness, Brightness.dark);

    state.toggleBrightness();
    await tester.pumpAndSettle();
    final AnimatedShadcnTheme updated = tester.widget<AnimatedShadcnTheme>(
      find.byType(AnimatedShadcnTheme),
    );
    expect(updated.data.brightness, Brightness.light);
  });
}
