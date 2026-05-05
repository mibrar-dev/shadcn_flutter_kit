import 'package:flutter/widgets.dart';

import 'button_state_property_delegate.dart';
import '../variants/button_variance.dart';

/// Data class holding button style override delegates.
///
/// [ButtonStyleOverrideData] is used internally by [ButtonStyleOverride] to pass
/// style override delegates through the widget tree via the [Data] inherited widget
/// system. It stores optional delegates for each button style property.
///
/// This class is typically not used directly by application code; instead, use
/// [ButtonStyleOverride] widget to apply style overrides.
class ButtonStyleOverrideData {
  /// Optional decoration override delegate.
  final ButtonStatePropertyDelegate<Decoration>? decoration;

  /// Optional mouse cursor override delegate.
  final ButtonStatePropertyDelegate<MouseCursor>? mouseCursor;

  /// Optional padding override delegate.
  final ButtonStatePropertyDelegate<EdgeInsetsGeometry>? padding;

  /// Optional text style override delegate.
  final ButtonStatePropertyDelegate<TextStyle>? textStyle;

  /// Optional icon theme override delegate.
  final ButtonStatePropertyDelegate<IconThemeData>? iconTheme;

  /// Optional margin override delegate.
  final ButtonStatePropertyDelegate<EdgeInsetsGeometry>? margin;

  /// Creates button style override data with the specified delegates.
  const ButtonStyleOverrideData({
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
    if (other.runtimeType != runtimeType) return false;
    return other is ButtonStyleOverrideData &&
        other.decoration == decoration &&
        other.mouseCursor == mouseCursor &&
        other.padding == padding &&
        other.textStyle == textStyle &&
        other.iconTheme == iconTheme &&
        other.margin == margin;
  }

  @override
  int get hashCode {
    return Object.hash(
      decoration,
      mouseCursor,
      padding,
      textStyle,
      iconTheme,
      margin,
    );
  }

  @override
/// Executes `toString` behavior for this component/composite.
  String toString() {
    return 'ButtonStyleOverrideData(decoration: $decoration, mouseCursor: $mouseCursor, padding: $padding, textStyle: $textStyle, iconTheme: $iconTheme, margin: $margin)';
  }
}
