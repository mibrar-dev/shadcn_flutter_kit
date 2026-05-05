import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/flutter_shadcn_kit.dart';
import 'package:flutter_shadcn_kit/registry/components/component_theme_global_configs.dart';
import 'package:flutter_shadcn_kit/registry/shared/theme/component_theme_global_registry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'ShadcnApp can skip the compatibility bootstrap when explicit registrars are provided',
    (tester) async {
      registerButtonThemeGlobals();
      registerTextFieldThemeGlobals();
      registerDialogThemeGlobals();

      await tester.pumpWidget(
        const ShadcnApp(
          preloadComponentThemeGlobals: false,
          home: SizedBox.shrink(),
        ),
      );
      await tester.pumpAndSettle();

      expect(ComponentThemeGlobalRegistry.hasResolver<MenuButtonTheme>(), isTrue);
      expect(ComponentThemeGlobalRegistry.hasResolver<TextFieldTheme>(), isTrue);
      expect(
        ComponentThemeGlobalRegistry.hasResolver<ModalBackdropTheme>(),
        isTrue,
      );
      expect(ComponentThemeGlobalRegistry.hasResolver<BadgeTheme>(), isFalse);
    },
  );
}
