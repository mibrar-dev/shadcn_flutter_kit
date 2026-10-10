// P6-P2 polish tests: single-token bar charts, stat suffixes and the login
// label alignment. Uses the shared block harness (bounded stages, no
// overflow, both presets × both brightnesses for the render contract are
// covered by blocks_render_test; here one neutral-light probe suffices for
// colour/content facts).

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/blocks/dashboard-01/dashboard_01.dart';
import 'package:flutter_shadcn_kit/registry/blocks/dashboard-02/dashboard_02.dart';
import 'package:flutter_shadcn_kit/registry/blocks/login-01/login_01.dart';
import 'package:flutter_shadcn_kit/registry/components/input/input.dart';
import 'package:flutter_test/flutter_test.dart';

import 'blocks_support.dart';

/// Colours of the tall (>50 px) decorated containers painted in a chart
/// token: the bar-chart bars. Progress rows (8 px) and legend dots (10 px)
/// are excluded by height; non-chart fills (avatar, table) by token.
List<Color> barColors(WidgetTester tester, Set<Color> chartTokens) {
  final List<Color> colors = <Color>[];
  for (final Element element in find.byType(Container).evaluate()) {
    final Container container = element.widget as Container;
    final Decoration? decoration = container.decoration;
    if (decoration is! BoxDecoration) {
      continue;
    }
    final Color? color = decoration.color;
    if (color == null || !chartTokens.contains(color)) {
      continue;
    }
    final RenderBox box = element.renderObject! as RenderBox;
    if (box.size.height > 50) {
      colors.add(color);
    }
  }
  return colors;
}

void main() {
  group('P6-P2 block polish', () {
    testWidgets('dashboard-01 bars use a single chart1 token', (
      WidgetTester tester,
    ) async {
      final theme = blockTheme('neutral', Brightness.light);
      await pumpBlock(tester, const Dashboard01(), theme, 1440);
      final List<Color> colors = barColors(
        tester,
        theme.colors.chartColors.toSet(),
      );
      expect(colors, isNotEmpty, reason: 'chart bars render');
      expect(colors.toSet(), <Color>{
        theme.colors.chart1,
      }, reason: 'one series, one token (no rainbow)');
    });

    testWidgets('dashboard-02 bars use a single chart1 token', (
      WidgetTester tester,
    ) async {
      final theme = blockTheme('neutral', Brightness.light);
      await pumpBlock(tester, const Dashboard02(), theme, 1440);
      final List<Color> colors = barColors(
        tester,
        theme.colors.chartColors.toSet(),
      );
      expect(colors, isNotEmpty, reason: 'chart bars render');
      expect(colors.toSet(), <Color>{
        theme.colors.chart1,
      }, reason: 'one series, one token (no rainbow)');
    });

    testWidgets('dashboard-01 stats carry the muted suffix', (
      WidgetTester tester,
    ) async {
      final theme = blockTheme('neutral', Brightness.light);
      await pumpBlock(tester, const Dashboard01(), theme, 1440);
      expect(find.textContaining('from last month'), findsNWidgets(4));
      expect(find.textContaining('+20.1% from last month'), findsOneWidget);
    });

    testWidgets('login-01 forgot link aligns to the field right edge', (
      WidgetTester tester,
    ) async {
      final theme = blockTheme('neutral', Brightness.light);
      await pumpBlock(tester, const Login01(), theme, 375);
      final Rect forgot = tester.getRect(find.text('Forgot password?'));
      final Rect field = tester.getRect(find.byType(Input).at(1));
      expect(
        (forgot.right - field.right).abs(),
        lessThan(1.5),
        reason: 'forgot $forgot vs field $field',
      );
    });
  });
}
