// Widget tests for the `stepper` component.
//
// Covers: numbering, indicator sizes, the token palette per phase, both
// variants and directions, controlled + controller navigation with bounds,
// keyboard activation, theme precedence (all four legs), dark tokens and a
// regression test per fixed old bug.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/stepper/stepper.dart';
import 'package:flutter_shadcn_kit/registry/foundation/icons/lucide_icons.dart';
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
        child: Shortcuts(
          shortcuts: const <ShortcutActivator, Intent>{
            SingleActivator(LogicalKeyboardKey.tab): NextFocusIntent(),
          },
          child: Actions(
            actions: <Type, Action<Intent>>{NextFocusIntent: NextFocusAction()},
            child: Center(child: child),
          ),
        ),
      ),
    ),
  );
}

const List<StepperStep> _steps = <StepperStep>[
  StepperStep(title: Text('One'), content: Text('first')),
  StepperStep(title: Text('Two'), content: Text('second')),
  StepperStep(title: Text('Three'), content: Text('third')),
];

/// The ring of the step at [index] (circle variant).
BoxDecoration _ring(WidgetTester tester, int index) {
  final rings = tester
      .widgetList<DecoratedBox>(
        find.descendant(
          of: find.byType(Stepper),
          matching: find.byType(DecoratedBox),
        ),
      )
      .map((box) => box.decoration as BoxDecoration)
      .where((decoration) => decoration.shape == BoxShape.circle)
      .toList();
  return rings[index];
}

Color _connectorColor(WidgetTester tester, int index) {
  final boxes = tester
      .widgetList<ColoredBox>(
        find.descendant(
          of: find.byType(Stepper),
          matching: find.byType(ColoredBox),
        ),
      )
      .map((box) => box.color)
      .toList();
  return boxes[index];
}

void main() {
  const ShadcnColors colors = ShadcnColors.lightFallback;

  testWidgets('numbers every step from one and shows the active content', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(child: const Stepper(currentStep: 1, steps: _steps)),
    );
    // A finished step shows a check mark, not its number.
    expect(find.text('1'), findsNothing);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('second'), findsOneWidget);
    expect(find.text('first'), findsNothing);
  });

  testWidgets('phase palette: pending / active / completed', (tester) async {
    await tester.pumpWidget(
      _frame(child: const Stepper(currentStep: 1, steps: _steps)),
    );
    expect(_ring(tester, 0).color, colors.primary);
    expect(_ring(tester, 1).color, colors.secondary);
    expect(_ring(tester, 2).color, colors.background);
  });

  testWidgets('indicator sizes follow StepperSize', (tester) async {
    for (final StepperSize size in StepperSize.values) {
      await tester.pumpWidget(
        _frame(
          child: Stepper(currentStep: 0, size: size, steps: _steps),
        ),
      );
      expect(
        tester.getSize(find.byType(StepperIndicator).first).width,
        size.indicatorSize,
      );
    }
  });

  testWidgets('connector is primary up to the active step, border after', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(child: const Stepper(currentStep: 1, steps: _steps)),
    );
    expect(_connectorColor(tester, 0), colors.primary);
    expect(_connectorColor(tester, 1), colors.border);
  });

  testWidgets('a first step has only pending connectors', (tester) async {
    await tester.pumpWidget(
      _frame(child: const Stepper(currentStep: 0, steps: _steps)),
    );
    expect(_connectorColor(tester, 0), colors.border);
    expect(_connectorColor(tester, 1), colors.border);
  });

  testWidgets('vertical renders one row per step', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: const Stepper(
          currentStep: 0,
          direction: Axis.vertical,
          steps: _steps,
        ),
      ),
    );
    expect(find.byType(StepperIndicator), findsNWidgets(3));
    expect(find.text('first'), findsOneWidget);
  });

  testWidgets('tapping a step reports the new index', (tester) async {
    final List<int> changes = <int>[];
    await tester.pumpWidget(
      _frame(
        child: Stepper(
          currentStep: 0,
          onStepChanged: changes.add,
          steps: _steps,
        ),
      ),
    );
    await tester.tap(find.byType(StepperIndicator).at(2));
    expect(changes, <int>[2]);
  });

  testWidgets('tapping the active step does not report a change', (
    tester,
  ) async {
    final List<int> changes = <int>[];
    await tester.pumpWidget(
      _frame(
        child: Stepper(
          currentStep: 1,
          onStepChanged: changes.add,
          steps: _steps,
        ),
      ),
    );
    await tester.tap(find.byType(StepperIndicator).at(1));
    expect(changes, isEmpty);
  });

  testWidgets('controller mode: next/previous stop at the ends', (
    tester,
  ) async {
    final StepperController controller = StepperController();
    await tester.pumpWidget(
      _frame(
        child: Stepper(controller: controller, steps: _steps),
      ),
    );
    expect(controller.currentStep, 0);
    expect(controller.previous(), isFalse);
    expect(controller.next(), isTrue);
    expect(controller.next(), isTrue);
    expect(controller.next(), isFalse);
    expect(controller.currentStep, 2);
    await tester.pumpAndSettle();
    // The render followed the controller.
    expect(_ring(tester, 2).color, colors.secondary);
    expect(controller.previous(), isTrue);
    expect(controller.previous(), isTrue);
    expect(controller.previous(), isFalse);
    expect(controller.currentStep, 0);
  });

  testWidgets('controller mode: jumping updates the render', (tester) async {
    final StepperController controller = StepperController();
    await tester.pumpWidget(
      _frame(
        child: Stepper(controller: controller, steps: _steps),
      ),
    );
    await tester.tap(find.byType(StepperIndicator).at(2));
    await tester.pumpAndSettle();
    expect(controller.currentStep, 2);
  });

  testWidgets('an out-of-range step is clamped instead of crashing', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(child: const Stepper(currentStep: 9, steps: _steps)),
    );
    expect(tester.takeException(), isNull);
    expect(_ring(tester, 2).color, colors.secondary);
  });

  testWidgets('keyboard: enter activates the focused indicator', (
    tester,
  ) async {
    final FocusNode node = FocusNode();
    addTearDown(node.dispose);
    var taps = 0;
    await tester.pumpWidget(
      _frame(
        child: StepperIndicator(
          index: 0,
          phase: StepperPhase.active,
          style: stepperDefaults.active!,
          size: StepperSize.md.indicatorSize,
          focusNode: node,
          onPressed: () => taps++,
        ),
      ),
    );
    node.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(taps, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    expect(taps, 2);
  });

  testWidgets('a failed step paints destructive and its connectors too', (
    tester,
  ) async {
    final StepperController controller = StepperController(1);
    controller.setStepState(0, StepperStepState.failed);
    await tester.pumpWidget(
      _frame(
        child: Stepper(controller: controller, steps: _steps),
      ),
    );
    expect(_ring(tester, 0).color, colors.destructive);
    expect(_connectorColor(tester, 0), colors.destructive);
    expect(_connectorColor(tester, 1), colors.destructive);
    controller.setStepState(0, null);
    await tester.pumpAndSettle();
    expect(_ring(tester, 0).color, colors.primary);
  });

  testWidgets('failed labels use destructiveForeground, never white', (
    tester,
  ) async {
    final StepperController controller = StepperController(0);
    controller.setStepState(0, StepperStepState.failed);
    await tester.pumpWidget(
      _frame(
        child: Stepper(controller: controller, steps: _steps),
      ),
    );
    final Icon icon = tester.widget<Icon>(
      find.descendant(
        of: find.byType(StepperIndicator),
        matching: find.byType(Icon),
      ),
    );
    // The cross follows the token (white in the light fallback preset), never a
    // hard-coded white literal as the old stepper did.
    expect(icon.color, colors.destructiveForeground);
    const StepperTheme custom = StepperTheme(
      failed: StepperIndicatorStyle(
        foreground: ThemedColor.value(Color(0xFF123456)),
      ),
    );
    await tester.pumpWidget(
      _frame(
        child: ComponentTheme<StepperTheme>(
          data: custom,
          child: Stepper(controller: controller, steps: _steps),
        ),
      ),
    );
    expect(
      tester
          .widget<Icon>(
            find.descendant(
              of: find.byType(StepperIndicator),
              matching: find.byType(Icon),
            ),
          )
          .color,
      const Color(0xFF123456),
    );
  });

  testWidgets('theme precedence: defaults < app < scoped < widget', (
    tester,
  ) async {
    const red = Color(0xFFFF0000);
    const green = Color(0xFF00FF00);
    const blue = Color(0xFF0000FF);

    Future<void> pump({
      List<ComponentThemeData> app = const <ComponentThemeData>[],
      Widget child = const Stepper(currentStep: 0, steps: _steps),
    }) async {
      await tester.pumpWidget(_frame(app: app, child: child));
      await tester.pumpAndSettle();
    }

    await pump(
      app: const <ComponentThemeData>[
        StepperTheme(
          active: StepperIndicatorStyle(background: ThemedColor.value(red)),
        ),
      ],
    );
    expect(_ring(tester, 0).color, red);

    await pump(
      app: const <ComponentThemeData>[
        StepperTheme(
          active: StepperIndicatorStyle(background: ThemedColor.value(red)),
        ),
      ],
      child: const ComponentTheme<StepperTheme>(
        data: StepperTheme(
          active: StepperIndicatorStyle(background: ThemedColor.value(green)),
        ),
        child: Stepper(currentStep: 0, steps: _steps),
      ),
    );
    expect(_ring(tester, 0).color, green);

    await pump(
      app: const <ComponentThemeData>[
        StepperTheme(
          active: StepperIndicatorStyle(background: ThemedColor.value(red)),
        ),
      ],
      child: const ComponentTheme<StepperTheme>(
        data: StepperTheme(
          active: StepperIndicatorStyle(background: ThemedColor.value(green)),
        ),
        child: Stepper(
          currentStep: 0,
          steps: _steps,
          theme: StepperTheme(
            active: StepperIndicatorStyle(background: ThemedColor.value(blue)),
          ),
        ),
      ),
    );
    expect(_ring(tester, 0).color, blue);
  });

  testWidgets('partial legs merge per field', (tester) async {
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          StepperTheme(
            connectorColor: ThemedColor.value(Color(0xFFFF0000)),
            connectorThickness: 5,
          ),
        ],
        child: const ComponentTheme<StepperTheme>(
          data: StepperTheme(gap: 20),
          child: Stepper(currentStep: 1, steps: _steps),
        ),
      ),
    );
    expect(_connectorColor(tester, 0), const Color(0xFFFF0000));
    expect(
      tester
          .widgetList<SizedBox>(
            find.descendant(
              of: find.byType(Stepper),
              matching: find.byType(SizedBox),
            ),
          )
          .any((box) => box.height == 5),
      isTrue,
    );
  });

  testWidgets('dark tokens drive the rings and the connector', (tester) async {
    const ShadcnThemeData dark = ShadcnThemeData(
      colors: ShadcnColors.darkFallback,
    );
    await tester.pumpWidget(
      _frame(
        data: dark,
        child: const Stepper(currentStep: 1, steps: _steps),
      ),
    );
    expect(_ring(tester, 0).color, dark.colors.primary);
    expect(_connectorColor(tester, 0), dark.colors.primary);
    expect(_connectorColor(tester, 1), dark.colors.border);
  });

  testWidgets('a custom icon replaces the number', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: const Stepper(
          currentStep: 0,
          steps: <StepperStep>[
            StepperStep(title: Text('Icon'), icon: Icon(LucideIcons.star)),
          ],
        ),
      ),
    );
    expect(find.byIcon(LucideIcons.star), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}
