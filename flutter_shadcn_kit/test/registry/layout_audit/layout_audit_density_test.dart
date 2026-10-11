// P6-D9b: density scaling of every listed user-facing component.
//
// Target rule (user requirement 2026-10-10): padding = the shadcn value x
// density. The kit's own wording of that rule is `_buttonMetricsFor` in
// `button.dart`: `scale = density.baseContentPadding /
// Density.defaultDensity.baseContentPadding`, so at the default density the
// scale is exactly 1 and every component measures its shadcn value.
//
// A test whose assertion fails today is a FINDING; the previous audit shipped
// them with `skip: true` and the fix removed both. P6-F1 fixed them all, so
// every test in this file runs for real.

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
        // Pop the route and settle the transition before the next density:
        // a route left mid-transition keeps its focus scope attached to the
        // focus manager and trips the next test's autofocus assertions.
        Navigator.of(host).pop();
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pump(const Duration(milliseconds: 400));
      }
      expectScaled(measured, horizontal: 24, vertical: 24, label: 'dialog');
      expectMonotonic(measured, 'dialog');
    });
  });

  group('density-derived padding (the P6-D9b findings, now fixed)', () {
    testWidgets('chip: px-2 py-0.5 scales', (tester) async {
      // chip_style.dart `chipDefaultPadding` is `EdgeInsetsDensity.pxSymmetric(
      // horizontal: 8, vertical: 2)`, resolved by `chip.dart` against
      // `density.baseContentPadding * scaling`.
      final List<EdgeInsets> measured = await measurePadding(
        tester,
        const Chip(child: Text('Chip')),
        Chip,
      );
      expectScaled(measured, horizontal: 8, vertical: 2, label: 'chip');
      expectMonotonic(measured, 'chip');
    });

    testWidgets('badge: px-2 py-0.5 scales', (tester) async {
      // badge_style.dart `badgeDefaultPadding` is density-derived like the
      // chip's.
      final List<EdgeInsets> measured = await measurePadding(
        tester,
        const Badge(child: Text('New')),
        Badge,
      );
      expectScaled(measured, horizontal: 8, vertical: 2, label: 'badge');
      expectMonotonic(measured, 'badge');
    });

    testWidgets('input: px-3 py-2 scales', (tester) async {
      // input_style.dart `inputDefaultPadding` is density-derived.
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
    });

    testWidgets('table cell: p-2 scales', (tester) async {
      // table_style.dart `tableCellPadding`/`tableHeadCellPadding` are
      // density-derived and resolved by `TableCellView`.
      final List<EdgeInsets> measured = await measurePadding(
        tester,
        _cell(),
        TableCellView,
      );
      expectScaled(measured, horizontal: 8, vertical: 8, label: 'table cell');
      expectMonotonic(measured, 'table cell');
    });

    testWidgets('select trigger: px-3 scales', (tester) async {
      // select_style.dart `selectDefaultTriggerPadding` and
      // `selectDefaultItemPadding` are density-derived.
      final List<EdgeInsets> measured = await measurePadding(
        tester,
        _select(),
        Select<String>,
      );
      // shadcn `px-3` is 12; the trigger's 1px border is a hairline that
      // never scales with density, and it is inset from the content padding
      // per side, so the measured padding is `12 * scale - 1` rather than
      // `(12 - 1) * scale`.
      for (int i = 0; i < auditDensities.length; i++) {
        final Density density = auditDensities[i];
        expect(
          measured[i].left,
          closeTo(12 * scaleAt(density) - 1, 0.001),
          reason: '${auditDensityNames[i]} select trigger left',
        );
        expect(measured[i].top, 0, reason: 'vertical padding is none');
      }
      expectMonotonic(measured, 'select');
    });

    testWidgets('menu row: px-2 py-1.5 scales', (tester) async {
      // menu_style.dart `menuItemDefaultPadding` is resolved by `menu.dart`.
      final List<EdgeInsets> measured = <EdgeInsets>[];
      for (final Density density in auditDensities) {
        await tester.pumpWidget(
          auditFrame(density: density, child: _menuRow()),
        );
        final RovingRow row = tester.widget<RovingRow>(find.byType(RovingRow));
        measured.add(row.padding!.resolve(TextDirection.ltr));
      }
      expectScaled(measured, horizontal: 8, vertical: 6, label: 'menu row');
      expectMonotonic(measured, 'menu row');
    });

    testWidgets('toast: p-4 is density-derived', (tester) async {
      // The toast renders inside `ToastLayer`; its padding default is
      // `toast_style.dart` `toastDefaultPadding`, an `EdgeInsetsDensity`
      // that resolves to 16 at the default density.
      expect(
        toastDefaults.padding,
        const EdgeInsetsDensity.pxAll(16),
        reason: 'shadcn p-4',
      );
      expect(
        resolveEdgeInsets(
          toastDefaults.padding!,
          Density.defaultDensity.baseContentPadding,
        ),
        const EdgeInsets.all(16),
      );
    });

    // tabs_style.dart `tabsDefaults` derives `containerPadding` (p-[3px]) and
    // `tabPadding` (px-2) from density; `tabs.dart` resolves both.
    testWidgets('tabs: p-[3px] strip and px-2 pills scale', (tester) async {
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
    });
  });
}
