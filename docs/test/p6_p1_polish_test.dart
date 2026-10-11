// P6-P1 polish gates: no menu focus steal, no scroll workarounds, 6-slot
// OTP, enabled showcase CTAs, edge-aligned payout labels.
import 'package:docs/routing/docs_router.dart';
import 'package:docs/ui/shadcn/components/button/button.dart';
import 'package:docs/ui/shadcn/components/calendar/calendar.dart';
import 'package:docs/ui/shadcn/components/input_otp/input_otp.dart';
import 'package:docs/ui/shadcn/components/menu/menu.dart';
import 'package:docs/ui/shadcn/components/pagination/pagination.dart';
import 'package:docs/ui/shadcn/components/slider/slider.dart';
import 'package:docs/widgets/collage_home_forms.dart';
import 'package:docs/widgets/docs_header.dart';
import 'package:docs/widgets/studio_blocks/studio_forms.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';

bool _isAncestorOf(Element ancestor, Element node) {
  bool found = false;
  node.visitAncestorElements((Element candidate) {
    if (identical(candidate, ancestor)) {
      found = true;
      return false;
    }
    return true;
  });
  return found;
}

bool _focusedWithin(Finder target) {
  final Element? focused =
      FocusManager.instance.primaryFocus?.context as Element?;
  if (focused == null) return false;
  for (final Element element in target.evaluate()) {
    if (identical(element, focused) ||
        _isAncestorOf(focused, element) ||
        _isAncestorOf(element, focused)) {
      return true;
    }
  }
  return false;
}

void main() {
  testWidgets('inline menus do not steal initial focus', (tester) async {
    await pumpDocsApp(tester, width: 1400, height: 900);
    expect(
      FocusManager.instance.primaryFocus?.debugLabel,
      isNot('RovingGroup'),
      reason: 'MenuGroup must not autofocus on mount',
    );
    for (final MenuGroup group in tester.widgetList<MenuGroup>(
      find.byType(MenuGroup),
    )) {
      expect(group.autofocus, isFalse, reason: 'inline MenuGroup');
    }
  });

  testWidgets('first Tab lands in the header, palette opens', (tester) async {
    await pumpDocsApp(tester, width: 1400, height: 900);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(_focusedWithin(find.byType(DocsHeader)), isTrue);
  });

  testWidgets('pagination and calendar have no scroll workaround', (
    tester,
  ) async {
    await pumpDocsApp(tester, width: 1400, height: 900);
    for (final Element pager in find.byType(Pagination).evaluate()) {
      bool inScroll = false;
      pager.visitAncestorElements((Element ancestor) {
        if (ancestor.widget is SingleChildScrollView &&
            (ancestor.widget as SingleChildScrollView).scrollDirection ==
                Axis.horizontal) {
          inScroll = true;
          return false;
        }
        return true;
      });
      expect(inScroll, isFalse, reason: 'Pagination must fit without scroll');
    }
    for (final Element cal in find.byType(Calendar).evaluate()) {
      bool inScroll = false;
      cal.visitAncestorElements((Element ancestor) {
        if (ancestor.widget is SingleChildScrollView &&
            (ancestor.widget as SingleChildScrollView).scrollDirection ==
                Axis.horizontal) {
          inScroll = true;
          return false;
        }
        return true;
      });
      expect(inScroll, isFalse, reason: 'Calendar must fit without scroll');
    }
  });

  testWidgets('otp blocks use the restored 6 slots', (tester) async {
    await pumpDocsApp(tester, width: 1400, height: 900);
    final List<InputOtp> otps = tester
        .widgetList<InputOtp>(find.byType(InputOtp))
        .toList();
    expect(otps, isNotEmpty);
    for (final InputOtp otp in otps) {
      expect(otp.length, 6, reason: 'P6-F5 fits 6 slots, T1 4-slot reverted');
    }
  });

  testWidgets('view analytics reads as an enabled primary button', (
    tester,
  ) async {
    await pumpDocsApp(tester, width: 1400, height: 900);
    await tester.ensureVisible(find.text('View Analytics'));
    await tester.pumpAndSettle();
    final Finder button = find.ancestor(
      of: find.text('View Analytics'),
      matching: find.byType(Button),
    );
    expect(button, findsOneWidget);
    final Button widget = tester.widget<Button>(button);
    final bool enabled = widget.enabled ?? widget.onPressed != null;
    expect(enabled, isTrue);
    expect(widget.variant, ButtonVariant.primary);
    final Opacity opacity = tester.widget<Opacity>(
      find.descendant(of: button, matching: find.byType(Opacity)).first,
    );
    expect(opacity.opacity, 1);
  });

  testWidgets('showcase buttons render enabled', (tester) async {
    await pumpDocsApp(tester, width: 1400, height: 900);
    for (final String label in <String>[
      'New Goal',
      'Pay Early',
      'View All',
      'Invite teammate',
      'Manage storage',
      'Sign In',
      'Verify',
      'Resend',
    ]) {
      final Finder buttons = find.ancestor(
        of: find.text(label),
        matching: find.byType(Button),
      );
      for (final Button button in tester.widgetList<Button>(buttons)) {
        final bool enabled = button.enabled ?? button.onPressed != null;
        expect(enabled, isTrue, reason: '$label must be enabled');
      }
    }
  });

  testWidgets('payout min/max labels align to the slider edges', (
    tester,
  ) async {
    await pumpDocsApp(tester, width: 1400, height: 900);
    await tester.ensureVisible(find.byType(HomePayoutCard));
    await tester.pumpAndSettle();
    final Rect sliderRect = tester.getRect(
      find.descendant(
        of: find.byType(HomePayoutCard),
        matching: find.byType(Slider),
      ),
    );
    final Rect minRect = tester.getRect(
      find.descendant(
        of: find.byType(HomePayoutCard),
        matching: find.text(r'$50 (MIN)'),
      ),
    );
    final Rect maxRect = tester.getRect(
      find.descendant(
        of: find.byType(HomePayoutCard),
        matching: find.text(r'$10,000 (MAX)'),
      ),
    );
    expect(
      (minRect.left - sliderRect.left).abs(),
      lessThanOrEqualTo(1),
      reason: 'home min label left edge',
    );
    expect(
      (maxRect.right - sliderRect.right).abs(),
      lessThanOrEqualTo(1),
      reason: 'home max label right edge',
    );
  });

  testWidgets('studio payout labels align to the slider edges', (tester) async {
    final DocsRouterDelegate delegate = await pumpDocsApp(
      tester,
      width: 1400,
      height: 900,
    );
    await goTo(tester, delegate, '/themes');
    await tester.ensureVisible(find.byType(StudioPayoutCard));
    await tester.pumpAndSettle();
    final Rect sliderRect = tester.getRect(
      find.descendant(
        of: find.byType(StudioPayoutCard),
        matching: find.byType(Slider),
      ),
    );
    final Finder mins = find.descendant(
      of: find.byType(StudioPayoutCard),
      matching: find.text(r'$50 (MIN)'),
    );
    final Finder maxs = find.descendant(
      of: find.byType(StudioPayoutCard),
      matching: find.text(r'$10,000 (MAX)'),
    );
    expect(mins, findsOneWidget);
    expect(maxs, findsOneWidget);
    final Rect minRect = tester.getRect(mins);
    final Rect maxRect = tester.getRect(maxs);
    expect(
      (minRect.left - sliderRect.left).abs(),
      lessThanOrEqualTo(1),
      reason: 'studio min label left edge',
    );
    expect(
      (maxRect.right - sliderRect.right).abs(),
      lessThanOrEqualTo(1),
      reason: 'studio max label right edge',
    );
  });
}
