import 'package:flutter/widgets.dart';

import '../../../../../shared/primitives/clickable.dart';
import '../../../../../shared/primitives/form_control.dart';
import '../../../../../shared/primitives/form_value_supplier.dart';
import '../../../../../shared/theme/theme.dart';
import '../styles/button_state_property.dart';
import '../styles/button_style_class.dart';
import '../extensions/button_style_extension.dart';
import '../core/button_widget.dart';
import 'toggle_controller.dart';
import '../core/toggle_widget.dart';

/// ToggleState defines a reusable type for this registry module.
class ToggleState extends State<Toggle> with FormValueSupplier<bool, Toggle> {
  /// Controller for managing widget interaction states.
  final WidgetStatesController statesController = WidgetStatesController();

  @override
/// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    statesController.update(WidgetState.selected, widget.value);
    formValue = widget.value;
  }

  @override
/// Executes `didUpdateWidget` behavior for this component/composite.
  void didUpdateWidget(Toggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      statesController.update(WidgetState.selected, widget.value);
      formValue = widget.value;
    }
  }

  @override
/// Executes `didReplaceFormValue` behavior for this component/composite.
  void didReplaceFormValue(bool value) {
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  @override
/// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Button(
      statesController: statesController,
      enabled: widget.enabled,
      style: widget.value
          ? ButtonStyle.secondary(
              density: widget.style.density,
              shape: widget.style.shape,
              size: widget.style.size,
            )
          : widget.style.copyWith(
              textStyle: (context, states, value) {
                final theme = Theme.of(context);
                return value.copyWith(
                  color: states.contains(WidgetState.hovered)
                      ? theme.colorScheme.mutedForeground
                      : null,
                );
              },
              iconTheme: (context, states, value) {
                final theme = Theme.of(context);
                return value.copyWith(
                  color: states.contains(WidgetState.hovered)
                      ? theme.colorScheme.mutedForeground
                      : null,
                );
              },
            ),
      onPressed: widget.onChanged != null
          ? () {
              widget.onChanged!(!widget.value);
            }
          : null,
      child: widget.child,
    );
  }
}
