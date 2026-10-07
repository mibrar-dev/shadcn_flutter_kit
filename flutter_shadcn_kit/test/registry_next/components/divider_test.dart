// Widget tests for the `divider` component.
//
// Covers both orientations, the label form and its alignment, indents, dark
// tokens and the four theme-precedence legs. The regression tests pin the two
// old bugs: `VerticalDivider` ignored every `DividerTheme` leg (it read
// `colorScheme.border` and `theme.iconTheme` directly), and the old widget's
// `preferredSize` reported a zero-length axis, so a themed rule in a list had
// no measurable size.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/divider/divider.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

Widget _frame({
  required Widget child,
  Axis axis = Axis.horizontal,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  DividerTheme? scopedTheme,
}) {
  Widget body = child;
  if (scopedTheme != null) {
    body = ComponentTheme<DividerTheme>(data: scopedTheme, child: body);
  }
  // The bounded axis matches the divider's own axis so a `double.infinity`
  // extent resolves instead of overflowing.
  final Widget slot = axis == Axis.horizontal
      ? SizedBox(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[body],
          ),
        )
      : SizedBox(height: 80, child: Row(children: <Widget>[body]));
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Align(alignment: Alignment.topLeft, child: slot),
      ),
    ),
  );
}

CustomPainter _painter(WidgetTester tester) => tester
    .widgetList<CustomPaint>(
      find.descendant(
        of: find.byType(Divider),
        matching: find.byType(CustomPaint),
      ),
    )
    .first
    .painter!;

Paint _paint(WidgetTester tester) =>
    _LineRecorder().paintOf(_painter(tester), const Size(100, 100));

/// Packed ARGB of a paint colour. `Paint.color` round-trips through the engine
/// and does not compare equal to a literal [Color] of the same value.
int _hex(Color color) => color.toARGB32();

void main() {
  group('plain rule', () {
    testWidgets('horizontal rule uses the border token at 1px', (tester) async {
      await tester.pumpWidget(_frame(child: const Divider()));
      final Paint paint = _paint(tester);
      expect(_hex(paint.color), _hex(ShadcnColors.lightFallback.border));
      expect(paint.strokeWidth, dividerDefaultThickness);
    });

    testWidgets('horizontal rule fills the available width', (tester) async {
      await tester.pumpWidget(_frame(child: const Divider()));
      final Size size = tester.getSize(find.byType(Divider));
      expect(size.width, 300);
      expect(size.height, dividerDefaultExtent);
    });

    testWidgets('vertical rule fills the available height', (tester) async {
      await tester.pumpWidget(
        _frame(
          axis: Axis.vertical,
          child: const Divider(axis: Axis.vertical),
        ),
      );
      final Size size = tester.getSize(find.byType(Divider));
      expect(size.height, 80);
      expect(size.width, dividerDefaultExtent);
    });

    testWidgets('thickness and extent overrides apply', (tester) async {
      await tester.pumpWidget(
        _frame(child: const Divider(thickness: 3, extent: 6)),
      );
      expect(_paint(tester).strokeWidth, 3);
      expect(tester.getSize(find.byType(Divider)).height, 6);
    });

    testWidgets('indents shrink the painted line', (tester) async {
      await tester.pumpWidget(
        _frame(child: const Divider(indent: 20, endIndent: 40)),
      );
      final _LineRecorder recorder = _LineRecorder();
      recorder.run(_painter(tester), const Size(300, 1));
      expect(recorder.start.dx, 20);
      expect(recorder.end.dx, 260);
    });
  });

  group('label', () {
    testWidgets('renders the label with the muted foreground token', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(child: const Divider(label: Text('section'))),
      );
      expect(find.text('section'), findsOneWidget);
      final TextStyle style = tester
          .widgetList<DefaultTextStyle>(
            find.descendant(
              of: find.byType(Divider),
              matching: find.byType(DefaultTextStyle),
            ),
          )
          .first
          .style;
      expect(style.color, ShadcnColors.lightFallback.mutedForeground);
      expect(style.fontSize, dividerDefaultLabelStyle.fontSize);
    });

    testWidgets('a centre-aligned label splits the rule evenly', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(child: const Divider(label: Text('mid'))));
      final List<Expanded> halves = tester
          .widgetList<Expanded>(find.byType(Expanded))
          .toList();
      expect(halves, hasLength(2));
      expect(halves.first.flex, halves.last.flex);
    });

    testWidgets('start alignment pushes the label to the end', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const Divider(
            label: Text('mid'),
            labelAlignment: DividerLabelAlignment.start,
          ),
        ),
      );
      final List<Expanded> halves = tester
          .widgetList<Expanded>(find.byType(Expanded))
          .toList();
      expect(halves.first.flex, greaterThan(halves.last.flex));
    });

    testWidgets('end alignment collapses the leading rule', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const Divider(
            label: Text('mid'),
            labelAlignment: DividerLabelAlignment.end,
          ),
        ),
      );
      final List<Expanded> halves = tester
          .widgetList<Expanded>(find.byType(Expanded))
          .toList();
      expect(halves.first.flex, lessThan(halves.last.flex));
    });

    testWidgets('a vertical divider can carry a label too', (tester) async {
      await tester.pumpWidget(
        _frame(
          axis: Axis.vertical,
          child: const Divider(axis: Axis.vertical, label: Text('v')),
        ),
      );
      expect(
        find.descendant(
          of: find.byType(Divider),
          matching: find.byType(Column),
        ),
        findsOneWidget,
      );
      expect(find.text('v'), findsOneWidget);
    });
  });

  group('theme precedence', () {
    testWidgets('app leg overrides the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            DividerTheme(color: ThemedColor.value(_green)),
          ],
          child: const Divider(),
        ),
      );
      expect(_hex(_paint(tester).color), _hex(_green));
    });

    testWidgets('scoped leg overrides the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            DividerTheme(color: ThemedColor.value(_green)),
          ],
          scopedTheme: const DividerTheme(color: ThemedColor.value(_blue)),
          child: const Divider(),
        ),
      );
      expect(_hex(_paint(tester).color), _hex(_blue));
    });

    testWidgets('widget leg overrides the scoped leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          scopedTheme: const DividerTheme(color: ThemedColor.value(_green)),
          child: const Divider(
            theme: DividerTheme(color: ThemedColor.value(_blue)),
          ),
        ),
      );
      expect(_hex(_paint(tester).color), _hex(_blue));
    });

    testWidgets('regression: a vertical divider reads the same theme legs', (
      tester,
    ) async {
      // The old `VerticalDivider` had no `theme` parameter at all and read
      // `colorScheme.border` directly, so a scoped colour never reached it.
      await tester.pumpWidget(
        _frame(
          axis: Axis.vertical,
          scopedTheme: const DividerTheme(
            color: ThemedColor.value(_green),
            thickness: 4,
          ),
          child: const Divider(axis: Axis.vertical),
        ),
      );
      expect(_hex(_paint(tester).color), _hex(_green));
      expect(_paint(tester).strokeWidth, 4);
    });

    testWidgets('a leg setting only thickness keeps the token colour', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          scopedTheme: const DividerTheme(thickness: 2),
          child: const Divider(),
        ),
      );
      expect(_paint(tester).strokeWidth, 2);
      expect(
        _hex(_paint(tester).color),
        _hex(ShadcnColors.lightFallback.border),
      );
    });
  });

  group('tokens', () {
    testWidgets('dark palette drives the same slot', (tester) async {
      const ShadcnColors dark = ShadcnColors.darkFallback;
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: dark),
          child: const Divider(label: Text('dark')),
        ),
      );
      expect(_hex(_paint(tester).color), _hex(dark.border));
      final TextStyle style = tester
          .widgetList<DefaultTextStyle>(
            find.descendant(
              of: find.byType(Divider),
              matching: find.byType(DefaultTextStyle),
            ),
          )
          .first
          .style;
      expect(style.color, dark.mutedForeground);
    });

    testWidgets('alpha multiplies the token alpha', (tester) async {
      const ShadcnColors dark = ShadcnColors.darkFallback;
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: dark),
          child: const Divider(
            theme: DividerTheme(
              color: ThemedColor.ref(ColorRef.border, alpha: 0.5),
            ),
          ),
        ),
      );
      expect(_paint(tester).color.a, closeTo(dark.border.a * 0.5, 0.001));
    });
  });

  group('defaults table', () {
    test('token-derived rows match the shadcn separator', () {
      const ShadcnColors colors = ShadcnColors.lightFallback;
      expect(dividerDefaults.color?.resolve(colors), colors.border);
      expect(dividerDefaults.thickness, 1);
      expect(dividerDefaults.labelAlignment, DividerLabelAlignment.center);
    });
  });
}

/// Canvas that records the first `drawLine` call and its paint.
class _LineRecorder implements Canvas {
  Offset start = Offset.zero;
  Offset end = Offset.zero;
  int calls = 0;
  Paint? paint;

  void run(CustomPainter painter, Size size) => painter.paint(this, size);

  Paint paintOf(CustomPainter painter, Size size) {
    run(painter, size);
    return paint!;
  }

  @override
  void noSuchMethod(Invocation invocation) {
    if (invocation.memberName == const Symbol('drawLine') && calls++ == 0) {
      start = invocation.positionalArguments[0] as Offset;
      end = invocation.positionalArguments[1] as Offset;
      paint = invocation.positionalArguments[2] as Paint?;
    }
  }
}
