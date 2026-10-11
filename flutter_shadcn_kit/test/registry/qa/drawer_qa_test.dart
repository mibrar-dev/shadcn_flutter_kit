// QA for `drawer` route pushes (P7-Q1): behaviour, spacing, robustness.
//
// Regression cover for: the panel border painted on the anchor edge instead
// of the content-facing edge (left-anchored panels drew the border on the
// left; they now draw it on the right, and so on for every edge).

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/drawer/drawer.dart';
import 'package:flutter_shadcn_kit/registry/components/drawer/preview.dart';
import 'package:flutter_shadcn_kit/registry/primitives/drawer_route/drawer_route.dart';
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

late BuildContext _host;

Future<void> _pumpNavigator(
  WidgetTester tester, {
  ShadcnThemeData data = const ShadcnThemeData(),
  TextDirection direction = TextDirection.ltr,
}) async {
  await tester.pumpWidget(
    ShadcnTheme(
      data: data,
      child: Directionality(
        textDirection: direction,
        child: MediaQuery(
          data: const MediaQueryData(),
          child: Navigator(
            onGenerateRoute: (RouteSettings settings) => PageRouteBuilder<void>(
              settings: settings,
              pageBuilder: (_, _, _) => Builder(
                builder: (BuildContext context) {
                  _host = context;
                  return const SizedBox(width: 10, height: 10);
                },
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Border _panelBorder(WidgetTester tester) {
  final DecoratedBox box = tester.widget<DecoratedBox>(
    find
        .descendant(
          of: find.byType(DrawerPanelScope),
          matching: find.byType(DecoratedBox),
        )
        .first,
  );
  return (box.decoration as BoxDecoration).border! as Border;
}

Future<void> _openAndPump(WidgetTester tester, OverlayPosition position) async {
  openDrawer<void>(
    context: _host,
    position: position,
    builder: (BuildContext context) => const Text('QA body'),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in drawerPreviews) {
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

  testWidgets('left panel borders the content edge (right), not the anchor', (
    tester,
  ) async {
    await _pumpNavigator(tester);
    await _openAndPump(tester, OverlayPosition.left);
    final Border border = _panelBorder(tester);
    expect(border.right.width, 1);
    expect(border.left.width, 0);
  });

  testWidgets('right/top/bottom panels border the content edge', (
    tester,
  ) async {
    await _pumpNavigator(tester);
    await _openAndPump(tester, OverlayPosition.right);
    expect(_panelBorder(tester).left.width, 1);
    expect(_panelBorder(tester).right.width, 0);
    Navigator.of(_host).pop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await _openAndPump(tester, OverlayPosition.top);
    expect(_panelBorder(tester).bottom.width, 1);
    expect(_panelBorder(tester).top.width, 0);
    Navigator.of(_host).pop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await _openAndPump(tester, OverlayPosition.bottom);
    expect(_panelBorder(tester).top.width, 1);
    expect(_panelBorder(tester).bottom.width, 0);
  });

  testWidgets('start resolves to the left border in LTR', (tester) async {
    await _pumpNavigator(tester);
    await _openAndPump(tester, OverlayPosition.start);
    final Border border = _panelBorder(tester);
    expect(border.right.width, 1);
    expect(border.left.width, 0);
  });

  testWidgets('default preview fits 375px with no overflow', (tester) async {
    await tester.pumpWidget(
      _frame(Builder(builder: drawerPreviews[0].builder), width: 375),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });

  testWidgets('RTL pumps, mirrors start to the right edge', (tester) async {
    await _pumpNavigator(tester, direction: TextDirection.rtl);
    await _openAndPump(tester, OverlayPosition.start);
    final Border border = _panelBorder(tester);
    expect(border.left.width, 1);
    expect(border.right.width, 0);
    expect(tester.takeException(), isNull);
  });
}
