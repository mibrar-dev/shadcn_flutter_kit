// P6-P3 §1: every demo control in every block is interactive.
//
// Pumps all 16 blocks and asserts no Button/Checkbox/Switch/Tabs is disabled,
// unless whitelisted with a reason (calendar-02 taken slots). Also asserts
// every enabled primary Button fills with the theme `primary` token (the
// login-01 "Sign in" grey-disabled regression).

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/blocks/account-01/account_01.dart';
import 'package:flutter_shadcn_kit/registry/blocks/account-02/account_02.dart';
import 'package:flutter_shadcn_kit/registry/blocks/calendar-01/calendar_01.dart';
import 'package:flutter_shadcn_kit/registry/blocks/calendar-02/calendar_02.dart';
import 'package:flutter_shadcn_kit/registry/blocks/dashboard-01/dashboard_01.dart';
import 'package:flutter_shadcn_kit/registry/blocks/dashboard-02/dashboard_02.dart';
import 'package:flutter_shadcn_kit/registry/blocks/login-01/login_01.dart';
import 'package:flutter_shadcn_kit/registry/blocks/login-02/login_02.dart';
import 'package:flutter_shadcn_kit/registry/blocks/login-03/login_03.dart';
import 'package:flutter_shadcn_kit/registry/blocks/otp-01/otp_01.dart';
import 'package:flutter_shadcn_kit/registry/blocks/pricing-01/pricing_01.dart';
import 'package:flutter_shadcn_kit/registry/blocks/sidebar-01/sidebar_01.dart';
import 'package:flutter_shadcn_kit/registry/blocks/sidebar-02/sidebar_02.dart';
import 'package:flutter_shadcn_kit/registry/blocks/sidebar-03/sidebar_03.dart';
import 'package:flutter_shadcn_kit/registry/blocks/signup-01/signup_01.dart';
import 'package:flutter_shadcn_kit/registry/blocks/signup-02/signup_02.dart';
import 'package:flutter_shadcn_kit/registry/components/button/button.dart';
import 'package:flutter_shadcn_kit/registry/components/checkbox/checkbox.dart';
import 'package:flutter_shadcn_kit/registry/components/switch/switch.dart';
import 'package:flutter_shadcn_kit/registry/components/tabs/tabs.dart';
import 'package:flutter_test/flutter_test.dart';

import 'blocks_support.dart';

/// Whitelisted disabled controls: id → reason.
const Map<String, String> _disabledAllowlist = <String, String>{
  'calendar-02 taken slot': 'taken time slots are disabled by design',
};

/// All 16 blocks with their ids.
List<(String, Widget)> _blocks() => const <(String, Widget)>[
  ('account-01', Account01()),
  ('account-02', Account02()),
  ('calendar-01', Calendar01()),
  ('calendar-02', Calendar02()),
  ('dashboard-01', Dashboard01()),
  ('dashboard-02', Dashboard02()),
  ('login-01', Login01()),
  ('login-02', Login02()),
  ('login-03', Login03()),
  ('otp-01', Otp01()),
  ('pricing-01', Pricing01()),
  ('sidebar-01', Sidebar01()),
  ('sidebar-02', Sidebar02()),
  ('sidebar-03', Sidebar03()),
  ('signup-01', Signup01()),
  ('signup-02', Signup02()),
];

bool _buttonEnabled(Button button) =>
    button.enabled ?? (button.onPressed != null);

bool _checkboxEnabled(Checkbox checkbox) =>
    checkbox.enabled ??
    (checkbox.controller != null || checkbox.onChanged != null);

bool _switchEnabled(Switch value) =>
    value.enabled ?? (value.controller != null || value.onChanged != null);

/// Fill of an enabled primary button: the Clickable's animated container.
Color? _primaryFill(WidgetTester tester, Element buttonElement) {
  final Finder containers = find.descendant(
    of: find.byWidget(buttonElement.widget),
    matching: find.byType(AnimatedContainer),
  );
  for (final Element element in containers.evaluate()) {
    final AnimatedContainer container = element.widget as AnimatedContainer;
    final Decoration? decoration = container.decoration;
    if (decoration is BoxDecoration && decoration.color != null) {
      return decoration.color;
    }
  }
  return null;
}

void main() {
  group('P6-P3 block interactivity', () {
    for (final (String id, Widget block) in _blocks()) {
      testWidgets('$id has no disabled demo controls', (
        WidgetTester tester,
      ) async {
        final theme = blockTheme('neutral', Brightness.light);
        await pumpBlock(tester, block, theme, 1440);

        for (final Element element in find.byType(Button).evaluate()) {
          final Button button = element.widget as Button;
          if (_buttonEnabled(button)) {
            continue;
          }
          // Only calendar-02 taken slots may be disabled (explicit
          // enabled:false, still carrying an onPressed).
          final bool whitelisted =
              id == 'calendar-02' && button.enabled == false;
          expect(
            whitelisted,
            isTrue,
            reason:
                '$id has a disabled Button '
                '(${_disabledAllowlist.values.first}): $button',
          );
        }

        for (final Element element in find.byType(Checkbox).evaluate()) {
          final Checkbox checkbox = element.widget as Checkbox;
          expect(
            _checkboxEnabled(checkbox),
            isTrue,
            reason: '$id has a disabled Checkbox: $checkbox',
          );
        }

        for (final Element element in find.byType(Switch).evaluate()) {
          final Switch value = element.widget as Switch;
          expect(
            _switchEnabled(value),
            isTrue,
            reason: '$id has a disabled Switch: $value',
          );
        }

        for (final Element element in find.byType(Tabs).evaluate()) {
          final Tabs tabs = element.widget as Tabs;
          expect(
            tabs.onChanged,
            isNotNull,
            reason: '$id has a disabled Tabs strip (null onChanged)',
          );
        }
      });
    }

    testWidgets('primary buttons fill with the primary token', (
      WidgetTester tester,
    ) async {
      final theme = blockTheme('neutral', Brightness.light);
      int checked = 0;
      for (final (String id, Widget block) in _blocks()) {
        await pumpBlock(tester, block, theme, 1440);
        for (final Element element in find.byType(Button).evaluate()) {
          final Button button = element.widget as Button;
          if (button.variant != ButtonVariant.primary) {
            continue;
          }
          if (!_buttonEnabled(button)) {
            continue;
          }
          expect(
            _primaryFill(tester, element),
            theme.colors.primary,
            reason: '$id primary Button fill != primary token',
          );
          checked++;
        }
      }
      expect(checked, greaterThan(0), reason: 'primary Buttons render');
    });

    testWidgets('login-01 sign-in is enabled and primary-filled', (
      WidgetTester tester,
    ) async {
      final theme = blockTheme('neutral', Brightness.light);
      await pumpBlock(tester, const Login01(), theme, 1440);
      final Finder signIn = find.widgetWithText(Button, 'Sign in');
      expect(signIn, findsOneWidget);
      final Button button = tester.widget<Button>(signIn);
      expect(_buttonEnabled(button), isTrue);
      expect(button.variant, ButtonVariant.primary);
      final Element element = signIn.evaluate().single;
      expect(_primaryFill(tester, element), theme.colors.primary);
      // Remember-me is enabled (not greyed to 50%).
      final Checkbox remember = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(_checkboxEnabled(remember), isTrue);
      final double opacity = tester
          .widget<Opacity>(
            find.descendant(
              of: find.byType(Checkbox),
              matching: find.byType(Opacity),
            ),
          )
          .opacity;
      expect(opacity, 1);
    });
  });
}
