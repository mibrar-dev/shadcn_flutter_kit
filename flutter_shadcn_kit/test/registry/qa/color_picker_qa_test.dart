// QA for `color_picker` previews (P7-Q1): behaviour, spacing, robustness.
//
// Regression cover for: the controls row pinning a fixed one-line width
// (overflowing 375px phones instead of reflowing) and the channel-field
// padding literal bypassing density.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/color/color.dart';
import 'package:flutter_shadcn_kit/registry/components/color_picker/color_picker.dart';
import 'package:flutter_shadcn_kit/registry/components/color_picker/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/history/history.dart';
import 'package:flutter_shadcn_kit/registry/components/input/input.dart';
import 'package:flutter_shadcn_kit/registry/components/select/select.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  TextDirection direction = TextDirection.ltr,
  double? width,
}) {
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: direction,
      child: Center(
        child: width == null ? child : SizedBox(width: width, child: child),
      ),
    ),
  );
}

Widget _picker({bool showAlpha = true}) {
  return RecentColorsScope(
    initialRecentColors: const <Color>[Color(0xFF22C55E)],
    child: ColorPicker(
      value: ColorDerivative.fromColor(const Color(0xFF2563EB)),
      showAlpha: showAlpha,
      onChanged: (_) {},
    ),
  );
}

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in colorPickerPreviews) {
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

  testWidgets('unbounded stages keep the one-line popover width', (
    tester,
  ) async {
    await tester.pumpWidget(_frame(_picker()));
    await tester.pump();
    expect(
      tester.getSize(find.byType(ColorPicker)).width,
      colorPickerControlsWidth(
        mode: ColorPickerMode.rgb,
        showAlpha: true,
        leadingButtons: 2,
        controlSpacing: 8,
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('the controls reflow instead of overflowing at 375px', (
    tester,
  ) async {
    await tester.pumpWidget(_frame(_picker(), width: 375));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
    final double selectDy = tester
        .getCenter(find.byType(Select<ColorPickerMode>))
        .dy;
    final double lastFieldDy = tester.getCenter(find.byType(Input).last).dy;
    expect(
      lastFieldDy,
      greaterThan(selectDy),
      reason: 'the last channel field wraps below the mode select at 375px',
    );
  });

  testWidgets('RTL pumps with no exception', (tester) async {
    await tester.pumpWidget(_frame(_picker(), direction: TextDirection.rtl));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });
}
