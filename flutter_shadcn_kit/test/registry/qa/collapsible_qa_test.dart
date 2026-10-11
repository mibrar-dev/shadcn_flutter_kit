// QA for `collapsible` previews (P7-Q1): behaviour, spacing, robustness.
//
// Regression cover for: only the 36px icon Button toggled (the label did
// nothing), the missing `Semantics(expanded:)` header node and the fixed
// 360px preview boxes overflowing narrow stages.

import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/collapsible/collapsible.dart';
import 'package:flutter_shadcn_kit/registry/components/collapsible/preview.dart';
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

Widget _section(String title) {
  return Collapsible(
    children: <Widget>[
      CollapsibleTrigger(child: Text(title)),
      const CollapsibleContent(child: Text('revealed')),
    ],
  );
}

bool _revealed(WidgetTester tester) =>
    find.text('revealed').evaluate().isNotEmpty;

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in collapsiblePreviews) {
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

  testWidgets('tapping the label toggles the section', (tester) async {
    await tester.pumpWidget(_frame(_section('tap me')));
    await tester.pump();
    expect(_revealed(tester), isFalse);
    await tester.tap(find.text('tap me'));
    await tester.pump();
    expect(_revealed(tester), isTrue);
    await tester.tap(find.text('tap me'));
    await tester.pump();
    expect(_revealed(tester), isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Space on the focused label toggles the section', (tester) async {
    await tester.pumpWidget(_frame(_section('keys')));
    await tester.pump();
    Focus.of(tester.element(find.text('keys'))).requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(_revealed(tester), isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the trigger header exposes button + expanded semantics', (
    tester,
  ) async {
    await tester.pumpWidget(_frame(_section('semantics')));
    await tester.pump();
    final SemanticsHandle handle = tester.ensureSemantics();
    SemanticsNode node = tester.getSemantics(find.byType(CollapsibleTrigger));
    expect(node.flagsCollection.isButton, isTrue);
    expect(node.flagsCollection.isExpanded.toBoolOrNull(), isFalse);
    await tester.tap(find.text('semantics'));
    await tester.pump();
    node = tester.getSemantics(find.byType(CollapsibleTrigger));
    expect(node.flagsCollection.isExpanded.toBoolOrNull(), isTrue);
    handle.dispose();
    expect(tester.takeException(), isNull);
  });

  testWidgets('default preview fits 375px with no overflow', (tester) async {
    await tester.pumpWidget(
      _frame(Builder(builder: collapsiblePreviews[0].builder), width: 375),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('@flutter/flutter'), findsNothing);
    await tester.tap(find.text('Recent activity'));
    await tester.pump();
    expect(find.text('@flutter/flutter'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('RTL pumps and the label still toggles', (tester) async {
    await tester.pumpWidget(
      _frame(_section('rtl'), direction: TextDirection.rtl),
    );
    await tester.pump();
    await tester.tap(find.text('rtl'));
    await tester.pump();
    expect(_revealed(tester), isTrue);
    expect(tester.takeException(), isNull);
  });
}
