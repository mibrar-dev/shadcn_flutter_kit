// Widget tests for the Theme Studio canvas (P6-T1 / P6-D8).
//
// Covers the three things the user reported broken and the brief's gates:
//   * no canvas card carries a fixed height or a stretch (the old grid
//     stretched every card to its row's tallest member);
//   * the masonry really packs: unequal cards go to the shortest column, so
//     a tall card never leaves a gap under its short neighbours;
//   * nothing overflows at 375 / 768 / 1440, in light and dark.

import 'package:docs/routing/docs_router.dart';
import 'package:docs/ui/shadcn/components/card/card.dart';
import 'package:docs/ui/shadcn/primitives/masonry_layout.dart';
import 'package:docs/ui/shadcn/theme/theme.dart';
import 'package:docs/widgets/studio_canvas.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';

/// The card count the brief demands.
const int kMinimumBlockCount = 24;

void main() {
  group('studio canvas masonry', () {
    testWidgets('the canvas is a masonry of registry blocks', (tester) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/themes');
      expect(find.byType(ThemeCanvas), findsOneWidget);
      expect(find.byType(MasonryLayout), findsOneWidget);
      expect(find.byType(Card), findsWidgets);
      expect(
        blocks.length,
        greaterThanOrEqualTo(kMinimumBlockCount),
        reason: 'the brief asks for many realistic example blocks',
      );
    });

    testWidgets('every block is built from registry components', (
      tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/themes');
      // A representative slice: the brief names these explicitly.
      for (final String label in <String>[
        'Contribution History',
        'Payout Threshold',
        'Savings Targets',
        'Claimable Balance',
        'Recent Transactions',
        'Distribute Track',
        'Preferences',
        'Overview',
        'Browse',
        'Release date',
        'Team Members',
        'Cookie Settings',
        'Create Account',
        'Payment Method',
        'Report an Issue',
        'Support',
        'Notifications',
        'Verify your phone',
        'Cover Art',
        'Team',
        'Payouts',
        'Frequently asked questions',
        'Plans',
        'Net Revenue',
        'Status',
        'Share this release',
        'Release checklist',
        'Format',
      ]) {
        expect(
          find.descendant(
            of: find.byType(ThemeCanvas),
            matching: find.text(label),
          ),
          findsWidgets,
          reason: 'canvas block "$label"',
        );
      }
    });

    testWidgets('no canvas block is wrapped in a height-pinning box', (
      tester,
    ) async {
      expect(blocks, isNotEmpty);
      for (final Widget block in blocks) {
        expect(
          switch (block) {
            SizedBox(height: final double? height) when height != null =>
              height,
            AspectRatio() => 'AspectRatio',
            ConstrainedBox(:final BoxConstraints constraints)
                when constraints.hasBoundedHeight =>
              constraints,
            _ => null,
          },
          isNull,
          reason: 'canvas block $block pins its own height',
        );
      }
    });

    testWidgets('rendered cards keep their own heights (no stretch)', (
      tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(
        tester,
        width: 1440,
        height: 900,
      );
      await goTo(tester, delegate, '/themes');
      final List<double> heights = <double>[
        for (final Element card
            in find
                .descendant(
                  of: find.byType(ThemeCanvas),
                  matching: find.byType(Card),
                )
                .evaluate())
          (card.renderObject as RenderBox).size.height,
      ];
      expect(heights.length, greaterThanOrEqualTo(kMinimumBlockCount));
      // A stretched grid would give every card in a row the same height;
      // the wall must instead contain a spread of card heights.
      expect(heights.toSet().length, greaterThan(heights.length ~/ 2));
    });

    testWidgets('cards hug their content and columns pack tightly', (
      tester,
    ) async {
      await _pumpProbe(tester);
      // Three cards of deliberately different heights under one another.
      final RenderBox tall = tester.renderObject(
        find.byKey(const ValueKey<String>('studio-probe-tall')),
      );
      final RenderBox short = tester.renderObject(
        find.byKey(const ValueKey<String>('studio-probe-short')),
      );
      // Same column width: the masonry, not the card, sizes the cross axis.
      expect(tall.size.width, short.size.width);
      // Different heights: nothing was stretched to a row height.
      expect(tall.size.height, 300);
      expect(short.size.height, 40);
      // The third card lands in the short card's column, not under the tall
      // one, and one gap (16) below it.
      expect(
        tester.getRect(find.byKey(const ValueKey<String>('studio-probe-next'))),
        const Rect.fromLTWH(200, 56, 200, 60),
      );
    });

    testWidgets('the canvas relayouts its columns with the viewport', (
      tester,
    ) async {
      Future<int> columnsAt(double width) async {
        final DocsRouterDelegate delegate = await pumpDocsApp(
          tester,
          width: width,
          height: 900,
        );
        await goTo(tester, delegate, '/themes');
        return tester
            .widget<MasonryLayout>(find.byType(MasonryLayout))
            .crossAxisCount!;
      }

      expect(await columnsAt(1440), 3);
      expect(await columnsAt(768), 2);
      expect(await columnsAt(375), 1);
    });

    testWidgets('no overflow at 375 / 768 / 1440, light and dark', (
      tester,
    ) async {
      for (final Brightness brightness in <Brightness>[
        Brightness.light,
        Brightness.dark,
      ]) {
        for (final double width in <double>[375, 768, 1440]) {
          final DocsRouterDelegate delegate = await pumpDocsApp(
            tester,
            width: width,
            height: 900,
          );
          docsState.setBrightness(brightness);
          await goTo(tester, delegate, '/themes');
          expect(
            tester.takeException(),
            isNull,
            reason: 'canvas overflow at $width ($brightness)',
          );
          expect(
            find.byType(AnimatedShadcnTheme),
            findsWidgets,
            reason: 'the canvas re-themes live at $width',
          );
        }
      }
    });
  });
}

/// Pumps a masonry with three probe boxes of different heights.
Future<void> _pumpProbe(WidgetTester tester) async {
  await tester.pumpWidget(
    const Directionality(
      textDirection: TextDirection.ltr,
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: 400,
          child: MasonryLayout.fixed(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            children: <Widget>[
              SizedBox(key: ValueKey<String>('studio-probe-tall'), height: 300),
              SizedBox(key: ValueKey<String>('studio-probe-short'), height: 40),
              SizedBox(key: ValueKey<String>('studio-probe-next'), height: 60),
            ],
          ),
        ),
      ),
    ),
  );
}
