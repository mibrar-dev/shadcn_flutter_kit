// Tests for the `alpha` component (checkerboard painter).
//
// Painter-only leaf: no variants, states, or theme legs to exercise.
// Covers both token modes for rendering and the repaint semantics.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/alpha/alpha.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final entry in <(String, ShadcnThemeData)>[
    ('light', const ShadcnThemeData()),
    ('dark', const ShadcnThemeData(colors: ShadcnColors.darkFallback)),
  ]) {
    testWidgets('renders behind a translucent fill (${entry.$1})', (
      tester,
    ) async {
      await tester.pumpWidget(
        ShadcnTheme(
          data: entry.$2,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: 100,
              height: 40,
              child: CustomPaint(painter: AlphaPainter()),
            ),
          ),
        ),
      );
      expect(find.byType(CustomPaint), findsWidgets);
      expect(
        find.byWidgetPredicate(
          (w) => w is CustomPaint && w.painter is AlphaPainter,
        ),
        findsOneWidget,
      );
    });
  }

  test('shouldRepaint only when the pattern inputs change', () {
    const a = AlphaPainter();
    expect(a.shouldRepaint(const AlphaPainter()), isFalse);
    expect(a.shouldRepaint(const AlphaPainter(squareSize: 4)), isTrue);
    expect(
      a.shouldRepaint(const AlphaPainter(primary: Color(0xFF000000))),
      isTrue,
    );
  });
}
