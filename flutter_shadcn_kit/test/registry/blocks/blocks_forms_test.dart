// P7-B1 form contract (auth blocks): every form validates through the
// kit's `ShadcnForm`, shows inline messages on an invalid submit without
// calling `onSubmit`, and on a valid submit calls `onSubmit` once with typed
// data after a loading state, then shows a success alert.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/blocks/login-01/login_01.dart';
import 'package:flutter_shadcn_kit/registry/blocks/login-02/login_02.dart';
import 'package:flutter_shadcn_kit/registry/blocks/login-03/login_03.dart';
import 'package:flutter_shadcn_kit/registry/blocks/otp-01/otp_01.dart';
import 'package:flutter_shadcn_kit/registry/blocks/signup-01/signup_01.dart';
import 'package:flutter_shadcn_kit/registry/blocks/signup-02/signup_02.dart';
import 'package:flutter_shadcn_kit/registry/components/button/button.dart';
import 'package:flutter_shadcn_kit/registry/components/checkbox/checkbox.dart';
import 'package:flutter_shadcn_kit/registry/components/spinner/spinner.dart';
import 'package:flutter_test/flutter_test.dart';

import 'blocks_support.dart';

/// Pumps [block] at desktop width under the neutral light preset.
Future<void> pumpForm(WidgetTester tester, Widget block) {
  return pumpBlock(tester, block, blockTheme('neutral', Brightness.light), 768);
}

/// Taps the submit button labelled [label] and settles the validation
/// frames (submit stores errors synchronously, entries surface them on the
/// controller notification a frame later).
Future<void> tapSubmit(WidgetTester tester, String label) async {
  await tester.tap(find.widgetWithText(Button, label));
  await tester.pump();
  await tester.pump();
}

/// Settles live (`changed`-mode) validation after entering values: the
/// controller notifies after the current frame, entries rebuild the next.
Future<void> settleValidation(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

/// Completes the simulated async submit (600 ms) and rebuilds.
Future<void> finishSubmit(WidgetTester tester) async {
  expect(find.byType(Spinner), findsOneWidget, reason: 'loading spinner');
  await tester.pump(const Duration(milliseconds: 600));
  await tester.pump();
}

void main() {
  group('P7-B1 auth forms', () {
    testWidgets('login-01 invalid submit shows messages, no onSubmit', (
      WidgetTester tester,
    ) async {
      var called = false;
      await pumpForm(
        tester,
        Login01(
          onSubmit: (_) async {
            called = true;
          },
        ),
      );
      await tapSubmit(tester, 'Sign in');
      expect(
        find.text('This field cannot be empty.'),
        findsNWidgets(2),
        reason: 'email + password errors',
      );
      expect(called, isFalse);
      expect(tester.takeException(), isNull);
    });

    testWidgets('login-01 valid submit calls onSubmit once, then success', (
      WidgetTester tester,
    ) async {
      final List<Login01Data> got = <Login01Data>[];
      await pumpForm(
        tester,
        Login01(
          onSubmit: (Login01Data data) async {
            got.add(data);
          },
        ),
      );
      await tester.enterText(
        find.byType(EditableText).at(0),
        'ada@example.com',
      );
      await tester.enterText(find.byType(EditableText).at(1), 'password123');
      await tester.pump();
      await tapSubmit(tester, 'Sign in');
      await finishSubmit(tester);
      expect(got, hasLength(1));
      expect(got.single.email, 'ada@example.com');
      expect(got.single.password, 'password123');
      expect(got.single.rememberMe, isTrue);
      expect(find.text('Signed in — welcome back.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('login-01 bad email shows the email message', (
      WidgetTester tester,
    ) async {
      await pumpForm(tester, const Login01());
      await tester.enterText(find.byType(EditableText).at(0), 'not-an-email');
      await settleValidation(tester);
      expect(find.text('Invalid email address.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('login-02 invalid submit shows messages, no onSubmit', (
      WidgetTester tester,
    ) async {
      var called = false;
      await pumpForm(
        tester,
        Login02(
          onSubmit: (_) async {
            called = true;
          },
        ),
      );
      await tapSubmit(tester, 'Sign in');
      expect(
        find.text('This field cannot be empty.'),
        findsNWidgets(2),
        reason: 'email + password errors',
      );
      expect(called, isFalse);
      expect(tester.takeException(), isNull);
    });

    testWidgets('login-02 valid submit calls onSubmit once, then success', (
      WidgetTester tester,
    ) async {
      final List<Login02Data> got = <Login02Data>[];
      await pumpForm(
        tester,
        Login02(
          onSubmit: (Login02Data data) async {
            got.add(data);
          },
        ),
      );
      await tester.enterText(
        find.byType(EditableText).at(0),
        'ada@example.com',
      );
      await tester.enterText(find.byType(EditableText).at(1), 'password123');
      await tester.pump();
      await tapSubmit(tester, 'Sign in');
      await finishSubmit(tester);
      expect(got, hasLength(1));
      expect(got.single.email, 'ada@example.com');
      expect(find.text('Signed in — welcome back.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('login-03 valid submit calls onSubmit once, then success', (
      WidgetTester tester,
    ) async {
      final List<Login03Data> got = <Login03Data>[];
      await pumpForm(
        tester,
        Login03(
          onSubmit: (Login03Data data) async {
            got.add(data);
          },
        ),
      );
      await tester.enterText(
        find.byType(EditableText).at(0),
        'ada@example.com',
      );
      await tester.enterText(find.byType(EditableText).at(1), 'password123');
      await tester.pump();
      await tapSubmit(tester, 'Sign in with email');
      await finishSubmit(tester);
      expect(got, hasLength(1));
      expect(got.single.email, 'ada@example.com');
      expect(find.text('Signed in — welcome back.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('login-03 empty submit shows messages, no onSubmit', (
      WidgetTester tester,
    ) async {
      var called = false;
      await pumpForm(
        tester,
        Login03(
          onSubmit: (_) async {
            called = true;
          },
        ),
      );
      await tapSubmit(tester, 'Sign in with email');
      expect(
        find.text('This field cannot be empty.'),
        findsNWidgets(2),
        reason: 'email + password errors',
      );
      expect(called, isFalse);
      expect(tester.takeException(), isNull);
    });

    testWidgets('otp-01 empty submit shows a message, no onSubmit', (
      WidgetTester tester,
    ) async {
      var called = false;
      await pumpForm(
        tester,
        Otp01(
          onSubmit: (_) async {
            called = true;
          },
        ),
      );
      await tapSubmit(tester, 'Verify');
      expect(find.text('This field cannot be empty.'), findsOneWidget);
      expect(called, isFalse);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(Container());
    });

    testWidgets('otp-01 valid code submits once, then success', (
      WidgetTester tester,
    ) async {
      final List<Otp01Data> got = <Otp01Data>[];
      await pumpForm(
        tester,
        Otp01(
          onSubmit: (Otp01Data data) async {
            got.add(data);
          },
        ),
      );
      // Completing all slots auto-submits the form.
      await tester.enterText(find.byType(EditableText), '123456');
      await settleValidation(tester);
      await finishSubmit(tester);
      expect(got, hasLength(1));
      expect(got.single.code, '123456');
      expect(find.text('Email verified — you are all set.'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(Container());
    });

    testWidgets('signup-01 empty submit requires terms too', (
      WidgetTester tester,
    ) async {
      var called = false;
      await pumpForm(
        tester,
        Signup01(
          onSubmit: (_) async {
            called = true;
          },
        ),
      );
      await tapSubmit(tester, 'Create account');
      expect(
        find.text('This field cannot be empty.'),
        findsNWidgets(3),
        reason: 'name + email + password errors',
      );
      expect(
        find.text('You must accept the terms to continue.'),
        findsOneWidget,
      );
      expect(called, isFalse);
      expect(tester.takeException(), isNull);
    });

    testWidgets('signup-01 valid submit calls onSubmit once, then success', (
      WidgetTester tester,
    ) async {
      final List<Signup01Data> got = <Signup01Data>[];
      await pumpForm(
        tester,
        Signup01(
          onSubmit: (Signup01Data data) async {
            got.add(data);
          },
        ),
      );
      await tester.enterText(find.byType(EditableText).at(0), 'Ada Lovelace');
      await tester.enterText(
        find.byType(EditableText).at(1),
        'ada@example.com',
      );
      await tester.enterText(find.byType(EditableText).at(2), 'password123');
      await tester.tap(find.byType(Checkbox));
      await settleValidation(tester);
      expect(
        find.text('You must accept the terms to continue.'),
        findsNothing,
        reason: 'terms error clears on check',
      );
      await tapSubmit(tester, 'Create account');
      await finishSubmit(tester);
      expect(got, hasLength(1));
      expect(got.single.name, 'Ada Lovelace');
      expect(got.single.email, 'ada@example.com');
      expect(
        find.text('Account created — check your inbox to verify it.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('signup-02 strength meter follows the password', (
      WidgetTester tester,
    ) async {
      await pumpForm(tester, const Signup02());
      expect(find.text('Enter a password'), findsOneWidget);
      await tester.enterText(find.byType(EditableText).at(3), 'Aa1!aaaa');
      await settleValidation(tester);
      expect(find.text('Strong'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('signup-02 valid submit calls onSubmit once, then success', (
      WidgetTester tester,
    ) async {
      final List<Signup02Data> got = <Signup02Data>[];
      await pumpForm(
        tester,
        Signup02(
          onSubmit: (Signup02Data data) async {
            got.add(data);
          },
        ),
      );
      await tester.enterText(find.byType(EditableText).at(0), 'Ada');
      await tester.enterText(find.byType(EditableText).at(1), 'Lovelace');
      await tester.enterText(
        find.byType(EditableText).at(2),
        'ada@example.com',
      );
      await tester.enterText(find.byType(EditableText).at(3), 'Aa1!aaaa');
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tapSubmit(tester, 'Start free trial');
      await finishSubmit(tester);
      expect(got, hasLength(1));
      expect(got.single.firstName, 'Ada');
      expect(got.single.lastName, 'Lovelace');
      expect(got.single.email, 'ada@example.com');
      expect(
        find.text('Trial started — check your inbox to verify it.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  });
}
