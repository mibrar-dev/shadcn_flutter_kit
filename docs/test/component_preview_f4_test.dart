// P7-D1 proofs: the site theme reaches every example card, code is
// selectable, and the stage is bounded.
//
//  * claude preset → the Calendar Read-only selection paints the preset's own
//    `primary` in light and dark (the registry is correct; this guards the
//    docs-side wiring), and a runtime preset switch re-themes the previews.
//  * every code surface (install block, usage snippet, per-example View Code
//    teaser, Get Code dialog, generic figure) renders a `SelectableRegion`
//    with its highlighting intact, plus a working copy button.
//  * the stage hands the preview a bounded width (the unbounded harness bug).
//
// P7-D1: every named example renders in its own card, so the calendar page
// shows six `Calendar` widgets (one per example), not one.

import 'package:docs/generated/docs_example_sources.dart';
import 'package:docs/generated/docs_previews.dart';
import 'package:docs/ui/shadcn/components/calendar/calendar.dart';
import 'package:docs/ui/shadcn/theme/theme.dart';
import 'package:docs/widgets/code_figure.dart';
import 'package:docs/widgets/example_preview_card.dart';
import 'package:docs/widgets/get_code_dialog.dart';
import 'package:docs/widgets/preview_stage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';

/// Every `Container` fill under [element], in paint order.
List<Color> _fillsOf(Element element) {
  final List<Color> out = <Color>[];
  void visit(Element e) {
    final Widget w = e.widget;
    if (w is Container) {
      final Decoration? d = w.decoration;
      if (d is BoxDecoration && d.color != null) {
        out.add(d.color!);
      }
    }
    e.visitChildren(visit);
  }

  visit(element);
  return out;
}

/// Whether any `Calendar` on the page paints [color] in a fill.
bool _anyCalendarPaints(WidgetTester tester, Color color) {
  for (final Element element in find.byType(Calendar).evaluate()) {
    if (_fillsOf(element).contains(color)) {
      return true;
    }
  }
  return false;
}

void main() {
  group('theme propagation (P6-F4.4)', () {
    for (final Brightness brightness in <Brightness>[
      Brightness.light,
      Brightness.dark,
    ]) {
      testWidgets(
        'claude calendar selection is primary in ${brightness.name}',
        (WidgetTester tester) async {
          final delegate = await pumpDocsApp(
            tester,
            platformBrightness: brightness,
          );
          docsState.setPreset('claude');
          await tester.pumpAndSettle();
          await goTo(tester, delegate, '/docs/components/calendar');
          await tester.pumpAndSettle();
          await tester.pumpAndSettle();
          final Color primary = docsState.theme.colors.primary;
          // P7-D1: all six calendar examples render; the Read-only example
          // seeds SingleCalendarValue(Mar 14 2024).
          expect(
            find.byType(Calendar),
            findsNWidgets(kComponentPreviews['calendar']!.length),
          );
          expect(
            _anyCalendarPaints(tester, primary),
            isTrue,
            reason: 'claude ${brightness.name} primary is $primary',
          );
          // The previews read the ambient site theme, not a nested default.
          final ShadcnThemeData ambient = ShadcnTheme.of(
            tester.element(find.byType(Calendar).first),
          );
          expect(ambient.colors.primary.toARGB32(), primary.toARGB32());
        },
      );
    }

    testWidgets('a runtime preset switch re-themes the previews', (
      WidgetTester tester,
    ) async {
      final delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/docs/components/calendar');
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      docsState.setPreset('claude');
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      final Color claude = docsState.theme.colors.primary;
      expect(_anyCalendarPaints(tester, claude), isTrue);
      docsState.setPreset('neutral');
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      final Color neutral = docsState.theme.colors.primary;
      expect(neutral.toARGB32(), isNot(claude.toARGB32()));
      expect(_anyCalendarPaints(tester, neutral), isTrue);
    });

    testWidgets('per-card toggle keeps the preset, flips brightness', (
      WidgetTester tester,
    ) async {
      final delegate = await pumpDocsApp(
        tester,
        platformBrightness: Brightness.light,
      );
      docsState.setPreset('claude');
      await tester.pumpAndSettle();
      await goTo(tester, delegate, '/docs/components/calendar');
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      final Color lightPrimary = docsState.themeModel
          .themeFor(Brightness.light)
          .colors
          .primary;
      final Color darkPrimary = docsState.themeModel
          .themeFor(Brightness.dark)
          .colors
          .primary;
      expect(_anyCalendarPaints(tester, lightPrimary), isTrue);
      // The Read-only example is card index 5; flip just that card.
      final Finder toggle = find.byKey(
        const ValueKey<String>('preview-theme-toggle-5'),
      );
      await tester.ensureVisible(toggle);
      await tester.pumpAndSettle();
      await tester.tap(toggle);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 500));
      // Same preset document, opposite brightness leg.
      expect(_anyCalendarPaints(tester, darkPrimary), isTrue);
      expect(docsState.presetId, 'claude');
    });
  });

  group('code selectability (P6-F4.3)', () {
    testWidgets('install command and usage snippets are selectable', (
      WidgetTester tester,
    ) async {
      final delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/docs/components/button');
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      // The install figure, the usage figures and the teasers all render
      // SelectableRegions; highlighting keeps the plain text intact.
      expect(find.byType(SelectableRegion), findsWidgets);
      expect(find.textContaining('flutter_shadcn add button'), findsWidgets);
    });

    testWidgets('expanded teaser stays selectable with a copy button', (
      WidgetTester tester,
    ) async {
      final List<String> copied = <String>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (MethodCall call) async {
          if (call.method == 'Clipboard.setData') {
            copied.add(
              (call.arguments as Map<Object?, Object?>)['text']! as String,
            );
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      final delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/docs/components/button');
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      // Open the first card's Code tab: its teaser carries the View Code
      // pill.
      await tester.tap(
        find.descendant(
          of: find.byType(ExamplePreviewCard).first,
          matching: find.text('Code'),
        ),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('code-teaser-view-code')).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey<String>('code-teaser-view-code')).first,
      );
      await tester.pumpAndSettle();
      expect(find.byType(SelectableRegion), findsWidgets);
    });

    testWidgets('every example code tab is selectable source text', (
      WidgetTester tester,
    ) async {
      final delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/docs/components/button');
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      // Open each card's Code tab: it carries exactly that example's
      // source, still selectable with colours intact.
      final List<DocsExampleSource> sources = kExampleSources['button']!;
      for (int i = 0; i < sources.length; i++) {
        await tester.ensureVisible(
          find.byKey(ValueKey<String>('example-tabs-$i')),
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.descendant(
            of: find.byType(ExamplePreviewCard).at(i),
            matching: find.text('Code'),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          find.textContaining(sources[i].builder),
          findsWidgets,
          reason: sources[i].name,
        );
      }
      expect(find.byType(SelectableRegion), findsWidgets);
    });

    testWidgets('get-code dialog pane is selectable', (
      WidgetTester tester,
    ) async {
      final delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/docs/components/button');
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      final BuildContext ctx = tester.element(find.byType(PreviewStage).first);
      showGetCodeDialog(ctx, docsState.themeModel);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Get Code'), findsOneWidget);
      expect(find.byType(SelectableRegion), findsWidgets);
    });

    testWidgets('generic figure keeps colours and copies plain text', (
      WidgetTester tester,
    ) async {
      const String code = 'final x = 42; // answer';
      await tester.pumpWidget(
        ShadcnTheme(
          data: const ShadcnThemeData(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Overlay.wrap(
              child: const Center(
                child: SizedBox(
                  width: 400,
                  child: DocsCodeFigure(code: code, language: 'dart'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SelectableRegion), findsOneWidget);
      expect(find.textContaining('final'), findsWidgets);
    });
  });

  group('stage bounds (P6-F4.1)', () {
    test('kComponentPreviews covers every component with counts', () {
      expect(kComponentPreviews['button']!.length, 11);
      expect(kComponentPreviewCounts['button'], 11);
      expect(kComponentPreviews['calendar']!.length, 6);
      // Building blocks have no named examples.
      expect(kComponentPreviews['patch'], isEmpty);
    });

    test('example sources match the preview lists one-to-one', () {
      for (final String id in kComponentPreviews.keys) {
        expect(
          kExampleSources[id]!.length,
          kComponentPreviews[id]!.length,
          reason: id,
        );
        for (int i = 0; i < kComponentPreviews[id]!.length; i++) {
          expect(kExampleSources[id]![i].name, kComponentPreviews[id]![i]);
          expect(
            kExampleSources[id]![i].code,
            contains(kExampleSources[id]![i].builder),
          );
        }
      }
    });

    testWidgets('divider and input lay out inside the bounded stage', (
      WidgetTester tester,
    ) async {
      final delegate = await pumpDocsApp(tester);
      for (final String id in <String>['divider', 'input', 'form']) {
        await goTo(tester, delegate, '/docs/components/$id');
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        expect(find.byType(PreviewStage), findsWidgets);
        expect(
          find.byType(ExamplePreviewCard),
          findsNWidgets(kComponentPreviews[id]!.length),
        );
        expect(tester.takeException(), isNull, reason: id);
      }
    });
  });
}
