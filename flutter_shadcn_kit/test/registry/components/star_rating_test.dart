// Widget tests for the `star_rating` component.
//
// Geometry: five stars of 24px with 5px gaps span 140px. Tap x maps to
// `x / 140 * 5`, snapped to the step.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/star_rating/star_rating.dart';
import 'package:flutter_shadcn_kit/registry/foundation/data.dart';
import 'package:flutter_shadcn_kit/registry/primitives/clickable.dart';
import 'package:flutter_shadcn_kit/registry/primitives/form_core/form_core.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  StarRatingTheme? scoped,
  FormFieldHandle? formHandle,
  TextDirection textDirection = TextDirection.ltr,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<StarRatingTheme>(data: scoped, child: body);
  }
  if (formHandle != null) {
    body = Data<FormFieldHandle>.inherit(data: formHandle, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: textDirection,
        child: Center(child: body),
      ),
    ),
  );
}

/// Taps at [x] px inside the star row.
Future<void> _tapX(WidgetTester tester, double x) async {
  final Offset topLeft = tester.getTopLeft(find.byType(StarRating));
  await tester.tapAt(topLeft + Offset(x, 12));
}

double _starSize(WidgetTester tester) => tester
    .getSize(
      find
          .descendant(
            of: find.byType(StarRating),
            matching: find.byType(ShaderMask),
          )
          .first,
    )
    .width;

class _FakeFormHandle with FormFieldHandle {
  final List<Object?> reported = <Object?>[];
  Object? replaceWith;

  @override
  final FormKey<Object?> formKey = const FormKey<Object?>('star_rating');

  @override
  bool get mounted => true;

  @override
  ValueListenable<ValidationResult?>? get validity => null;

  @override
  FutureOr<ValidationResult?> reportNewFormValue<T>(T? value) {
    reported.add(value);
    final Object? replacement = replaceWith;
    if (replacement == null) {
      return null;
    }
    return ReplaceResult<T>(
      replacement as T,
      state: FormValidationMode.changed,
    );
  }

  @override
  FutureOr<ValidationResult?> revalidate() => null;
}

void main() {
  testWidgets('renders under light and dark tokens with slider semantics', (
    tester,
  ) async {
    for (final ShadcnThemeData data in <ShadcnThemeData>[
      const ShadcnThemeData(),
      const ShadcnThemeData(colors: ShadcnColors.darkFallback),
    ]) {
      await tester.pumpWidget(
        _frame(data: data, child: const StarRating(value: 3.5)),
      );
      expect(find.byType(ShaderMask), findsNWidgets(5));
      final SemanticsNode node = tester.getSemantics(
        find
            .descendant(
              of: find.byType(StarRating),
              matching: find.byType(Semantics),
            )
            .first,
      );
      expect(node.flagsCollection.isSlider, isTrue);
      expect(node.value, '3.5');
    }
  });

  testWidgets('a tap commits the snapped value exactly once', (tester) async {
    final List<double> changes = <double>[];
    await tester.pumpWidget(
      _frame(child: StarRating(value: 0, onChanged: changes.add)),
    );
    await _tapX(tester, 12); // middle of the first star -> 0.5
    // Regression: the old row reported on tap-down and again on tap-up.
    expect(changes, <double>[0.5]);
  });

  testWidgets('taps snap to step and clamp to max', (tester) async {
    final List<double> changes = <double>[];
    await tester.pumpWidget(
      _frame(child: StarRating(value: 0, onChanged: changes.add)),
    );
    await _tapX(tester, 128); // last star center -> 4.57 -> 4.5
    expect(changes, <double>[4.5]);

    changes.clear();
    await tester.pumpWidget(
      _frame(child: StarRating(value: 0, step: 1, onChanged: changes.add)),
    );
    await _tapX(tester, 70); // exactly half -> snaps to 3 with step 1
    expect(changes, <double>[3]);
  });

  testWidgets('regression: the disabled cursor is the system arrow', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(child: const StarRating(value: 3, enabled: false)),
    );
    final Clickable clickable = tester.widget<Clickable>(
      find.descendant(
        of: find.byType(StarRating),
        matching: find.byType(Clickable),
      ),
    );
    expect(
      clickable.mouseCursor?.resolve(<WidgetState>{WidgetState.disabled}),
      SystemMouseCursors.basic,
    );
  });

  testWidgets('a disabled or read-only row ignores taps', (tester) async {
    final List<double> changes = <double>[];
    await tester.pumpWidget(
      _frame(
        child: StarRating(value: 3, enabled: false, onChanged: changes.add),
      ),
    );
    await _tapX(tester, 12);
    expect(changes, isEmpty);

    await tester.pumpWidget(_frame(child: const StarRating(value: 3)));
    await _tapX(tester, 12);
    expect(changes, isEmpty);
  });

  testWidgets('disabled dims the whole control', (tester) async {
    await tester.pumpWidget(
      _frame(child: const StarRating(value: 3, enabled: false)),
    );
    final Opacity opacity = tester.widget<Opacity>(
      find
          .descendant(
            of: find.byType(StarRating),
            matching: find.byType(Opacity),
          )
          .first,
    );
    expect(opacity.opacity, 0.5);
  });

  testWidgets('arrow keys step by step and clamp at zero', (tester) async {
    final List<double> changes = <double>[];
    final FocusNode node = FocusNode();
    addTearDown(node.dispose);
    await tester.pumpWidget(
      _frame(
        child: StarRating(value: 0.5, focusNode: node, onChanged: changes.add),
      ),
    );
    node.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    expect(changes, <double>[1.0]);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    expect(changes.last, 0.0);
  });

  testWidgets('controller mode owns the value', (tester) async {
    final StarRatingController controller = StarRatingController(2);
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(child: StarRating(controller: controller)));
    await _tapX(tester, 12);
    expect(controller.value, 0.5);
  });

  testWidgets('a drag updates the value while moving', (tester) async {
    final List<double> changes = <double>[];
    await tester.pumpWidget(
      _frame(child: StarRating(value: 0, onChanged: changes.add)),
    );
    final Offset topLeft = tester.getTopLeft(find.byType(StarRating));
    final TestGesture gesture = await tester.startGesture(
      topLeft + const Offset(2, 12),
    );
    await gesture.moveTo(topLeft + const Offset(70, 12));
    await tester.pump();
    expect(changes.last, 2.5);
    await gesture.up();
    await tester.pump();
    expect(changes.last, 2.5, reason: 'release adds no extra change');
  });

  testWidgets('an RTL row fills from the right', (tester) async {
    final List<double> changes = <double>[];
    await tester.pumpWidget(
      _frame(
        textDirection: TextDirection.rtl,
        child: StarRating(value: 0, onChanged: changes.add),
      ),
    );
    await _tapX(tester, 12);
    expect(changes, <double>[4.5]);
  });

  testWidgets('theme legs resolve per field', (tester) async {
    Future<void> pump({
      List<ComponentThemeData> app = const <ComponentThemeData>[],
      StarRatingTheme? scoped,
      StarRatingStyle? widget,
    }) async {
      await tester.pumpWidget(
        _frame(
          app: app,
          scoped: scoped,
          child: StarRating(value: 3, theme: widget),
        ),
      );
    }

    await pump();
    expect(_starSize(tester), 24);

    await pump(
      app: <ComponentThemeData>[
        const StarRatingTheme(style: StarRatingStyle(size: 26)),
      ],
    );
    expect(_starSize(tester), 26);

    await pump(
      app: <ComponentThemeData>[
        const StarRatingTheme(style: StarRatingStyle(size: 26)),
      ],
      scoped: const StarRatingTheme(style: StarRatingStyle(size: 28)),
    );
    expect(_starSize(tester), 28);

    await pump(
      app: <ComponentThemeData>[
        const StarRatingTheme(style: StarRatingStyle(size: 26)),
      ],
      scoped: const StarRatingTheme(style: StarRatingStyle(size: 28)),
      widget: const StarRatingStyle(size: 30),
    );
    expect(_starSize(tester), 30);

    // A widget leg that sets only a colour keeps the lower leg's size.
    await pump(
      app: <ComponentThemeData>[
        const StarRatingTheme(style: StarRatingStyle(size: 26)),
      ],
      widget: const StarRatingStyle(
        activeColor: ThemedColor.ref(ColorRef.destructive),
      ),
    );
    expect(_starSize(tester), 26);
  });

  testWidgets('a form handle receives and can replace the value', (
    tester,
  ) async {
    final _FakeFormHandle handle = _FakeFormHandle();
    final List<double> changes = <double>[];
    Widget build(double value) => _frame(
      formHandle: handle,
      child: StarRating(value: value, onChanged: changes.add),
    );

    await tester.pumpWidget(build(2));
    expect(handle.reported.last, 2.0);

    handle.replaceWith = 4.0;
    await tester.pumpWidget(build(3));
    await tester.pump(); // apply the post-frame replacement
    expect(changes, contains(4.0));
  });
}
