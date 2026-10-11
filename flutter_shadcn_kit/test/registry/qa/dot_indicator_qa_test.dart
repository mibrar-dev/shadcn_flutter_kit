// QA for `dot_indicator` previews (P7-Q1): behaviour, spacing, robustness.
//
// Regression cover for: `dotBuilder` never being invoked, and dots
// exposing no selected state to assistive technology.

import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/dot_indicator/dot_indicator.dart';
import 'package:flutter_shadcn_kit/registry/components/dot_indicator/preview.dart';
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

Widget _customDot(BuildContext context, int index, bool isActive) {
  return SizedBox(
    key: Key('custom-dot-$index'),
    width: isActive ? 30 : 10,
    height: 10,
  );
}

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in dotIndicatorPreviews) {
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

  testWidgets('dotBuilder replaces the default dot (read-only)', (
    tester,
  ) async {
    final List<(int, bool)> calls = <(int, bool)>[];
    await tester.pumpWidget(
      _frame(
        DotIndicator(
          index: 1,
          length: 3,
          dotBuilder: (BuildContext context, int index, bool isActive) {
            calls.add((index, isActive));
            return _customDot(context, index, isActive);
          },
        ),
      ),
    );
    await tester.pump();
    expect(calls, <(int, bool)>[(0, false), (1, true), (2, false)]);
    expect(find.byKey(const Key('custom-dot-0')), findsOneWidget);
    expect(find.byKey(const Key('custom-dot-1')), findsOneWidget);
    expect(find.byKey(const Key('custom-dot-2')), findsOneWidget);
    expect(
      find.byType(AnimatedContainer),
      findsNothing,
      reason: 'no default dot is built when a builder is supplied',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('dotBuilder dots stay tappable (interactive)', (tester) async {
    final List<int> tapped = <int>[];
    await tester.pumpWidget(
      _frame(
        DotIndicator(
          index: 0,
          length: 3,
          onChanged: tapped.add,
          dotBuilder: _customDot,
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('custom-dot-2')));
    await tester.pump();
    expect(tapped, <int>[2]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dots expose selected state with a position label', (
    tester,
  ) async {
    await tester.pumpWidget(_frame(const DotIndicator(index: 1, length: 3)));
    await tester.pump();
    final SemanticsHandle handle = tester.ensureSemantics();
    expect(find.bySemanticsLabel('Page 2 of 3'), findsOneWidget);
    final SemanticsNode active = tester.getSemantics(
      find.bySemanticsLabel('Page 2 of 3'),
    );
    expect(active.flagsCollection.isSelected.toBoolOrNull(), isTrue);
    final SemanticsNode inactive = tester.getSemantics(
      find.bySemanticsLabel('Page 1 of 3'),
    );
    expect(inactive.flagsCollection.isSelected.toBoolOrNull(), isFalse);
    handle.dispose();
    expect(tester.takeException(), isNull);
  });

  testWidgets('default preview fits 375px with no overflow', (tester) async {
    await tester.pumpWidget(
      _frame(Builder(builder: dotIndicatorPreviews[0].builder), width: 375),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });

  testWidgets('RTL pumps and taps with no exception', (tester) async {
    final List<int> tapped = <int>[];
    await tester.pumpWidget(
      _frame(
        DotIndicator(index: 0, length: 3, onChanged: tapped.add),
        direction: TextDirection.rtl,
      ),
    );
    await tester.pump();
    await tester.tap(find.bySemanticsLabel('Page 3 of 3'));
    await tester.pump();
    expect(tapped, <int>[2]);
    expect(tester.takeException(), isNull);
  });
}
