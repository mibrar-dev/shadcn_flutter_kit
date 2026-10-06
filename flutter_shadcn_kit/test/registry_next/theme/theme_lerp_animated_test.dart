import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ShadcnColors.lerp endpoints return the inputs', () {
    const a = ShadcnColors.lightFallback;
    const b = ShadcnColors.darkFallback;
    expect(ShadcnColors.lerp(a, b, 0.0), a);
    expect(ShadcnColors.lerp(a, b, 1.0), b);
    expect(ShadcnColors.lerp(a, b, 0.0).brightness, Brightness.light);
    expect(ShadcnColors.lerp(a, b, 1.0).brightness, Brightness.dark);
  });

  test('ShadcnThemeData.lerp endpoints return the inputs', () {
    const a = ShadcnThemeData();
    const b = ShadcnThemeData(colors: ShadcnColors.darkFallback);
    expect(ShadcnThemeData.lerp(a, b, 0.0), a);
    expect(ShadcnThemeData.lerp(a, b, 1.0), b);
  });

  testWidgets('AnimatedShadcnTheme animates a color', (tester) async {
    Color? seen;
    ShadcnThemeData dataFor(Color background) => ShadcnThemeData(
      colors: ShadcnColors.lightFallback.copyWith(background: background),
    );
    Widget frame(ShadcnThemeData data) => AnimatedShadcnTheme(
      duration: const Duration(milliseconds: 300),
      data: data,
      child: Builder(
        builder: (context) {
          seen = ShadcnTheme.of(context).colors.background;
          return const SizedBox();
        },
      ),
    );

    await tester.pumpWidget(frame(dataFor(const Color(0xFF000000))));
    expect(seen, const Color(0xFF000000));

    await tester.pumpWidget(frame(dataFor(const Color(0xFFFFFFFF))));
    await tester.pump(const Duration(milliseconds: 150));
    // Mid-animation: strictly between the two endpoints.
    expect(seen, isNot(const Color(0xFF000000)));
    expect(seen, isNot(const Color(0xFFFFFFFF)));

    await tester.pumpAndSettle();
    expect(seen, const Color(0xFFFFFFFF));
  });
}
