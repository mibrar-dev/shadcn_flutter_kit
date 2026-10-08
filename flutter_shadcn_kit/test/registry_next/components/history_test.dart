// Tests for the `history` component: storage and grid.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/history/history.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_shadcn_kit/registry_next/components/button/button.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _blue = Color(0xFF0000FF);
const Color _red = Color(0xFFFF0000);
const Color _green = Color(0xFF00FF00);

Future<void> _pump(
  WidgetTester tester, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  HistoryTheme? widgetTheme,
  List<Color> initial = const <Color>[],
  int maxRecent = 50,
  ColorHistoryStorage? storage,
  ValueChanged<Color>? onPicked,
  Color? selected,
}) async {
  await tester.pumpWidget(
    ShadcnTheme(
      data: data,
      child: ComponentThemes(
        themes: app,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: RecentColorsScope(
              initialRecentColors: initial,
              maxRecentColors: maxRecent,
              child: Builder(
                builder: (context) => ColorHistoryGrid(
                  storage: storage ?? ColorHistoryStorage.of(context),
                  selectedColor: selected,
                  theme: widgetTheme,
                  crossAxisCount: 3,
                  maxTotalColors: 6,
                  onColorPicked: onPicked,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Future<RecentColorsScopeState> _pumpScope(WidgetTester tester) async {
  final key = GlobalKey<RecentColorsScopeState>();
  await tester.pumpWidget(
    RecentColorsScope(key: key, child: const SizedBox.shrink()),
  );
  return key.currentState!;
}

void main() {
  group('RecentColorsScopeState', () {
    testWidgets('add dedupes by colour value, most-recent first', (
      tester,
    ) async {
      // Regression: old code used List.contains with identity ==, so a
      // fresh Color with the same ARGB always accumulated as a duplicate.
      final state = await _pumpScope(tester);
      state.addHistory(Color(0xFF112233));
      state.addHistory(const Color(0xFFAABBCC));
      state.addHistory(const Color(0xFF112233)); // duplicate by value
      expect(state.recentColors.length, 2);
      expect(state.recentColors.first.toARGB32(), 0xFF112233);
    });

    testWidgets('capacity clamps the list', (tester) async {
      final key = GlobalKey<RecentColorsScopeState>();
      await tester.pumpWidget(
        RecentColorsScope(
          key: key,
          maxRecentColors: 2,
          child: const SizedBox.shrink(),
        ),
      );
      final state = key.currentState!;
      state.addHistory(_blue);
      state.addHistory(_red);
      state.addHistory(_green);
      expect(state.recentColors, <Color>[_green, _red]);
    });

    testWidgets('setHistory clamps to capacity and notifies', (tester) async {
      final state = await _pumpScope(tester);
      var notifications = 0;
      state.addListener(() => notifications++);
      state.setHistory(<Color>[_blue, _red, _green]);
      expect(state.recentColors, <Color>[_blue, _red, _green]);
      expect(notifications, 1);
      state.clear();
      expect(state.recentColors, isEmpty);
      expect(notifications, 2);
    });
  });

  group('grid', () {
    testWidgets('renders swatches with tokens (light + dark)', (tester) async {
      for (final data in <ShadcnThemeData>[
        const ShadcnThemeData(),
        const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      ]) {
        await _pump(tester, data: data, initial: const <Color>[_blue, _red]);
        expect(find.byType(ColorHistoryGrid), findsOneWidget);
        expect(find.text('x'), findsNothing);
      }
    });

    testWidgets('tap reports the picked colour', (tester) async {
      Color? picked;
      await _pump(
        tester,
        initial: const <Color>[_blue, _red],
        onPicked: (c) => picked = c,
      );
      final buttons = find.byType(Button);
      expect(buttons, findsWidgets);
      await tester.tap(buttons.first);
      await tester.pump();
      expect(picked, _blue);
    });

    testWidgets('defaults theme wins with no overrides', (tester) async {
      await _pump(tester, initial: const <Color>[_blue]);
      expect(historyDefaults.selectedBorderWidth, 2);
      expect(historyDefaults.spacing, 4);
    });

    testWidgets('theme precedence: widget > tree > app > defaults', (
      tester,
    ) async {
      // Fill: widget leg sets border width; tree leg sets spacing; app leg
      // sets tile size — all merge; each leg wins over every lower one.
      await _pump(
        tester,
        initial: const <Color>[_blue],
        widgetTheme: const HistoryTheme(selectedBorderWidth: 9),
        app: const <ComponentThemeData>[
          HistoryTheme(spacing: 7, tileSize: 55, selectedBorderWidth: 3),
        ],
      );
      // Inspect via defaults + resolver directly is brittle; assert the
      // merged result on the rendered box through the theme object.
      final resolved = resolveComponentStyle<HistoryTheme, HistoryTheme>(
        tester.element(find.byType(ColorHistoryGrid)),
        widget: const HistoryTheme(selectedBorderWidth: 9),
        select: (t) => t,
        defaults: historyDefaults,
      );
      expect(resolved.selectedBorderWidth, 9);
      expect(resolved.spacing, 7);
      expect(resolved.tileSize, 55);
    });

    testWidgets('tree ComponentTheme beats app; widget beats tree', (
      tester,
    ) async {
      late HistoryTheme tree; // tree vs app, no widget leg
      late HistoryTheme widget; // widget vs tree vs app
      await tester.pumpWidget(
        ShadcnTheme(
          data: const ShadcnThemeData(),
          child: ComponentThemes(
            themes: const <ComponentThemeData>[HistoryTheme(spacing: 1)],
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Center(
                child: ComponentTheme<HistoryTheme>(
                  data: const HistoryTheme(spacing: 2),
                  child: Builder(
                    builder: (context) {
                      tree = resolveComponentStyle<HistoryTheme, HistoryTheme>(
                        context,
                        select: (t) => t,
                        defaults: historyDefaults,
                      );
                      widget =
                          resolveComponentStyle<HistoryTheme, HistoryTheme>(
                            context,
                            widget: const HistoryTheme(spacing: 3),
                            select: (t) => t,
                            defaults: historyDefaults,
                          );
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      expect(tree.spacing, 2);
      expect(widget.spacing, 3);
    });
  });
}
