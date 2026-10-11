// QA for `color_input` previews (P7-Q1): behaviour, spacing, robustness.
//
// Regression cover for: the popover alignments being non-directional
// (`Alignment.topLeft`/`bottomLeft` instead of top/bottom-start).

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/color_input/color_input.dart';
import 'package:flutter_shadcn_kit/registry/components/color_input/preview.dart';
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

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in colorInputPreviews) {
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

  test('the popover placements are directional', () {
    expect(colorInputDefaults.popoverAlignment, AlignmentDirectional.topStart);
    expect(
      colorInputDefaults.popoverAnchorAlignment,
      AlignmentDirectional.bottomStart,
    );
  });

  testWidgets('default preview fits 375px with no overflow', (tester) async {
    await tester.pumpWidget(
      _frame(Builder(builder: colorInputPreviews[0].builder), width: 375),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });

  testWidgets('RTL pumps with no exception', (tester) async {
    await tester.pumpWidget(
      _frame(
        Builder(builder: colorInputPreviews[0].builder),
        direction: TextDirection.rtl,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });
}
