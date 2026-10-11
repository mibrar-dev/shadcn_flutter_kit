// P6-P2 polish tests: single-token bar charts, stat suffixes and the login
// label alignment. P6-Z1 adds the trailing-link contract: link/text buttons
// carry zero horizontal padding (plain shadcn anchors), every forgot-type row
// meets the field's right edge, and calendar steppers are icon buttons.
// Uses the shared block harness (bounded stages, no overflow, both presets ×
// both brightnesses for the render contract are covered by blocks_render_test;
// here one neutral-light probe suffices for colour/content facts).

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/blocks/calendar-01/calendar_01.dart';
import 'package:flutter_shadcn_kit/registry/blocks/calendar-02/calendar_02.dart';
import 'package:flutter_shadcn_kit/registry/blocks/dashboard-01/dashboard_01.dart';
import 'package:flutter_shadcn_kit/registry/blocks/dashboard-02/dashboard_02.dart';
import 'package:flutter_shadcn_kit/registry/blocks/login-01/login_01.dart';
import 'package:flutter_shadcn_kit/registry/blocks/login-02/login_02.dart';
import 'package:flutter_shadcn_kit/registry/blocks/login-03/login_03.dart';
import 'package:flutter_shadcn_kit/registry/blocks/otp-01/otp_01.dart';
import 'package:flutter_shadcn_kit/registry/blocks/signup-02/signup_02.dart';
import 'package:flutter_shadcn_kit/registry/components/button/button.dart';
import 'package:flutter_shadcn_kit/registry/components/input/input.dart';
import 'package:flutter_shadcn_kit/registry/foundation/icons/lucide_icons.dart';
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

/// The link [Button] wrapping [label]: enabled, link variant, zero padding.
Button linkButton(WidgetTester tester, String label) {
  final Finder finder = find.widgetWithText(Button, label);
  expect(finder, findsOneWidget, reason: 'link button "$label" renders');
  final Button button = tester.widget<Button>(finder);
  expect(button.variant, ButtonVariant.link, reason: '"$label" is a link');
  expect(button.onPressed, isNotNull, reason: '"$label" is enabled');
  return button;
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

    testWidgets('login-03 forgot link aligns to the field right edge', (
      WidgetTester tester,
    ) async {
      final theme = blockTheme('neutral', Brightness.light);
      await pumpBlock(tester, const Login03(), theme, 375);
      final Rect forgot = tester.getRect(find.text('Forgot your password?'));
      final Rect field = tester.getRect(find.byType(Input).at(1));
      expect(
        (forgot.right - field.right).abs(),
        lessThan(1.5),
        reason: 'forgot $forgot vs field $field',
      );
    });
  });

  group('P6-Z1 trailing links and steppers', () {
    test('link and text variants carry zero horizontal padding', () {
      // shadcn links are plain ml-auto anchors: no horizontal padding, so an
      // end-aligned link's text meets the field's right edge.
      expect(
        buttonDefaults.forVariant(ButtonVariant.link)!.padding,
        EdgeInsets.zero,
      );
      expect(
        buttonDefaults.forVariant(ButtonVariant.text)!.padding,
        EdgeInsets.zero,
      );
    });

    testWidgets('login-01 forgot is an enabled link meeting the field', (
      WidgetTester tester,
    ) async {
      final theme = blockTheme('neutral', Brightness.light);
      for (final double width in <double>[375, 1440]) {
        await pumpBlock(tester, const Login01(), theme, width);
        linkButton(tester, 'Forgot password?');
        final Rect forgot = tester.getRect(find.text('Forgot password?'));
        final Rect field = tester.getRect(find.byType(Input).at(1));
        expect(
          (forgot.right - field.right).abs(),
          lessThan(1.5),
          reason: 'forgot $forgot vs field $field at ${width}px',
        );
      }
    });

    testWidgets('login-03 forgot is an enabled link meeting the field', (
      WidgetTester tester,
    ) async {
      final theme = blockTheme('neutral', Brightness.light);
      for (final double width in <double>[375, 1440]) {
        await pumpBlock(tester, const Login03(), theme, width);
        linkButton(tester, 'Forgot your password?');
        final Rect forgot = tester.getRect(find.text('Forgot your password?'));
        final Rect field = tester.getRect(find.byType(Input).at(1));
        expect(
          (forgot.right - field.right).abs(),
          lessThan(1.5),
          reason: 'forgot $forgot vs field $field at ${width}px',
        );
      }
    });

    testWidgets('login-02 carries no forgot row (checked, no change)', (
      WidgetTester tester,
    ) async {
      final theme = blockTheme('neutral', Brightness.light);
      await pumpBlock(tester, const Login02(), theme, 375);
      expect(find.textContaining('Forgot'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('auth footers are enabled link buttons', (
      WidgetTester tester,
    ) async {
      final theme = blockTheme('neutral', Brightness.light);
      await pumpBlock(tester, const Login03(), theme, 375);
      linkButton(tester, 'Sign up');
      await pumpBlock(tester, const Signup02(), theme, 375);
      linkButton(tester, 'Sign in');
      await pumpBlock(tester, const Otp01(), theme, 375);
      linkButton(tester, 'Use a different email');
    });

    testWidgets('otp-01 trailing countdown meets the action edge', (
      WidgetTester tester,
    ) async {
      final theme = blockTheme('neutral', Brightness.light);
      await pumpBlock(tester, const Otp01(), theme, 375);
      // The countdown (or the Resend link once it appears) rides at the end
      // of its row: its right edge meets the full-width Verify action.
      // (P7-B1: the block runs a real 30s countdown, not the old static 47.)
      final Rect trailing = tester.getRect(find.text('Resend in 30s'));
      final Rect action = tester.getRect(find.widgetWithText(Button, 'Verify'));
      expect(
        (trailing.right - action.right).abs(),
        lessThan(1.5),
        reason: 'trailing $trailing vs action $action',
      );
    });

    testWidgets('calendar-01 steppers are ghost icon buttons', (
      WidgetTester tester,
    ) async {
      final theme = blockTheme('neutral', Brightness.light);
      await pumpBlock(tester, const Calendar01(), theme, 1440);
      expect(find.byIcon(LucideIcons.chevronLeft), findsOneWidget);
      expect(find.byIcon(LucideIcons.chevronRight), findsOneWidget);
      expect(find.text('<'), findsNothing, reason: 'no raw glyph steppers');
      expect(find.text('>'), findsNothing, reason: 'no raw glyph steppers');
      for (final IconData icon in <IconData>[
        LucideIcons.chevronLeft,
        LucideIcons.chevronRight,
      ]) {
        final Finder button = find.ancestor(
          of: find.byIcon(icon),
          matching: find.byType(Button),
        );
        expect(button, findsOneWidget, reason: 'stepper $icon has a button');
        final Button step = tester.widget<Button>(button);
        expect(step.variant, ButtonVariant.ghost);
        expect(step.size, ButtonSize.icon);
        expect(step.onPressed, isNotNull, reason: 'stepper stays enabled');
      }
    });

    testWidgets('calendar-02 steppers are ghost icon buttons', (
      WidgetTester tester,
    ) async {
      final theme = blockTheme('neutral', Brightness.light);
      await pumpBlock(tester, const Calendar02(), theme, 1440);
      expect(find.byIcon(LucideIcons.chevronLeft), findsOneWidget);
      expect(find.byIcon(LucideIcons.chevronRight), findsOneWidget);
      expect(find.text('<'), findsNothing, reason: 'no raw glyph steppers');
      expect(find.text('>'), findsNothing, reason: 'no raw glyph steppers');
      for (final IconData icon in <IconData>[
        LucideIcons.chevronLeft,
        LucideIcons.chevronRight,
      ]) {
        final Finder button = find.ancestor(
          of: find.byIcon(icon),
          matching: find.byType(Button),
        );
        expect(button, findsOneWidget, reason: 'stepper $icon has a button');
        final Button step = tester.widget<Button>(button);
        expect(step.variant, ButtonVariant.ghost);
        expect(step.size, ButtonSize.icon);
        expect(step.onPressed, isNotNull, reason: 'stepper stays enabled');
      }
    });
  });
}
