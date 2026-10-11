// Component page tests (P7-D1): the template renders for
// button/dialog/command, every named example has its own Preview | Code
// card (the main demo on top, the rest under an Examples section), the
// install block shows the generated file lists, and the API/theme/keyboard
// tables render from generated data. Golden tests cover light + dark.

import 'package:docs/generated/docs_data.dart';
import 'package:docs/generated/docs_example_sources.dart';
import 'package:docs/generated/docs_previews.dart';
import 'package:docs/routing/docs_nav.dart';
import 'package:docs/routing/docs_router.dart';
import 'package:docs/ui/shadcn/components/badge/badge.dart';
import 'package:docs/ui/shadcn/components/button/button.dart';
import 'package:docs/widgets/docs_toc.dart';
import 'package:docs/widgets/example_preview_card.dart';
import 'package:docs/widgets/preview_stage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';

void main() {
  group('component page', () {
    testWidgets('button renders title, badges, previews and tables', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/docs/components/button');
      expect(find.text('Button'), findsWidgets);
      expect(find.byType(Badge), findsWidgets);
      // P7-D1: one card per named example (11 for button), each with its
      // own stage. The deferred chunks load async.
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      expect(
        find.byType(ExamplePreviewCard),
        findsNWidgets(kComponentPreviews['button']!.length),
      );
      expect(find.byType(PreviewStage), findsWidgets);
      // Every card has Preview/Code tabs plus the per-card toggle.
      expect(
        find.byKey(const ValueKey<String>('example-tabs-0')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('preview-theme-toggle-0')),
        findsOneWidget,
      );
      // The default example (button "Default") paints a Button.
      expect(find.byType(Button), findsWidgets);
      expect(find.text('Button'), findsWidgets);
      // Install block.
      expect(find.text('Installation'), findsWidgets);
      expect(find.text('Command'), findsWidgets);
      expect(find.text('Manual'), findsWidgets);
      // Examples section lists the remaining examples as h3 headings.
      expect(find.text('Examples'), findsWidgets);
      expect(find.text('Destructive'), findsWidgets);
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
      await tester.pumpAndSettle();
      expect(
        find.byType(ExamplePreviewCard),
        findsNWidgets(kComponentPreviews['dialog']!.length),
      );
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
      await tester.pumpAndSettle();
      expect(
        find.byType(ExamplePreviewCard),
        findsNWidgets(kComponentPreviews['command']!.length),
      );
      expect(find.byType(PreviewStage), findsWidgets);
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

    testWidgets('every example renders its own card with Preview/Code', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/docs/components/button');
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      final List<String> names = kComponentPreviews['button']!;
      expect(names.length, 11);
      final List<DocsExampleSource> sources = kExampleSources['button']!;
      expect(sources.length, names.length);
      // The main demo card shows the first example.
      final ExamplePreviewCard first = tester.widget<ExamplePreviewCard>(
        find.byType(ExamplePreviewCard).first,
      );
      expect(first.exampleIndex, 0);
      expect(first.source.name, names.first);
      // Every card carries Preview/Code tabs and a theme toggle.
      expect(
        find.descendant(
          of: find.byType(ExamplePreviewCard),
          matching: find.text('Preview'),
        ),
        findsNWidgets(names.length),
      );
      expect(
        find.descendant(
          of: find.byType(ExamplePreviewCard),
          matching: find.text('Code'),
        ),
        findsNWidgets(names.length),
      );
      for (int i = 0; i < names.length; i++) {
        expect(
          find.byKey(ValueKey<String>('preview-theme-toggle-$i')),
          findsOneWidget,
        );
      }
    });

    testWidgets('code tab text contains the example builder body', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/docs/components/button');
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      // Each card's Code tab reveals exactly that example's source.
      for (final MapEntry<int, String> entry in <int, String>{
        0: '_buttonDefault',
        5: '_buttonDestructive',
        7: '_buttonWithIcon',
      }.entries) {
        final Finder tabs = find.byKey(
          ValueKey<String>('example-tabs-${entry.key}'),
        );
        await tester.ensureVisible(tabs);
        await tester.pumpAndSettle();
        final Finder codeTab = find.descendant(
          of: find.byType(ExamplePreviewCard).at(entry.key),
          matching: find.text('Code'),
        );
        await tester.tap(codeTab);
        await tester.pumpAndSettle();
        expect(find.textContaining(entry.value), findsWidgets);
      }
    });

    testWidgets('examples are listed in the On This Page TOC', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(
        tester,
        width: 1400,
      );
      await goTo(tester, delegate, '/docs/components/button');
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      expect(find.text('On This Page'), findsOneWidget);
      final Finder toc = find.byType(DocsToc);
      expect(toc, findsOneWidget);
      // Section headings plus every example name register as TOC links.
      for (final String heading in <String>[
        'Installation',
        'Usage',
        'Examples',
        'API Reference',
      ]) {
        expect(
          find.descendant(of: toc, matching: find.text(heading)),
          findsWidgets,
          reason: heading,
        );
      }
      for (final String name in <String>['Secondary', 'With icon', 'Loading']) {
        expect(
          find.descendant(of: toc, matching: find.text(name)),
          findsWidgets,
          reason: name,
        );
      }
    });

    testWidgets('per-card toggle inverts only its own stage', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(
        tester,
        platformBrightness: Brightness.light,
      );
      await goTo(tester, delegate, '/docs/components/button');
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      expect(docsState.brightness, Brightness.light);
      // P7-D1b: the toggle is icon-only (tooltip, no Light/Dark label), so
      // the first card carries an icon toggle and no brightness text.
      final Finder firstCard = find.byType(ExamplePreviewCard).first;
      expect(
        find.descendant(of: firstCard, matching: find.text('Light')),
        findsNothing,
      );
      expect(
        find.descendant(of: firstCard, matching: find.text('Dark')),
        findsNothing,
      );
      expect(
        find.descendant(
          of: find.byKey(const ValueKey<String>('preview-theme-toggle-0')),
          matching: find.byType(Icon),
        ),
        findsOneWidget,
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('preview-theme-toggle-0')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey<String>('preview-theme-toggle-0')),
      );
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 500));
      // The site itself stays light: only the card flipped (the flip itself
      // is proved by the calendar paint test in component_preview_f4_test).
      expect(docsState.brightness, Brightness.light);
      expect(
        find.byKey(const ValueKey<String>('preview-theme-toggle-0')),
        findsOneWidget,
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('preview-theme-toggle-0')),
      );
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 500));
      expect(docsState.brightness, Brightness.light);
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
        await tester.pumpAndSettle();
        expect(find.byType(PreviewStage), findsWidgets);
        expect(
          find.byType(ExamplePreviewCard),
          findsNWidgets(kComponentPreviews['button']!.length),
        );
        expect(find.text('API Reference'), findsWidgets);
      });
    }
  });
}
