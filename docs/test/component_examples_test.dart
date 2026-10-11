// P7-D1 proofs: every named example renders in its own Preview | Code
// card on every listed component page, each card's Code tab carries that
// example's source, and the pages hold together at 375 and 1440 px.
//
// P7-D1b: the stage centres every example on both axes (example centre ==
// stage centre ±1 px at 1440 and 375 for button/badge/input/table/tabs/
// calendar/card/alert/accordion) and the toolbar stays a single row at
// 320/375 with an icon-only light/dark toggle.

import 'package:docs/generated/docs_data.dart';
import 'package:docs/generated/docs_example_sources.dart';
import 'package:docs/generated/docs_previews.dart';
import 'package:docs/ui/shadcn/components/accordion/accordion.dart';
import 'package:docs/ui/shadcn/components/alert/alert.dart';
import 'package:docs/ui/shadcn/components/badge/badge.dart';
import 'package:docs/ui/shadcn/components/button/button.dart';
import 'package:docs/ui/shadcn/components/calendar/calendar.dart';
import 'package:docs/ui/shadcn/components/card/card.dart';
import 'package:docs/ui/shadcn/components/input/input.dart';
import 'package:docs/ui/shadcn/components/table/table.dart';
import 'package:docs/ui/shadcn/components/tabs/tabs.dart';
import 'package:docs/widgets/component_preview_card.dart';
import 'package:docs/widgets/example_preview_card.dart';
import 'package:docs/widgets/preview_stage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';

/// Listed components that ship named examples.
List<String> get _exampleIds => <String>[
  for (final DocsComponent component in kComponents)
    if (component.listed &&
        (kComponentPreviews[component.id] ?? const <String>[]).isNotEmpty)
      component.id,
];

void main() {
  test('sweep inputs are self-consistent', () {
    expect(_exampleIds, isNotEmpty);
    for (final String id in _exampleIds) {
      expect(
        kExampleSources[id]!.length,
        kComponentPreviews[id]!.length,
        reason: id,
      );
    }
  });

  testWidgets('every listed page renders one card per example', (
    WidgetTester tester,
  ) async {
    final delegate = await pumpDocsApp(tester);
    for (final String id in _exampleIds) {
      // Bounded pumps, not pumpAndSettle: mounting every example also
      // mounts the animated ones (carousel autoplay, tickers, spinners),
      // whose repeating timers never let the scheduler settle.
      delegate.go(
        tester.element(find.byType(Navigator).last),
        '/docs/components/$id',
      );
      await _pumpSoon(tester);
      final int count = kComponentPreviews[id]!.length;
      expect(find.byType(ExamplePreviewCard), findsNWidgets(count), reason: id);
      // Each card has its own Preview/Code tabs.
      expect(
        find.descendant(
          of: find.byType(ExamplePreviewCard),
          matching: find.text('Preview'),
        ),
        findsNWidgets(count),
        reason: '$id preview tabs',
      );
      expect(
        find.descendant(
          of: find.byType(ExamplePreviewCard),
          matching: find.text('Code'),
        ),
        findsNWidgets(count),
        reason: '$id code tabs',
      );
      expect(tester.takeException(), isNull, reason: id);
    }
  }, timeout: const Timeout(Duration(minutes: 20)));

  testWidgets('code tabs carry the example builder bodies', (
    WidgetTester tester,
  ) async {
    final delegate = await pumpDocsApp(tester);
    const Map<String, List<String>> builders = <String, List<String>>{
      'select': <String>['_FruitSelect', '_GroupedSelect'],
      'tabs': <String>['_InteractiveTabs', '_PaneDemo'],
      'calendar': <String>['_CalendarCalendarPanel', '_calendarReadOnly'],
    };
    for (final MapEntry<String, List<String>> entry in builders.entries) {
      await goTo(tester, delegate, '/docs/components/${entry.key}');
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      final int count = kComponentPreviews[entry.key]!.length;
      for (int i = 0; i < count; i++) {
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
      }
      for (final String builder in entry.value) {
        expect(
          find.textContaining(builder),
          findsWidgets,
          reason: '${entry.key}/$builder',
        );
      }
      expect(tester.takeException(), isNull, reason: entry.key);
    }
  });

  testWidgets('no overflow at 375 and 1440', (WidgetTester tester) async {
    for (final double width in <double>[375, 1440]) {
      // Fresh tree per width (as in the responsive audit): re-pumping over
      // the previous width's tree leaves transient transition frames behind.
      await tester.pumpWidget(const SizedBox.shrink());
      tester.takeException();
      final delegate = await pumpDocsApp(tester, width: width);
      for (final String id in <String>[
        'button',
        'select',
        'calendar',
        'tabs',
      ]) {
        await goTo(tester, delegate, '/docs/components/$id');
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: '$id@$width');
      }
    }
  });

  testWidgets('D1b: example stage centres content at 1440 and 375', (
    WidgetTester tester,
  ) async {
    const Map<String, Type> content = <String, Type>{
      'button': Button,
      'badge': Badge,
      'input': Input,
      'table': ShadcnTable,
      'tabs': Tabs,
      'calendar': Calendar,
      'card': Card,
      'alert': Alert,
      'accordion': Accordion,
    };
    for (final double width in <double>[1440, 375]) {
      await tester.pumpWidget(const SizedBox.shrink());
      tester.takeException();
      final delegate = await pumpDocsApp(tester, width: width);
      for (final MapEntry<String, Type> entry in content.entries) {
        await goTo(tester, delegate, '/docs/components/${entry.key}');
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: '${entry.key}@$width');
        final Finder stage = find.byType(PreviewStage).first;
        expect(stage, findsOneWidget, reason: '${entry.key}@$width stage');
        final Offset stageCenter = tester.getCenter(stage);
        // The example bounding box (the loader) is centred in the stage on
        // both axes.
        final Finder loader = find.descendant(
          of: stage,
          matching: find.byType(PreviewExampleLoader),
        );
        expect(loader, findsOneWidget, reason: '${entry.key}@$width loader');
        final Offset loaderCenter = tester.getCenter(loader);
        expect(
          (loaderCenter.dx - stageCenter.dx).abs(),
          lessThanOrEqualTo(1.0),
          reason: '${entry.key}@$width dx',
        );
        expect(
          (loaderCenter.dy - stageCenter.dy).abs(),
          lessThanOrEqualTo(1.0),
          reason: '${entry.key}@$width dy',
        );
        // The reported bug: the Button demo sat at the left edge. Every
        // example's main content is centred horizontally (the D1b preview
        // fixes centre button/badge/calendar and cap inputs/cards); vertical
        // centring of stacked children is the loader's (checked above).
        // Tabs on narrow phones is wider than the stage and scrolls instead
        // of centring its strip: skip its inner dx at 375 (the loader is
        // still centred and there is no overflow).
        if (!(entry.key == 'tabs' && width == 375)) {
          final Finder inner = find.descendant(
            of: stage,
            matching: find.byType(entry.value),
          );
          expect(inner, findsWidgets, reason: '${entry.key}@$width content');
          final Offset innerCenter = tester.getCenter(inner.first);
          expect(
            (innerCenter.dx - stageCenter.dx).abs(),
            lessThanOrEqualTo(1.0),
            reason: '${entry.key}@$width content dx',
          );
          // Single-child examples are centred vertically too.
          if (entry.key == 'button') {
            expect(
              (innerCenter.dy - stageCenter.dy).abs(),
              lessThanOrEqualTo(1.0),
              reason: 'button@$width content dy',
            );
          }
        }
      }
    }
  }, timeout: const Timeout(Duration(minutes: 20)));

  testWidgets('D1b: toolbar stays single row at 320 and 375', (
    WidgetTester tester,
  ) async {
    for (final double width in <double>[320, 375]) {
      await tester.pumpWidget(const SizedBox.shrink());
      tester.takeException();
      final delegate = await pumpDocsApp(tester, width: width);
      // Drain the initial route's exceptions (the landing announcement is
      // 260 px wide and overflows at 320; out of scope for this polish):
      // this test only asserts the component-page toolbar.
      tester.takeException();
      await goTo(tester, delegate, '/docs/components/button');
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'button@$width');
      final Finder tabs = find.byKey(const ValueKey<String>('example-tabs-0'));
      final Finder toggle = find.byKey(
        const ValueKey<String>('preview-theme-toggle-0'),
      );
      final Finder copy = find.byKey(const ValueKey<String>('example-copy-0'));
      expect(tabs, findsOneWidget, reason: 'tabs@$width');
      expect(toggle, findsOneWidget, reason: 'toggle@$width');
      expect(copy, findsOneWidget, reason: 'copy@$width');
      final Offset tabsCenter = tester.getCenter(tabs);
      final Offset toggleCenter = tester.getCenter(toggle);
      final Offset copyCenter = tester.getCenter(copy);
      // Single row: tabs, toggle and copy share one horizontal line.
      expect(
        (toggleCenter.dy - tabsCenter.dy).abs(),
        lessThanOrEqualTo(8.0),
        reason: 'toolbar row@$width',
      );
      expect(
        (copyCenter.dy - tabsCenter.dy).abs(),
        lessThanOrEqualTo(8.0),
        reason: 'toolbar row@$width',
      );
      // Icon-only toggle: no Light/Dark text in the card toolbar.
      final Finder firstCard = find.byType(ExamplePreviewCard).first;
      expect(
        find.descendant(of: firstCard, matching: find.text('Light')),
        findsNothing,
        reason: 'icon-only@$width',
      );
      expect(
        find.descendant(of: firstCard, matching: find.text('Dark')),
        findsNothing,
        reason: 'icon-only@$width',
      );
    }
  });
}

/// Bounded settle: enough frames for the deferred chunks and lazy cards,
/// without hanging on the animated examples' repeating timers.
Future<void> _pumpSoon(WidgetTester tester) async {
  for (int i = 0; i < 30; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}
