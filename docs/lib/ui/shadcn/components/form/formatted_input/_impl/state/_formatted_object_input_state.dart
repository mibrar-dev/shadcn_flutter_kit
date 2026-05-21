// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../formatted_input.dart';

/// _FormattedObjectInputState stores and manages mutable widget state.
class _FormattedObjectInputState<T> extends State<FormattedObjectInput<T>> {
  /// Controller used to coordinate `_formattedController` behavior.
  late FormattedInputController _formattedController;

  /// Controller used to coordinate `_controller` behavior.
  late ComponentController<T?> _controller;

  final _popoverController = PopoverController();

  bool _updating = false; // to prevent circular updates

  /// Initializes stateful resources for this widget.
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? _FormattedObjectController<T>();
    List<String?> values = widget.converter.convertA(
      widget.initialValue ?? widget.controller?.value,
    );
    List<FormattedValuePart> valueParts = [];
    int partIndex = 0;
    for (var i = 0; i < widget.parts.length; i++) {
      var part = widget.parts[i];
      if (part.canHaveValue) {
        var value = values[partIndex];
        if (value != null) {
          valueParts.add(part.withValue(value));
        } else {
          valueParts.add(FormattedValuePart(part));
        }
        partIndex++;
      } else {
        valueParts.add(FormattedValuePart(part));
      }
    }
    _formattedController = FormattedInputController(FormattedValue(valueParts));
    _formattedController.addListener(_onFormattedControllerUpdate);
    _controller.addListener(_onControllerUpdate);
  }

  /// Reacts to widget configuration updates from the parent.
  @override
  void didUpdateWidget(covariant FormattedObjectInput<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.parts, oldWidget.parts)) {
      List<String?> values = widget.converter.convertA(_controller.value);
      List<FormattedValuePart> valueParts = [];
      List<FormattedValuePart> oldValues = _formattedController.value.values
          .toList();
      int partIndex = 0;
      for (var i = 0; i < widget.parts.length; i++) {
        var part = widget.parts[i];
        if (part.canHaveValue) {
          var value = values[partIndex];
          if (value != null) {
            valueParts.add(part.withValue(value));
          } else {
            var oldValue = partIndex < oldValues.length
                ? oldValues[partIndex]
                : null;
            if (oldValue != null) {
              valueParts.add(oldValue);
            } else {
              valueParts.add(FormattedValuePart(part));
            }
          }
          partIndex++;
        } else {
          valueParts.add(FormattedValuePart(part));
        }
      }
      _updating = true;
      try {
        _formattedController.value = FormattedValue(valueParts);
      } finally {
        _updating = false;
      }
    }
  }

  /// Performs `_onFormattedControllerUpdate` logic for this form component.
  void _onFormattedControllerUpdate() {
    if (_updating) return;
    _updating = true;
    try {
      var value = _formattedController.value;
      T? newValue = widget.converter.convertB(
        value.values.map((part) {
          return part.value ?? '';
        }).toList(),
      );
      _controller.value = newValue;
      widget.onChanged?.call(newValue);
    } finally {
      _updating = false;
    }
  }

  /// Performs `_onControllerUpdate` logic for this form component.
  void _onControllerUpdate() {
    if (_updating) return;
    _updating = true;
    try {
      List<String?> values = widget.converter.convertA(_controller.value);
      List<FormattedValuePart> valueParts = [];
      int partIndex = 0;
      List<FormattedValuePart> oldValues = _formattedController.value.values
          .toList();
      for (var i = 0; i < widget.parts.length; i++) {
        var part = widget.parts[i];
        if (part.canHaveValue) {
          var value = values[partIndex];
          if (value != null) {
            valueParts.add(part.withValue(value));
          } else {
            var oldValue = partIndex < oldValues.length
                ? oldValues[partIndex]
                : null;
            if (oldValue != null) {
              valueParts.add(oldValue);
            } else {
              valueParts.add(FormattedValuePart(part));
            }
          }
          partIndex++;
        } else {
          valueParts.add(FormattedValuePart(part));
        }
      }
      _formattedController.value = FormattedValue(valueParts);
      widget.onChanged?.call(_controller.value);
    } finally {
      _updating = false;
    }
  }

  /// Performs `_openPopover` logic for this form component.
  void _openPopover() {
    var popupBuilder = widget.popupBuilder;
    if (popupBuilder == null) {
      return;
    }
    final theme = Theme.of(context);
    _popoverController.show(
      context: context,
      alignment: widget.popoverAlignment ?? AlignmentDirectional.topStart,
      anchorAlignment:
          widget.popoverAnchorAlignment ?? AlignmentDirectional.bottomStart,
      offset: widget.popoverOffset ?? (const Offset(0, 4) * theme.scaling),
      builder: (context) {
        return popupBuilder(context, _controller);
      },
    );
  }

  /// Releases resources owned by this state object.
  @override
  void dispose() {
    _formattedController.dispose();
    super.dispose();
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    var popoverIcon = widget.popoverIcon;
    return FormattedInput(
      controller: _formattedController,
      onChanged: (value) {
        List<String> values = value.values.map((part) {
          return part.value ?? '';
        }).toList();
        widget.onPartsChanged?.call(values);
        T? newValue = widget.converter.convertB(values);
        _controller.value = newValue;
      },
      trailing: popoverIcon == null
          ? null
          : ListenableBuilder(
              listenable: _popoverController,
              builder: (context, child) {
                return WidgetStatesProvider(
                  states: {
                    if (_popoverController.hasOpenPopover) WidgetState.hovered,
                  },
                  child: child!,
                );
              },
              child: IconButton.text(
                icon: popoverIcon,
                density: ButtonDensity.compact,
                onPressed: _openPopover,
              ),
            ),
    );
  }
}
