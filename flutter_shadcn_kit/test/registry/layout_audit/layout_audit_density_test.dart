// P6-D9b: density scaling of every listed user-facing component.
//
// Target rule (user requirement 2026-10-10): padding = the shadcn value x
// density. The kit's own wording of that rule is `_buttonMetricsFor` in
// `button.dart`: `scale = density.baseContentPadding /
// Density.defaultDensity.baseContentPadding`, so at the default density the
// scale is exactly 1 and every component measures its shadcn value.
//
// A test whose assertion fails today is a FINDING and is marked `skip:` with
// the file:line that must change; the fix batches remove the skip.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/badge/badge.dart';
import 'package:flutter_shadcn_kit/registry/components/button/button.dart';
import 'package:flutter_shadcn_kit/registry/components/chip/chip.dart';
import 'package:flutter_shadcn_kit/registry/components/dialog/dialog.dart';
import 'package:flutter_shadcn_kit/registry/components/input/input.dart';
import 'package:flutter_shadcn_kit/registry/components/menu/menu.dart';
import 'package:flutter_shadcn_kit/registry/components/select/select.dart';
import 'package:flutter_shadcn_kit/registry/components/tabs/tabs.dart';
import 'package:flutter_shadcn_kit/registry/components/table/table.dart';
import 'package:flutter_shadcn_kit/registry/components/toast/toast.dart';
import 'package:flutter_shadcn_kit/registry/theme/density.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

import 'layout_audit_support.dart';

/// Density scale of the kit's documented rule: exactly 1 at the default
/// density, 0.5 at compact, 1.25 at comfortable.
double scaleAt(Density density) =>
    density.baseContentPadding / Density.defaultDensity.baseContentPadding;

/// A shadcn value scaled by [density].
double scaled(double shadcn, Density density) => shadcn * scaleAt(density);

/// Renders [child] under every audited density and collects its padding.
Future<List<EdgeInsets>> measurePadding(
  WidgetTester tester,
  Widget child,
  Type type, {
  Widget Function(Widget child)? host,
  int index = 0,
}) async {
  final List<EdgeInsets> measured = <EdgeInsets>[];
  for (final Density density in auditDensities) {
    await tester.pumpWidget(
      auditFrame(
        density: density,
        child: child,
        parent: host?.call(child) ?? looseHost(child: child),
      ),
    );
    measured.add(resolvedPaddingOf(tester, type, index: index));
  }
  return measured;
}

/// Asserts compact < default < comfortable on both axes.
///
/// An axis whose default value is 0 (a button's vertical padding) carries no
/// scaling information and is skipped rather than reported as flat.
void expectMonotonic(List<EdgeInsets> measured, String label) {
  double get(EdgeInsets e, int axis) =>
      axis == 0 ? e.left + e.right : e.top + e.bottom;
  for (int axis = 0; axis < 2; axis++) {
    if (get(measured[1], axis) == 0) {
      continue;
    }
    final String name = axis == 0 ? 'horizontal' : 'vertical';
    expect(
      get(measured[0], axis),
      lessThan(get(measured[1], axis)),
      reason: '$label $name: compact < default',
    );
    expect(
      get(measured[1], axis),
      lessThan(get(measured[2], axis)),
      reason: '$label $name: default < comfortable',
    );
  }
}

/// Asserts every measured padding equals the shadcn value scaled by density.
void expectScaled(
  List<EdgeInsets> measured, {
  required double horizontal,
  required double vertical,
  required String label,
}) {
  for (int i = 0; i < auditDensities.length; i++) {
    final Density density = auditDensities[i];
    final double factor = scaleAt(density);
    final String label2 = '${auditDensityNames[i]} $label (x$factor)';
    expect(
      measured[i].left,
      closeTo(scaled(horizontal, density), 0.001),
      reason: '$label2 left',
    );
    expect(
      measured[i].right,
      closeTo(scaled(horizontal, density), 0.001),
      reason: '$label2 right',
    );
    expect(
      measured[i].top,
      closeTo(scaled(vertical, density), 0.001),
      reason: '$label2 top',
    );
    expect(
      measured[i].bottom,
      closeTo(scaled(vertical, density), 0.001),
      reason: '$label2 bottom',
    );
  }
}

void _noop(Object? value) {}

Widget _menuRow() => MenuGroup(
  direction: Axis.vertical,
  builder: (context, rows) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: rows,
  ),
  children: const <MenuItem>[MenuButton(onPressed: _noop, child: Text('Cut'))],
);

Widget _select() => Select<String>(
  value: 'a',
  onChanged: (_) {},
  placeholder: const Text('Pick'),
  itemBuilder: (context, value) => Text(value),
  items: const <Widget>[Text('A')],
);

Widget _tabs() => const Tabs(
  index: 0,
  children: <TabItem>[
    TabItem(child: Text('One')),
    TabItem(child: Text('Two')),
  ],
);

Widget _cell() => TableCellView(
  current: const TableCellRange(0, 0, 1, 1),
  hoveredNotifier: ValueNotifier<TableCellRange?>(null),
  padding: tableCellPadding,
  child: const Text('cell'),
);

void main() {
  group('compliant components scale with density', () {
    testWidgets('button: px-4 scales (the reference implementation)', (
      tester,
    ) async {
      final List<EdgeInsets> measured = await measurePadding(
        tester,
        Button(onPressed: () {}, child: const Text('Button')),
        Button,
      );
      expectScaled(measured, horizontal: 16, vertical: 0, label: 'button');
      expectMonotonic(measured, 'button');
    });

    testWidgets('dialog: p-6 scales via EdgeInsetsDensity', (tester) async {
      // dialog_style.dart:193 `EdgeInsetsDensity.all(padMd)`, resolved against
      // `density.baseContentPadding` => 24 at the default density.
      EdgeInsets cardPadding() => tester
          .widget<Padding>(
            find.descendant(
              of: find.byKey(kDialogSurfaceKey),
              matching: find.byType(Padding),
            ),
          )
          .padding
          .resolve(TextDirection.ltr);
      final List<EdgeInsets> measured = <EdgeInsets>[];
      for (final Density density in auditDensities) {
        late BuildContext host;
        await tester.pumpWidget(
          ShadcnTheme(
            data: const ShadcnThemeData().copyWith(density: () => density),
            child: ComponentThemes(
              themes: const <ComponentThemeData>[],
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Navigator(
                  // A per-density key rebuilds the route under the new theme.
                  key: ValueKey<String>('audit-nav-${density.hashCode}'),
                  onGenerateRoute: (settings) => PageRouteBuilder<void>(
                    settings: settings,
                    pageBuilder: (context, _, _) {
                      host = context;
                      return const SizedBox(width: 10, height: 10);
                    },
                  ),
                ),
              ),
            ),
          ),
        );
        showShadcnDialog<void>(
          context: host,
          builder: (_) => const Text('body'),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));
        measured.add(cardPadding());
      }
      expectScaled(measured, horizontal: 24, vertical: 24, label: 'dialog');
      expectMonotonic(measured, 'dialog');
    });
  });

  group('findings — the padding is a fixed literal', () {
    testWidgets(
      'chip: px-2 py-0.5 is fixed',
      (tester) async {
        // FINDING: chip_style.dart:29-32 `chipDefaultPadding` is a raw
        // `EdgeInsets.symmetric(horizontal: 8, vertical: 2)` that never reads
        // the density; fix -> derive it from `density.baseContentPadding`.
        final List<EdgeInsets> measured = await measurePadding(
          tester,
          const Chip(child: Text('Chip')),
          Chip,
        );
        expectScaled(measured, horizontal: 8, vertical: 2, label: 'chip');
        expectMonotonic(measured, 'chip');
      },
      // P6-D9b finding (why this test is skipped): P6-D9b finding: chip_style.dart:29-32 chipDefaultPadding is a raw EdgeInsets.symmetric(horizontal: 8, vertical: 2); it never reads the density
      skip: true,
    );

    testWidgets(
      'badge: px-2 py-0.5 is fixed',
      (tester) async {
        // FINDING: badge_style.dart:273-276 `badgeDefaultPadding` is a raw
        // `EdgeInsets.symmetric(horizontal: 8, vertical: 2)`.
        final List<EdgeInsets> measured = await measurePadding(
          tester,
          const Badge(child: Text('New')),
          Badge,
        );
        expectScaled(measured, horizontal: 8, vertical: 2, label: 'badge');
        expectMonotonic(measured, 'badge');
      },
      // P6-D9b finding (why this test is skipped): P6-D9b finding: badge_style.dart:273-276 badgeDefaultPadding is a raw EdgeInsets.symmetric(horizontal: 8, vertical: 2)
      skip: true,
    );

    testWidgets(
      'input: px-3 py-2 is fixed',
      (tester) async {
        // FINDING: input_style.dart:209 `inputDefaults.padding` is a raw
        // `EdgeInsets.symmetric(horizontal: 12, vertical: 8)`.
        // An input is a full-width control: it needs a bounded host, not a
        // shrink-wrapping one.
        final List<EdgeInsets> measured = await measurePadding(
          tester,
          Input(),
          Input,
          host: (child) => SizedBox(width: 200, child: child),
          // Index 1: an input's first `Padding` reserves its 1px border.
          index: 1,
        );
        expectScaled(measured, horizontal: 12, vertical: 8, label: 'input');
        expectMonotonic(measured, 'input');
      },
      // P6-D9b finding (why this test is skipped): P6-D9b finding: input_style.dart:209 inputDefaults.padding is a raw EdgeInsets.symmetric(horizontal: 12, vertical: 8)
      skip: true,
    );

    testWidgets(
      'table cell: p-2 is fixed',
      (tester) async {
        // FINDING: table_style.dart:273 `tableCellPadding` is
        // `EdgeInsets.all(8)` and :278 `tableHeadCellPadding` likewise.
        final List<EdgeInsets> measured = await measurePadding(
          tester,
          _cell(),
          TableCellView,
        );
        expectScaled(measured, horizontal: 8, vertical: 8, label: 'table cell');
        expectMonotonic(measured, 'table cell');
      },
      // P6-D9b finding (why this test is skipped): P6-D9b finding: table_style.dart:273 tableCellPadding and :278 tableHeadCellPadding are raw literals
      skip: true,
    );

    testWidgets(
      'select trigger: px-3 is fixed',
      (tester) async {
        // FINDING: select_style.dart:20-22 `selectDefaultTriggerPadding` is
        // `EdgeInsets.symmetric(horizontal: 12)`; :26-29 the item row too.
        final List<EdgeInsets> measured = await measurePadding(
          tester,
          _select(),
          Select<String>,
        );
        // shadcn `px-3` is 12; the trigger's 1px border is reserved as padding,
        // so the measured content padding is 11 before any density scaling.
        expectScaled(
          measured,
          horizontal: 11,
          vertical: 0,
          label: 'select trigger (px-3 less its 1px border)',
        );
        expectMonotonic(measured, 'select');
      },
      // P6-D9b finding (why this test is skipped): P6-D9b finding: select_style.dart:20-22 selectDefaultTriggerPadding (and :26-29 the option rows) are raw literals
      skip: true,
    );

    testWidgets(
      'menu row: px-2 py-1.5 is fixed',
      (tester) async {
        // FINDING: menu.dart:206-209 inlines
        // `EdgeInsets.symmetric(horizontal: 8, vertical: 6)` for every row.
        final List<EdgeInsets> measured = <EdgeInsets>[];
        for (final Density density in auditDensities) {
          await tester.pumpWidget(
            auditFrame(density: density, child: _menuRow()),
          );
          final RovingRow row = tester.widget<RovingRow>(
            find.byType(RovingRow),
          );
          measured.add(row.padding!.resolve(TextDirection.ltr));
        }
        expectScaled(measured, horizontal: 8, vertical: 6, label: 'menu row');
        expectMonotonic(measured, 'menu row');
      },
      // P6-D9b finding (why this test is skipped): P6-D9b finding: menu.dart:206-209 inlines a raw EdgeInsets.symmetric(horizontal: 8, vertical: 6) for every row
      skip: true,
    );

    testWidgets('toast: p-4 is fixed', (tester) async {
      // The toast renders inside `ToastLayer`; its padding default is
      // `toast_style.dart:236` `EdgeInsets.all(16)`.
      expect(toastDefaults.padding, const EdgeInsets.all(16));
    });

    // FINDING: tabs_style.dart:247-248 `tabsDefaults` hard-codes
    // `containerPadding: EdgeInsets.all(3)` and
    // `tabPadding: EdgeInsets.symmetric(horizontal: 8)`.
    testWidgets('tabs: p-[3px] strip and px-2 pills are fixed', (tester) async {
      EdgeInsets stripPadding() =>
          (tester
                  .widget<Container>(
                    find
                        .descendant(
                          of: find.byType(Tabs),
                          matching: find.byType(Container),
                        )
                        .first,
                  )
                  .padding!)
              .resolve(TextDirection.ltr);
      final List<EdgeInsets> measured = <EdgeInsets>[];
      for (final Density density in auditDensities) {
        await tester.pumpWidget(auditFrame(density: density, child: _tabs()));
        measured.add(stripPadding());
      }
      expectScaled(measured, horizontal: 3, vertical: 3, label: 'tabs strip');
    }, skip: true);
  });
}
