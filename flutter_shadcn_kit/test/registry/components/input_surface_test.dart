// P6-P3 §5: the input surface matches shadcn v4.
//
// Light: `bg-transparent` (input @0). Dark: `bg-input/30` (input token is 15%
// white, @0.3 ≈ 4.5% white). Both: `border-input` 1px. Reads real painted
// values via widget tests.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/input/input.dart';
import 'package:flutter_shadcn_kit/registry/primitives/overlay_manager.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';

Color _alpha(Color base, double factor) =>
    base.withValues(alpha: base.a * factor);

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
}) {
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: const [],
      child: MediaQuery(
        data: const MediaQueryData(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: ShadcnLayer(
            child: Shortcuts(
              shortcuts: const <ShortcutActivator, Intent>{
                SingleActivator(LogicalKeyboardKey.tab): NextFocusIntent(),
              },
              child: Actions(
                actions: <Type, Action<Intent>>{
                  NextFocusIntent: NextFocusAction(),
                },
                child: Overlay(
                  initialEntries: <OverlayEntry>[
                    OverlayEntry(builder: (_) => Center(child: child)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

BoxDecoration _surface(WidgetTester tester) {
  final containers = tester.widgetList<Container>(
    find.descendant(of: find.byType(Input), matching: find.byType(Container)),
  );
  return containers.first.decoration! as BoxDecoration;
}

void main() {
  group('P6-P3 input surface', () {
    testWidgets('light is transparent with a border-input border', (
      tester,
    ) async {
      const ShadcnColors colors = ShadcnColors.lightFallback;
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: colors),
          child: const Input(hintText: 'Email'),
        ),
      );
      final BoxDecoration surface = _surface(tester);
      expect(surface.color, _alpha(colors.input, 0));
      expect(surface.border, Border.all(color: colors.input));
      expect(surface.border, isNotNull);
    });

    testWidgets('dark is input/30 with a border-input border', (tester) async {
      const ShadcnColors colors = ShadcnColors.darkFallback;
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: colors),
          child: const Input(hintText: 'Email'),
        ),
      );
      final BoxDecoration surface = _surface(tester);
      expect(surface.color, _alpha(colors.input, 0.3));
      expect(surface.border, Border.all(color: colors.input));
    });

    test('defaults carry the documented rows', () {
      expect(
        inputDefaults.background?.rest,
        const ThemedColor.ref(ColorRef.input, alpha: 0),
      );
      expect(
        inputDarkDefaults.background?.rest,
        const ThemedColor.ref(ColorRef.input, alpha: 0.3),
      );
      expect(
        inputDefaults.borderColor?.rest,
        const ThemedColor.ref(ColorRef.input),
      );
      expect(inputDefaults.borderWidth, 1);
    });
  });
}
