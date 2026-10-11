// QA for `formatted_input` previews (P7-Q1 batch E): behaviour, robustness.
//
// Regression cover for: a controlled clear via `value: null` being swallowed,
// the phone preview mixing `value:` + `initialValue` + `onChanged`, the
// unscaled `leadingGap`, and a disabled field that stayed focusable with a
// focus ring.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/formatted_input/formatted_input.dart';
import 'package:flutter_shadcn_kit/registry/components/formatted_input/preview.dart';
import 'package:flutter_shadcn_kit/registry/primitives/focus_outline.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

/// Keeps one [OverlayEntry] alive across re-pumps so state survives a
/// `pumpWidget` with new constructor arguments (controlled-value swaps).
class _OverlayHost extends StatefulWidget {
  const _OverlayHost({required this.child});

  final Widget child;

  @override
  State<_OverlayHost> createState() => _OverlayHostState();
}

class _OverlayHostState extends State<_OverlayHost> {
  late final OverlayEntry _entry = OverlayEntry(
    builder: (BuildContext context) =>
        Center(child: DefaultTextEditingShortcuts(child: widget.child)),
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
      child: _OverlayHost(child: body),
    ),
  );
}

const SegmentedValue _phone = SegmentedValue(<SegmentPart>[
  SegmentPart.editable(length: 3, width: 32),
  SegmentPart.separator(' '),
  SegmentPart.editable(length: 3, width: 32),
]);

String _joinedText(WidgetTester tester) {
  return tester
      .widgetList<EditableText>(find.byType(EditableText))
      .map((EditableText field) => field.controller.text)
      .join('|');
}

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in formattedInputPreviews) {
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

  testWidgets('controlled clear via value: null empties the segments', (
    tester,
  ) async {
    SegmentedValue? value = _phone.withValue(0, '555');
    late StateSetter setValue;
    await tester.pumpWidget(
      _frame(
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            setValue = setState;
            return FormattedInput(
              value: value,
              onChanged: (SegmentedValue next) => setValue(() {
                value = next;
              }),
            );
          },
        ),
      ),
    );
    await tester.pump();
    expect(_joinedText(tester), '555|');
    setValue(() {
      value = null;
    });
    await tester.pump();
    expect(_joinedText(tester), '|');
    expect(tester.takeException(), isNull);
  });

  testWidgets('phone preview stays controlled while typing', (tester) async {
    await tester.pumpWidget(
      _frame(Builder(builder: formattedInputPreviews[0].builder)),
    );
    await tester.pump();
    await tester.enterText(find.byType(EditableText).first, '555');
    await tester.pump();
    expect(_joinedText(tester).startsWith('555'), isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('leadingGap follows theme scaling', (tester) async {
    // Pump the same field under two scales and compare the rendered gaps:
    // the space between `leading` and the first part must double.
    Future<Iterable<double>> renderedGaps(double scaling) async {
      await tester.pumpWidget(
        _frame(
          const FormattedInput(
            leading: Text('L'),
            initialValue: SegmentedValue(<SegmentPart>[
              SegmentPart.editable(length: 2, width: 28),
            ]),
          ),
          data: ShadcnThemeData(scaling: scaling),
        ),
      );
      await tester.pump();
      return tester
          .widgetList<SizedBox>(
            find.descendant(
              of: find.byType(FormattedInput),
              matching: find.byType(SizedBox),
            ),
          )
          .where((SizedBox box) => box.width != null && box.child == null)
          .map((SizedBox box) => box.width!);
    }

    expect(await renderedGaps(1), contains(8));
    expect(await renderedGaps(2), contains(16));
  });

  testWidgets('disabled field refuses focus and paints no ring', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(const FormattedInput(initialValue: _phone, enabled: false)),
    );
    await tester.pump();
    final List<EditableText> fields = tester
        .widgetList<EditableText>(find.byType(EditableText))
        .toList();
    expect(fields, isNotEmpty);
    for (final EditableText field in fields) {
      expect(field.focusNode.canRequestFocus, isFalse);
      field.focusNode.requestFocus();
    }
    await tester.pump();
    for (final EditableText field in fields) {
      expect(field.focusNode.hasFocus, isFalse);
    }
    final FocusOutline outline = tester.widget<FocusOutline>(
      find.descendant(
        of: find.byType(FormattedInput),
        matching: find.byType(FocusOutline),
      ),
    );
    expect(outline.focused, isFalse);
  });

  testWidgets('default preview fits 375px with no overflow', (tester) async {
    await tester.pumpWidget(
      _frame(Builder(builder: formattedInputPreviews[0].builder), width: 375),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });

  testWidgets('RTL pumps with no exception', (tester) async {
    for (final preview in formattedInputPreviews) {
      await tester.pumpWidget(
        _frame(Builder(builder: preview.builder), direction: TextDirection.rtl),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull, reason: '${preview.name} RTL');
    }
  });
}
