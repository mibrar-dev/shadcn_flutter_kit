// Widget tests for the `badge` component.
//
// Covers the four variants, the dot form, press/focus/keyboard behaviour and
// the four theme-precedence legs. The regression tests cover the retired
// `Styleable<BadgeTheme>` whole-property replace semantics: an override that
// sets only one state must keep the lower leg's other states, and a static
// badge must not become a focus/hover target.

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/badge/badge.dart';
import 'package:flutter_shadcn_kit/registry/primitives/clickable.dart';
import 'package:flutter_shadcn_kit/registry/primitives/focus_outline.dart';
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
  BadgeTheme? scopedTheme,
}) {
  Widget body = child;
  if (scopedTheme != null) {
    body = ComponentTheme<BadgeTheme>(data: scopedTheme, child: body);
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

/// The `Clickable` inside a badge, when it has one.
Clickable? _clickable(WidgetTester tester) {
  final Finder finder = find.descendant(
    of: find.byType(Badge),
    matching: find.byType(Clickable),
  );
  return tester.widgetList<Clickable>(finder).isEmpty
      ? null
      : tester.widget<Clickable>(finder.first);
}

BoxDecoration _decoration(WidgetTester tester, Set<WidgetState> states) {
  final Clickable clickable = _clickable(tester)!;
  return clickable.decoration!.resolve(states) as BoxDecoration;
}

TextStyle _textStyle(WidgetTester tester, Set<WidgetState> states) {
  final Clickable clickable = _clickable(tester)!;
  return clickable.textStyle!.resolve(states)!;
}

/// The static (non-interactive) surface decoration of a badge.
BoxDecoration _staticDecoration(WidgetTester tester) {
  return tester
          .widget<DecoratedBox>(
            find.descendant(
              of: find.byType(Badge),
              matching: find.byType(DecoratedBox),
            ),
          )
          .decoration
      as BoxDecoration;
}

void main() {
  group('variants', () {
    testWidgets('every variant renders its label', (tester) async {
      for (final BadgeVariant variant in BadgeVariant.values) {
        await tester.pumpWidget(
          _frame(
            child: Badge(variant: variant, child: Text(variant.name)),
          ),
        );
        expect(find.text(variant.name), findsOneWidget);
      }
    });

    testWidgets('primary fills primary and labels primaryForeground', (
      tester,
    ) async {
      final ShadcnColors colors = ShadcnColors.lightFallback;
      await tester.pumpWidget(
        _frame(
          child: Badge(onPressed: () {}, child: const Text('New')),
        ),
      );
      final BoxDecoration rest = _decoration(tester, const <WidgetState>{});
      expect(rest.color, colors.primary);
      expect(
        _textStyle(tester, const <WidgetState>{}).color,
        colors.primaryForeground,
      );
    });

    testWidgets('secondary and destructive use their own tokens', (
      tester,
    ) async {
      final ShadcnColors colors = ShadcnColors.lightFallback;
      for (final MapEntry<BadgeVariant, Color> entry in <BadgeVariant, Color>{
        BadgeVariant.secondary: colors.secondary,
        BadgeVariant.destructive: colors.destructive,
      }.entries) {
        await tester.pumpWidget(
          _frame(
            child: Badge(
              variant: entry.key,
              onPressed: () {},
              child: const Text('x'),
            ),
          ),
        );
        expect(
          _decoration(tester, const <WidgetState>{}).color,
          entry.value,
          reason: entry.key.name,
        );
      }
    });

    testWidgets('outline paints a 1px border and no fill', (tester) async {
      final ShadcnColors colors = ShadcnColors.lightFallback;
      await tester.pumpWidget(
        _frame(
          child: Badge(
            variant: BadgeVariant.outline,
            onPressed: () {},
            child: const Text('Beta'),
          ),
        ),
      );
      final BoxDecoration rest = _decoration(tester, const <WidgetState>{});
      expect(rest.color, isNull);
      expect(rest.border, Border.all(color: colors.border));
    });
  });

  group('interaction', () {
    testWidgets('a static badge has no clickable and no focus node', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(child: const Badge(child: Text('Static'))),
      );
      expect(_clickable(tester), isNull);
      expect(find.byType(FocusOutline), findsNothing);
    });

    testWidgets('tap fires onPressed exactly once', (tester) async {
      int taps = 0;
      await tester.pumpWidget(
        _frame(
          child: Badge(onPressed: () => taps++, child: const Text('Press')),
        ),
      );
      await tester.tap(find.byType(Badge));
      expect(taps, 1);
    });

    testWidgets('hover reaches the pressed-style table row', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: Badge(onPressed: () {}, child: const Text('Hover')),
        ),
      );
      final Color hovered = _decoration(tester, const <WidgetState>{
        WidgetState.hovered,
      }).color!;
      final Color rest = _decoration(tester, const <WidgetState>{}).color!;
      expect(hovered.a, lessThan(rest.a));
    });

    testWidgets('space and enter activate a focused badge', (tester) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(
        () => FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.automatic,
      );
      int taps = 0;
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        _frame(
          child: Badge(
            focusNode: node,
            onPressed: () => taps++,
            child: const Text('Keys'),
          ),
        ),
      );
      node.requestFocus();
      await tester.pump();
      expect(
        tester.widget<FocusOutline>(find.byType(FocusOutline)).focused,
        isTrue,
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(taps, 1);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(taps, 2);
    });

    testWidgets('onHover and onFocusChange report state changes', (
      tester,
    ) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(
        () => FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.automatic,
      );
      final List<bool> hovered = <bool>[];
      final List<bool> focused = <bool>[];
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        _frame(
          child: Badge(
            focusNode: node,
            onPressed: () {},
            onHover: hovered.add,
            onFocusChange: focused.add,
            child: const Text('Observe'),
          ),
        ),
      );
      node.requestFocus();
      await tester.pump();
      expect(focused, <bool>[true]);
      final TestGesture gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      addTearDown(gesture.removePointer);
      await gesture.addPointer(location: Offset.zero);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(Badge)));
      await tester.pump();
      expect(hovered, contains(true));
    });
  });

  group('dot', () {
    testWidgets('renders a circular 6px surface without the child', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(child: const Badge(showAsDot: true, child: SizedBox.shrink())),
      );
      final DecoratedBox box = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(Badge),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      final BoxDecoration decoration = box.decoration as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);
      expect(decoration.color, ShadcnColors.lightFallback.primary);
      expect(
        tester.getSize(find.byType(Badge)),
        const Size.square(badgeDotSize),
      );
    });

    test('asserts against leading/trailing content', () {
      expect(
        () => Badge(
          showAsDot: true,
          leading: const SizedBox.shrink(),
          child: const SizedBox.shrink(),
        ),
        throwsAssertionError,
      );
    });
  });

  group('theme precedence', () {
    testWidgets('app leg overrides the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            BadgeTheme(
              primary: BadgeStyle(
                background: StateValue(rest: ThemedColor.value(_green)),
              ),
            ),
          ],
          child: Badge(onPressed: () {}, child: const Text('App leg')),
        ),
      );
      expect(_decoration(tester, const <WidgetState>{}).color, _green);
    });

    testWidgets('scoped leg overrides the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            BadgeTheme(
              primary: BadgeStyle(
                background: StateValue(rest: ThemedColor.value(_green)),
              ),
            ),
          ],
          scopedTheme: const BadgeTheme(
            primary: BadgeStyle(
              background: StateValue(rest: ThemedColor.value(_blue)),
            ),
          ),
          child: Badge(onPressed: () {}, child: const Text('Scoped leg')),
        ),
      );
      expect(_decoration(tester, const <WidgetState>{}).color, _blue);
    });

    testWidgets('widget leg overrides the scoped leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          scopedTheme: const BadgeTheme(
            primary: BadgeStyle(
              background: StateValue(rest: ThemedColor.value(_green)),
            ),
          ),
          child: Badge(
            onPressed: () {},
            theme: const BadgeStyle(
              background: StateValue(rest: ThemedColor.value(_blue)),
            ),
            child: const Text('Widget leg'),
          ),
        ),
      );
      expect(_decoration(tester, const <WidgetState>{}).color, _blue);
    });

    testWidgets(
      'regression: an override setting only one state keeps the other defaults',
      (tester) async {
        // The old `Styleable<BadgeTheme>` theme replaced whole properties, so
        // an override that only restated `hovered` lost the default `rest`
        // colour and the badge rendered transparent at rest.
        await tester.pumpWidget(
          _frame(
            scopedTheme: const BadgeTheme(
              primary: BadgeStyle(
                background: StateValue(hovered: ThemedColor.value(_green)),
              ),
            ),
            child: Badge(onPressed: () {}, child: const Text('Partial')),
          ),
        );
        final ShadcnColors colors = ShadcnColors.lightFallback;
        expect(
          _decoration(tester, const <WidgetState>{}).color,
          colors.primary,
        );
        expect(
          _decoration(tester, const <WidgetState>{WidgetState.hovered}).color,
          _green,
        );
      },
    );

    testWidgets('a variant the theme leaves unset falls back to defaults', (
      tester,
    ) async {
      final ShadcnColors colors = ShadcnColors.lightFallback;
      await tester.pumpWidget(
        _frame(
          scopedTheme: const BadgeTheme(
            primary: BadgeStyle(
              background: StateValue(rest: ThemedColor.value(_green)),
            ),
          ),
          child: Badge(
            variant: BadgeVariant.secondary,
            onPressed: () {},
            child: const Text('Untouched variant'),
          ),
        ),
      );
      expect(
        _decoration(tester, const <WidgetState>{}).color,
        colors.secondary,
      );
    });

    testWidgets('static badges resolve the same theme legs', (tester) async {
      await tester.pumpWidget(
        _frame(
          scopedTheme: const BadgeTheme(
            primary: BadgeStyle(
              background: StateValue(rest: ThemedColor.value(_green)),
            ),
          ),
          child: const Badge(child: Text('Static themed')),
        ),
      );
      expect(_staticDecoration(tester).color, _green);
    });
  });

  group('tokens', () {
    testWidgets('dark palette drives the same slots', (tester) async {
      const ShadcnColors dark = ShadcnColors.darkFallback;
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: dark),
          child: Badge(onPressed: () {}, child: const Text('Dark')),
        ),
      );
      expect(_decoration(tester, const <WidgetState>{}).color, dark.primary);
      expect(
        _textStyle(tester, const <WidgetState>{}).color,
        dark.primaryForeground,
      );
    });

    testWidgets('padding comes from the style row', (tester) async {
      await tester.pumpWidget(
        _frame(child: const Badge(child: Text('Padded'))),
      );
      final Padding padding = tester.widget<Padding>(
        find.descendant(of: find.byType(Badge), matching: find.byType(Padding)),
      );
      // `badgeDefaultPadding` is density multipliers; the built badge holds
      // the shadcn value (px-2 py-0.5) resolved at the default density.
      expect(
        padding.padding,
        resolveEdgeInsets(
          badgeDefaultPadding,
          Density.defaultDensity.baseContentPadding,
        ),
      );
    });

    testWidgets('alpha multiplies the token alpha', (tester) async {
      const ShadcnColors dark = ShadcnColors.darkFallback;
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: dark),
          child: Badge(
            variant: BadgeVariant.outline,
            theme: const BadgeStyle(
              borderColor: StateValue(
                rest: ThemedColor.ref(ColorRef.border, alpha: 0.5),
              ),
            ),
            onPressed: () {},
            child: const Text('Alpha'),
          ),
        ),
      );
      final Border border =
          _decoration(tester, const <WidgetState>{}).border! as Border;
      expect(border.top.color.a, closeTo(dark.border.a * 0.5, 0.001));
    });
  });
}
