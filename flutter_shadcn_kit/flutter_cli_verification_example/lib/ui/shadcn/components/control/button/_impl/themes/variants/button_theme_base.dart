import 'package:flutter/widgets.dart';

import '../../../../../../shared/theme/theme.dart';
import '../../styles/abstract_button_style.dart';
import '../../styles/button_state_property.dart';
import '../../styles/button_state_property_delegate.dart';

/// ButtonTheme defines a reusable type for this registry module.
abstract class ButtonTheme extends ComponentThemeData {
  /// Optional decoration override (background, border, shadows).
  final ButtonStatePropertyDelegate<Decoration>? decoration;

  /// Optional mouse cursor override.
  final ButtonStatePropertyDelegate<MouseCursor>? mouseCursor;

  /// Optional padding override.
  final ButtonStatePropertyDelegate<EdgeInsetsGeometry>? padding;

  /// Optional text style override.
  final ButtonStatePropertyDelegate<TextStyle>? textStyle;

  /// Optional icon theme override.
  final ButtonStatePropertyDelegate<IconThemeData>? iconTheme;

  /// Optional margin override.
  final ButtonStatePropertyDelegate<EdgeInsetsGeometry>? margin;

  /// Creates a [ButtonTheme] with optional style property delegates.
  ///
  /// All parameters are optional, allowing selective override of specific
  /// style properties while leaving others to use default values.
  const ButtonTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.decoration,
    this.mouseCursor,
    this.padding,
    this.textStyle,
    this.iconTheme,
    this.margin,
  });

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ButtonTheme &&
        other.decoration == decoration &&
        other.mouseCursor == mouseCursor &&
        other.padding == padding &&
        other.textStyle == textStyle &&
        other.iconTheme == iconTheme &&
        other.margin == margin;
  }

  @override
  int get hashCode => Object.hash(
    decoration,
    mouseCursor,
    padding,
    textStyle,
    iconTheme,
    margin,
  );

  @override
  /// Executes `toString` behavior for this component/composite.
  String toString() =>
      '$runtimeType{decoration: $decoration, mouseCursor: $mouseCursor, padding: $padding, textStyle: $textStyle, iconTheme: $iconTheme, margin: $margin}';
}
