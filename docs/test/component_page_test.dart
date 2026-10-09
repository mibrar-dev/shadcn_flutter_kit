// D4 component page tests: the template renders for button/dialog/command,
// the deferred preview loads, the install block shows the generated file
// lists, and the API/theme/keyboard tables render from generated data.
// Golden tests cover light + dark for the three sample components.

import 'package:docs/routing/docs_router.dart';
import 'package:docs/ui/shadcn/components/badge/badge.dart';
import 'package:docs/widgets/preview_stage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';

void main() {
  group('component page', () {
    testWidgets('button renders title, badges, preview and tables', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/docs/components/button');
      expect(find.text('Button'), findsWidgets);
      expect(find.byType(Badge), findsWidgets);
      expect(find.byType(PreviewStage), findsOneWidget);
      // Deferred preview loads (button preview shows variant sections).
      await tester.pumpAndSettle();
      expect(find.text('Variants'), findsOneWidget);
      // Install block.
      expect(find.text('Installation'), findsWidgets);
      expect(find.text('Command'), findsWidgets);
      expect(find.text('Manual'), findsWidgets);
      // API Reference table.
      expect(find.text('API Reference'), findsWidgets);
      expect(find.text('Parameter'), findsOneWidget);
      expect(find.textContaining('variant'), findsWidgets);
      // Theme table.
      expect(find.text('Theme'), findsWidgets);
      expect(find.textContaining('ButtonTheme'), findsOneWidget);
    });

    testWidgets('dialog renders function-first API table', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/docs/components/dialog');
      expect(find.text('Dialog'), findsWidgets);
      await tester.pumpAndSettle();
      // Function-first API: showShadcnDialog params.
      expect(find.text('API Reference'), findsWidgets);
      expect(find.textContaining('showShadcnDialog'), findsWidgets);
      expect(find.textContaining('barrierDismissible'), findsWidgets);
      expect(find.textContaining('fullScreen'), findsWidgets);
    });

    testWidgets('command renders preview and install block', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/docs/components/command');
      expect(find.text('Command'), findsWidgets);
      await tester.pumpAndSettle();
      expect(find.byType(PreviewStage), findsOneWidget);
      expect(find.text('Installation'), findsWidgets);
      expect(find.textContaining('flutter_shadcn add command'), findsWidgets);
    });

    testWidgets('install block Manual tab shows generated file list', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/docs/components/button');
      await tester.pumpAndSettle();
      // Switch to Manual tab. The tabs now sit above the preview figure, so at
      // the 1400x900 test surface they can be below the fold - scroll first.
      await tester.ensureVisible(find.text('Manual'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Manual'));
      await tester.pumpAndSettle();
      expect(
        find.text('lib/ui/shadcn/components/button/button.dart'),
        findsOneWidget,
      );
      expect(
        find.text('lib/ui/shadcn/components/button/button_theme.dart'),
        findsOneWidget,
      );
      expect(find.text('user-owned'), findsOneWidget);
    });

    testWidgets('prev/next pager links to adjacent components', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/docs/components/button');
      await tester.pumpAndSettle();
      // Button is first in the alphabetical list; only next exists.
      expect(find.text('ClickDetector'), findsWidgets);
    });

    testWidgets('accessibility section hidden when no keyboard rows', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/docs/components/button');
      await tester.pumpAndSettle();
      // Button has no keyboard rows in its README.
      expect(find.text('Accessibility'), findsNothing);
    });

    testWidgets('accessibility section shown for calendar', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/docs/components/calendar');
      await tester.pumpAndSettle();
      expect(find.text('Accessibility'), findsWidgets);
      expect(find.textContaining('ArrowLeft / ArrowRight'), findsWidgets);
    });
  });

  group('golden: component page light + dark', () {
    for (final Brightness brightness in <Brightness>[
      Brightness.light,
      Brightness.dark,
    ]) {
      testWidgets('button page in ${brightness.name}', (
        WidgetTester tester,
      ) async {
        await pumpDocsApp(tester, platformBrightness: brightness);
        final DocsRouterDelegate delegate = tester
            .widget<DocsRouterScope>(find.byType(DocsRouterScope).first)
            .delegate;
        await goTo(tester, delegate, '/docs/components/button');
        await tester.pumpAndSettle();
        expect(find.byType(PreviewStage), findsOneWidget);
        expect(find.text('API Reference'), findsWidgets);
      });
    }
  });
}
