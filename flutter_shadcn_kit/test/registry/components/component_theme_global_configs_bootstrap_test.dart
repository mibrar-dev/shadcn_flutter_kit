import 'package:flutter_shadcn_kit/registry/components/component_theme_global_configs.dart';
import 'package:flutter_shadcn_kit/registry/components/control/button/_impl/themes/config/button_theme_config.dart';
import 'package:flutter_shadcn_kit/registry/components/display/badge/_impl/themes/config/badge_theme_config.dart';
import 'package:flutter_shadcn_kit/registry/components/form/text_field/_impl/themes/config/text_field_theme_config.dart';
import 'package:flutter_shadcn_kit/registry/components/overlay/dialog/_impl/themes/config/dialog_theme_config.dart';
import 'package:flutter_shadcn_kit/registry/shared/theme/component_theme_global_registry.dart';
import 'package:flutter_shadcn_kit/flutter_shadcn_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('registerComponentThemeGlobalConfigs preloads aggregate resolvers', () {
    registerComponentThemeGlobalConfigs();
    registerComponentThemeGlobalConfigs();

    expect(ComponentThemeGlobalRegistry.hasResolver<MenuButtonTheme>(), isTrue);
    expect(ComponentThemeGlobalRegistry.hasResolver<TextFieldTheme>(), isTrue);
    expect(ComponentThemeGlobalRegistry.hasResolver<ModalBackdropTheme>(), isTrue);
    expect(ComponentThemeGlobalRegistry.hasResolver<BadgeTheme>(), isTrue);
    expect(
      ComponentThemeGlobalRegistry.maybeOf<MenuButtonTheme>(),
      same(ButtonThemeConfig.menuButtonTheme),
    );
    expect(
      ComponentThemeGlobalRegistry.maybeOf<TextFieldTheme>(),
      same(TextFieldThemeConfig.global),
    );
    expect(
      ComponentThemeGlobalRegistry.maybeOf<ModalBackdropTheme>(),
      same(DialogThemeConfig.modalBackdropTheme),
    );
    expect(
      ComponentThemeGlobalRegistry.maybeOf<BadgeTheme>(),
      same(BadgeThemeConfig.global),
    );
  });
}
