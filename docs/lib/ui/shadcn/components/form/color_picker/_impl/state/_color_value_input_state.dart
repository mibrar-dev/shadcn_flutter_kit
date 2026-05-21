// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../color_picker.dart';

/// _ColorValueInputState stores and manages mutable widget state.
class _ColorValueInputState extends State<_ColorValueInput> {
  /// Controller used to coordinate `_controller` behavior.
  late TextEditingController _controller;

  /// Focus node/reference used by `_focused` interactions.
  bool _focused = false;

  /// Initializes stateful resources for this widget.
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  /// Reacts to widget configuration updates from the parent.
  @override
  void didUpdateWidget(covariant _ColorValueInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && !_focused) {
      _controller.text = widget.value;
    }
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) {
        /// Triggers a rebuild after mutating local state.
        setState(() {
          _focused = focused;
        });
      },
      child: TextField(
        placeholder: widget.placeholder,
        keyboardType: widget.keyboardType,
        controller: _controller,
        onChanged: widget.onChanged != null
            ? (val) {
                if (_focused) {
                  widget.onChanged!(val);
                }
              }
            : null,
        inputFormatters: widget.inputFormatters,
      ),
    );
  }
}
