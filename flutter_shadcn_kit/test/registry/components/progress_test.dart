// Widget and unit tests for the `progress` component.
//
// Covers: the token surface (light + dark), the four theme legs, per-field
// merge, widget-leg overrides, determinate animation vs `disableAnimation`,
// indeterminate mode, clamping and semantics. Progress absorbs the old
// `linear_progress_indicator`; its indeterminate mode is covered here.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/progress/progress.dart';
import 'package:flutter_shadcn_kit/registry/foundation/constants.dart';
import 'package:flutter_shadcn_kit/registry/primitives/animation.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
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
        child: Center(child: SizedBox(width: 200, child: child)),
      ),
    ),
  );
}

ProgressSurface _surface(WidgetTester tester) {
  final Progress widget = tester.widget<Progress>(find.byType(Progress));
  return resolveProgressSurface(
    tester.element(find.byType(Progress)),
    widgetTheme: widget.theme,
    height: widget.height,
    borderRadius: widget.borderRadius,
    color: widget.color,
    backgroundColor: widget.backgroundColor,
    showSparks: widget.showSparks,
    disableAnimation: widget.disableAnimation,
  );
}

void main() {
  const ShadcnColors colors = ShadcnColors.lightFallback;

  testWidgets('token surface: primary fill, 20% track, 8px pill', (
    tester,
  ) async {
    await tester.pumpWidget(_frame(child: const Progress(value: 0.5)));
    final surface = _surface(tester);
    expect(surface.color, colors.primary);
    expect(
      surface.backgroundColor,
      colors.primary.withValues(alpha: colors.primary.a * 0.2),
    );
    expect(surface.height, 8);
    expect(surface.borderRadius, BorderRadius.circular(4));
    expect(surface.showSparks, isFalse);
    expect(surface.animate, isTrue);
  });

  testWidgets('dark tokens drive the surface', (tester) async {
    const ShadcnThemeData dark = ShadcnThemeData(
      colors: ShadcnColors.darkFallback,
    );
    await tester.pumpWidget(
      _frame(data: dark, child: const Progress(value: 0.5)),
    );
    final surface = _surface(tester);
    expect(surface.color, dark.colors.primary);
    expect(
      surface.backgroundColor,
      dark.colors.primary.withValues(alpha: dark.colors.primary.a * 0.2),
    );
  });

  testWidgets('theme precedence: defaults < app < scoped < widget', (
    tester,
  ) async {
    const red = ProgressTheme(color: ThemedColor.value(_red));
    const green = ProgressTheme(color: ThemedColor.value(_green));
    const blue = ProgressTheme(color: ThemedColor.value(_blue));

    await tester.pumpWidget(
      _frame(app: <ComponentThemeData>[red], child: const Progress(value: 0.5)),
    );
    expect(_surface(tester).color, _red);

    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[red],
        child: const ComponentTheme<ProgressTheme>(
          data: green,
          child: Progress(value: 0.5),
        ),
      ),
    );
    expect(_surface(tester).color, _green);

    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[red],
        child: const ComponentTheme<ProgressTheme>(
          data: green,
          child: Progress(value: 0.5, theme: blue),
        ),
      ),
    );
    expect(_surface(tester).color, _blue);
  });

  testWidgets('partial legs merge per field', (tester) async {
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          ProgressTheme(color: ThemedColor.value(_red)),
        ],
        child: const ComponentTheme<ProgressTheme>(
          data: ProgressTheme(showSparks: true),
          child: Progress(value: 0.5, theme: ProgressTheme(height: 4)),
        ),
      ),
    );
    final surface = _surface(tester);
    expect(surface.color, _red);
    expect(surface.showSparks, isTrue);
    expect(surface.height, 4);
  });

  testWidgets('widget arguments beat every theme leg', (tester) async {
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          ProgressTheme(
            color: ThemedColor.value(_red),
            height: 20,
            showSparks: false,
          ),
        ],
        child: const Progress(
          value: 0.5,
          color: _blue,
          height: 6,
          showSparks: true,
        ),
      ),
    );
    final surface = _surface(tester);
    expect(surface.color, _blue);
    expect(surface.height, 6);
    expect(surface.showSparks, isTrue);
  });

  testWidgets('default radius follows the height (pill)', (tester) async {
    await tester.pumpWidget(
      _frame(child: const Progress(value: 0.5, height: 14)),
    );
    expect(_surface(tester).borderRadius, BorderRadius.circular(7));
  });

  testWidgets('determinate value animates, disableAnimation jumps', (
    tester,
  ) async {
    await tester.pumpWidget(_frame(child: const Progress(value: 0.2)));
    final animated = tester.widget<TweenAnimationBuilder<double>>(
      find.byType(TweenAnimationBuilder<double>),
    );
    expect(animated.duration, kDefaultDuration);

    await tester.pumpWidget(
      _frame(child: const Progress(value: 0.2, disableAnimation: true)),
    );
    final jumped = tester.widget<TweenAnimationBuilder<double>>(
      find.byType(TweenAnimationBuilder<double>),
    );
    expect(jumped.duration, Duration.zero);
  });

  testWidgets('null value renders the indeterminate sweep', (tester) async {
    await tester.pumpWidget(_frame(child: const Progress()));
    expect(find.byType(RepeatedAnimationBuilder), findsOneWidget);
    expect(find.byType(TweenAnimationBuilder<double>), findsNothing);

    // The sweep keeps animating without settling.
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);
  });

  testWidgets('out-of-range values clamp instead of asserting (regression)', (
    tester,
  ) async {
    // The old `Progress` asserted `min <= progress <= max`; a bad caller
    // crashed in debug. The new bar clamps.
    await tester.pumpWidget(_frame(child: const Progress(value: 5)));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(_frame(child: const Progress(value: -2)));
    expect(tester.takeException(), isNull);
  });

  testWidgets('semantics expose label and value', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _frame(
        child: const Progress(
          value: 0.4,
          semanticsLabel: 'Uploading',
          semanticsValue: '40%',
        ),
      ),
    );
    final semantics = tester.getSemantics(
      find
          .descendant(
            of: find.byType(Progress),
            matching: find.byType(Semantics),
          )
          .first,
    );
    expect(semantics.label, contains('Uploading'));
    expect(semantics.value, contains('40%'));
    handle.dispose();
  });

  testWidgets('RTL renders', (tester) async {
    await tester.pumpWidget(
      _frame(
        textDirection: TextDirection.rtl,
        child: const Progress(value: 0.5),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(Progress), findsOneWidget);
  });
}
