// Widget tests for the `outlined_container` component.
//
// Covers token defaults (light + dark), the four theme-precedence legs,
// surface opacity/blur, the dashed helpers and the old regressions: the
// dropped widget-leg `theme` field and the child remount when the blur
// wrapper appears.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/outlined_container/outlined_container.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  OutlinedContainerTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<OutlinedContainerTheme>(data: scoped, child: body);
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

AnimatedContainer _surface(WidgetTester tester) =>
    tester.widget<AnimatedContainer>(
      find.descendant(
        of: find.byType(OutlinedContainer),
        matching: find.byType(AnimatedContainer),
      ),
    );

BoxDecoration _decoration(WidgetTester tester) =>
    _surface(tester).decoration! as BoxDecoration;

int _hex(Color color) => color.toARGB32();

class _Counter extends StatefulWidget {
  const _Counter();

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => count++),
      child: Text('count $count'),
    );
  }
}

void main() {
  testWidgets('uses the background and muted tokens with borderRadiusXl', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(child: const OutlinedContainer(child: Text('body'))),
    );

    final BoxDecoration decoration = _decoration(tester);
    expect(
      _hex(decoration.color!),
      _hex(ShadcnColors.lightFallback.background),
    );
    final Border border = decoration.border! as Border;
    expect(_hex(border.top.color), _hex(ShadcnColors.lightFallback.muted));
    expect(border.top.width, 1);
    final BorderRadius radius = decoration.borderRadius! as BorderRadius;
    // Default radius 0.5: xl = 0.5 * 16 + 4 = 12 (shadcn v4 scale).
    expect(radius.topLeft.x, 12);
    expect(_surface(tester).padding, EdgeInsets.zero);
  });

  testWidgets('dark palette drives the same slots', (tester) async {
    await tester.pumpWidget(
      _frame(
        data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
        child: const OutlinedContainer(child: Text('body')),
      ),
    );

    final BoxDecoration decoration = _decoration(tester);
    expect(_hex(decoration.color!), _hex(ShadcnColors.darkFallback.background));
    final Border border = decoration.border! as Border;
    expect(_hex(border.top.color), _hex(ShadcnColors.darkFallback.muted));
  });

  testWidgets('all four theme legs override per field', (tester) async {
    const ThemedColor appColor = ThemedColor.value(Color(0xFF111111));
    const ThemedColor scopedColor = ThemedColor.value(Color(0xFF222222));
    const ThemedColor widgetColor = ThemedColor.value(Color(0xFF333333));

    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[
          const OutlinedContainerTheme(backgroundColor: appColor),
        ],
        scoped: const OutlinedContainerTheme(backgroundColor: scopedColor),
        child: OutlinedContainer(
          theme: const OutlinedContainerTheme(backgroundColor: widgetColor),
          child: const Text('body'),
        ),
      ),
    );
    expect(_hex(_decoration(tester).color!), 0xFF333333);

    // The widget argument beats the widget theme leg.
    await tester.pumpWidget(
      _frame(
        child: OutlinedContainer(
          backgroundColor: const ThemedColor.value(Color(0xFF444444)),
          theme: const OutlinedContainerTheme(backgroundColor: widgetColor),
          child: const Text('body'),
        ),
      ),
    );
    expect(_hex(_decoration(tester).color!), 0xFF444444);
  });

  testWidgets('regression: the widget theme leg reaches the decoration', (
    tester,
  ) async {
    // The old state only read ComponentTheme.maybeOf and dropped the
    // widget's `theme` field entirely.
    await tester.pumpWidget(
      _frame(
        child: OutlinedContainer(
          theme: const OutlinedContainerTheme(
            backgroundColor: ThemedColor.value(Color(0xFF00FF00)),
            borderColor: ThemedColor.value(Color(0xFF0000FF)),
          ),
          child: const Text('body'),
        ),
      ),
    );

    final BoxDecoration decoration = _decoration(tester);
    expect(_hex(decoration.color!), 0xFF00FF00);
    expect(_hex((decoration.border! as Border).top.color), 0xFF0000FF);
  });

  testWidgets('surfaceOpacity multiplies the fill alpha', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: const OutlinedContainer(
          surfaceOpacity: 0.5,
          child: Text('body'),
        ),
      ),
    );

    expect(_decoration(tester).color!.a, closeTo(0.5, 0.001));
  });

  testWidgets('surfaceBlur adds a BackdropFilter only when positive', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(child: const OutlinedContainer(child: Text('body'))),
    );
    expect(find.byType(BackdropFilter), findsNothing);

    await tester.pumpWidget(
      _frame(
        child: const OutlinedContainer(surfaceBlur: 8, child: Text('body')),
      ),
    );
    expect(find.byType(BackdropFilter), findsOneWidget);
  });

  testWidgets('regression: toggling the blur keeps the child state', (
    tester,
  ) async {
    Widget build({double? blur}) {
      return _frame(
        child: OutlinedContainer(surfaceBlur: blur, child: const _Counter()),
      );
    }

    await tester.pumpWidget(build());
    await tester.tap(find.text('count 0'));
    await tester.pump();
    expect(find.text('count 1'), findsOneWidget);

    await tester.pumpWidget(build(blur: 8));
    expect(find.text('count 1'), findsOneWidget);

    await tester.pumpWidget(build());
    expect(find.text('count 1'), findsOneWidget);
  });

  testWidgets('dashed helpers paint without a Material import', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: const SizedBox(
          width: 120,
          height: 60,
          child: DashedContainer(child: Text('drop here')),
        ),
      ),
    );
    expect(find.text('drop here'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(DashedContainer),
        matching: find.byType(CustomPaint),
      ),
      findsWidgets,
    );

    // A zero dash step used to loop forever; the painter must bail out.
    await tester.pumpWidget(
      _frame(
        child: const SizedBox(
          width: 120,
          height: 20,
          child: DashedLine(width: 0, gap: 0),
        ),
      ),
    );
    expect(find.byType(DashedLine), findsOneWidget);
  });

  testWidgets('SurfaceBlur keeps its child at zero sigma', (tester) async {
    await tester.pumpWidget(
      _frame(child: const SurfaceBlur(surfaceBlur: 0, child: Text('blurred'))),
    );
    expect(find.text('blurred'), findsOneWidget);
    expect(find.byType(BackdropFilter), findsOneWidget);
  });
}
