import 'package:flutter/widgets.dart';

import '../../../../../shared/primitives/clickable.dart';
import '../../../../../shared/primitives/form_control.dart';
import '../../../../../shared/primitives/form_value_supplier.dart';
import '../../../../../shared/theme/theme.dart';
import '../styles/button_state_property.dart';
import '../styles/button_style_class.dart';
import '../core/button_widget.dart';
import '../variants/selected_button_widget.dart';

/// SelectedButtonState defines a reusable type for this registry module.
class SelectedButtonState extends State<SelectedButton> {
  /// The controller managing widget states (selected, hovered, focused, etc.).
  ///
  /// This controller is either provided via [SelectedButton.statesController]
  /// or created automatically. It tracks and manages the button's interactive
  /// states and updates them based on user interactions and the selection value.
  late WidgetStatesController statesController;
  @override
/// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    statesController = widget.statesController ?? WidgetStatesController();
    statesController.update(WidgetState.selected, widget.value);
  }

  @override
/// Executes `didUpdateWidget` behavior for this component/composite.
  void didUpdateWidget(SelectedButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.statesController != widget.statesController) {
      statesController = widget.statesController ?? WidgetStatesController();
      statesController.update(WidgetState.selected, widget.value);
    }
    if (oldWidget.value != widget.value) {
      statesController.update(WidgetState.selected, widget.value);
    }
  }

  @override
/// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Button(
      statesController: statesController,
      enabled: widget.enabled,
      style: widget.value ? widget.selectedStyle : widget.style,
      alignment: widget.alignment,
      marginAlignment: widget.marginAlignment,
      disableTransition: widget.disableTransition,
      onHover: widget.onHover,
      onFocus: widget.onFocus,
      enableFeedback: widget.enableFeedback,
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
      disableHoverEffect: widget.disableHoverEffect,
      onPressed: () {
        if (widget.onChanged != null) {
          widget.onChanged!(!widget.value);
        }
        if (widget.onPressed != null) {
          widget.onPressed!();
        }
      },
      child: widget.child,
    );
  }
}
