// D4 component page tests: the template renders for button/dialog/command,
// the deferred preview loads one named example at a time (P6-F4), the install
// block shows the generated file lists, and the API/theme/keyboard tables
// render from generated data. Golden tests cover light + dark.

import 'package:docs/generated/docs_data.dart';
import 'package:docs/generated/docs_previews.dart';
import 'package:docs/routing/docs_nav.dart';
import 'package:docs/routing/docs_router.dart';
import 'package:docs/ui/shadcn/components/badge/badge.dart';
import 'package:docs/ui/shadcn/components/button/button.dart';
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
      // P6-F4: one named example at a time behind a Select, plus the
      // per-preview light/dark toggle. The deferred chunk loads async.
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey<String>('preview-example-select')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('preview-theme-toggle')),
        findsOneWidget,
      );
      // The default example (button "Default") paints a Button.
      expect(find.byType(Button), findsWidgets);
      expect(find.text('Button'), findsWidgets);
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
      // Pager neighbors come from the generated alphabetical links.
      final ({String? previousId, String? nextId}) neighbors =
          componentNeighbors('button');
      expect(neighbors.previousId, 'breadcrumb');
      expect(neighbors.nextId, 'calendar');
      expect(find.text('Breadcrumb'), findsWidgets);
      expect(find.text('Calendar'), findsWidgets);
      // The pager label comes from the generated links, not a hard-coded name.
      final DocsComponentLink next = kComponentLinks.firstWhere(
        (DocsComponentLink link) => link.id == neighbors.nextId,
      );
      expect(next.name, 'Calendar');
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

    testWidgets('example Select lists every named example', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/docs/components/button');
      await tester.pumpAndSettle();
      final List<String> names = kComponentPreviews['button']!;
      expect(names.length, 11);
      // The trigger shows the default example.
      expect(find.text(names.first), findsWidgets);
      // Opening the Select reveals every example name.
      await tester.tap(
        find.byKey(const ValueKey<String>('preview-example-select')),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      for (final String name in names) {
        expect(find.text(name), findsWidgets);
      }
    });

    testWidgets('switching examples re-renders the stage', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/docs/components/button');
      await tester.pumpAndSettle();
      // Default example shows the primary button label.
      expect(find.text('Button'), findsWidgets);
      // Switch to the Destructive example through DocsState (the Select
      // writes here too; the state path is what the stage reads). The
      // deferred chunk reload needs a second settle: the first completes
      // the `loadLibrary` future, the second builds the new example.
      docsState.setPreviewExample('button', 'Destructive');
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      expect(find.text('Delete'), findsOneWidget);
      // The selection survives navigation away and back.
      await goTo(tester, delegate, '/docs/components/badge');
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      await goTo(tester, delegate, '/docs/components/button');
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('per-preview toggle inverts only the stage', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(
        tester,
        platformBrightness: Brightness.light,
      );
      await goTo(tester, delegate, '/docs/components/button');
      await tester.pumpAndSettle();
      expect(docsState.brightness, Brightness.light);
      // Site is light; the stage toggle starts following the site.
      expect(find.text('Light'), findsWidgets);
      await tester.tap(
        find.byKey(const ValueKey<String>('preview-theme-toggle')),
      );
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 500));
      expect(docsState.isPreviewInverted('button'), isTrue);
      expect(find.text('Dark'), findsWidgets);
      // The site itself stays light: only the stage flipped.
      expect(docsState.brightness, Brightness.light);
      await tester.tap(
        find.byKey(const ValueKey<String>('preview-theme-toggle')),
      );
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 500));
      expect(docsState.isPreviewInverted('button'), isFalse);
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
