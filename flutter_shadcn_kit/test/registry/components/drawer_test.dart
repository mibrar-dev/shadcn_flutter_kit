// Widget tests for the `drawer` component.
//
// Covers: open/close and the result, barrier + Escape dismissal, panel sizing,
// the sheet marker, focus restore, position resolution and the four theme legs.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/drawer/drawer.dart';
import 'package:flutter_shadcn_kit/registry/foundation/data.dart';
import 'package:flutter_shadcn_kit/registry/primitives/drawer_route/drawer_route.dart';
import 'package:flutter_shadcn_kit/registry/primitives/sheet_overlay.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

late BuildContext _host;
final FocusNode _openerNode = FocusNode(debugLabel: 'opener');

Future<void> _pumpApp(
  WidgetTester tester, {
  ShadcnThemeData? theme,
  DrawerTheme? appTheme,
  DrawerTheme? scopedTheme,
}) async {
  Widget page = Builder(
    builder: (BuildContext context) {
      _host = context;
      return Center(
        child: Focus(
          focusNode: _openerNode,
          child: const SizedBox(width: 10, height: 10),
        ),
      );
    },
  );
  if (scopedTheme != null) {
    page = ComponentTheme<DrawerTheme>(data: scopedTheme, child: page);
  }
  Widget app = Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(),
      child: Navigator(
        key: UniqueKey(),
        onGenerateRoute: (RouteSettings settings) => PageRouteBuilder<void>(
          settings: settings,
          pageBuilder:
              (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) => page,
        ),
      ),
    ),
  );
  if (appTheme != null) {
    app = ComponentThemes(themes: <ComponentThemeData>[appTheme], child: app);
  }
  await tester.pumpWidget(
    ShadcnTheme(data: theme ?? const ShadcnThemeData(), child: app),
  );
  _openerNode.requestFocus();
}

Widget _panel() {
  return find
      .descendant(
        of: find.byType(DrawerPanelScope),
        matching: find.byType(DecoratedBox),
      )
      .first
      .evaluate()
      .first
      .widget;
}

Color? _panelColor(WidgetTester tester) {
  final DecoratedBox box = tester.widget<DecoratedBox>(
    find
        .descendant(
          of: find.byType(DrawerPanelScope),
          matching: find.byType(DecoratedBox),
        )
        .first,
  );
  return (box.decoration as BoxDecoration).color;
}

FocusNode get _primary => FocusManager.instance.primaryFocus!;

void main() {
  const ShadcnColors colors = ShadcnColors.lightFallback;

  tearDown(() {
    FocusManager.instance.primaryFocus?.unfocus();
  });

  testWidgets('opens a panel and closes with a result', (tester) async {
    await _pumpApp(tester);
    final Future<String?> result = openDrawer<String>(
      context: _host,
      position: OverlayPosition.end,
      builder: (BuildContext context) => Builder(
        builder: (BuildContext inner) {
          return const Text('Drawer body');
        },
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Drawer body'), findsOneWidget);
    expect(find.byType(DrawerPanelScope), findsOneWidget);
    expect(find.byType(ModalBarrier), findsWidgets);

    Navigator.of(_host).pop('ok');
    await tester.pumpAndSettle();
    expect(find.byType(DrawerPanelScope), findsNothing);
    expect(await result, 'ok');
  });

  testWidgets('closeDrawer pops the nearest drawer', (tester) async {
    await _pumpApp(tester);
    late BuildContext inner;
    final Future<void> result = openDrawer<void>(
      context: _host,
      builder: (BuildContext context) {
        inner = context;
        return const Text('Body');
      },
    );
    await tester.pumpAndSettle();
    await closeDrawer(inner);
    await tester.pumpAndSettle();
    expect(find.byType(DrawerPanelScope), findsNothing);
    await result;
  });

  testWidgets('barrier tap dismisses only when barrierDismissible', (
    tester,
  ) async {
    await _pumpApp(tester);
    openDrawer<void>(
      context: _host,
      builder: (BuildContext context) => const Text('Body'),
    );
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(4, 4));
    await tester.pumpAndSettle();
    expect(find.byType(DrawerPanelScope), findsNothing);

    openDrawer<void>(
      context: _host,
      barrierDismissible: false,
      builder: (BuildContext context) => const Text('Body'),
    );
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(4, 4));
    await tester.pumpAndSettle();
    expect(find.byType(DrawerPanelScope), findsOneWidget);
  });

  testWidgets('escape dismisses only when barrierDismissible', (tester) async {
    await _pumpApp(tester);
    openDrawer<void>(
      context: _host,
      builder: (BuildContext context) => const Text('Body'),
    );
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(DrawerPanelScope), findsNothing);

    openDrawer<void>(
      context: _host,
      barrierDismissible: false,
      builder: (BuildContext context) => const Text('Body'),
    );
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(DrawerPanelScope), findsOneWidget);
  });

  testWidgets('maxSize caps the panel width and expands fills it', (
    tester,
  ) async {
    await _pumpApp(tester);
    openDrawer<void>(
      context: _host,
      position: OverlayPosition.end,
      maxSize: 240,
      builder: (BuildContext context) => const SizedBox.expand(),
    );
    await tester.pumpAndSettle();
    final Size size = tester.getSize(
      find
          .descendant(
            of: find.byType(DrawerPanelScope),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    expect(size.width, 240);

    Navigator.of(_host).pop();
    await tester.pumpAndSettle();
    openDrawer<void>(
      context: _host,
      position: OverlayPosition.end,
      expands: true,
      builder: (BuildContext context) => const SizedBox.expand(),
    );
    await tester.pumpAndSettle();
    expect(
      tester
          .getSize(
            find
                .descendant(
                  of: find.byType(DrawerPanelScope),
                  matching: find.byType(DecoratedBox),
                )
                .first,
          )
          .width,
      800,
    );
  });

  testWidgets('a sheet marks its content as a sheet overlay', (tester) async {
    await _pumpApp(tester);
    bool? drawerMarker;
    bool? sheetMarker;
    openDrawer<void>(
      context: _host,
      builder: (BuildContext context) {
        drawerMarker = Data.maybeOf<SheetOverlayMarker>(context) != null;
        return const Text('Drawer');
      },
    );
    await tester.pumpAndSettle();
    expect(drawerMarker, isFalse);
    Navigator.of(_host).pop();
    await tester.pumpAndSettle();

    openSheet<void>(
      context: _host,
      builder: (BuildContext context) {
        sheetMarker = Data.maybeOf<SheetOverlayMarker>(context) != null;
        return const Text('Sheet');
      },
    );
    await tester.pumpAndSettle();
    expect(sheetMarker, isTrue);
  });

  testWidgets('restores the opener focus on close', (tester) async {
    await _pumpApp(tester);
    expect(_primary, _openerNode);
    openDrawer<void>(
      context: _host,
      builder: (BuildContext context) => const Text('Body'),
    );
    await tester.pumpAndSettle();
    expect(_primary, isNot(_openerNode));
    Navigator.of(_host).pop();
    await tester.pumpAndSettle();
    expect(_primary, _openerNode);
  });

  testWidgets('theme precedence: defaults < app < scoped < widget', (
    tester,
  ) async {
    const red = Color(0xFFFF0000);
    const green = Color(0xFF00FF00);
    const blue = Color(0xFF0000FF);

    Future<void> pumpWith(DrawerTheme? widgetTheme) async {
      await _pumpApp(
        tester,
        appTheme: const DrawerTheme(background: ThemedColor.value(red)),
        scopedTheme: const DrawerTheme(background: ThemedColor.value(green)),
      );
      openDrawer<void>(
        context: _host,
        theme: widgetTheme,
        builder: (BuildContext context) => const Text('Body'),
      );
      await tester.pumpAndSettle();
    }

    await pumpWith(null);
    expect(_panelColor(tester), green);

    await pumpWith(const DrawerTheme(background: ThemedColor.value(blue)));
    expect(_panelColor(tester), blue);
  });

  testWidgets('dark tokens drive the panel', (tester) async {
    const ShadcnThemeData dark = ShadcnThemeData(
      colors: ShadcnColors.darkFallback,
    );
    await _pumpApp(tester, theme: dark);
    openDrawer<void>(
      context: _host,
      builder: (BuildContext context) => const Text('Body'),
    );
    await tester.pumpAndSettle();
    expect(_panelColor(tester), dark.colors.background);
    expect(_panelColor(tester), isNot(colors.background));
  });

  test('position resolves start and end by text direction', () {
    expect(
      OverlayPosition.start.resolve(TextDirection.ltr),
      OverlayPosition.left,
    );
    expect(
      OverlayPosition.start.resolve(TextDirection.rtl),
      OverlayPosition.right,
    );
    expect(
      OverlayPosition.end.resolve(TextDirection.rtl),
      OverlayPosition.left,
    );
    expect(
      OverlayPosition.left.resolve(TextDirection.rtl),
      OverlayPosition.left,
    );
  });

  testWidgets('nested drawers stack and close one at a time', (tester) async {
    await _pumpApp(tester);
    late BuildContext first;
    openDrawer<void>(
      context: _host,
      builder: (BuildContext context) {
        first = context;
        return const Text('First');
      },
    );
    await tester.pumpAndSettle();
    openDrawer<void>(
      context: first,
      position: OverlayPosition.bottom,
      builder: (BuildContext context) => const Text('Second'),
    );
    await tester.pumpAndSettle();
    expect(find.byType(DrawerPanelScope), findsNWidgets(2));
    expect(_panel(), isA<DecoratedBox>());

    Navigator.of(first).pop();
    await tester.pumpAndSettle();
    expect(find.byType(DrawerPanelScope), findsOneWidget);
    expect(find.text('First'), findsOneWidget);
  });
}
