// QA for `input_otp` previews (P7-Q1 batch E): behaviour, robustness.
//
// Regression cover for: a custom `separator` widget never rendering, the
// validator docs claiming `null` until complete, a disabled field staying
// keyboard-focusable, and slot order mirroring in RTL.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/input_otp/input_otp.dart';
import 'package:flutter_shadcn_kit/registry/components/input_otp/preview.dart';
import 'package:flutter_shadcn_kit/registry/primitives/focus_outline.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

/// Keeps one [OverlayEntry] alive across re-pumps (the hidden field needs a
/// real Overlay for its selection overlay).
class _OverlayHost extends StatefulWidget {
  const _OverlayHost({required this.child});

  final Widget child;

  @override
  State<_OverlayHost> createState() => _OverlayHostState();
}

class _OverlayHostState extends State<_OverlayHost> {
  late final OverlayEntry _entry = OverlayEntry(
    builder: (BuildContext context) =>
        Align(alignment: Alignment.topLeft, child: widget.child),
  );

  @override
  void didUpdateWidget(covariant _OverlayHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    _entry.markNeedsBuild();
  }

  @override
  void dispose() {
    _entry
      ..remove()
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Overlay(initialEntries: <OverlayEntry>[_entry]);
}

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  TextDirection direction = TextDirection.ltr,
  double? width,
}) {
  final Widget body = width == null
      ? child
      : SizedBox(width: width, child: child);
  return ShadcnTheme(
    data: data,
    // Directionality sits above the Overlay, as the contract requires.
    child: Directionality(
      textDirection: direction,
      child: _OverlayHost(child: DefaultTextEditingShortcuts(child: body)),
    ),
  );
}

Finder get _slots => find.byType(FocusOutline);

Future<void> _focus(WidgetTester tester) async {
  await tester.tap(find.byType(InputOtp));
  await tester.pump();
}

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in inputOtpPreviews) {
      for (final colors in <ShadcnColors>[
        ShadcnColors.lightFallback,
        ShadcnColors.darkFallback,
      ]) {
        await tester.pumpWidget(
          _frame(
            Builder(builder: preview.builder),
            data: ShadcnThemeData(colors: colors),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(
          tester.takeException(),
          isNull,
          reason: '${preview.name} light/dark',
        );
      }
    }
  });

  testWidgets('custom separator widget renders instead of the dash', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        const InputOtp(length: 6, separatorEvery: 3, separator: Text('|')),
      ),
    );
    await tester.pump();
    expect(find.text('|'), findsOneWidget);
    expect(find.text('-'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('wide custom separator reserves its own width', (tester) async {
    await tester.pumpWidget(
      _frame(
        const InputOtp(length: 6, separatorEvery: 3, separator: Text('||||||')),
        width: 240,
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(InputOtp)).width, lessThanOrEqualTo(240));
    final Size slot = tester.getSize(_slots.at(0));
    expect(slot.width, slot.height);
  });

  testWidgets('validator sees partials but UI waits for completion', (
    tester,
  ) async {
    final List<String?> seen = <String?>[];
    await tester.pumpWidget(
      _frame(
        InputOtp(
          length: 4,
          validator: (String? code) {
            seen.add(code);
            return 'Bad';
          },
        ),
      ),
    );
    await _focus(tester);
    await tester.enterText(find.byType(InputOtp), '12');
    await tester.pump();
    expect(seen, contains('12'));
    expect(find.text('Bad'), findsNothing);

    await tester.enterText(find.byType(InputOtp), '1234');
    await tester.pump();
    expect(seen, contains('1234'));
    expect(find.text('Bad'), findsOneWidget);
  });

  testWidgets('disabled field refuses keyboard focus', (tester) async {
    await tester.pumpWidget(_frame(const InputOtp(length: 4, enabled: false)));
    await tester.pump();
    final EditableText field = tester.widget<EditableText>(
      find.byType(EditableText),
    );
    expect(field.focusNode.canRequestFocus, isFalse);
    await _focus(tester);
    expect(field.focusNode.hasFocus, isFalse);
  });

  testWidgets('slot row stays LTR in RTL', (tester) async {
    await tester.pumpWidget(
      _frame(
        const InputOtp(length: 4, separatorEvery: 2, separator: Text('|')),
        direction: TextDirection.rtl,
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(
      find.descendant(
        of: find.byType(InputOtp),
        matching: find.byWidgetPredicate(
          (Widget widget) =>
              widget is Directionality &&
              widget.textDirection == TextDirection.ltr,
        ),
      ),
      findsWidgets,
    );
  });

  testWidgets('default preview fits 375px with no overflow', (tester) async {
    await tester.pumpWidget(
      _frame(Builder(builder: inputOtpPreviews[0].builder), width: 375),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });

  testWidgets('RTL pumps with no exception', (tester) async {
    for (final preview in inputOtpPreviews) {
      await tester.pumpWidget(
        _frame(Builder(builder: preview.builder), direction: TextDirection.rtl),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull, reason: '${preview.name} RTL');
    }
  });
}
