// P6-D9b: shadcn padding values at the default density.
//
// Each expectation cites the shadcn/ui new-york Tailwind class it mirrors and
// the registry default that implements it. This file pins the values; whether
// those values scale with density is asserted separately in
// `layout_audit_density_test.dart`.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/alert/alert.dart';
import 'package:flutter_shadcn_kit/registry/components/badge/badge.dart';
import 'package:flutter_shadcn_kit/registry/components/button/button.dart';
import 'package:flutter_shadcn_kit/registry/components/card/card.dart';
import 'package:flutter_shadcn_kit/registry/components/chip/chip.dart';
import 'package:flutter_shadcn_kit/registry/components/input/input.dart';
import 'package:flutter_shadcn_kit/registry/components/menu/menu.dart';
import 'package:flutter_shadcn_kit/registry/components/table/table.dart';
import 'package:flutter_test/flutter_test.dart';

import 'layout_audit_support.dart';

void _noop(Object? value) {}

void main() {
  group('chip — shadcn `px-2 py-0.5 text-xs`', () {
    testWidgets('default padding is horizontal 8 / vertical 2', (tester) async {
      await tester.pumpWidget(
        auditFrame(child: const Chip(child: Text('Chip'))),
      );
      final EdgeInsets padding = resolvedPaddingOf(tester, Chip);
      expect(padding.left, 8, reason: 'px-2');
      expect(padding.right, 8, reason: 'px-2');
      expect(padding.top, 2, reason: 'py-0.5');
      expect(padding.bottom, 2, reason: 'py-0.5');
    });

    testWidgets('the remove control has no padding of its own', (tester) async {
      await tester.pumpWidget(
        auditFrame(
          child: ChipButton(onPressed: () {}, child: const Text('x')),
        ),
      );
      expect(resolvedPaddingOf(tester, ChipButton), EdgeInsets.zero);
    });
  });

  group('badge — shadcn `px-2 py-0.5 text-xs`', () {
    testWidgets('default padding is horizontal 8 / vertical 2', (tester) async {
      await tester.pumpWidget(
        auditFrame(child: const Badge(child: Text('New'))),
      );
      final EdgeInsets padding = resolvedPaddingOf(tester, Badge);
      expect(padding.left, 8, reason: 'px-2');
      expect(padding.right, 8, reason: 'px-2');
      expect(padding.top, 2, reason: 'py-0.5');
      expect(padding.bottom, 2, reason: 'py-0.5');
    });
  });

  group('input — shadcn `px-3 py-2`', () {
    testWidgets('default padding is horizontal 12 / vertical 8', (
      tester,
    ) async {
      await tester.pumpWidget(auditFrame(child: Input()));
      // Index 1: the first `Padding` inside an input reserves the 1px border.
      final EdgeInsets padding = resolvedPaddingOf(tester, Input, index: 1);
      expect(padding.left, 12, reason: 'px-3');
      expect(padding.right, 12, reason: 'px-3');
      expect(padding.top, 8, reason: 'py-2');
      expect(padding.bottom, 8, reason: 'py-2');
    });
  });

  group('button — shadcn `px-4` at size md', () {
    testWidgets('default padding is horizontal 16 / vertical 0', (
      tester,
    ) async {
      await tester.pumpWidget(
        auditFrame(
          child: Button(onPressed: () {}, child: const Text('Button')),
        ),
      );
      final EdgeInsets padding = resolvedPaddingOf(tester, Button);
      expect(padding.left, 16, reason: 'px-4');
      expect(padding.right, 16, reason: 'px-4');
      expect(padding.top, 0, reason: 'height comes from minHeight');
      expect(padding.bottom, 0, reason: 'height comes from minHeight');
    });

    testWidgets('each size cites its own px step', (tester) async {
      const List<(ButtonSize, double)> cases = <(ButtonSize, double)>[
        (ButtonSize.xs, 8),
        (ButtonSize.sm, 12),
        (ButtonSize.md, 16),
        (ButtonSize.lg, 24),
      ];
      for (final (ButtonSize size, double expected) in cases) {
        await tester.pumpWidget(
          auditFrame(
            child: Button(onPressed: () {}, size: size, child: const Text('B')),
          ),
        );
        expect(
          resolvedPaddingOf(tester, Button).left,
          expected,
          reason: 'button ${size.name} horizontal padding',
        );
      }
    });

    testWidgets('an icon button is square with zero padding', (tester) async {
      // A loose host: an icon button must keep its intrinsic 36x36 square and
      // never stretch to the parent width.
      final Widget button = Button(
        onPressed: () {},
        size: ButtonSize.icon,
        child: const Text('x'),
      );
      await tester.pumpWidget(
        auditFrame(
          child: button,
          parent: looseHost(child: button),
        ),
      );
      expect(resolvedPaddingOf(tester, Button), EdgeInsets.zero);
      expect(sizeOf(tester, Button).width, 36, reason: 'h-9 / w-9');
      expect(sizeOf(tester, Button).height, 36);
    });
  });

  group('table cell — shadcn `p-2`', () {
    testWidgets('cell padding is 8 on every side', (tester) async {
      await tester.pumpWidget(
        auditFrame(
          child: TableCellView(
            current: const TableCellRange(0, 0, 1, 1),
            hoveredNotifier: ValueNotifier<TableCellRange?>(null),
            padding: tableCellPadding,
            child: const Text('cell'),
          ),
        ),
      );
      final EdgeInsets padding = resolvedPaddingOf(tester, TableCellView);
      expect(padding.left, 8, reason: 'p-2');
      expect(padding.right, 8, reason: 'p-2');
      expect(padding.top, 8, reason: 'p-2');
      expect(padding.bottom, 8, reason: 'p-2');
    });

    testWidgets('header cell padding matches its documented value', (
      tester,
    ) async {
      // table_style.dart:277 `EdgeInsets.symmetric(horizontal: 8)`: shadcn's
      // `TableHead` is `h-10 px-2` — horizontal padding only, the height comes
      // from the cell's `minHeight`.
      expect(tableHeadCellPadding, const EdgeInsets.symmetric(horizontal: 8));
    });
  });

  group('menu row — shadcn `px-2 py-1.5`', () {
    testWidgets('default row padding is horizontal 8 / vertical 6', (
      tester,
    ) async {
      await tester.pumpWidget(
        auditFrame(
          child: MenuGroup(
            direction: Axis.vertical,
            builder: (context, rows) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: rows,
            ),
            children: const <MenuItem>[
              MenuButton(onPressed: _noop, child: Text('Cut')),
            ],
          ),
        ),
      );
      // menu.dart:208 `EdgeInsets.symmetric(horizontal: 8, vertical: 6)`.
      final RovingRow row = tester.widget<RovingRow>(find.byType(RovingRow));
      expect(
        row.padding!.resolve(TextDirection.ltr),
        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        reason: 'px-2 py-1.5',
      );
    });
  });

  group('card — shadcn `py-6`', () {
    testWidgets('root padding is 24 on every side', (tester) async {
      await tester.pumpWidget(
        auditFrame(child: const Card(child: Text('body'))),
      );
      final EdgeInsets padding = resolvedPaddingOf(tester, Card);
      expect(padding.left, 24, reason: 'p-6');
      expect(padding.right, 24, reason: 'p-6');
      expect(padding.top, 24, reason: 'py-6');
      expect(padding.bottom, 24, reason: 'py-6');
    });
  });

  group('alert — documented 16px content padding', () {
    testWidgets('leading rail keeps 16px horizontal padding', (tester) async {
      await tester.pumpWidget(
        auditFrame(
          child: const Alert(title: Text('T'), content: Text('body')),
        ),
      );
      final EdgeInsets padding = resolvedPaddingOf(tester, Alert);
      expect(padding.left, 16);
      expect(padding.right, 16);
    });
  });
}
