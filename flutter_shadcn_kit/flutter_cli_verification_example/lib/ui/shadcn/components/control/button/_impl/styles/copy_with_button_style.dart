import 'package:flutter/widgets.dart';

import 'abstract_button_style.dart';
import 'button_state_property.dart';
import 'button_state_property_delegate.dart';

/// CopyWithButtonStyle defines a reusable type for this registry module.
class CopyWithButtonStyle implements AbstractButtonStyle {
/// Stores `_decoration` state/configuration for this implementation.
  final ButtonStatePropertyDelegate<Decoration>? _decoration;
/// Stores `_mouseCursor` state/configuration for this implementation.
  final ButtonStatePropertyDelegate<MouseCursor>? _mouseCursor;
/// Stores `_padding` state/configuration for this implementation.
  final ButtonStatePropertyDelegate<EdgeInsetsGeometry>? _padding;
/// Stores `_textStyle` state/configuration for this implementation.
  final ButtonStatePropertyDelegate<TextStyle>? _textStyle;
/// Stores `_iconTheme` state/configuration for this implementation.
  final ButtonStatePropertyDelegate<IconThemeData>? _iconTheme;
/// Stores `_margin` state/configuration for this implementation.
  final ButtonStatePropertyDelegate<EdgeInsetsGeometry>? _margin;
/// Stores `_delegate` state/configuration for this implementation.
  final AbstractButtonStyle _delegate;

/// Creates a `CopyWithButtonStyle` instance.
  const CopyWithButtonStyle(
    this._delegate,
    this._decoration,
    this._mouseCursor,
    this._padding,
    this._textStyle,
    this._iconTheme,
    this._margin,
  );

  @override
  ButtonStateProperty<IconThemeData> get iconTheme {
    if (_iconTheme == null) {
      return _delegate.iconTheme;
    }
    return _buildIconTheme;
  }

/// Executes `_buildIconTheme` behavior for this component/composite.
  IconThemeData _buildIconTheme(BuildContext context, Set<WidgetState> states) {
    return _iconTheme!(context, states, _delegate.iconTheme(context, states));
  }

  @override
  ButtonStateProperty<TextStyle> get textStyle {
    if (_textStyle == null) {
      return _delegate.textStyle;
    }
    return _buildTextStyle;
  }

/// Executes `_buildTextStyle` behavior for this component/composite.
  TextStyle _buildTextStyle(BuildContext context, Set<WidgetState> states) {
    return _textStyle!(context, states, _delegate.textStyle(context, states));
  }

  @override
  ButtonStateProperty<EdgeInsetsGeometry> get padding {
    if (_padding == null) {
      return _delegate.padding;
    }
    return _buildPadding;
  }

  EdgeInsetsGeometry _buildPadding(
    BuildContext context,
    Set<WidgetState> states,
  ) {
    return _padding!(context, states, _delegate.padding(context, states));
  }

  @override
  ButtonStateProperty<MouseCursor> get mouseCursor {
    if (_mouseCursor == null) {
      return _delegate.mouseCursor;
    }
    return _buildMouseCursor;
  }

/// Executes `_buildMouseCursor` behavior for this component/composite.
  MouseCursor _buildMouseCursor(BuildContext context, Set<WidgetState> states) {
    return _mouseCursor!(
      context,
      states,
/// Creates a `_delegate.mouseCursor` instance.
      _delegate.mouseCursor(context, states),
    );
  }

  @override
  ButtonStateProperty<Decoration> get decoration {
    if (_decoration == null) {
      return _delegate.decoration;
    }
    return _buildDecoration;
  }

/// Executes `_buildDecoration` behavior for this component/composite.
  Decoration _buildDecoration(BuildContext context, Set<WidgetState> states) {
    return _decoration!(context, states, _delegate.decoration(context, states));
  }

  @override
  ButtonStateProperty<EdgeInsetsGeometry> get margin {
    if (_margin == null) {
      return _delegate.margin;
    }
    return _buildMargin;
  }

  EdgeInsetsGeometry _buildMargin(
    BuildContext context,
    Set<WidgetState> states,
  ) {
    return _margin!(context, states, _delegate.margin(context, states));
  }

  @override
/// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CopyWithButtonStyle &&
        other._delegate == _delegate &&
        other._decoration == _decoration &&
        other._mouseCursor == _mouseCursor &&
        other._padding == _padding &&
        other._textStyle == _textStyle &&
        other._iconTheme == _iconTheme &&
        other._margin == _margin;
  }

  @override
  int get hashCode {
    return Object.hash(
      _delegate,
      _decoration,
      _mouseCursor,
      _padding,
      _textStyle,
      _iconTheme,
      _margin,
    );
  }

  @override
/// Executes `toString` behavior for this component/composite.
  String toString() {
    return 'CopyWithButtonStyle(_delegate: $_delegate, _decoration: $_decoration, _mouseCursor: $_mouseCursor, _padding: $_padding, _textStyle: $_textStyle, _iconTheme: $_iconTheme, _margin: $_margin)';
  }
}
