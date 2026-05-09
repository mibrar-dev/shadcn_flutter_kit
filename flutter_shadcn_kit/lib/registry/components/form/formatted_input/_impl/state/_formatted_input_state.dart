// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../formatted_input.dart';

/// _FormattedInputState stores and manages mutable widget state.
class _FormattedInputState extends State<FormattedInput> {
  final FormController _controller = FormController();

  /// Focus node/reference used by `_hasFocus` interactions.
  bool _hasFocus = false;

  /// Current value stored for `_value`.
  FormattedValue? _value;

  /// Focus node/reference used by `_focusNodes` interactions.
  late List<FocusNode> _focusNodes;

  /// Initializes stateful resources for this widget.
  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? widget.controller?.value;
    _controller.addListener(_notifyChanged);
    int partIndex = 0;
    if (_value != null) {
      for (var part in _value!.parts) {
        if (part.part.canHaveValue) {
          partIndex++;
        }
      }
    }
    _focusNodes = _allocateFocusNodes(partIndex);
  }

  List<FocusNode> _allocateFocusNodes(
    int newLength, [
    List<FocusNode>? oldNodes,
  ]) {
    if (oldNodes == null) {
      return List.generate(newLength, (index) => FocusNode());
    }
    if (newLength == oldNodes.length) {
      return oldNodes;
    }
    if (newLength < oldNodes.length) {
      for (var i = newLength; i < oldNodes.length; i++) {
        oldNodes[i].dispose();
      }
      return oldNodes.sublist(0, newLength);
    }
    return [
      ...oldNodes,
      ...List.generate(newLength - oldNodes.length, (index) => FocusNode()),
    ];
  }

  /// Performs `_buildPart` logic for this form component.
  Widget _buildPart(int index, InputPart part) {
    var formattedInputData = FormattedInputData(
      partIndex: index,
      initialValue: index < 0 ? null : (_value?[index]?.value ?? ''),
      enabled: widget.enabled,
      controller: widget.controller,
      focusNode: index < 0 ? null : _focusNodes[index],
      focusNodes: _focusNodes,
    );
    return part.build(context, formattedInputData);
  }

  /// Field storing `_updating` for this form implementation.
  bool _updating = false;

  /// Performs `_notifyChanged` logic for this form component.
  void _notifyChanged() {
    if (_updating) {
      return;
    }
    _updating = true;
    try {
      List<FormattedValuePart> parts = [];
      var values = _controller.values;
      var value = _value;
      if (value != null) {
        int partIndex = 0;
        for (var i = 0; i < value.parts.length; i++) {
          var part = value.parts[i];
          if (part.part.canHaveValue) {
            FormKey key = FormKey(partIndex);
            var val = values[key];
            parts.add(part.withValue(val as String? ?? ''));
            partIndex++;
          } else {
            parts.add(part);
          }
        }
        _focusNodes = _allocateFocusNodes(partIndex, _focusNodes);
      } else {
        _focusNodes = _allocateFocusNodes(0, _focusNodes);
      }
      var newValue = FormattedValue(parts);
      if (widget.onChanged != null && newValue != _value) {
        widget.onChanged!(newValue);
      }
    } finally {
      _updating = false;
    }
  }

  /// Releases resources owned by this state object.
  @override
  void dispose() {
    _controller.dispose();
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<Widget> children = [];
    if (_value != null) {
      int partIndex = 0;
      for (var part in _value!.parts) {
        if (part.part.canHaveValue) {
          children.add(_buildPart(partIndex, part.part));
          partIndex++;
        } else {
          children.add(_buildPart(-1, part.part));
        }
      }
    }
    final compTheme = ComponentTheme.maybeOf<FormattedInputTheme>(context);
    return SizedBox(
      height: (compTheme?.height ?? kTextFieldHeight) * theme.scaling, // 32 + 2
      child: TextFieldTapRegion(
        child: Focus(
          onFocusChange: (hasFocus) {
            /// Triggers a rebuild after mutating local state.
            setState(() {
              _hasFocus = hasFocus;
            });
          },
          child: FocusOutline(
            focused: _hasFocus,
            borderRadius: theme.borderRadiusMd,
            child: OutlinedContainer(
              borderRadius: theme.borderRadiusMd,
              borderColor: theme.colorScheme.border,
              backgroundColor: theme.colorScheme.input.scaleAlpha(0.3),
              padding:
                  compTheme?.padding ??
                  EdgeInsets.symmetric(
                    horizontal: theme.density.baseGap * theme.scaling * 0.75,
                  ),
              child: Form(
                controller: _controller,
                child: FocusTraversalGroup(
                  policy: WidgetOrderTraversalPolicy(),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (widget.leading != null) widget.leading!,
                        ...children,
                        if (widget.trailing != null) widget.trailing!,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
