// QA for `divider` previews (P7-Q1): behaviour, spacing, robustness.
//
// Regression cover for: `start`/`end` label alignment expanding the wrong
// half (the label sat at the opposite end), physical insets ignoring text
// direction, and the plain rule leaking into the semantics tree.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/divider/divider.dart';
import 'package:flutter_shadcn_kit/registry/components/divider/preview.dart';
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

List<Expanded> _halves(WidgetTester tester) =>
    tester.widgetList<Expanded>(find.byType(Expanded)).toList();

Finder _indentBox() => find.byWidgetPredicate(
  (Widget widget) => widget is SizedBox && widget.width == 20,
);

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in dividerPreviews) {
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
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(
          tester.takeException(),
          isNull,
          reason: '${preview.name} light/dark',
        );
      }
    }
  });

  testWidgets('start collapses the leading rule (label sits at the start)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        const Divider(
          label: Text('qa label'),
          labelAlignment: DividerLabelAlignment.start,
        ),
      ),
    );
    final List<Expanded> halves = _halves(tester);
    expect(halves, hasLength(2));
    expect(halves.first.flex, lessThan(halves.last.flex));
  });

  testWidgets('end collapses the trailing rule (label sits at the end)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        const Divider(
          label: Text('qa label'),
          labelAlignment: DividerLabelAlignment.end,
        ),
      ),
    );
    final List<Expanded> halves = _halves(tester);
    expect(halves, hasLength(2));
    expect(halves.first.flex, greaterThan(halves.last.flex));
  });

  testWidgets('the plain rule is decorative; the label is exposed', (
    tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(_frame(const Divider()));
    await tester.pump();
    expect(find.bySemanticsLabel(RegExp('.+')), findsNothing);
    await tester.pumpWidget(_frame(const Divider(label: Text('qa label'))));
    await tester.pump();
    expect(find.bySemanticsLabel('qa label'), findsOneWidget);
    handle.dispose();
    expect(tester.takeException(), isNull);
  });

  testWidgets('the indent mirrors to the leading side in RTL', (tester) async {
    Future<double> indentDx(TextDirection direction) async {
      await tester.pumpWidget(
        _frame(
          const Divider(indent: 20, label: Text('qa label')),
          direction: direction,
          width: 375,
        ),
      );
      await tester.pump();
      expect(_indentBox(), findsOneWidget);
      return tester.getTopLeft(_indentBox()).dx;
    }

    final double ltr = await indentDx(TextDirection.ltr);
    final double rtl = await indentDx(TextDirection.rtl);
    expect(
      rtl,
      greaterThan(ltr),
      reason: 'the 20px indent sits left in LTR and right in RTL',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('labelled preview fits 375px with no overflow', (tester) async {
    await tester.pumpWidget(
      _frame(Builder(builder: dividerPreviews[1].builder), width: 375),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });

  testWidgets('RTL pumps labelled and plain rules with no exception', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Divider(label: Text('rtl')),
            Divider(),
            Divider(indent: 20, endIndent: 40),
          ],
        ),
        direction: TextDirection.rtl,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });
}
