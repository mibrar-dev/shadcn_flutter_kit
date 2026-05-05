import 'package:data_widget/data_widget.dart';
import 'package:flutter/widgets.dart';

import 'button_state_property_delegate.dart';
import 'button_style_override_data.dart';
import '../variants/button_variance.dart';

/// ButtonStyleOverride defines a reusable type for this registry module.
class ButtonStyleOverride extends StatelessWidget {
  /// Whether to inherit and chain with parent overrides.
  ///
  /// When `true`, this override's delegates receive the parent override's result
  /// as their default value, allowing nested style modifications. When `false`,
  /// parent overrides are ignored.
  final bool inherit;

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

  /// The widget subtree where overrides apply.
  final Widget child;

  /// Creates a button style override in replace mode.
  ///
  /// Overrides apply to all descendant buttons, ignoring parent overrides.
  const ButtonStyleOverride({
    super.key,
    this.decoration,
    this.mouseCursor,
    this.padding,
    this.textStyle,
    this.iconTheme,
    this.margin,
    required this.child,
  }) : inherit = false;

  /// Creates a button style override in inherit mode.
  ///
  /// Overrides chain with parent overrides, allowing nested customization where
  /// each level can modify the result of the previous level.
  const ButtonStyleOverride.inherit({
    super.key,
    this.decoration,
    this.mouseCursor,
    this.padding,
    this.textStyle,
    this.iconTheme,
    this.margin,
    required this.child,
  }) : inherit = true;

  @override
/// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
/// Stores `decoration` state/configuration for this implementation.
    var decoration = this.decoration;
/// Stores `mouseCursor` state/configuration for this implementation.
    var mouseCursor = this.mouseCursor;
/// Stores `padding` state/configuration for this implementation.
    var padding = this.padding;
/// Stores `textStyle` state/configuration for this implementation.
    var textStyle = this.textStyle;
/// Stores `iconTheme` state/configuration for this implementation.
    var iconTheme = this.iconTheme;
/// Stores `margin` state/configuration for this implementation.
    var margin = this.margin;
    if (inherit) {
      var data = Data.maybeOf<ButtonStyleOverrideData>(context);
      if (data != null) {
        decoration = (context, state, value) {
          return data.decoration?.call(
                context,
                state,
                decoration?.call(context, state, value) ?? value,
              ) ??
              decoration?.call(context, state, value) ??
              value;
        };
        mouseCursor = (context, state, value) {
          return data.mouseCursor?.call(
                context,
                state,
                mouseCursor?.call(context, state, value) ?? value,
              ) ??
              mouseCursor?.call(context, state, value) ??
              value;
        };
        padding = (context, state, value) {
          return data.padding?.call(
                context,
                state,
                padding?.call(context, state, value) ?? value,
              ) ??
              padding?.call(context, state, value) ??
              value;
        };
        textStyle = (context, state, value) {
          return data.textStyle?.call(
                context,
                state,
                textStyle?.call(context, state, value) ?? value,
              ) ??
              textStyle?.call(context, state, value) ??
              value;
        };
        iconTheme = (context, state, value) {
          return data.iconTheme?.call(
                context,
                state,
                iconTheme?.call(context, state, value) ?? value,
              ) ??
              iconTheme?.call(context, state, value) ??
              value;
        };
        margin = (context, state, value) {
          return data.margin?.call(
                context,
                state,
                margin?.call(context, state, value) ?? value,
              ) ??
              margin?.call(context, state, value) ??
              value;
        };
      }
    }
    return Data.inherit(
      data: ButtonStyleOverrideData(
        decoration: decoration,
        mouseCursor: mouseCursor,
        padding: padding,
        textStyle: textStyle,
        iconTheme: iconTheme,
        margin: margin,
      ),
      child: child,
    );
  }
}
