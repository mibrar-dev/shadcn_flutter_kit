// P7-B1 form + layout contract (settings + pricing blocks): validated
// submits call `onSubmit` once with typed data after loading, then show a
// success alert; invalid submits show inline messages and never call
// `onSubmit`. Layout: no block is wider than its documented max-width, at
// desktop width in both presets (overflow at 375/768/1440 is covered by
// `blocks_render_test.dart`).

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/blocks/account-01/account_01.dart';
import 'package:flutter_shadcn_kit/registry/blocks/account-01/account_01_profile.dart';
import 'package:flutter_shadcn_kit/registry/blocks/account-02/account_02.dart';
import 'package:flutter_shadcn_kit/registry/blocks/dashboard-01/dashboard_01.dart';
import 'package:flutter_shadcn_kit/registry/blocks/login-01/login_01.dart';
import 'package:flutter_shadcn_kit/registry/blocks/login-03/login_03.dart';
import 'package:flutter_shadcn_kit/registry/blocks/otp-01/otp_01.dart';
import 'package:flutter_shadcn_kit/registry/blocks/pricing-01/pricing_01.dart';
import 'package:flutter_shadcn_kit/registry/blocks/pricing-01/pricing_01_promo.dart';
import 'package:flutter_shadcn_kit/registry/blocks/signup-01/signup_01.dart';
import 'package:flutter_shadcn_kit/registry/blocks/signup-02/signup_02.dart';
import 'package:flutter_shadcn_kit/registry/components/button/button.dart';
import 'package:flutter_shadcn_kit/registry/components/card/card.dart';
import 'package:flutter_shadcn_kit/registry/components/spinner/spinner.dart';
import 'package:flutter_shadcn_kit/registry/components/switch/switch.dart';
import 'package:flutter_shadcn_kit/registry/components/table/table.dart';
import 'package:flutter_test/flutter_test.dart';

import 'blocks_support.dart';

/// Pumps [block] at a real 1440×900 test surface under [preset] (light),
/// so desktop branches (≥960/1080) are really taken. (`pumpBlock` alone
/// clamps to the default 800×600 surface.)
Future<void> pumpForm(
  WidgetTester tester,
  Widget block, {
  String preset = 'neutral',
}) {
  tester.view.physicalSize = const Size(1440, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  return pumpBlock(tester, block, blockTheme(preset, Brightness.light), 1440);
}

/// Scrolls the button labelled [label] into view, taps it and settles
/// validation frames.
Future<void> tapSubmit(WidgetTester tester, String label) async {
  final Finder button = find.widgetWithText(Button, label);
  await tester.ensureVisible(button);
  await tester.pump();
  await tester.pump();
  await tester.tap(button);
  await tester.pump();
  await tester.pump();
}

/// Completes the simulated async submit (600 ms) and rebuilds.
Future<void> finishSubmit(WidgetTester tester) async {
  expect(find.byType(Spinner), findsOneWidget, reason: 'loading spinner');
  await tester.pump(const Duration(milliseconds: 600));
  await tester.pump();
}

/// Settles live (`changed`-mode) validation after entering values.
Future<void> settleValidation(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

void main() {
  group('P7-B1 settings + pricing forms', () {
    testWidgets('account-01 profile invalid shows messages, no onSubmit', (
      WidgetTester tester,
    ) async {
      var called = false;
      await pumpForm(
        tester,
        Account01(
          onSubmitProfile: (_) async {
            called = true;
          },
        ),
      );
      await tapSubmit(tester, 'Save changes');
      expect(
        find.text('This field cannot be empty.'),
        findsNWidgets(2),
        reason: 'name + username errors',
      );
      expect(called, isFalse);
      expect(tester.takeException(), isNull);
    });

    testWidgets('account-01 profile valid submits once, then success', (
      WidgetTester tester,
    ) async {
      final List<Account01ProfileData> got = <Account01ProfileData>[];
      await pumpForm(
        tester,
        Account01(
          onSubmitProfile: (Account01ProfileData data) async {
            got.add(data);
          },
        ),
      );
      await tester.enterText(find.byType(EditableText).at(0), 'Ada Lovelace');
      await tester.enterText(find.byType(EditableText).at(1), 'ada_lovelace');
      await tester.enterText(
        find.byType(EditableText).at(2),
        'Counting my blessings.',
      );
      await settleValidation(tester);
      await tapSubmit(tester, 'Save changes');
      await finishSubmit(tester);
      expect(got, hasLength(1));
      expect(got.single.name, 'Ada Lovelace');
      expect(got.single.username, 'ada_lovelace');
      expect(got.single.bio, 'Counting my blessings.');
      expect(find.text('Profile saved.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('account-01 username pattern is enforced', (
      WidgetTester tester,
    ) async {
      await pumpForm(tester, const Account01());
      await tester.enterText(find.byType(EditableText).at(1), 'Ada Lovelace!');
      await settleValidation(tester);
      expect(find.text('Invalid value provided.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('account-01 password mismatch blocks submit', (
      WidgetTester tester,
    ) async {
      var called = false;
      await pumpForm(
        tester,
        Account01(
          onSubmitPassword: (_) async {
            called = true;
          },
        ),
      );
      await tester.tap(find.text('Password'));
      await settleValidation(tester);
      await tester.enterText(find.byType(EditableText).at(0), 'oldpassword');
      await tester.enterText(find.byType(EditableText).at(1), 'newpassword1');
      await tester.enterText(find.byType(EditableText).at(2), 'different');
      await settleValidation(tester);
      await tapSubmit(tester, 'Update password');
      expect(find.text('Passwords do not match.'), findsOneWidget);
      expect(called, isFalse);
      await tester.enterText(find.byType(EditableText).at(2), 'newpassword1');
      await settleValidation(tester);
      expect(find.text('Passwords do not match.'), findsNothing);
      await tapSubmit(tester, 'Update password');
      await finishSubmit(tester);
      expect(called, isTrue);
      expect(find.text('Password updated.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('account-02 save submits defaults once, then success', (
      WidgetTester tester,
    ) async {
      final List<Account02Data> got = <Account02Data>[];
      await pumpForm(
        tester,
        Account02(
          onSubmit: (Account02Data data) async {
            got.add(data);
          },
        ),
      );
      await tapSubmit(tester, 'Save preferences');
      await finishSubmit(tester);
      expect(got, hasLength(1));
      expect(got.single.email['Marketing'], isFalse);
      expect(got.single.email['Everything'], isTrue);
      expect(got.single.quietHours, isTrue);
      expect(got.single.weeklyDigest, isTrue);
      expect(find.text('Preferences saved.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('account-02 toggle then save carries the new value', (
      WidgetTester tester,
    ) async {
      final List<Account02Data> got = <Account02Data>[];
      await pumpForm(
        tester,
        Account02(
          onSubmit: (Account02Data data) async {
            got.add(data);
          },
        ),
      );
      // The Marketing email row is the fourth switch on the page.
      final Finder marketing = find.byType(Switch).at(3);
      await tester.ensureVisible(marketing);
      await tester.pump();
      await tester.pump();
      await tester.tap(marketing);
      await settleValidation(tester);
      await tapSubmit(tester, 'Save preferences');
      await finishSubmit(tester);
      expect(got, hasLength(1));
      expect(got.single.email['Marketing'], isTrue);
      // Reset restores the defaults; saving again reports Marketing off.
      await tester.tap(find.widgetWithText(Button, 'Reset'));
      await settleValidation(tester);
      await tapSubmit(tester, 'Save preferences');
      await finishSubmit(tester);
      expect(got, hasLength(2));
      expect(got[1].email['Marketing'], isFalse);
      expect(tester.takeException(), isNull);
    });

    testWidgets('pricing promo empty submit shows a message, no callback', (
      WidgetTester tester,
    ) async {
      var called = false;
      await pumpForm(
        tester,
        Pricing01(
          onApplyPromo: (_) async {
            called = true;
          },
        ),
      );
      await tapSubmit(tester, 'Apply code');
      expect(find.text('This field cannot be empty.'), findsOneWidget);
      expect(called, isFalse);
      expect(tester.takeException(), isNull);
    });

    testWidgets('pricing promo valid code applies once, then success', (
      WidgetTester tester,
    ) async {
      final List<Pricing01PromoData> got = <Pricing01PromoData>[];
      await pumpForm(
        tester,
        Pricing01(
          onApplyPromo: (Pricing01PromoData data) async {
            got.add(data);
          },
        ),
      );
      await tester.enterText(find.byType(EditableText), 'SAVE20');
      await settleValidation(tester);
      await tapSubmit(tester, 'Apply code');
      await finishSubmit(tester);
      expect(got, hasLength(1));
      expect(got.single.code, 'SAVE20');
      expect(
        find.text('Code applied — your discount shows at checkout.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('dashboard filter narrows the transactions table', (
      WidgetTester tester,
    ) async {
      await pumpForm(tester, const Dashboard01());
      Finder inTable(String text) => find.descendant(
        of: find.byType(ShadcnTable),
        matching: find.text(text),
      );
      expect(inTable('Isabella Nguyen'), findsOneWidget);
      await tester.enterText(find.byType(EditableText), 'olivia');
      await settleValidation(tester);
      expect(inTable('Olivia Martin'), findsOneWidget);
      expect(inTable('Isabella Nguyen'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  group('P7-B1 block max-widths', () {
    testWidgets('auth cards respect max-w-sm (384)', (
      WidgetTester tester,
    ) async {
      for (final Widget block in const <Widget>[
        Login01(),
        Login03(),
        Signup01(),
        Otp01(),
      ]) {
        await pumpForm(tester, block);
        final double width = tester.getSize(find.byType(Card)).width;
        expect(
          width,
          lessThanOrEqualTo(384.5),
          reason: '${block.runtimeType} card width $width',
        );
      }
      await tester.pumpWidget(Container());
      expect(tester.takeException(), isNull);
    });

    testWidgets('settings shells respect max-w-3xl (768)', (
      WidgetTester tester,
    ) async {
      for (final Widget block in const <Widget>[Account01(), Account02()]) {
        await pumpForm(tester, block);
        final Finder shell = find.byWidgetPredicate(
          (Widget widget) =>
              widget is ConstrainedBox && widget.constraints.maxWidth == 768,
        );
        expect(shell, findsOneWidget, reason: '${block.runtimeType} shell');
        // The box itself fills the parent; the cap applies to the content.
        final Iterable<Element> cards = find
            .descendant(of: shell, matching: find.byType(Card))
            .evaluate();
        expect(cards, isNotEmpty, reason: '${block.runtimeType} cards');
        for (final Element card in cards) {
          final double width = (card.renderObject! as RenderBox).size.width;
          expect(
            width,
            lessThanOrEqualTo(768.5),
            reason: '${block.runtimeType} card width $width',
          );
        }
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('signup-02 shell respects its 1024 cap', (
      WidgetTester tester,
    ) async {
      await pumpForm(tester, const Signup02());
      final Finder shell = find.byWidgetPredicate(
        (Widget widget) =>
            widget is ConstrainedBox && widget.constraints.maxWidth == 1024,
      );
      expect(shell, findsOneWidget);
      expect(tester.getSize(shell).width, lessThanOrEqualTo(1024.5));
      expect(tester.takeException(), isNull);
    });
  });
}
