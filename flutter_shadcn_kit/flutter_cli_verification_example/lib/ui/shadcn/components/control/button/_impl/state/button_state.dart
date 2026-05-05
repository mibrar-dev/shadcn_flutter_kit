import 'package:data_widget/data_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import '../../../../../shared/primitives/clickable.dart';
import '../../../../../shared/theme/theme.dart';
import '../../../../../shared/utils/geometry_extensions.dart';
import '../../../../../shared/utils/platform_utils.dart';
import '../styles/button_overrides.dart';
import '../styles/button_style.dart';
import '../extensions/button_style_extension.dart';
import '../core/button_widget.dart';

/// ButtonState defines a reusable type for this registry module.
class ButtonState<T extends Button> extends State<T> {
  bool get _shouldEnableFeedback {
    final theme = Theme.of(context);
    if (theme.enableFeedback != null) {
      return theme.enableFeedback!;
    }
    return isMobile(theme.platform);
  }

/// Stores `_style` state/configuration for this implementation.
  AbstractButtonStyle? _style;
/// Stores `_overrideData` state/configuration for this implementation.
  ButtonStyleOverrideData? _overrideData;

  @override
/// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    _style = widget.style;
  }

  @override
/// Executes `didChangeDependencies` behavior for this component/composite.
  void didChangeDependencies() {
    super.didChangeDependencies();
    var overrideData = Data.maybeOf<ButtonStyleOverrideData>(context);
    if (overrideData != _overrideData) {
      _overrideData = overrideData;
      if (overrideData != null) {
        _style = widget.style.copyWith(
          decoration: overrideData.decoration,
          mouseCursor: overrideData.mouseCursor,
          padding: overrideData.padding,
          textStyle: overrideData.textStyle,
          iconTheme: overrideData.iconTheme,
          margin: overrideData.margin,
        );
      } else {
        _style = widget.style;
      }
    }
  }

  @override
/// Executes `didUpdateWidget` behavior for this component/composite.
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.style != oldWidget.style) {
/// Stores `overrideData` state/configuration for this implementation.
      var overrideData = _overrideData;
      if (overrideData != null) {
        _style = widget.style.copyWith(
          decoration: overrideData.decoration,
          mouseCursor: overrideData.mouseCursor,
          padding: overrideData.padding,
          textStyle: overrideData.textStyle,
          iconTheme: overrideData.iconTheme,
          margin: overrideData.margin,
        );
      } else {
        _style = widget.style;
      }
    }
  }

/// Executes `_resolveMargin` behavior for this component/composite.
  EdgeInsetsGeometry _resolveMargin(Set<WidgetState> states) {
    return _style!.margin(context, states);
  }

/// Executes `_resolveDecoration` behavior for this component/composite.
  Decoration _resolveDecoration(Set<WidgetState> states) {
    return _style!.decoration(context, states);
  }

/// Executes `_resolveMouseCursor` behavior for this component/composite.
  MouseCursor _resolveMouseCursor(Set<WidgetState> states) {
    return _style!.mouseCursor(context, states);
  }

/// Executes `_resolvePadding` behavior for this component/composite.
  EdgeInsetsGeometry _resolvePadding(Set<WidgetState> states) {
    return _style!.padding(context, states);
  }

/// Executes `_resolveTextStyle` behavior for this component/composite.
  TextStyle _resolveTextStyle(Set<WidgetState> states) {
    return _style!.textStyle(context, states);
  }

/// Executes `_resolveIconTheme` behavior for this component/composite.
  IconThemeData _resolveIconTheme(Set<WidgetState> states) {
    return _style!.iconTheme(context, states);
  }

  @override
/// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
/// Stores `enableFeedback` state/configuration for this implementation.
    bool enableFeedback = widget.enableFeedback ?? _shouldEnableFeedback;
    return Clickable(
      disableFocusOutline: widget.disableFocusOutline,
      statesController: widget.statesController,
      focusNode: widget.focusNode,
      enabled: widget.enabled ?? widget.onPressed != null,
      marginAlignment: widget.marginAlignment,
      disableTransition: widget.disableTransition,
      onHover: widget.onHover,
      onFocus: widget.onFocus,
      disableHoverEffect: widget.disableHoverEffect,
      enableFeedback: enableFeedback,
      margin: WidgetStateProperty.resolveWith(_resolveMargin),
      decoration: WidgetStateProperty.resolveWith(_resolveDecoration),
      mouseCursor: WidgetStateProperty.resolveWith(_resolveMouseCursor),
      padding: WidgetStateProperty.resolveWith(_resolvePadding),
      textStyle: WidgetStateProperty.resolveWith(_resolveTextStyle),
      iconTheme: WidgetStateProperty.resolveWith(_resolveIconTheme),
      transform: enableFeedback
          ? WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                // scale down to 95% with alignment at center
                return Matrix4.identity()..scaleByDouble(0.95, 0.95, 0.95, 1);
              }
              return null;
            })
          : null,
      onPressed: widget.onPressed,
      onTapDown: widget.onTapDown,
      onTapUp: widget.onTapUp,
      onTapCancel: widget.onTapCancel,
      onSecondaryTapDown: widget.onSecondaryTapDown,
      onSecondaryTapUp: widget.onSecondaryTapUp,
      onSecondaryTapCancel: widget.onSecondaryTapCancel,
      onTertiaryTapDown: widget.onTertiaryTapDown,
      onTertiaryTapUp: widget.onTertiaryTapUp,
      onTertiaryTapCancel: widget.onTertiaryTapCancel,
      onLongPressStart: widget.onLongPressStart,
      onLongPressUp: widget.onLongPressUp,
      onLongPressMoveUpdate: widget.onLongPressMoveUpdate,
      onLongPressEnd: widget.onLongPressEnd,
      onSecondaryLongPress: widget.onSecondaryLongPress,
      onTertiaryLongPress: widget.onTertiaryLongPress,
      child: widget.leading == null && widget.trailing == null
          ? Align(
              heightFactor: 1,
              widthFactor: 1,
              alignment: widget.alignment ?? Alignment.center,
              child: widget.child,
            )
          : IntrinsicWidth(
              child: IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.leading != null) widget.leading!,
                    if (widget.leading != null) DensityGap(gapSm),
/// Creates a `Expanded` instance.
                    Expanded(
                      child: Align(
                        widthFactor: 1,
                        heightFactor: 1,
                        alignment:
                            widget.alignment ??
                            AlignmentDirectional.centerStart,
                        child: widget.child,
                      ),
                    ),
                    if (widget.trailing != null) DensityGap(gapSm),
                    if (widget.trailing != null) widget.trailing!,
                  ],
                ),
              ),
            ),
    );
  }
}

/// Defines the relative size scaling for button components.
///
/// [ButtonSize] controls the overall scale of buttons, affecting text size,
/// icon size, and proportional padding. The scaling factor is applied to
/// all dimensional properties to maintain visual consistency.
///
/// Example:
/// ```dart
/// Button.primary(
///   style: ButtonStyle.primary().copyWith(size: ButtonSize.large),
///   child: Text('Large Button'),
/// );
/// ```
