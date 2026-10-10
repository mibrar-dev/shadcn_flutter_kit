// Widget tests for the `alert` component.
//
// Covers both variants, the slot styles, the four theme-precedence legs,
// dark tokens and the old-bug regressions: the old destructive styling
// overrode the whole banner from outside (so a caller's `DefaultTextStyle`
// could leak between slots) and the old `AlertTheme` had no destructive row.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/alert/alert.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/density.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  AlertTheme? scopedTheme,
}) {
  Widget body = child;
  if (scopedTheme != null) {
    body = ComponentTheme<AlertTheme>(data: scopedTheme, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Align(alignment: Alignment.topLeft, child: body),
      ),
    ),
  );
}

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  AlertTheme? scopedTheme,
}) {
  return tester.pumpWidget(
    _frame(data: data, app: app, scopedTheme: scopedTheme, child: child),
  );
}

BoxDecoration _decoration(WidgetTester tester) {
  final DecoratedBox box = tester.widget<DecoratedBox>(
    find
        .descendant(of: find.byType(Alert), matching: find.byType(DecoratedBox))
        .first,
  );
  return box.decoration as BoxDecoration;
}

EdgeInsets _outerPadding(WidgetTester tester) {
  final Padding padding = tester.widget<Padding>(
    find
        .descendant(of: find.byType(Alert), matching: find.byType(Padding))
        .first,
  );
  return padding.padding.resolve(TextDirection.ltr);
}

/// The style applied to the slot [text] lives in.
TextStyle _slotStyle(WidgetTester tester, String text) {
  final DefaultTextStyle style = tester.widget<DefaultTextStyle>(
    find
        .ancestor(of: find.text(text), matching: find.byType(DefaultTextStyle))
        .first,
  );
  return style.style;
}

IconThemeData _leadingIconTheme(WidgetTester tester) {
  return tester
      .widget<IconTheme>(
        find
            .descendant(
              of: find.byType(Alert),
              matching: find.byType(IconTheme),
            )
            .first,
      )
      .data;
}

void main() {
  const ShadcnColors light = ShadcnColors.lightFallback;

  group('base variant', () {
    testWidgets('renders all four slots', (tester) async {
      await _pump(
        tester,
        const Alert(
          leading: Icon(IconData(0x1)),
          title: Text('title'),
          content: Text('content'),
          trailing: Text('trailing'),
        ),
      );
      expect(find.text('title'), findsOneWidget);
      expect(find.text('content'), findsOneWidget);
      expect(find.text('trailing'), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('card surface, border token and radiusLg', (tester) async {
      await _pump(tester, const Alert(title: Text('title')));
      final BoxDecoration decoration = _decoration(tester);
      expect(decoration.color, light.card);
      expect(decoration.border!.top.color, light.border);
      expect(decoration.border!.top.width, 1);
      expect(decoration.borderRadius, const ShadcnThemeData().borderRadiusLg);
    });

    testWidgets('padding is 16/12 and the icon is 16px', (tester) async {
      await _pump(
        tester,
        const Alert(leading: Icon(IconData(0x1)), title: Text('title')),
      );
      expect(
        _outerPadding(tester),
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      );
      expect(_leadingIconTheme(tester).size, 16);
      expect(_leadingIconTheme(tester).color, light.foreground);
    });

    testWidgets('title is 14 w500 and content 14 mutedForeground', (
      tester,
    ) async {
      await _pump(
        tester,
        const Alert(title: Text('title'), content: Text('content')),
      );
      final TextStyle title = _slotStyle(tester, 'title');
      expect(title.fontSize, 14);
      expect(title.fontWeight, FontWeight.w500);
      expect(title.color, light.foreground);
      final TextStyle content = _slotStyle(tester, 'content');
      expect(content.fontSize, 14);
      expect(content.color, light.mutedForeground);
    });
  });

  group('destructive variant', () {
    testWidgets('keeps the card surface, swaps the foregrounds', (
      tester,
    ) async {
      await _pump(
        tester,
        const Alert(
          variant: AlertVariant.destructive,
          leading: Icon(IconData(0x1)),
          title: Text('title'),
          content: Text('content'),
        ),
      );
      expect(_decoration(tester).color, light.card);
      expect(_slotStyle(tester, 'title').color, light.destructive);
      expect(_slotStyle(tester, 'content').color, light.destructive);
      expect(_leadingIconTheme(tester).color, light.destructive);
    });

    testWidgets('regression: slot styles win over an ambient text style', (
      tester,
    ) async {
      // The old code wrapped the whole banner in `DefaultTextStyle.merge`,
      // which let slot styles from the caller leak between title and content.
      await tester.pumpWidget(
        _frame(
          child: const DefaultTextStyle(
            style: TextStyle(color: _green),
            child: Alert(
              variant: AlertVariant.destructive,
              title: Text('title'),
              content: Text('content'),
            ),
          ),
        ),
      );
      expect(_slotStyle(tester, 'title').color, light.destructive);
      expect(_slotStyle(tester, 'content').color, light.destructive);
    });
  });

  group('theme precedence', () {
    testWidgets('app leg overrides the defaults', (tester) async {
      await _pump(
        tester,
        const Alert(title: Text('title')),
        app: const <ComponentThemeData>[
          AlertTheme(base: AlertStyle(background: ThemedColor.value(_green))),
        ],
      );
      expect(_decoration(tester).color, _green);
    });

    testWidgets('scoped leg overrides the app leg', (tester) async {
      await _pump(
        tester,
        const Alert(title: Text('title')),
        app: const <ComponentThemeData>[
          AlertTheme(base: AlertStyle(background: ThemedColor.value(_green))),
        ],
        scopedTheme: const AlertTheme(
          base: AlertStyle(background: ThemedColor.value(_blue)),
        ),
      );
      expect(_decoration(tester).color, _blue);
    });

    testWidgets('widget leg overrides the scoped leg', (tester) async {
      await _pump(
        tester,
        const Alert(
          title: Text('title'),
          theme: AlertTheme(
            base: AlertStyle(background: ThemedColor.value(_blue)),
          ),
        ),
        scopedTheme: const AlertTheme(
          base: AlertStyle(background: ThemedColor.value(_green)),
        ),
      );
      expect(_decoration(tester).color, _blue);
    });

    testWidgets('a leg setting only the title colour keeps the tokens', (
      tester,
    ) async {
      await _pump(
        tester,
        const Alert(title: Text('title')),
        scopedTheme: const AlertTheme(
          base: AlertStyle(titleColor: ThemedColor.value(_green)),
        ),
      );
      expect(_decoration(tester).color, light.card);
      expect(_slotStyle(tester, 'title').color, _green);
    });

    testWidgets('destructive inherits the same leg base row', (tester) async {
      await _pump(
        tester,
        const Alert(variant: AlertVariant.destructive, title: Text('title')),
        app: const <ComponentThemeData>[
          AlertTheme(
            base: AlertStyle(background: ThemedColor.value(_green)),
            destructive: AlertStyle(titleColor: ThemedColor.value(_blue)),
          ),
        ],
      );
      expect(_decoration(tester).color, _green);
      expect(_slotStyle(tester, 'title').color, _blue);
    });
  });

  group('tokens', () {
    testWidgets('dark palette drives the same slots', (tester) async {
      const ShadcnColors dark = ShadcnColors.darkFallback;
      await _pump(
        tester,
        const Alert(
          variant: AlertVariant.destructive,
          leading: Icon(IconData(0x1)),
          title: Text('title'),
          content: Text('content'),
        ),
        data: const ShadcnThemeData(colors: dark),
      );
      expect(_decoration(tester).color, dark.card);
      expect(_decoration(tester).border!.top.color, dark.border);
      expect(_slotStyle(tester, 'title').color, dark.destructive);
      expect(_slotStyle(tester, 'content').color, dark.destructive);
      expect(_leadingIconTheme(tester).color, dark.destructive);
    });

    testWidgets('alpha multiplies the token alpha', (tester) async {
      const ShadcnColors dark = ShadcnColors.darkFallback;
      await _pump(
        tester,
        const Alert(
          title: Text('title'),
          theme: AlertTheme(
            base: AlertStyle(
              background: ThemedColor.ref(ColorRef.card, alpha: 0.5),
            ),
          ),
        ),
        data: const ShadcnThemeData(colors: dark),
      );
      expect(_decoration(tester).color!.a, closeTo(dark.card.a * 0.5, 0.001));
    });
  });

  group('defaults table', () {
    test('token-derived rows match the shadcn alert', () {
      const ShadcnColors colors = ShadcnColors.lightFallback;
      final AlertStyle base = alertDefaults.forVariant(AlertVariant.base)!;
      expect(base.background?.resolve(colors), colors.card);
      expect(base.borderColor?.resolve(colors), colors.border);
      // `px-4 py-3` is stored as density multipliers, so the row itself only
      // resolves to 16/12 at the default density (see `Alert`).
      expect(
        resolveEdgeInsets(
          base.padding!,
          Density.defaultDensity.baseContentPadding,
        ),
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      );
      expect(base.gap, 12);
      final AlertStyle destructive = alertDefaults.forVariant(
        AlertVariant.destructive,
      )!;
      expect(destructive.background?.resolve(colors), colors.card);
      expect(destructive.titleColor?.resolve(colors), colors.destructive);
    });

    test('rows merge and lerp', () {
      const AlertStyle a = AlertStyle(background: ThemedColor.value(_green));
      const AlertStyle b = AlertStyle(
        background: ThemedColor.value(_blue),
        gap: 8,
      );
      final AlertStyle merged = a.merge(b);
      expect((merged.background! as LiteralColor).color, _green);
      expect(merged.gap, 8);
      final AlertStyle stepped = AlertStyle.lerp(a, b, 0.25);
      expect((stepped.background! as LiteralColor).color, _green);
      expect(stepped.gap, 2);
    });
  });
}
