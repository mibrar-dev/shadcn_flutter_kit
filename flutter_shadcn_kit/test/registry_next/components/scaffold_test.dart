// Widget tests for the `scaffold` component.
//
// Covers shell layout (headers/body/footers), the loading bar, floating
// modes, keyboard avoidance, the AppBar slots and the four
// theme-precedence legs. Regression tests cover the retired pieces: no
// nested `Overlay`, no `DrawerOverlay` host requirement and the token
// loading track (the old `Colors.transparent` override is gone).

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/progress/progress.dart';
import 'package:flutter_shadcn_kit/registry_next/components/scaffold/scaffold.dart';
import 'package:flutter_shadcn_kit/registry_next/foundation/data.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  ScaffoldTheme? scopedScaffold,
  AppBarTheme? scopedAppBar,
}) {
  Widget body = child;
  if (scopedAppBar != null) {
    body = ComponentTheme<AppBarTheme>(data: scopedAppBar, child: body);
  }
  if (scopedScaffold != null) {
    body = ComponentTheme<ScaffoldTheme>(data: scopedScaffold, child: body);
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

Future<ScaffoldTheme> _resolve(
  WidgetTester tester,
  ScaffoldTheme? widget,
  ScaffoldTheme? scoped,
  List<ComponentThemeData> app,
) async {
  late ScaffoldTheme resolved;
  await tester.pumpWidget(
    _frame(
      app: app,
      scopedScaffold: scoped,
      child: Builder(
        builder: (context) {
          resolved = resolveComponentStyle<ScaffoldTheme, ScaffoldTheme>(
            context,
            widget: widget,
            select: (t) => t,
            defaults: scaffoldDefaults,
          );
          return const SizedBox();
        },
      ),
    ),
  );
  return resolved;
}

void main() {
  group('layout', () {
    testWidgets('renders headers, body and footers in order', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const Scaffold(
            headers: <Widget>[Text('head')],
            footers: <Widget>[Text('foot')],
            child: Text('body'),
          ),
        ),
      );
      expect(find.text('head'), findsOneWidget);
      expect(find.text('body'), findsOneWidget);
      expect(find.text('foot'), findsOneWidget);
      final Offset headY = tester.getTopLeft(find.text('head'));
      final Offset bodyY = tester.getTopLeft(find.text('body'));
      final Offset footY = tester.getTopLeft(find.text('foot'));
      expect(headY.dy, lessThan(bodyY.dy));
      expect(bodyY.dy, lessThan(footY.dy));
    });

    testWidgets('no nested Overlay is created', (tester) async {
      await tester.pumpWidget(
        _frame(child: Scaffold(child: const Text('body'))),
      );
      expect(find.byType(Overlay), findsNothing);
    });

    testWidgets('works without any overlay host above it', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: Scaffold(
            headers: const <Widget>[AppBar(title: Text('T'))],
            loadingProgress: 0.5,
            child: const Text('body'),
          ),
        ),
      );
      expect(find.byType(Progress), findsOneWidget);
    });

    testWidgets('loading bar hidden without progress', (tester) async {
      await tester.pumpWidget(
        _frame(child: Scaffold(child: const Text('body'))),
      );
      expect(find.byType(Progress), findsNothing);
    });

    testWidgets('determinate and indeterminate bars', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: Scaffold(loadingProgress: 0.4, child: const Text('body')),
        ),
      );
      expect(tester.widget<Progress>(find.byType(Progress)).value, 0.4);
      await tester.pumpWidget(
        _frame(
          child: Scaffold(
            loadingProgressIndeterminate: true,
            child: const Text('body'),
          ),
        ),
      );
      expect(tester.widget<Progress>(find.byType(Progress)).value, isNull);
    });

    testWidgets('floating header overlays the body', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const Scaffold(
            floatingHeader: true,
            headers: <Widget>[Text('head')],
            child: Text('body'),
          ),
        ),
      );
      expect(find.byType(Positioned), findsWidgets);
    });

    testWidgets('footer hides while the keyboard is open', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const MediaQuery(
            data: MediaQueryData(viewInsets: EdgeInsets.only(bottom: 300)),
            child: Scaffold(
              footers: <Widget>[Text('foot')],
              child: Text('body'),
            ),
          ),
        ),
      );
      expect(find.byType(Offstage), findsOneWidget);
      expect(tester.widget<Offstage>(find.byType(Offstage)).offstage, isTrue);
    });
  });

  group('AppBar', () {
    testWidgets('title, header and subtitle slots render', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const AppBar(
            leading: <Widget>[Text('L')],
            title: Text('Title'),
            header: Text('Above'),
            subtitle: Text('Below'),
            trailing: <Widget>[Text('R')],
          ),
        ),
      );
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Above'), findsOneWidget);
      expect(find.text('Below'), findsOneWidget);
      expect(find.text('L'), findsOneWidget);
      expect(find.text('R'), findsOneWidget);
    });

    testWidgets('child overrides the title slots', (tester) async {
      await tester.pumpWidget(
        _frame(child: const AppBar(child: Text('custom'))),
      );
      expect(find.text('custom'), findsOneWidget);
    });

    testWidgets('bar position data reaches AppBar descendants', (tester) async {
      ScaffoldBarData? seen;
      await tester.pumpWidget(
        _frame(
          child: Scaffold(
            headers: <Widget>[
              Builder(
                builder: (context) {
                  seen = Data.maybeOf<ScaffoldBarData>(context);
                  return const Text('head');
                },
              ),
            ],
            child: const Text('body'),
          ),
        ),
      );
      expect(seen, isNotNull);
      expect(seen!.isHeader, isTrue);
      expect(seen!.childIndex, 0);
      expect(seen!.childrenCount, 1);
    });
  });

  group('theme precedence', () {
    testWidgets('widget > scoped > app > defaults', (tester) async {
      const ThemedColor red = ThemedColor.value(Color(0xFFFF0000));
      const ThemedColor green = ThemedColor.value(Color(0xFF00FF00));
      const ThemedColor blue = ThemedColor.value(Color(0xFF0000FF));
      final ScaffoldTheme defaults = await _resolve(
        tester,
        null,
        null,
        const <ComponentThemeData>[],
      );
      expect(defaults.background, scaffoldDefaults.background);

      final ScaffoldTheme fromApp = await _resolve(
        tester,
        null,
        null,
        const <ComponentThemeData>[ScaffoldTheme(background: red)],
      );
      expect(fromApp.background, red);

      final ScaffoldTheme fromScoped = await _resolve(
        tester,
        null,
        const ScaffoldTheme(background: green),
        const <ComponentThemeData>[ScaffoldTheme(background: red)],
      );
      expect(fromScoped.background, green);

      final ScaffoldTheme fromWidget = await _resolve(
        tester,
        const ScaffoldTheme(background: blue),
        const ScaffoldTheme(background: green),
        const <ComponentThemeData>[ScaffoldTheme(background: red)],
      );
      expect(fromWidget.background, blue);
    });

    testWidgets('dark tokens restyle the shell', (tester) async {
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
          child: Scaffold(child: const Text('body')),
        ),
      );
      final ColoredBox box = tester.widget<ColoredBox>(
        find.byType(ColoredBox).first,
      );
      expect(box.color, ShadcnColors.darkFallback.background);
    });
  });
}
