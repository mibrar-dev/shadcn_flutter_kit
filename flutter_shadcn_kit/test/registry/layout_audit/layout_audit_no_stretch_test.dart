// P6-D9b: no stretch, no compact.
//
// "Every component must render exactly right — never stretched, never
// compacted."
//
// * never stretched: inside a `Row`/`Column` with loose constraints AND inside
//   a 600px wide parent, an intrinsic-size component keeps its own width.
//   Components documented as full-width (a card surface) may grow.
// * never compacted: a long label inside a tight box still carries the full
//   shadcn padding — the padding is never squeezed away to fit the text.
//
// Note on the harness: `flutter_test` gives the root tight constraints equal
// to the surface size, so a `SizedBox` must be wrapped in a `Center` (loose
// constraints) before it can actually bound a component.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/badge/badge.dart';
import 'package:flutter_shadcn_kit/registry/components/button/button.dart';
import 'package:flutter_shadcn_kit/registry/components/card/card.dart';
import 'package:flutter_shadcn_kit/registry/components/chip/chip.dart';
import 'package:flutter_test/flutter_test.dart';

import 'layout_audit_support.dart';

/// The tight host used for the no-compact assertions. 80 is tall enough for a
/// long label to wrap instead of being clipped.
Widget tightHost(Widget child) =>
    Center(child: SizedBox(width: 48, height: 80, child: child));

/// Width of [child] when its host shrink-wraps it.
Future<double> widthLoose(WidgetTester tester, Widget child, Type type) async {
  await tester.pumpWidget(
    auditFrame(
      child: child,
      parent: looseHost(child: child),
    ),
  );
  return sizeOf(tester, type).width;
}

/// Width of [child] inside a 600px wide parent that would let it stretch.
Future<double> widthWide(WidgetTester tester, Widget child, Type type) async {
  await tester.pumpWidget(
    auditFrame(
      child: child,
      parent: SizedBox(
        width: 600,
        child: Center(child: looseHost(child: child)),
      ),
    ),
  );
  return sizeOf(tester, type).width;
}

/// Asserts [child] keeps its intrinsic width in a loose and a wide host.
Future<void> expectIntrinsicWidth(
  WidgetTester tester,
  Widget child,
  Type type,
) async {
  final double loose = await widthLoose(tester, child, type);
  final double wide = await widthWide(tester, child, type);
  expect(
    wide,
    closeTo(loose, 0.01),
    reason: '$type must keep its intrinsic width ($loose) inside a wide parent',
  );
  expect(wide, lessThan(600), reason: '$type must not stretch to the parent');
}

/// Asserts the padding survives a tight (narrow) host.
Future<void> expectPaddingUnderTightHost(
  WidgetTester tester,
  Widget child,
  Type type, {
  required EdgeInsets expected,
}) async {
  await tester.pumpWidget(auditFrame(child: child, parent: tightHost(child)));
  expect(
    resolvedPaddingOf(tester, type),
    expected,
    reason: '$type must keep its padding even when its label has to wrap',
  );
}

void main() {
  group('intrinsic-size controls never stretch', () {
    testWidgets('chip keeps its own width', (tester) async {
      await expectIntrinsicWidth(tester, const Chip(child: Text('Chip')), Chip);
    });

    testWidgets('badge keeps its own width', (tester) async {
      await expectIntrinsicWidth(
        tester,
        const Badge(child: Text('New')),
        Badge,
      );
    });

    testWidgets('button keeps its own width', (tester) async {
      await expectIntrinsicWidth(
        tester,
        Button(onPressed: () {}, child: const Text('Button')),
        Button,
      );
    });

    testWidgets('an icon button keeps its intrinsic 36x36 square', (
      tester,
    ) async {
      final Widget button = Button(
        onPressed: () {},
        size: ButtonSize.icon,
        child: const Text('x'),
      );
      await expectIntrinsicWidth(tester, button, Button);
      expect(sizeOf(tester, Button).height, 36, reason: 'h-9');
    });

    testWidgets('a long chip label wraps instead of losing its padding', (
      tester,
    ) async {
      const String long =
          'A very long chip label that has to wrap onto several lines';
      await tester.pumpWidget(
        auditFrame(
          child: const Chip(child: Text(long)),
          parent: Center(
            child: SizedBox(width: 160, child: const Chip(child: Text(long))),
          ),
        ),
      );
      final EdgeInsets padding = resolvedPaddingOf(tester, Chip);
      expect(padding.left, 8, reason: 'px-2 survives the tight box');
      expect(padding.right, 8, reason: 'px-2 survives the tight box');
      expect(padding.top, 2, reason: 'py-0.5 survives the tight box');
      expect(padding.bottom, 2, reason: 'py-0.5 survives the tight box');
      final double labelHeight = tester.getRect(find.text(long).last).height;
      expect(
        sizeOf(tester, Chip).height,
        greaterThan(labelHeight),
        reason: 'the wrapped label must fit inside the chip',
      );
    });
  });

  group('padding survives tight hosts (no compact)', () {
    testWidgets('chip keeps px-2 py-0.5 in a 48px box', (tester) async {
      await expectPaddingUnderTightHost(
        tester,
        const Chip(child: Text('Compact')),
        Chip,
        expected: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      );
    });

    testWidgets('badge keeps px-2 py-0.5 in a 48px box', (tester) async {
      await expectPaddingUnderTightHost(
        tester,
        const Badge(child: Text('Compact')),
        Badge,
        expected: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      );
    });
  });

  group('documented full-width controls', () {
    // A card is a block surface: it fills the width it is given, so the
    // stretch is documented, not a defect. Its padding must still be p-6.
    testWidgets('card fills the 400px host and keeps p-6', (tester) async {
      await tester.pumpWidget(
        auditFrame(
          child: const Card(child: Text('body')),
          parent: const Center(
            child: SizedBox(
              width: 400,
              height: 200,
              child: Card(child: Text('body')),
            ),
          ),
        ),
      );
      expect(sizeOf(tester, Card).width, 400, reason: 'a card is full-width');
      expect(
        resolvedPaddingOf(tester, Card),
        const EdgeInsets.all(24),
        reason: 'p-6',
      );
    });
  });
}
