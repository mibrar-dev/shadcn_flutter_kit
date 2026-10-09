import 'package:docs/routing/docs_router.dart';
import 'package:docs/ui/shadcn/components/input/input.dart';
import 'package:docs/widgets/palette.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';

Finder _inPalette(Finder matching) =>
    find.descendant(of: find.byType(DocsPalette), matching: matching);

void main() {
  testWidgets('palette opens with the Pages group (empty query)', (
    WidgetTester tester,
  ) async {
    final DocsRouterDelegate delegate = await pumpDocsApp(tester);
    delegate.openPalette();
    await tester.pumpAndSettle();
    expect(_inPalette(find.text('Pages')), findsOneWidget);
    expect(_inPalette(find.text('Home')), findsOneWidget);
    // Component and preset rows are hidden for an empty query.
    expect(_inPalette(find.text('Presets')), findsNothing);
    expect(_inPalette(find.text('Accordion')), findsNothing);
    expect(find.text('Go to Page'), findsOneWidget);
  });

  testWidgets('typing filters all groups and the footer shows the action', (
    WidgetTester tester,
  ) async {
    final DocsRouterDelegate delegate = await pumpDocsApp(tester);
    delegate.openPalette();
    await tester.pumpAndSettle();

    await tester.enterText(_inPalette(find.byType(Input)), 'button');
    await tester.pumpAndSettle();
    expect(_inPalette(find.text('Components')), findsOneWidget);
    expect(_inPalette(find.text('Button')), findsOneWidget);
    expect(_inPalette(find.text('flutter_shadcn add button')), findsOneWidget);
  });

  testWidgets('arrow keys move the selection (footer action follows)', (
    WidgetTester tester,
  ) async {
    final DocsRouterDelegate delegate = await pumpDocsApp(tester);
    delegate.openPalette();
    await tester.pumpAndSettle();

    // Empty query: the Pages group; the footer shows the selected route.
    expect(_inPalette(find.text('/')), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    expect(_inPalette(find.text('/docs')), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    expect(_inPalette(find.text('/docs/components')), findsOneWidget);
  });

  testWidgets('Enter navigates to the selected entry and closes', (
    WidgetTester tester,
  ) async {
    final DocsRouterDelegate delegate = await pumpDocsApp(tester);
    delegate.openPalette();
    await tester.pumpAndSettle();
    await tester.enterText(_inPalette(find.byType(Input)), 'button');
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(
      delegate.currentConfiguration,
      DocsRouteConfiguration.component('button'),
    );
    expect(find.text('button'), findsOneWidget);
  });

  testWidgets('Escape closes the palette without navigating', (
    WidgetTester tester,
  ) async {
    final DocsRouterDelegate delegate = await pumpDocsApp(tester);
    delegate.openPalette();
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(DocsPalette), findsNothing);
    expect(delegate.currentConfiguration, DocsRouteConfiguration.landing);
    expect(find.text('Search documentation…'), findsOneWidget);
  });
}
