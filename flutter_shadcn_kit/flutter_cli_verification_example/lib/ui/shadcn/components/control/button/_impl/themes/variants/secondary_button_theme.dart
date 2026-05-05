import 'package:flutter/widgets.dart';

import '../../../../../../shared/theme/theme.dart';
import '../../styles/abstract_button_style.dart';
import '../../styles/button_state_property.dart';
import '../../styles/button_state_property_delegate.dart';
import './button_theme_base.dart';

/// SecondaryButtonTheme defines a reusable type for this registry module.
class SecondaryButtonTheme extends ButtonTheme {
  /// Creates a [SecondaryButtonTheme] with optional style property delegates.
  const SecondaryButtonTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    super.decoration,
    super.mouseCursor,
    super.padding,
    super.textStyle,
    super.iconTheme,
    super.margin,
  });

  /// Creates a copy of this theme with selectively replaced properties.
  SecondaryButtonTheme copyWith({
    ValueGetter<ButtonStatePropertyDelegate<Decoration>?>? decoration,
    ValueGetter<ButtonStatePropertyDelegate<MouseCursor>?>? mouseCursor,
    ValueGetter<ButtonStatePropertyDelegate<EdgeInsetsGeometry>?>? padding,
    ValueGetter<ButtonStatePropertyDelegate<TextStyle>?>? textStyle,
    ValueGetter<ButtonStatePropertyDelegate<IconThemeData>?>? iconTheme,
    ValueGetter<ButtonStatePropertyDelegate<EdgeInsetsGeometry>?>? margin,
  }) {
    return SecondaryButtonTheme(
      decoration: decoration == null ? this.decoration : decoration(),
      mouseCursor: mouseCursor == null ? this.mouseCursor : mouseCursor(),
      padding: padding == null ? this.padding : padding(),
      textStyle: textStyle == null ? this.textStyle : textStyle(),
      iconTheme: iconTheme == null ? this.iconTheme : iconTheme(),
      margin: margin == null ? this.margin : margin(),
    );
  }
}
