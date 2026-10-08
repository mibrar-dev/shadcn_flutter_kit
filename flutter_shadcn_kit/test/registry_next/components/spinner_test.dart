// Widget and unit tests for the `spinner` component.
//
// Covers: the token surface (light + dark), the four theme legs, per-field
// merge, widget-leg overrides, the rotating arc and semantics. Spinner
// absorbs the old `circular_progress_indicator`'s indeterminate mode.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/spinner/spinner.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/animation.dart';
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
        child: Center(child: child),
      ),
    ),
  );
}

SpinnerSurface _surface(WidgetTester tester) {
  final Spinner widget = tester.widget<Spinner>(find.byType(Spinner));
  return resolveSpinnerSurface(
    tester.element(find.byType(Spinner)),
    widgetTheme: widget.theme,
    size: widget.size,
    strokeWidth: widget.strokeWidth,
    color: widget.color,
  );
}

void main() {
  const ShadcnColors colors = ShadcnColors.lightFallback;

  testWidgets('token surface: 24px, 2px stroke, primary arc', (tester) async {
    await tester.pumpWidget(_frame(child: const Spinner()));
    final surface = _surface(tester);
    expect(surface.size, 24);
    expect(surface.strokeWidth, 2);
    expect(surface.color, colors.primary);
    final box = tester.widget<SizedBox>(
      find
          .descendant(of: find.byType(Spinner), matching: find.byType(SizedBox))
          .first,
    );
    expect(box.width, 24);
    expect(box.height, 24);
  });

  testWidgets('dark tokens drive the arc', (tester) async {
    const ShadcnThemeData dark = ShadcnThemeData(
      colors: ShadcnColors.darkFallback,
    );
    await tester.pumpWidget(_frame(data: dark, child: const Spinner()));
    expect(_surface(tester).color, dark.colors.primary);
  });

  testWidgets('theme precedence: defaults < app < scoped < widget', (
    tester,
  ) async {
    const red = SpinnerTheme(color: ThemedColor.value(_red));
    const green = SpinnerTheme(color: ThemedColor.value(_green));
    const blue = SpinnerTheme(color: ThemedColor.value(_blue));

    await tester.pumpWidget(
      _frame(app: <ComponentThemeData>[red], child: const Spinner()),
    );
    expect(_surface(tester).color, _red);

    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[red],
        child: const ComponentTheme<SpinnerTheme>(
          data: green,
          child: Spinner(),
        ),
      ),
    );
    expect(_surface(tester).color, _green);

    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[red],
        child: const ComponentTheme<SpinnerTheme>(
          data: green,
          child: Spinner(theme: blue),
        ),
      ),
    );
    expect(_surface(tester).color, _blue);
  });

  testWidgets('partial legs merge per field', (tester) async {
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          SpinnerTheme(color: ThemedColor.value(_red)),
        ],
        child: const ComponentTheme<SpinnerTheme>(
          data: SpinnerTheme(strokeWidth: 3),
          child: Spinner(theme: SpinnerTheme(size: 40)),
        ),
      ),
    );
    final surface = _surface(tester);
    expect(surface.color, _red);
    expect(surface.strokeWidth, 3);
    expect(surface.size, 40);
  });

  testWidgets('widget arguments beat every theme leg', (tester) async {
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          SpinnerTheme(
            color: ThemedColor.value(_red),
            size: 40,
            strokeWidth: 8,
          ),
        ],
        child: const Spinner(color: _blue, size: 16, strokeWidth: 2),
      ),
    );
    final surface = _surface(tester);
    expect(surface.color, _blue);
    expect(surface.size, 16);
    expect(surface.strokeWidth, 2);
  });

  testWidgets('stroke default follows the diameter', (tester) async {
    await tester.pumpWidget(_frame(child: const Spinner(size: 48)));
    expect(_surface(tester).strokeWidth, 4);
  });

  testWidgets('the arc rotates over time', (tester) async {
    await tester.pumpWidget(_frame(child: const Spinner()));
    expect(find.byType(RepeatedAnimationBuilder), findsOneWidget);

    Matrix4 matrix() => tester
        .widget<Transform>(
          find
              .descendant(
                of: find.byType(Spinner),
                matching: find.byType(Transform),
              )
              .first,
        )
        .transform;
    final first = matrix();
    await tester.pump(const Duration(milliseconds: 300));
    final second = matrix();
    expect(first, isNot(equals(second)));
  });

  testWidgets('semantics expose the label', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _frame(child: const Spinner(semanticsLabel: 'Loading')),
    );
    expect(find.bySemanticsLabel('Loading'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('RTL renders', (tester) async {
    await tester.pumpWidget(
      _frame(textDirection: TextDirection.rtl, child: const Spinner()),
    );
    expect(tester.takeException(), isNull);
  });
}
