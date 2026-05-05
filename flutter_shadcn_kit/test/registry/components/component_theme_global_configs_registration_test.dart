import 'package:flutter_shadcn_kit/registry/components/component_theme_global_configs.dart';
import 'package:flutter_shadcn_kit/registry/components/control/button/button.dart';
import 'package:flutter_shadcn_kit/registry/components/control/button/_impl/themes/config/button_theme_config.dart';
import 'package:flutter_shadcn_kit/registry/components/form/text_field/text_field.dart';
import 'package:flutter_shadcn_kit/registry/components/form/text_field/_impl/themes/config/text_field_theme_config.dart';
import 'package:flutter_shadcn_kit/registry/components/overlay/dialog/dialog.dart';
import 'package:flutter_shadcn_kit/registry/components/overlay/dialog/_impl/themes/config/dialog_theme_config.dart';
import 'package:flutter_shadcn_kit/registry/shared/theme/component_theme_global_registry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('registerButtonThemeGlobals keeps pilot button resolvers available', () {
    registerButtonThemeGlobals();
    registerButtonThemeGlobals();

    expect(ComponentThemeGlobalRegistry.hasResolver<PrimaryButtonTheme>(), isTrue);
    expect(ComponentThemeGlobalRegistry.hasResolver<MenuButtonTheme>(), isTrue);
    expect(
      ComponentThemeGlobalRegistry.maybeOf<PrimaryButtonTheme>(),
      same(ButtonThemeConfig.primaryButtonTheme),
    );
    expect(
      ComponentThemeGlobalRegistry.maybeOf<MenuButtonTheme>(),
      same(ButtonThemeConfig.menuButtonTheme),
    );

    expect(
      ComponentThemeGlobalRegistry.maybeOf<PrimaryButtonTheme>(),
      same(ButtonThemeConfig.primaryButtonTheme),
    );
    expect(
      ComponentThemeGlobalRegistry.maybeOf<MenuButtonTheme>(),
      same(ButtonThemeConfig.menuButtonTheme),
    );
  });

  test(
    'registerTextFieldThemeGlobals keeps a nullable text field resolver available',
    () {
      registerTextFieldThemeGlobals();
      registerTextFieldThemeGlobals();

      expect(ComponentThemeGlobalRegistry.hasResolver<TextFieldTheme>(), isTrue);
      expect(
        ComponentThemeGlobalRegistry.maybeOf<TextFieldTheme>(),
        same(TextFieldThemeConfig.global),
      );

      expect(ComponentThemeGlobalRegistry.hasResolver<TextFieldTheme>(), isTrue);
      expect(
        ComponentThemeGlobalRegistry.maybeOf<TextFieldTheme>(),
        same(TextFieldThemeConfig.global),
      );
    },
  );

  test('registerDialogThemeGlobals keeps a nullable dialog resolver available', () {
    registerDialogThemeGlobals();
    registerDialogThemeGlobals();

    expect(ComponentThemeGlobalRegistry.hasResolver<ModalBackdropTheme>(), isTrue);
    expect(
      ComponentThemeGlobalRegistry.maybeOf<ModalBackdropTheme>(),
      same(DialogThemeConfig.modalBackdropTheme),
    );

    expect(ComponentThemeGlobalRegistry.hasResolver<ModalBackdropTheme>(), isTrue);
    expect(
      ComponentThemeGlobalRegistry.maybeOf<ModalBackdropTheme>(),
      same(DialogThemeConfig.modalBackdropTheme),
    );
  });
}
