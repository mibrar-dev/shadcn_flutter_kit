// Widget and unit tests for the `timeline` component.
//
// Covers: the token surface in light + dark, the four theme legs, per-entry
// colours, widget-leg geometry, the fixed column/dot metrics, the
// widgets-only connector (the old Material `VerticalDivider`) and RTL.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/timeline/timeline.dart';
import 'package:flutter_shadcn_kit/registry_next/foundation/gap.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _red = Color(0xFFFF0000);
const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

Widget _frame({
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  TextDirection textDirection = TextDirection.ltr,
  required Widget child,
}) {
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: textDirection,
        child: Center(child: SingleChildScrollView(child: child)),
      ),
    ),
  );
}

List<TimelineData> _entries({int count = 3, ThemedColor? color}) {
  return List<TimelineData>.generate(
    count,
    (int i) => TimelineData(
      time: Text('t$i'),
      title: Text('title $i'),
      content: Text('content $i'),
      color: color,
    ),
  );
}

TimelineSurface _surface(WidgetTester tester) {
  final Timeline widget = tester.widget<Timeline>(find.byType(Timeline));
  return resolveTimelineSurface(
    tester.element(find.byType(Timeline)),
    widgetTheme: widget.theme,
    timeConstraints: widget.timeConstraints,
  );
}

bool _isDot(Widget widget) {
  if (widget is! Container) {
    return false;
  }
  final Decoration? decoration = widget.decoration;
  return decoration is BoxDecoration && decoration.shape == BoxShape.circle;
}

void main() {
  const ShadcnColors light = ShadcnColors.lightFallback;
  const ShadcnColors dark = ShadcnColors.darkFallback;

  testWidgets('token surface: 120px column, 12px dot, primary indicator', (
    tester,
  ) async {
    await tester.pumpWidget(_frame(child: Timeline(data: _entries())));
    final TimelineSurface surface = _surface(tester);
    expect(surface.timeConstraints.minWidth, 120);
    expect(surface.timeConstraints.maxWidth, 120);
    expect(surface.dotSize, 12);
    expect(surface.connectorThickness, 2);
    expect(surface.rowGap, 16);
    expect(surface.color, light.primary);

    final Finder dotFinder = find.byWidgetPredicate(_isDot);
    expect(dotFinder, findsNWidgets(3));
    final Container firstDot = tester.widget<Container>(dotFinder.first);
    final BoxDecoration decoration = firstDot.decoration! as BoxDecoration;
    expect(decoration.color, light.primary);
    expect(firstDot.constraints!.maxWidth, 12);
  });

  testWidgets('dark tokens drive the indicator', (tester) async {
    await tester.pumpWidget(
      _frame(
        data: const ShadcnThemeData(colors: dark),
        child: Timeline(data: _entries(count: 1)),
      ),
    );
    expect(_surface(tester).color, dark.primary);
    final Container dot = tester.widget<Container>(
      find.byWidgetPredicate(_isDot),
    );
    expect((dot.decoration! as BoxDecoration).color, dark.primary);
  });

  testWidgets('theme precedence: defaults < app < scoped < widget', (
    tester,
  ) async {
    const TimelineTheme red = TimelineTheme(
      color: ThemedColor.value(_red),
      dotSize: 4,
    );
    const TimelineTheme green = TimelineTheme(
      color: ThemedColor.value(_green),
      dotSize: 8,
    );
    const TimelineTheme blue = TimelineTheme(color: ThemedColor.value(_blue));

    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[red],
        child: Timeline(data: _entries()),
      ),
    );
    expect(_surface(tester).color, _red);
    expect(_surface(tester).dotSize, 4);

    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[red],
        child: const ComponentTheme<TimelineTheme>(
          data: green,
          child: Timeline(data: <TimelineData>[]),
        ),
      ),
    );
    expect(_surface(tester).color, _green);
    expect(_surface(tester).dotSize, 8);

    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[red],
        child: ComponentTheme<TimelineTheme>(
          data: green,
          child: Timeline(theme: blue, data: _entries(count: 1)),
        ),
      ),
    );
    expect(_surface(tester).color, _blue);
    // The widget leg sets no dotSize, so the scoped leg's value survives.
    expect(_surface(tester).dotSize, 8);
  });

  testWidgets('partial legs merge per field', (tester) async {
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          TimelineTheme(color: ThemedColor.value(_red)),
        ],
        child: const ComponentTheme<TimelineTheme>(
          data: TimelineTheme(dotSize: 6),
          child: Timeline(data: <TimelineData>[]),
        ),
      ),
    );
    final TimelineSurface surface = _surface(tester);
    expect(surface.color, _red);
    expect(surface.dotSize, 6);
  });

  testWidgets('per-entry colour wins over the theme colour', (tester) async {
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          TimelineTheme(color: ThemedColor.value(_red)),
        ],
        child: Timeline(
          data: _entries(count: 2, color: const ThemedColor.value(_green)),
        ),
      ),
    );
    final Container dot = tester.widget<Container>(
      find.byWidgetPredicate(_isDot).first,
    );
    expect((dot.decoration! as BoxDecoration).color, _green);
    // The connector follows the entry colour too (widgets-only ColoredBox,
    // not the old Material VerticalDivider).
    final List<ColoredBox> connectors = tester
        .widgetList<ColoredBox>(find.byType(ColoredBox))
        .where((ColoredBox box) => box.color == _green)
        .toList();
    expect(connectors, hasLength(1));
  });

  testWidgets('regression: connectors are plain boxes, one per gap', (
    tester,
  ) async {
    await tester.pumpWidget(_frame(child: Timeline(data: _entries(count: 4))));
    expect(find.byType(ColoredBox), findsNWidgets(3));
    expect(tester.takeException(), isNull);
  });

  testWidgets('last row draws no connector', (tester) async {
    await tester.pumpWidget(_frame(child: Timeline(data: _entries(count: 1))));
    expect(find.byType(ColoredBox), findsNothing);
  });

  testWidgets('widget-leg timeConstraints beat the theme', (tester) async {
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          TimelineTheme(
            timeConstraints: BoxConstraints(minWidth: 40, maxWidth: 40),
          ),
        ],
        child: const Timeline(
          timeConstraints: BoxConstraints(minWidth: 64, maxWidth: 64),
          data: <TimelineData>[TimelineData(time: Text('t'), title: Text('a'))],
        ),
      ),
    );
    expect(_surface(tester).timeConstraints.minWidth, 64);
  });

  testWidgets('row spacing uses rowGap', (tester) async {
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[TimelineTheme(rowGap: 32)],
        child: Timeline(data: _entries(count: 2)),
      ),
    );
    final Column column = tester.widget<Column>(
      find
          .descendant(of: find.byType(Timeline), matching: find.byType(Column))
          .first,
    );
    expect(column.children, hasLength(3));
    expect(column.children[1], isA<Gap>());
  });

  testWidgets('text modifiers style the three columns', (tester) async {
    await tester.pumpWidget(_frame(child: Timeline(data: _entries(count: 1))));

    TextStyle styleOf(String text) {
      return DefaultTextStyle.of(tester.element(find.text(text))).style;
    }

    final TextStyle title = styleOf('title 0');
    expect(title.fontSize, 16);
    expect(title.fontWeight, FontWeight.w600);
    expect(title.color, light.secondaryForeground);

    final TextStyle content = styleOf('content 0');
    expect(content.fontSize, 14);
    expect(content.color, light.mutedForeground);

    final TextStyle time = styleOf('t0');
    expect(time.fontSize, 14);
    expect(time.fontWeight, FontWeight.w500);
  });

  testWidgets('RTL renders', (tester) async {
    await tester.pumpWidget(
      _frame(
        textDirection: TextDirection.rtl,
        child: Timeline(data: _entries()),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  test('merge is receiver-wins per field', () {
    const TimelineTheme base = TimelineTheme(
      color: ThemedColor.value(_red),
      dotSize: 4,
      rowGap: 8,
    );
    const TimelineTheme over = TimelineTheme(color: ThemedColor.value(_blue));
    final TimelineTheme merged = over.merge(base);
    expect(merged.color, const ThemedColor.value(_blue));
    expect(merged.dotSize, 4);
    expect(merged.rowGap, 8);
  });
}
