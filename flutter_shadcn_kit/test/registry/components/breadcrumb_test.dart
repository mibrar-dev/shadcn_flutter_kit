// Widget tests for the `breadcrumb` component.
//
// Covers: token rendering (light + dark), the default chevron and slash
// separators, the current-crumb colour, the four theme legs and a regression
// for the single-child path.

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/breadcrumb/breadcrumb.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame({
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  required Widget child,
}) {
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: child),
      ),
    ),
  );
}

const List<Widget> _crumbs = <Widget>[
  Text('Home'),
  Text('Components'),
  Text('Breadcrumb'),
];

Color? _textColor(WidgetTester tester, String text) {
  final RenderParagraph paragraph = tester.renderObject<RenderParagraph>(
    find.text(text),
  );
  return (paragraph.text as TextSpan).style?.color;
}

void main() {
  const ShadcnColors colors = ShadcnColors.lightFallback;

  testWidgets('renders a chevron between every pair of crumbs', (tester) async {
    await tester.pumpWidget(_frame(child: const Breadcrumb(children: _crumbs)));
    expect(find.byType(Breadcrumb), findsOneWidget);
    // Two separators for three crumbs.
    expect(find.byType(Icon), findsNWidgets(2));
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Breadcrumb'), findsOneWidget);
  });

  testWidgets('the current crumb is foreground, earlier ones muted', (
    tester,
  ) async {
    await tester.pumpWidget(_frame(child: const Breadcrumb(children: _crumbs)));
    expect(_textColor(tester, 'Home'), colors.mutedForeground);
    expect(_textColor(tester, 'Breadcrumb'), colors.foreground);
  });

  testWidgets('slash separator replaces the chevron', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: const Breadcrumb(
          separator: Breadcrumb.slashSeparator,
          children: _crumbs,
        ),
      ),
    );
    expect(find.byType(Icon), findsNothing);
    expect(find.text('/'), findsNWidgets(2));
  });

  testWidgets('a custom separator widget is used as-is', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: const Breadcrumb(
          separator: Text('>'),
          children: <Widget>[Text('a'), Text('b')],
        ),
      ),
    );
    expect(find.text('>'), findsOneWidget);
    expect(find.byType(Icon), findsNothing);
  });

  testWidgets('a single crumb renders without a separator', (tester) async {
    await tester.pumpWidget(
      _frame(child: const Breadcrumb(children: <Widget>[Text('Only')])),
    );
    expect(find.text('Only'), findsOneWidget);
    expect(find.byType(Icon), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dark tokens colour the chevron and crumbs', (tester) async {
    const ShadcnThemeData dark = ShadcnThemeData(
      colors: ShadcnColors.darkFallback,
    );
    await tester.pumpWidget(
      _frame(
        data: dark,
        child: const Breadcrumb(children: _crumbs),
      ),
    );
    final Icon icon = tester.widget<Icon>(find.byType(Icon).first);
    expect(icon.color, dark.colors.mutedForeground);
    expect(_textColor(tester, 'Breadcrumb'), dark.colors.foreground);
  });

  testWidgets('theme precedence: defaults < app < scoped < widget', (
    tester,
  ) async {
    const BreadcrumbTheme app = BreadcrumbTheme(spacing: 10);
    const BreadcrumbTheme scoped = BreadcrumbTheme(spacing: 20);
    const BreadcrumbTheme widget = BreadcrumbTheme(spacing: 30);

    double gapOf(WidgetTester tester) {
      final SizedBox box = tester.widget<SizedBox>(
        find
            .descendant(
              of: find.byType(Breadcrumb),
              matching: find.byType(SizedBox),
            )
            .first,
      );
      return box.width!;
    }

    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[app],
        child: const Breadcrumb(children: _crumbs),
      ),
    );
    expect(gapOf(tester), 10);

    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[app],
        child: const ComponentTheme<BreadcrumbTheme>(
          data: scoped,
          child: Breadcrumb(children: _crumbs),
        ),
      ),
    );
    expect(gapOf(tester), 20);

    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[app],
        child: const ComponentTheme<BreadcrumbTheme>(
          data: scoped,
          child: Breadcrumb(children: _crumbs, theme: widget),
        ),
      ),
    );
    expect(gapOf(tester), 30);
  });

  testWidgets('the separator theme leg is used when no widget separator', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[BreadcrumbTheme(separator: Text('~'))],
        child: const Breadcrumb(children: <Widget>[Text('a'), Text('b')]),
      ),
    );
    expect(find.text('~'), findsOneWidget);
    expect(find.byType(Icon), findsNothing);
  });

  testWidgets('padding theme leg wraps the strip', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: const Breadcrumb(padding: EdgeInsets.all(12), children: _crumbs),
      ),
    );
    expect(
      tester.widget<Padding>(find.byType(Padding).first).padding,
      const EdgeInsets.all(12),
    );
  });
}
