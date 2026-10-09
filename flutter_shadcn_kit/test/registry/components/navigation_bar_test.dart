// Widget tests for the `navigation_bar` component.
//
// Covers the three containers, labels (all/selected/tooltip/marquee), groups,
// the collapsible controlled/uncontrolled flow, selection, disabled and action
// items, arrow-key roving, theme precedence on all four legs, light and dark
// tokens, sizes against the shadcn scale, and the old bugs that were fixed.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/navigation_bar/navigation_bar.dart';
import 'package:flutter_shadcn_kit/registry/components/overflow_marquee/overflow_marquee.dart';
import 'package:flutter_shadcn_kit/registry/components/tooltip/tooltip.dart';
import 'package:flutter_shadcn_kit/registry/foundation/icons/radix_icons.dart';
import 'package:flutter_shadcn_kit/registry/primitives/hidden.dart';
import 'package:flutter_shadcn_kit/registry/primitives/navigation/navigation_item_row.dart';
import 'package:flutter_shadcn_kit/registry/primitives/roving_group.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _red = Color(0xFFFF0000);
const Color _green = Color(0xFF00FF00);

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  NavigationBarTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<NavigationBarTheme>(data: scoped, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: SizedBox(width: 480, child: body)),
      ),
    ),
  );
}

NavigationItem _item(String label, {int? index, bool? enabled}) {
  return NavigationItem(
    index: index,
    enabled: enabled,
    child: Icon(RadixIcons.dot),
    label: Text(label),
  );
}

int _focusedRowIndex(WidgetTester tester) {
  final BuildContext? context = FocusManager.instance.primaryFocus?.context;
  if (context == null) {
    return -1;
  }
  final List<Element> rows = find.byType(NavigationItemRow).evaluate().toList();
  var index = -1;
  context.visitAncestorElements((Element element) {
    if (element.widget is NavigationItemRow) {
      index = rows.indexWhere((Element row) => row.widget == element.widget);
      return false;
    }
    return true;
  });
  return index;
}

Color _barBackground(WidgetTester tester) {
  final ColoredBox box = tester.widget<ColoredBox>(
    find
        .descendant(
          of: find.byType(NavigationBar),
          matching: find.byType(ColoredBox),
        )
        .first,
  );
  return box.color;
}

Color _rowBackground(WidgetTester tester, int index) {
  // The first Container is Clickable's internal decoration host (null); the
  // row body is the second one.
  final Container container = tester.widget<Container>(
    find
        .descendant(
          of: find.byType(NavigationItemRow).at(index),
          matching: find.byType(Container),
        )
        .at(1),
  );
  return (container.decoration! as BoxDecoration).color!;
}

double _labelHeight(WidgetTester tester, String label) {
  return tester
      .getSize(
        find
            .ancestor(of: find.text(label), matching: find.byType(Hidden))
            .first,
      )
      .height;
}

void main() {
  group('containers', () {
    testWidgets('bar renders items and fires onSelected', (
      WidgetTester tester,
    ) async {
      int? selected;
      await tester.pumpWidget(
        _frame(
          child: NavigationBar(
            onSelected: (int index) => selected = index,
            children: <NavigationBarItem>[_item('Home'), _item('Settings')],
          ),
        ),
      );
      expect(find.text('Home'), findsOneWidget);
      expect(find.byType(NavigationItemRow), findsNWidgets(2));
      await tester.tap(find.byType(NavigationItemRow).at(1));
      await tester.pump();
      expect(selected, 1);
    });

    testWidgets('rail lays items out vertically', (WidgetTester tester) async {
      await tester.pumpWidget(
        _frame(
          child: NavigationBar(
            container: NavigationContainerType.rail,
            labelType: NavigationLabelType.all,
            children: <NavigationBarItem>[_item('Home'), _item('Search')],
          ),
        ),
      );
      final Offset home = tester.getTopLeft(find.text('Home'));
      final Offset search = tester.getTopLeft(find.text('Search'));
      expect(search.dy, greaterThan(home.dy));
    });

    testWidgets('sidebar is 200 wide and shows its labels', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ShadcnTheme(
          data: const ShadcnThemeData(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Align(
              alignment: Alignment.centerLeft,
              child: NavigationBar(
                container: NavigationContainerType.sidebar,
                children: <NavigationBarItem>[_item('Home')],
              ),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(NavigationBar)).width, 200);
      expect(find.text('Home'), findsOneWidget);
    });
  });

  group('labels', () {
    testWidgets(
      'none hides, all shows and selected shows only the active one',
      (WidgetTester tester) async {
        Widget bar(NavigationLabelType type) => _frame(
          child: NavigationBar(
            index: 0,
            labelType: type,
            children: <NavigationBarItem>[_item('Home'), _item('Settings')],
          ),
        );
        await tester.pumpWidget(bar(NavigationLabelType.none));
        await tester.pumpAndSettle();
        expect(_labelHeight(tester, 'Home'), 0);
        await tester.pumpWidget(bar(NavigationLabelType.all));
        await tester.pumpAndSettle();
        expect(_labelHeight(tester, 'Home'), greaterThan(0));
        expect(_labelHeight(tester, 'Settings'), greaterThan(0));
        await tester.pumpWidget(bar(NavigationLabelType.selected));
        await tester.pumpAndSettle();
        expect(_labelHeight(tester, 'Home'), greaterThan(0));
        expect(_labelHeight(tester, 'Settings'), 0);
      },
    );

    testWidgets('tooltip wraps the item and marquee wraps the label', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: NavigationBar(
            labelType: NavigationLabelType.tooltip,
            children: <NavigationBarItem>[_item('Home')],
          ),
        ),
      );
      expect(find.byType(Tooltip), findsOneWidget);
      await tester.pumpWidget(
        _frame(
          child: NavigationBar(
            labelType: NavigationLabelType.all,
            children: <NavigationBarItem>[
              NavigationItem(
                child: Icon(RadixIcons.dot),
                label: const Text('A very long label'),
                overflow: NavigationOverflow.marquee,
              ),
            ],
          ),
        ),
      );
      expect(find.byType(OverflowMarquee), findsOneWidget);
    });
  });

  group('selection', () {
    testWidgets('the selected item uses the active row', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: NavigationBar(
            index: 1,
            children: <NavigationBarItem>[_item('Home'), _item('Settings')],
          ),
        ),
      );
      expect(_rowBackground(tester, 1), ShadcnColors.lightFallback.secondary);
      expect(_rowBackground(tester, 0).a, 0);
    });

    testWidgets('an item selected override beats the container index', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: NavigationBar(
            index: 0,
            children: <NavigationBarItem>[
              _item('Home'),
              NavigationItem(
                child: Icon(RadixIcons.dot),
                label: const Text('Pinned'),
                selected: true,
              ),
            ],
          ),
        ),
      );
      expect(_rowBackground(tester, 1), ShadcnColors.lightFallback.secondary);
    });

    testWidgets('an action item fires and never highlights', (
      WidgetTester tester,
    ) async {
      int actions = 0;
      await tester.pumpWidget(
        _frame(
          child: NavigationBar(
            index: 0,
            children: <NavigationBarItem>[
              _item('Home'),
              NavigationItem(
                child: Icon(RadixIcons.exit),
                label: const Text('Log out'),
                onPressed: () => actions += 1,
              ),
            ],
          ),
        ),
      );
      await tester.tap(find.byType(NavigationItemRow).at(1));
      await tester.pump();
      expect(actions, 1);
      expect(_rowBackground(tester, 1).a, 0);
    });

    testWidgets('a disabled item ignores taps', (WidgetTester tester) async {
      int? selected;
      await tester.pumpWidget(
        _frame(
          child: NavigationBar(
            onSelected: (int index) => selected = index,
            children: <NavigationBarItem>[
              _item('Home'),
              _item('Settings', enabled: false),
            ],
          ),
        ),
      );
      await tester.tap(find.byType(NavigationItemRow).at(1));
      await tester.pump();
      expect(selected, isNull);
    });
  });

  group('sections', () {
    testWidgets('group, label and divider render', (WidgetTester tester) async {
      await tester.pumpWidget(
        _frame(
          child: NavigationBar(
            container: NavigationContainerType.sidebar,
            children: <NavigationBarItem>[
              const NavigationLabel(child: Text('Main')),
              _item('Home'),
              const NavigationDivider(),
              NavigationGroup(
                label: const Text('Account'),
                children: <Widget>[_item('Profile', index: 1)],
              ),
            ],
          ),
        ),
      );
      expect(find.text('Main'), findsOneWidget);
      expect(find.text('Account'), findsOneWidget);
      expect(
        tester
            .getSize(
              find.descendant(
                of: find.byType(NavigationDivider),
                matching: find.byType(ColoredBox),
              ),
            )
            .height,
        1,
      );
    });

    testWidgets(
      'the collapsible toggles uncontrolled and stays put controlled',
      (WidgetTester tester) async {
        bool? expanded;
        await tester.pumpWidget(
          _frame(
            child: NavigationBar(
              container: NavigationContainerType.sidebar,
              children: <NavigationBarItem>[
                NavigationCollapsible(
                  label: const Text('Profile'),
                  onExpandedChanged: (bool value) => expanded = value,
                  children: <Widget>[_item('Details', index: 0)],
                ),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          tester.getSize(find.byKey(navigationCollapsibleChildrenKey)).height,
          0,
        );
        await tester.tap(find.text('Profile'));
        await tester.pumpAndSettle();
        expect(expanded, isTrue);
        expect(
          tester.getSize(find.byKey(navigationCollapsibleChildrenKey)).height,
          greaterThan(0),
        );
        await tester.tap(find.text('Profile'));
        await tester.pumpAndSettle();
        expect(expanded, isFalse);

        await tester.pumpWidget(
          _frame(
            child: NavigationBar(
              container: NavigationContainerType.sidebar,
              children: <NavigationBarItem>[
                NavigationCollapsible(
                  label: const Text('Profile'),
                  expanded: false,
                  children: <Widget>[_item('Details', index: 0)],
                ),
              ],
            ),
          ),
        );
        await tester.tap(find.text('Profile'));
        await tester.pumpAndSettle();
        expect(
          tester.getSize(find.byKey(navigationCollapsibleChildrenKey)).height,
          0,
        );
      },
    );
  });

  group('roving', () {
    testWidgets('the arrow-key action walks to the next enabled item', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: NavigationBar(
            index: 0,
            children: <NavigationBarItem>[
              _item('Home'),
              _item('Disabled', enabled: false),
              _item('Settings'),
            ],
          ),
        ),
      );
      Element inner(int row) => tester.element(
        find
            .descendant(
              of: find.byType(NavigationItemRow).at(row),
              matching: find.byType(Container),
            )
            .first,
      );
      // The walk starts from the selected item (0): Next skips the disabled
      // item 1 and lands on 2.
      Actions.invoke(inner(0), const NextRovingItemIntent());
      await tester.pump();
      expect(_focusedRowIndex(tester), 2);
      await tester.pumpWidget(
        _frame(
          child: NavigationBar(
            index: 2,
            children: <NavigationBarItem>[
              _item('Home'),
              _item('Disabled', enabled: false),
              _item('Settings'),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      // From the selected item (2): Previous skips the disabled item 1.
      Actions.invoke(
        tester.element(
          find
              .descendant(
                of: find.byType(NavigationItemRow).at(2),
                matching: find.byType(Container),
              )
              .first,
        ),
        const PreviousRovingItemIntent(),
      );
      await tester.pump();
      expect(_focusedRowIndex(tester), 0);
    });
  });

  group('sizes', () {
    testWidgets('an item is 36 high (shadcn h-9)', (WidgetTester tester) async {
      await tester.pumpWidget(
        _frame(
          child: NavigationBar(children: <NavigationBarItem>[_item('Home')]),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(NavigationItemRow)).height, 36);
    });
  });

  group('theme', () {
    testWidgets('defaults use the background token in light and dark', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: NavigationBar(children: <NavigationBarItem>[_item('Home')]),
        ),
      );
      expect(_barBackground(tester), ShadcnColors.lightFallback.background);
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
          child: NavigationBar(children: <NavigationBarItem>[_item('Home')]),
        ),
      );
      expect(_barBackground(tester), ShadcnColors.darkFallback.background);
    });

    testWidgets('all four precedence legs resolve in order', (
      WidgetTester tester,
    ) async {
      const NavigationBarTheme app = NavigationBarTheme(
        backgroundColor: ThemedColor.value(_red),
      );
      const NavigationBarTheme scoped = NavigationBarTheme(
        backgroundColor: ThemedColor.value(_green),
      );
      await tester.pumpWidget(
        _frame(
          child: NavigationBar(children: <NavigationBarItem>[_item('Home')]),
        ),
      );
      expect(_barBackground(tester), ShadcnColors.lightFallback.background);
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[app],
          child: NavigationBar(children: <NavigationBarItem>[_item('Home')]),
        ),
      );
      expect(_barBackground(tester), _red);
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[app],
          scoped: scoped,
          child: NavigationBar(children: <NavigationBarItem>[_item('Home')]),
        ),
      );
      expect(_barBackground(tester), _green);
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[app],
          scoped: scoped,
          child: NavigationBar(
            theme: const NavigationBarTheme(
              backgroundColor: ThemedColor.value(_red),
            ),
            children: <NavigationBarItem>[_item('Home')],
          ),
        ),
      );
      expect(_barBackground(tester), _red);
    });

    testWidgets('the item slice themes unselected rows', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            NavigationBarTheme(
              itemStyle: NavigationItemStyle(
                background: StateValue(rest: ThemedColor.value(_red)),
              ),
            ),
          ],
          child: NavigationBar(children: <NavigationBarItem>[_item('Home')]),
        ),
      );
      expect(_rowBackground(tester, 0), _red);
    });
  });

  group('helpers (F2 restores)', () {
    testWidgets('NavigationGap inserts a fixed main-axis gap', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: NavigationBar(
            children: <NavigationBarItem>[
              _item('Home'),
              const NavigationGap(40),
              _item('Settings'),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final double right = tester
          .getTopRight(find.byType(NavigationItemRow).at(0))
          .dx;
      final double left = tester
          .getTopLeft(find.byType(NavigationItemRow).at(1))
          .dx;
      expect(left - right, 40);
    });

    testWidgets('NavigationSlot renders leading/title/subtitle/trailing', (
      WidgetTester tester,
    ) async {
      int presses = 0;
      await tester.pumpWidget(
        _frame(
          child: NavigationBar(
            container: NavigationContainerType.sidebar,
            children: <NavigationBarItem>[
              NavigationSlot(
                leading: const Icon(RadixIcons.person),
                title: const Text('Ada'),
                subtitle: const Text('Admin'),
                trailing: const Icon(RadixIcons.chevronRight),
                onPressed: () => presses += 1,
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Ada'), findsOneWidget);
      expect(find.text('Admin'), findsOneWidget);
      expect(find.byIcon(RadixIcons.chevronRight), findsOneWidget);
      await tester.tap(find.byType(NavigationItemRow));
      await tester.pump();
      expect(presses, 1);
    });
  });
}
