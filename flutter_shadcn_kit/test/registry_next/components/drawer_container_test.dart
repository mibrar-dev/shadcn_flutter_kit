// Widget tests for the `drawer_container` component.
//
// Covers: token colours (light + dark), the per-edge border and outer radius,
// the drag handle, sheet chrome, cross-axis sizing, the barrier wash, the
// data-driven `DrawerContainer` and the `AxisSize` algebra.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/drawer_container/drawer_container.dart';
import 'package:flutter_shadcn_kit/registry_next/foundation/data.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const ShadcnColors _light = ShadcnColors.lightFallback;
const ShadcnColors _dark = ShadcnColors.darkFallback;

Future<void> _pump(WidgetTester tester, Widget child, {ShadcnColors? colors}) {
  return tester.pumpWidget(
    ShadcnTheme(
      data: ShadcnThemeData(colors: colors ?? _light),
      child: Directionality(
        textDirection: TextDirection.ltr,
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
  testWidgets('uses the background token in light and dark', (tester) async {
    await _pump(
      tester,
      const DrawerRawContainer(
        position: OverlayPosition.right,
        child: SizedBox(),
      ),
    );
    expect(_decoration(tester).color, _light.background);

    await _pump(
      tester,
      const DrawerRawContainer(
        position: OverlayPosition.right,
        child: SizedBox(),
      ),
      colors: _dark,
    );
    expect(_decoration(tester).color, _dark.background);
  });

  testWidgets('drawer chrome borders three inner sides and rounds the outer '
      'corners', (tester) async {
    await _pump(
      tester,
      const DrawerRawContainer(
        position: OverlayPosition.left,
        child: SizedBox(),
      ),
    );
    final BoxDecoration decoration = _decoration(tester);
    final Border border = decoration.border! as Border;
    expect(border.top.width, 1);
    expect(border.right.width, 1);
    expect(border.bottom.width, 1);
    expect(border.left.width, 0);
    final BorderRadius radius = decoration.borderRadius! as BorderRadius;
    expect(radius.topLeft, Radius.zero);
    expect(radius.topRight, isNot(Radius.zero));
  });

  testWidgets('sheet chrome borders one inner side and squares the corners', (
    tester,
  ) async {
    await _pump(
      tester,
      const DrawerRawContainer(
        position: OverlayPosition.bottom,
        isSheet: true,
        child: SizedBox(),
      ),
    );
    final BoxDecoration decoration = _decoration(tester);
    final Border border = decoration.border! as Border;
    expect(border.top.width, 1);
    expect(border.bottom.width, 0);
    expect(decoration.borderRadius, BorderRadius.zero);
  });

  testWidgets('draws a 32x4 drag handle when draggable', (tester) async {
    await _pump(
      tester,
      const DrawerRawContainer(
        position: OverlayPosition.bottom,
        child: SizedBox(),
      ),
    );
    final Finder handle = find.byWidgetPredicate(
      (Widget w) => w is Container && w.constraints != null,
    );
    expect(tester.getSize(handle), const Size(32, 4));

    await _pump(
      tester,
      const DrawerRawContainer(
        position: OverlayPosition.bottom,
        showDragHandle: false,
        child: SizedBox(),
      ),
    );
    expect(handle, findsNothing);
  });

  Finder panelOf() => find.byWidgetPredicate(
    (Widget w) =>
        w is Container &&
        w.decoration is BoxDecoration &&
        w.constraints == null,
  );

  testWidgets('sizes the sheet along the cross axis', (tester) async {
    await _pump(
      tester,
      const DrawerRawContainer(
        position: OverlayPosition.bottom,
        isSheet: true,
        crossAxisSize: FractionAxisSize(0.5),
        child: SizedBox(),
      ),
    );
    expect(tester.getSize(panelOf()).width, 100);
  });

  testWidgets('draws a barrier wash when a fade animation is set', (
    tester,
  ) async {
    await _pump(
      tester,
      const DrawerRawContainer(
        position: OverlayPosition.bottom,
        isSheet: true,
        fadeAnimation: AlwaysStoppedAnimation<double>(1),
        barrierColor: Color(0x40000000),
        child: SizedBox(),
      ),
    );
    final FadeTransition fade = tester.widget<FadeTransition>(
      find.byType(FadeTransition),
    );
    expect(fade.opacity.value, 1);
    expect(find.byType(ColoredBox), findsWidgets);
  });

  testWidgets('DrawerContainer reads its configuration from data', (
    tester,
  ) async {
    await _pump(
      tester,
      const Data<DrawerContainerData>.inherit(
        data: DrawerContainerData(
          position: OverlayPosition.bottom,
          isSheet: true,
        ),
        child: DrawerContainer(size: FractionAxisSize(0.5), child: SizedBox()),
      ),
    );
    expect(find.byType(DrawerRawContainer), findsOneWidget);
    expect(tester.getSize(panelOf()).width, 100);
  });

  test('AxisSize algebra resolves against the available extent', () {
    expect(const FixedAxisSize(40).resolve(200), 40);
    expect(const FractionAxisSize(0.5).resolve(200), 100);
    expect(
      (const FractionAxisSize(0.5) + const FixedAxisSize(40)).resolve(200),
      140,
    );
    expect(
      (const FixedAxisSize(100) - const FixedAxisSize(40)).resolve(200),
      60,
    );
    expect((const FixedAxisSize(40) * 2).resolve(200), 80);
    expect((const FixedAxisSize(40) / 2).resolve(200), 20);
  });
}
