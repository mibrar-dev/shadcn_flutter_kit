// Widget tests for the `accordion` component.
//
// Covers single-open behaviour, initial expansion, dividers, the four
// theme-precedence legs, keyboard activation and the old regressions: the
// re-applied initial expansion, the stray trailing divider and the skipped
// app-level theme leg.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/accordion/accordion.dart';
import 'package:flutter_shadcn_kit/registry/foundation/icons/lucide_icons.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  AccordionTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<AccordionTheme>(data: scoped, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: body),
      ),
    ),
  );
}

Widget _accordion({bool firstExpanded = false, AccordionTheme? theme}) {
  return Accordion(
    theme: theme,
    items: <Widget>[
      AccordionItem(
        expanded: firstExpanded,
        trigger: const AccordionTrigger(child: Text('first')),
        content: const Text('first content'),
      ),
      const AccordionItem(
        trigger: AccordionTrigger(child: Text('second')),
        content: Text('second content'),
      ),
      const AccordionItem(
        trigger: AccordionTrigger(child: Text('third')),
        content: Text('third content'),
      ),
    ],
  );
}

double _sizeFactor(WidgetTester tester, int index) {
  return tester
      .widget<SizeTransition>(
        find.descendant(
          of: find.byType(AccordionItem).at(index),
          matching: find.byType(SizeTransition),
        ),
      )
      .sizeFactor
      .value;
}

Finder _dividers() => find.byWidgetPredicate(
  (Widget widget) => widget is SizedBox && widget.child is ColoredBox,
);

void main() {
  testWidgets('renders one divider between items and none at the end', (
    tester,
  ) async {
    await tester.pumpWidget(_frame(child: _accordion()));
    expect(find.byType(AccordionItem), findsNWidgets(3));
    // The old accordion appended a Material Divider after the last item.
    expect(_dividers(), findsNWidgets(2));
  });

  testWidgets('only one item is open at a time', (tester) async {
    await tester.pumpWidget(_frame(child: _accordion()));

    await tester.tap(find.text('first'));
    await tester.pumpAndSettle();
    expect(_sizeFactor(tester, 0), 1);
    expect(_sizeFactor(tester, 1), 0);

    await tester.tap(find.text('second'));
    await tester.pumpAndSettle();
    expect(_sizeFactor(tester, 0), 0);
    expect(_sizeFactor(tester, 1), 1);

    await tester.tap(find.text('second'));
    await tester.pumpAndSettle();
    expect(_sizeFactor(tester, 1), 0);
  });

  testWidgets('an item can start expanded', (tester) async {
    await tester.pumpWidget(_frame(child: _accordion(firstExpanded: true)));
    expect(_sizeFactor(tester, 0), 1);
    expect(_sizeFactor(tester, 1), 0);
  });

  testWidgets('regression: a collapsed initial item stays collapsed', (
    tester,
  ) async {
    await tester.pumpWidget(_frame(child: _accordion(firstExpanded: true)));
    await tester.tap(find.text('first'));
    await tester.pumpAndSettle();
    expect(_sizeFactor(tester, 0), 0);

    // Any inherited change used to re-apply `expanded: true` because the old
    // item re-checked on every didChangeDependencies.
    await tester.pumpWidget(
      _frame(
        data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
        child: _accordion(firstExpanded: true),
      ),
    );
    await tester.pumpAndSettle();
    expect(_sizeFactor(tester, 0), 0);
  });

  testWidgets('all four theme legs drive the divider colour', (tester) async {
    Future<void> expectDivider(
      WidgetTester tester, {
      required Color color,
      List<ComponentThemeData> app = const <ComponentThemeData>[],
      AccordionTheme? scoped,
      AccordionTheme? widgetTheme,
    }) async {
      await tester.pumpWidget(
        _frame(
          app: app,
          scoped: scoped,
          child: _accordion(theme: widgetTheme),
        ),
      );
      final ColoredBox divider = tester.widget<ColoredBox>(
        find.descendant(
          of: _dividers().first,
          matching: find.byType(ColoredBox),
        ),
      );
      expect(divider.color, color);
    }

    const Color appColor = Color(0xFF111111);
    const Color scopedColor = Color(0xFF222222);
    const Color widgetColor = Color(0xFF333333);

    await expectDivider(tester, color: ShadcnColors.lightFallback.muted);
    await expectDivider(
      tester,
      color: appColor,
      app: <ComponentThemeData>[
        const AccordionTheme(dividerColor: ThemedColor.value(appColor)),
      ],
    );
    await expectDivider(
      tester,
      color: scopedColor,
      app: <ComponentThemeData>[
        const AccordionTheme(dividerColor: ThemedColor.value(appColor)),
      ],
      scoped: const AccordionTheme(
        dividerColor: ThemedColor.value(scopedColor),
      ),
    );
    await expectDivider(
      tester,
      color: widgetColor,
      app: <ComponentThemeData>[
        const AccordionTheme(dividerColor: ThemedColor.value(appColor)),
      ],
      scoped: const AccordionTheme(
        dividerColor: ThemedColor.value(scopedColor),
      ),
      widgetTheme: const AccordionTheme(
        dividerColor: ThemedColor.value(widgetColor),
      ),
    );
  });

  testWidgets('dark palette colours the arrow with mutedForeground', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
        child: _accordion(),
      ),
    );

    final IconTheme theme = tester.widget<IconTheme>(
      find
          .ancestor(of: find.byType(Icon), matching: find.byType(IconTheme))
          .first,
    );
    expect(theme.data.color, ShadcnColors.darkFallback.mutedForeground);
    // The old default came from Material's Icons.keyboard_arrow_up.
    final Icon icon = tester.widget<Icon>(find.byType(Icon).first);
    expect(icon.icon, LucideIcons.chevronUp);
  });

  testWidgets('keyboard activation opens an item', (tester) async {
    await tester.pumpWidget(_frame(child: _accordion()));

    final FocusNode node = Focus.of(tester.element(find.byType(Icon).first));
    node.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(_sizeFactor(tester, 0), 1);
  });

  testWidgets('theme duration drives the expand animation', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: _accordion(
          theme: const AccordionTheme(duration: Duration(milliseconds: 80)),
        ),
      ),
    );

    await tester.tap(find.text('first'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 40));
    final double mid = _sizeFactor(tester, 0);
    expect(mid, greaterThan(0));
    expect(mid, lessThan(1));
    await tester.pumpAndSettle();
    expect(_sizeFactor(tester, 0), 1);
  });
}
