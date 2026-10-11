// QA for `drawer_container` (P7-Q1): behaviour, spacing, robustness.
//
// Regression cover for: `start`/`end` never resolved (three-sided `Border.all`
// + circular radius), the 32x4 handle vs the 36x4 theme default, the
// hard-coded `border` handle colour vs the `muted` theme token, LTR-only
// alignment/padding, and the missing `ExcludeSemantics` on the handle/barrier.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/drawer/drawer.dart'
    show DrawerTheme;
import 'package:flutter_shadcn_kit/registry/components/drawer_container/drawer_container.dart';
import 'package:flutter_shadcn_kit/registry/components/drawer_container/preview.dart';
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

Future<void> _pumpSized(
  WidgetTester tester,
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  TextDirection direction = TextDirection.ltr,
}) {
  return tester.pumpWidget(
    ShadcnTheme(
      data: data,
      child: Directionality(
        textDirection: direction,
        child: Center(child: SizedBox(width: 200, height: 160, child: child)),
      ),
    ),
  );
}

BoxDecoration _decoration(WidgetTester tester) {
  final DecoratedBox box = tester.widget<DecoratedBox>(
    find
        .descendant(
          of: find.byType(DrawerRawContainer),
          matching: find.byType(DecoratedBox),
        )
        .first,
  );
  return box.decoration as BoxDecoration;
}

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in drawerContainerPreviews) {
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

  testWidgets('start resolves like left in LTR (three sides, two radii)', (
    tester,
  ) async {
    await _pumpSized(
      tester,
      const DrawerRawContainer(
        position: OverlayPosition.start,
        child: SizedBox(),
      ),
    );
    final Border border = _decoration(tester).border! as Border;
    expect(border.top.width, 1);
    expect(border.right.width, 1);
    expect(border.bottom.width, 1);
    expect(border.left.width, 0);
    final BorderRadius radius =
        _decoration(tester).borderRadius! as BorderRadius;
    expect(radius.topLeft, Radius.zero);
    expect(radius.topRight, isNot(Radius.zero));
  });

  testWidgets('start resolves like right in RTL', (tester) async {
    await _pumpSized(
      tester,
      const DrawerRawContainer(
        position: OverlayPosition.start,
        child: SizedBox(),
      ),
      direction: TextDirection.rtl,
    );
    final Border border = _decoration(tester).border! as Border;
    expect(border.top.width, 1);
    expect(border.left.width, 1);
    expect(border.bottom.width, 1);
    expect(border.right.width, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the handle is the 36x4 theme default in the muted token', (
    tester,
  ) async {
    await _pumpSized(
      tester,
      const DrawerRawContainer(
        position: OverlayPosition.bottom,
        child: SizedBox(),
      ),
    );
    final Finder handle = find.byWidgetPredicate(
      (Widget w) =>
          w is Container &&
          w.decoration is BoxDecoration &&
          (w.decoration! as BoxDecoration).color ==
              ShadcnColors.lightFallback.muted,
    );
    expect(handle, findsOneWidget);
    expect(tester.getSize(handle), const Size(36, 4));
  });

  testWidgets('a DrawerTheme dragHandleColor wins over the muted default', (
    tester,
  ) async {
    const Color green = Color(0xFF00FF00);
    await _pumpSized(
      tester,
      const DrawerRawContainer(
        position: OverlayPosition.bottom,
        child: SizedBox(),
      ),
    );
    expect(
      find.byWidgetPredicate(
        (Widget w) =>
            w is Container &&
            w.decoration is BoxDecoration &&
            (w.decoration! as BoxDecoration).color ==
                ShadcnColors.lightFallback.muted,
      ),
      findsOneWidget,
    );
    await tester.pumpWidget(
      ShadcnTheme(
        data: const ShadcnThemeData(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: const SizedBox(
              width: 200,
              height: 160,
              child: ComponentTheme<DrawerTheme>(
                data: DrawerTheme(dragHandleColor: ThemedColor.value(green)),
                child: DrawerRawContainer(
                  position: OverlayPosition.bottom,
                  child: SizedBox(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    expect(
      find.byWidgetPredicate(
        (Widget w) =>
            w is Container &&
            w.decoration is BoxDecoration &&
            (w.decoration! as BoxDecoration).color == green,
      ),
      findsOneWidget,
    );
  });

  testWidgets('the decorative handle and barrier hide their semantics', (
    tester,
  ) async {
    await _pumpSized(
      tester,
      const DrawerRawContainer(
        position: OverlayPosition.bottom,
        isSheet: true,
        fadeAnimation: AlwaysStoppedAnimation<double>(1),
        barrierColor: Color(0x40000000),
        child: SizedBox(),
      ),
    );
    expect(find.byType(ExcludeSemantics), findsWidgets);
  });

  testWidgets('default preview fits 375px with no overflow', (tester) async {
    await tester.pumpWidget(
      _frame(Builder(builder: drawerContainerPreviews[0].builder), width: 375),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });

  testWidgets('RTL pumps with no exception', (tester) async {
    await tester.pumpWidget(
      _frame(
        Builder(builder: drawerContainerPreviews[0].builder),
        direction: TextDirection.rtl,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });
}
