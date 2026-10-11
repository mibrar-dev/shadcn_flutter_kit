import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

/// Port of the old `Theme._ensureReadableDarkTheme` behaviour: dark theme on
/// a dark background patches near-black foregrounds to readable fallbacks.
void main() {
  Future<ShadcnThemeData> themeOf(
    WidgetTester tester,
    ShadcnThemeData data,
  ) async {
    ShadcnThemeData? seen;
    await tester.pumpWidget(
      ShadcnTheme(
        data: data,
        child: Builder(
          builder: (context) {
            seen = ShadcnTheme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
    return seen!;
  }

  testWidgets('dark theme patches near-black foregrounds', (tester) async {
    const dark = ShadcnColors.darkFallback;
    final data = ShadcnThemeData(
      colors: dark.copyWith(
        background: const Color(0xFF000000),
        foreground: const Color(0xFF111111),
        mutedForeground: const Color(0xFF111111),
        cardForeground: const Color(0xFF111111),
        popoverForeground: const Color(0xFF111111),
        sidebarForeground: const Color(0xFF111111),
      ),
    );
    final seen = await themeOf(tester, data);
    expect(seen.colors.foreground, dark.foreground);
    expect(seen.colors.mutedForeground, dark.mutedForeground);
    expect(seen.colors.cardForeground, dark.cardForeground);
    expect(seen.colors.popoverForeground, dark.popoverForeground);
    expect(seen.colors.sidebarForeground, dark.sidebarForeground);
  });

  testWidgets('readable dark theme passes through untouched', (tester) async {
    const data = ShadcnThemeData(colors: ShadcnColors.darkFallback);
    final seen = await themeOf(tester, data);
    expect(seen, data);
  });

  testWidgets('light theme never patches', (tester) async {
    const data = ShadcnThemeData(colors: ShadcnColors.lightFallback);
    final seen = await themeOf(
      tester,
      ShadcnThemeData(
        colors: ShadcnColors.lightFallback.copyWith(
          background: const Color(0xFF000000),
          foreground: const Color(0xFF111111),
        ),
      ),
    );
    expect(seen.colors.foreground, const Color(0xFF111111));
    expect(data.colors.foreground, isNot(const Color(0xFF111111)));
  });
}
