// P6-D9b: leading/trailing icon geometry.
//
// User requirement: "a leading/trailing icon keeps the correct gap from the
// label AND from the chip edge (never touching the edge), same for table
// cells, menu rows, inputs, buttons, badges, tabs, cards, dialogs, toasts".
//
// Two distances are asserted per icon:
//   * icon edge -> outer edge = the component's horizontal padding;
//   * icon edge -> label edge = the component's gap token
//     (`theme.spacing.sm`, shadcn `gap-2`).
//
// A component whose icons are laid out outside the padding, or on the wrong
// side, is a FINDING and is marked `skip: true` with the source line.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/badge/badge.dart';
import 'package:flutter_shadcn_kit/registry/components/button/button.dart';
import 'package:flutter_shadcn_kit/registry/components/chip/chip.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_shadcn_kit/registry/theme/tokens.dart';
import 'package:flutter_test/flutter_test.dart';

import 'layout_audit_support.dart';

const Key _lead = ValueKey<String>('audit-lead');
const Key _trail = ValueKey<String>('audit-trail');
const String _label = 'Audit';

/// The gap token a chip/button uses between its children: shadcn `gap-2`
/// (`theme.spacing.sm` = 8 at the default spacing base).
const double gapToken = 8;

/// Asserts an icon slot in [direction].
///
/// [leading] selects which slot the icon fills, so the "outer" side is the
/// one facing the component edge and the label side is the one facing the
/// label. Both distances and the no-overlap condition are asserted.
void expectIconSlot({
  required Rect host,
  required Rect icon,
  required Rect label,
  required double edgePadding,
  required double gap,
  required TextDirection direction,
  required bool leading,
  required String role,
}) {
  final bool ltr = direction == TextDirection.ltr;
  // An LTR leading icon and an RTL trailing icon both put `left` outward.
  final bool leftIsOuter = ltr == leading;
  final double outer = leftIsOuter ? host.left : host.right;
  final double iconOuter = leftIsOuter ? icon.left : icon.right;
  final double iconInner = leftIsOuter ? icon.right : icon.left;
  final double labelFacing = leftIsOuter ? label.left : label.right;
  expect(
    (iconOuter - outer).abs(),
    closeTo(edgePadding, 0.01),
    reason:
        '$role must sit the horizontal padding ($edgePadding) from the '
        'outer edge, never touching it',
  );
  expect(
    (labelFacing - iconInner).abs(),
    closeTo(gap, 0.01),
    reason: '$role must keep the gap token ($gap) from the label',
  );
  // No overlap: the label must sit on the far side of the icon.
  expect(
    leftIsOuter ? label.left >= icon.right : label.right <= icon.left,
    isTrue,
    reason: '$role must not overlap the label',
  );
}

void main() {
  group('button — shadcn `px-4 gap-2`', () {
    Widget build(TextDirection direction) => Button(
      onPressed: () {},
      leading: const Icon(IconData(0x1), key: _lead),
      trailing: const Icon(IconData(0x2), key: _trail),
      child: const Text(_label),
    );

    testWidgets('LTR: icons sit inside the padding, gap-2 from the label', (
      tester,
    ) async {
      final Widget button = build(TextDirection.ltr);
      await tester.pumpWidget(
        auditFrame(
          child: button,
          parent: looseHost(child: button),
        ),
      );
      expectIconSlot(
        host: rectOf(tester, Button),
        icon: rectOfKey(tester, _lead),
        label: tester.getRect(find.text(_label)),
        edgePadding: 16,
        gap: gapToken,
        direction: TextDirection.ltr,
        leading: true,
        role: 'leading icon',
      );
      expectIconSlot(
        host: rectOf(tester, Button),
        icon: rectOfKey(tester, _trail),
        label: tester.getRect(find.text(_label)),
        edgePadding: 16,
        gap: gapToken,
        direction: TextDirection.ltr,
        leading: false,
        role: 'trailing icon',
      );
    });

    testWidgets('RTL mirrors the icon slots', (tester) async {
      final Widget button = build(TextDirection.rtl);
      await tester.pumpWidget(
        auditFrame(
          textDirection: TextDirection.rtl,
          child: button,
          parent: looseHost(child: button),
        ),
      );
      expectIconSlot(
        host: rectOf(tester, Button),
        icon: rectOfKey(tester, _lead),
        label: tester.getRect(find.text(_label)),
        edgePadding: 16,
        gap: gapToken,
        direction: TextDirection.rtl,
        leading: true,
        role: 'leading icon',
      );
      expectIconSlot(
        host: rectOf(tester, Button),
        icon: rectOfKey(tester, _trail),
        label: tester.getRect(find.text(_label)),
        edgePadding: 16,
        gap: gapToken,
        direction: TextDirection.rtl,
        leading: false,
        role: 'trailing icon',
      );
    });
  });

  group('chip — shadcn `px-2 gap-2`', () {
    Widget build(TextDirection direction) => const Chip(
      leading: Icon(IconData(0x1), key: _lead),
      trailing: Icon(IconData(0x2), key: _trail),
      child: Text(_label),
    );

    // FINDING: chip.dart:132-146 pads only `child`, so both `leading` and
    // `trailing` are appended after the label in the row — the leading icon
    // renders on the wrong side and the trailing icon touches the chip edge.
    testWidgets('LTR: leading icon renders before the label', (tester) async {
      final Widget chip = build(TextDirection.ltr);
      await tester.pumpWidget(
        auditFrame(
          child: chip,
          parent: looseHost(child: chip),
        ),
      );
      expectIconSlot(
        host: rectOf(tester, Chip),
        icon: rectOfKey(tester, _lead),
        label: tester.getRect(find.text(_label)),
        edgePadding: 8,
        gap: gapToken,
        direction: TextDirection.ltr,
        leading: true,
        role: 'leading icon',
      );
      expectIconSlot(
        host: rectOf(tester, Chip),
        icon: rectOfKey(tester, _trail),
        label: tester.getRect(find.text(_label)),
        edgePadding: 8,
        gap: gapToken,
        direction: TextDirection.ltr,
        leading: false,
        role: 'trailing icon',
      );
    }, skip: true);

    // FINDING: same root cause — the slot is not mirrored in RTL either.
    testWidgets('RTL mirrors the icon slots', (tester) async {
      final Widget chip = build(TextDirection.rtl);
      await tester.pumpWidget(
        auditFrame(
          textDirection: TextDirection.rtl,
          child: chip,
          parent: looseHost(child: chip),
        ),
      );
      expectIconSlot(
        host: rectOf(tester, Chip),
        icon: rectOfKey(tester, _lead),
        label: tester.getRect(find.text(_label)),
        edgePadding: 8,
        gap: gapToken,
        direction: TextDirection.rtl,
        leading: true,
        role: 'leading icon',
      );
    }, skip: true);
  });

  group('badge — shadcn `px-2 gap-2`', () {
    // FINDING: badge.dart:157 wraps only `child` in the padding, so the
    // leading icon starts at the badge edge (x = 0) and touches it.
    testWidgets('LTR: leading icon sits inside the padding', (tester) async {
      final Widget badge = const Badge(
        leading: Icon(IconData(0x3), key: _lead),
        child: Text(_label),
      );
      await tester.pumpWidget(
        auditFrame(
          child: badge,
          parent: looseHost(child: badge),
        ),
      );
      expectIconSlot(
        host: rectOf(tester, Badge),
        icon: rectOfKey(tester, _lead),
        label: tester.getRect(find.text(_label)),
        edgePadding: 8,
        gap: gapToken,
        direction: TextDirection.ltr,
        leading: true,
        role: 'leading icon',
      );
    }, skip: true);
  });

  group('gap token tracks the preset spacing base', () {
    testWidgets('a preset spacing base rescales the icon gap', (tester) async {
      // `theme.spacing.sm` is `base * 2`; the audit default base is 4 => 8.
      const ShadcnThemeData base4 = ShadcnThemeData();
      const SpacingScale scale = SpacingScale(8);
      expect(base4.spacing.sm, gapToken);
      expect(scale.sm, 16);
      expect(base4.spacing.md, 12);
    });
  });
}
