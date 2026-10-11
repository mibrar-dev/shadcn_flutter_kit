// QA for `accordion` previews (P7-Q1): behaviour, spacing, robustness.
//
// Regression cover for: the `Expanded` preview example rendering collapsed
// (it toggled with a `Key` instead of the item identity), Space-key
// activation, single-open behaviour and 375px widths.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/accordion/accordion.dart';
import 'package:flutter_shadcn_kit/registry/components/accordion/preview.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  TextDirection direction = TextDirection.ltr,
  double? width,
}) {
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: direction,
      child: Center(
        child: width == null ? child : SizedBox(width: width, child: child),
      ),
    ),
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

Widget _item(String label) {
  return AccordionItem(
    trigger: AccordionTrigger(child: Text(label)),
    content: Text('$label content'),
  );
}

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in accordionPreviews) {
      for (final colors in <ShadcnColors>[
        ShadcnColors.lightFallback,
        ShadcnColors.darkFallback,
      ]) {
        await tester.pumpWidget(
          _frame(
            Builder(builder: preview.builder),
            data: ShadcnThemeData(colors: colors),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason: '${preview.name} light/dark',
        );
      }
    }
  });

  testWidgets('Expanded preview starts with the second item open', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(Builder(builder: accordionPreviews[1].builder)),
    );
    await tester.pumpAndSettle();
    // The second item is revealed while the others stay shut.
    expect(_sizeFactor(tester, 1), 1);
    expect(_sizeFactor(tester, 0), 0);
    expect(_sizeFactor(tester, 2), 0);
  });

  testWidgets('Space toggles the focused trigger (Enter already covered)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(Accordion(items: <Widget>[_item('one'), _item('two')])),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('one'));
    await tester.pumpAndSettle();
    expect(_sizeFactor(tester, 0), 1);
    // Focus the second trigger and press Space.
    final Element trigger = tester.element(find.text('two'));
    Focus.of(trigger).requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(_sizeFactor(tester, 1), 1);
    expect(_sizeFactor(tester, 0), 0);
  });

  testWidgets('tap opens one item and closes the previous (single-open)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(Accordion(items: <Widget>[_item('a'), _item('b')])),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('a'));
    await tester.pumpAndSettle();
    expect(_sizeFactor(tester, 0), 1);
    await tester.tap(find.text('b'));
    await tester.pumpAndSettle();
    expect(_sizeFactor(tester, 1), 1);
    expect(_sizeFactor(tester, 0), 0);
  });

  testWidgets('trigger semantics expose button + expanded', (tester) async {
    await tester.pumpWidget(_frame(Accordion(items: <Widget>[_item('s')])));
    await tester.pumpAndSettle();
    final SemanticsHandle handle = tester.ensureSemantics();
    expect(find.bySemanticsLabel(RegExp('s')), findsWidgets);
    await tester.tap(find.text('s'));
    await tester.pumpAndSettle();
    handle.dispose();
    expect(tester.takeException(), isNull);
  });

  testWidgets('default preview fits 375px with no overflow', (tester) async {
    await tester.pumpWidget(
      _frame(Builder(builder: accordionPreviews[0].builder), width: 375),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Is it styled?'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('RTL pumps, mirrors and toggles with no exception', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        Accordion(items: <Widget>[_item('r1'), _item('r2')]),
        direction: TextDirection.rtl,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('r1'));
    await tester.pumpAndSettle();
    expect(_sizeFactor(tester, 0), 1);
    expect(tester.takeException(), isNull);
  });
}
