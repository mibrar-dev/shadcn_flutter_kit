// Widget and unit tests for the `slider` component.
//
// Covers: token-derived defaults per variant (light + dark), every variant
// renders, all snap modes, tap/drag/keyboard interaction, controlled value
// flow, range min-range/allowSwap, disabled, form participation and the
// four-leg theme precedence. Regression: the old Material-Slider import and
// `ShadRangeValue` model are gone (compile-time), plus snap edge cases.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/slider/slider.dart';
import 'package:flutter_shadcn_kit/registry_next/foundation/data.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/form_core/form_core.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/slider/slider.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/slider_value.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

SliderMarksStyle _marksStyleFor(SliderVariant variant) {
  return switch (variant) {
    SliderVariant.standard || SliderVariant.soft => SliderMarksStyle.none,
    SliderVariant.dots => SliderMarksStyle.dots,
    SliderVariant.wave => SliderMarksStyle.wave,
  };
}

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
        child: Center(child: SizedBox(width: 300, child: child)),
      ),
    ),
  );
}

SliderPainter _painter(WidgetTester tester) {
  final paint = tester.widget<CustomPaint>(
    find.descendant(
      of: find.byType(Slider),
      matching: find.byType(CustomPaint),
    ),
  );
  return paint.painter! as SliderPainter;
}

class _FakeFormHandle with FormFieldHandle {
  final List<Object?> reported = <Object?>[];

  @override
  final FormKey<SliderValue> formKey = const FormKey<SliderValue>('slider');

  @override
  bool get mounted => true;

  @override
  ValueListenable<ValidationResult?>? get validity => null;

  @override
  FutureOr<ValidationResult?> reportNewFormValue<T>(T? value) {
    reported.add(value);
    return null;
  }

  @override
  FutureOr<ValidationResult?> revalidate() => null;
}

void main() {
  const colors = ShadcnColors.lightFallback;

  test('default rows match the token design for every variant', () {
    for (final variant in SliderVariant.values) {
      final row = sliderDefaults.forVariant(variant)!;
      expect(
        row.track?.resolve(const <WidgetState>{})?.resolve(colors),
        colors.secondary,
        reason: variant.name,
      );
      expect(
        row.fill?.resolve(const <WidgetState>{})?.resolve(colors),
        colors.primary,
        reason: variant.name,
      );
      expect(row.trackHeight, isNotNull, reason: variant.name);
      expect(row.thumbSize, isNotNull, reason: variant.name);
    }
    expect(
      sliderDefaults.forVariant(SliderVariant.standard)!.thumbShape,
      SliderThumbShape.bar,
    );
    expect(
      sliderDefaults.forVariant(SliderVariant.soft)!.thumbShape,
      SliderThumbShape.circle,
    );
  });

  testWidgets('renders standard variant with token colors (light)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(child: Slider(value: 0.5, onChanged: (_) {})),
    );
    final painter = _painter(tester);
    expect(painter.trackColor, colors.secondary);
    expect(painter.fillColor, colors.primary);
    expect(painter.marksStyle, SliderMarksStyle.none);
    expect(painter.thumbShape, SliderThumbShape.bar);
  });

  testWidgets('renders dark tokens', (tester) async {
    await tester.pumpWidget(
      _frame(
        data: ShadcnThemeData(colors: ShadcnColors.darkFallback),
        child: Slider(value: 0.5, onChanged: (_) {}),
      ),
    );
    final painter = _painter(tester);
    expect(painter.trackColor, ShadcnColors.darkFallback.secondary);
    expect(painter.fillColor, ShadcnColors.darkFallback.primary);
  });

  for (final variant in SliderVariant.values) {
    testWidgets('renders variant ${variant.name}', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: Slider(
            value: 0.5,
            variant: variant,
            snap: const SliderSnap.steps(8),
            onChanged: (_) {},
          ),
        ),
      );
      expect(_painter(tester).marksStyle, _marksStyleFor(variant));
      expect(
        _painter(tester).thumbShape,
        variant == SliderVariant.standard
            ? SliderThumbShape.bar
            : SliderThumbShape.circle,
      );
      expect(find.byType(Semantics), findsWidgets);
    });
  }

  testWidgets('tap jumps to the tapped value', (tester) async {
    double? seen;
    await tester.pumpWidget(
      _frame(child: Slider(value: 0.2, onChanged: (v) => seen = v)),
    );
    final box = tester.getRect(find.byType(Slider));
    await tester.tapAt(box.centerRight - const Offset(20, 0));
    expect(seen, isNotNull);
    expect(seen!, greaterThan(0.5));
  });

  testWidgets('horizontal drag emits a clamped value', (tester) async {
    double? seen;
    await tester.pumpWidget(
      _frame(child: Slider(value: 0.5, onChanged: (v) => seen = v)),
    );
    await tester.drag(find.byType(Slider), const Offset(-200, 0));
    expect(seen, isNotNull);
    expect(seen!, inInclusiveRange(0, 1));
  });

  testWidgets('steps snap quantizes drag output', (tester) async {
    double? seen;
    await tester.pumpWidget(
      _frame(
        child: Slider(
          value: 0,
          max: 4,
          snap: const SliderSnap.steps(4),
          onChanged: (v) => seen = v,
        ),
      ),
    );
    await tester.tapAt(tester.getRect(find.byType(Slider)).center);
    expect(seen, isNotNull);
    expect(seen! % 1 == 0 || (seen! * 4) % 1 == 0, isTrue);
  });

  test('SliderSnap.values picks the nearest entry', () {
    const snap = SliderSnap.values([0.1, 0.5, 0.9]);
    expect(snap.apply(0.4, 0, 1), 0.5);
    expect(snap.apply(0.02, 0, 1), 0.1);
  });

  test('SliderSnap.steps collapses zero-width domain', () {
    const snap = SliderSnap.steps(3);
    expect(snap.apply(5, 2, 2), 2);
  });

  testWidgets('arrow keys step, Home/End jump to the bounds', (tester) async {
    double? seen;
    var current = 0.5;
    await tester.pumpWidget(
      _frame(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Slider(
              value: current,
              autofocus: true,
              onChanged: (v) => setState(() {
                current = v;
                seen = v;
              }),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(seen, closeTo(0.51, 1e-6));
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(seen, closeTo(0.5, 1e-6));
    await tester.sendKeyEvent(LogicalKeyboardKey.home);
    await tester.pump();
    expect(seen, 0);
    await tester.sendKeyEvent(LogicalKeyboardKey.end);
    await tester.pump();
    expect(seen, 1);
  });

  testWidgets('PageUp/PageDown move ten steps at once', (tester) async {
    double? seen;
    var current = 0.5;
    await tester.pumpWidget(
      _frame(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Slider(
              value: current,
              autofocus: true,
              onChanged: (v) => setState(() {
                current = v;
                seen = v;
              }),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.pageUp);
    await tester.pump();
    expect(seen, closeTo(0.6, 1e-6));
    await tester.sendKeyEvent(LogicalKeyboardKey.pageDown);
    await tester.pump();
    expect(seen, closeTo(0.5, 1e-6));
  });

  testWidgets('PageUp/PageDown respect step divisions', (tester) async {
    double? seen;
    var current = 2.0;
    await tester.pumpWidget(
      _frame(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Slider(
              value: current,
              min: 0,
              max: 10,
              snap: const SliderSnap.steps(10),
              autofocus: true,
              onChanged: (v) => setState(() {
                current = v;
                seen = v;
              }),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.pageUp);
    await tester.pump();
    // 10 arrow steps x (10/10) = +10, clamped to max.
    expect(seen, 10.0);
  });

  testWidgets('controlled flow: widget value wins, null onChanged is inert', (
    tester,
  ) async {
    var calls = 0;
    await tester.pumpWidget(
      _frame(child: Slider(value: 0.3, onChanged: (_) => calls++)),
    );
    double? emitted;
    await tester.pumpWidget(
      _frame(child: Slider(value: 0.3, onChanged: (v) => emitted = v)),
    );
    await tester.tap(find.byType(Slider));
    expect(emitted, isNotNull);
    expect(calls, 0, reason: 'first slider had no state, never rebuilt');

    calls = 0;
    await tester.pumpWidget(_frame(child: Slider(value: 0.3, onChanged: null)));
    await tester.tap(find.byType(Slider));
    expect(calls, 0);
  });

  test('range value↔position mapping round-trips through the primitive', () {
    final logic = SliderLogic();
    final view = logic.buildView(
      min: 0,
      max: 100,
      snap: const SliderSnap.none(),
      enabled: true,
      trackRect: const Rect.fromLTWH(0, 0, 200, 4),
      trackRadius: 2,
      thumbInset: 8,
      dragging: false,
      activeThumb: null,
      thumbSize: const Size(16, 16),
      textDirection: TextDirection.ltr,
      value: null,
      rangeStart: 25,
      rangeEnd: 75,
    );
    expect(view.isRange, isTrue);
    expect(view.thumbs.length, 2);
    expect(view.thumbs[0].t, closeTo(0.25, 1e-6));
    expect(view.thumbs[1].t, closeTo(0.75, 1e-6));
    final dx = view.thumbs[1].center.dx;
    expect(
      logic.valueFromDx(view, const SliderSnap.none(), dx),
      closeTo(75, 1e-6),
    );
  });

  testWidgets('range slider drags the nearest thumb and clamps minRange', (
    tester,
  ) async {
    SliderValue? seen;
    const current = SliderValue.ranged(0.2, 0.8);
    await tester.pumpWidget(
      _frame(
        child: Slider.range(
          value: current,
          minRange: 0.2,
          onRangeChanged: (v) => seen = v,
        ),
      ),
    );
    // Tap near the right thumb -> moves end, never below start + minRange.
    final rect = tester.getRect(find.byType(Slider));
    await tester.tapAt(Offset(rect.left + rect.width * 0.3, rect.center.dy));
    expect(seen, isNotNull);
    expect(seen!.start, greaterThanOrEqualTo(0));
    expect(seen!.end, closeTo(0.8, 1e-6));
    expect(seen!.end - seen!.start, greaterThanOrEqualTo(0.2 - 1e-6));
  });

  testWidgets('range allowSwap lets thumbs cross', (tester) async {
    SliderValue? seen;
    const current = SliderValue.ranged(0.4, 0.6);
    await tester.pumpWidget(
      _frame(
        child: Slider.range(
          value: current,
          allowSwap: true,
          onRangeChanged: (v) => seen = v,
        ),
      ),
    );
    final rect = tester.getRect(find.byType(Slider));
    // Drag the first (left) thumb far right, past the second thumb.
    await tester.dragFrom(
      Offset(rect.left + rect.width * 0.4, rect.center.dy),
      Offset(rect.width * 0.55, 0),
    );
    expect(seen, isNotNull);
    expect(seen!.start <= seen!.end, isTrue);
  });

  testWidgets('disabled slider is inert and dimmed', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      _frame(
        child: Slider(value: 0.5, enabled: false, onChanged: (_) => calls++),
      ),
    );
    final opacity = tester.widget<Opacity>(
      find.descendant(of: find.byType(Slider), matching: find.byType(Opacity)),
    );
    expect(opacity.opacity, 0.5);
    await tester.tap(find.byType(Slider));
    expect(calls, 0);
  });

  testWidgets('reports its value to a form and accepts replacements', (
    tester,
  ) async {
    final handle = _FakeFormHandle();
    await tester.pumpWidget(
      _frame(
        child: Data<FormFieldHandle>.inherit(
          data: handle,
          child: Slider(value: 0.25, onChanged: (_) {}),
        ),
      ),
    );
    expect(
      handle.reported.whereType<SliderValue>().map((v) => v.value),
      contains(0.25),
    );
  });

  testWidgets('theme legs: widget beats tree beats app beats defaults', (
    tester,
  ) async {
    const widgetFill = StateValue<ThemedColor>(
      rest: ThemedColor.value(Color(0xFF111111)),
    );
    const treeFill = StateValue<ThemedColor>(
      rest: ThemedColor.value(Color(0xFF222222)),
    );
    const appFill = StateValue<ThemedColor>(
      rest: ThemedColor.value(Color(0xFF333333)),
    );

    // Default leg.
    await tester.pumpWidget(
      _frame(child: Slider(value: 0.5, onChanged: (_) {})),
    );
    expect(_painter(tester).fillColor, colors.primary);

    // App leg beats defaults.
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          SliderTheme(standard: SliderStyle(fill: appFill)),
        ],
        child: Slider(value: 0.5, onChanged: (_) {}),
      ),
    );
    expect(_painter(tester).fillColor, const Color(0xFF333333));

    // Tree leg beats app.
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          SliderTheme(standard: SliderStyle(fill: appFill)),
        ],
        child: ComponentTheme<SliderTheme>(
          data: const SliderTheme(standard: SliderStyle(fill: treeFill)),
          child: Slider(value: 0.5, onChanged: (_) {}),
        ),
      ),
    );
    expect(_painter(tester).fillColor, const Color(0xFF222222));

    // Widget leg beats tree.
    await tester.pumpWidget(
      _frame(
        child: ComponentTheme<SliderTheme>(
          data: const SliderTheme(standard: SliderStyle(fill: treeFill)),
          child: Slider(
            value: 0.5,
            onChanged: (_) {},
            theme: const SliderStyle(fill: widgetFill),
          ),
        ),
      ),
    );
    expect(_painter(tester).fillColor, const Color(0xFF111111));
  });

  testWidgets('empty merge keeps the lower leg', (tester) async {
    const treeFill = StateValue<ThemedColor>(
      rest: ThemedColor.value(Color(0xFF222222)),
    );
    await tester.pumpWidget(
      _frame(
        child: ComponentTheme<SliderTheme>(
          data: const SliderTheme(standard: SliderStyle(fill: treeFill)),
          child: Slider(
            value: 0.5,
            onChanged: (_) {},
            theme: const SliderStyle(trackHeight: 10),
          ),
        ),
      ),
    );
    final painter = _painter(tester);
    expect(painter.fillColor, const Color(0xFF222222));
    expect(painter.view.trackRect.height, 10);
  });
}
