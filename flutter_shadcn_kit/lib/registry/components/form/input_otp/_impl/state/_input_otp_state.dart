// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../input_otp.dart';

/// _InputOTPState stores and manages mutable widget state.
class _InputOTPState extends State<InputOTP>
    with FormValueSupplier<OTPCodepointList, InputOTP> {
  final List<_InputOTPChild> _children = [];

  OTPCodepointList get value {
    return _children.map((e) => e.value).toList();
  }

  /// Performs `_changeValue` logic for this form component.
  void _changeValue(int index, int? value) {
    _children[index].value = value;
    var val = this.value;
    if (widget.onChanged != null) {
      widget.onChanged!(val);
    }
    if (widget.onSubmitted != null) {
      if (val.every((e) => e != null)) {
        widget.onSubmitted?.call(val);
      }
    }
    formValue = this.value;
  }

  /// Initializes stateful resources for this widget.
  @override
  void initState() {
    super.initState();
    int index = 0;
    int groupIndex = 0;
    int relativeIndex = 0;
    for (final child in widget.children) {
      if (child.hasValue) {
        int? value = getInitialValue(index);
        _children.add(
          _InputOTPChild(
            focusNode: FocusNode(),
            child: child,
            value: value,
            groupIndex: groupIndex,
            relativeIndex: relativeIndex,
          ),
        );
        index++;
        relativeIndex++;
      } else {
        // update previous group length
        for (int i = 0; i < index; i++) {
          _children[i].groupLength = relativeIndex;
        }
        groupIndex++;
        relativeIndex = 0;
      }
    }
    for (int i = index - relativeIndex; i < index; i++) {
      _children[i].groupLength = relativeIndex;
    }
    formValue = value;
  }

  /// Performs `getInitialValue` logic for this form component.
  int? getInitialValue(int index) {
    if (widget.initialValue != null && index < widget.initialValue!.length) {
      return widget.initialValue![index];
    }
    return null;
  }

  /// Reacts to widget configuration updates from the parent.
  @override
  void didUpdateWidget(covariant InputOTP oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.initialValue, widget.initialValue) ||
        !listEquals(oldWidget.children, widget.children)) {
      int index = 0;
      int groupIndex = 0;
      int relativeIndex = 0;
      for (final child in widget.children) {
        if (child.hasValue) {
          if (index < _children.length) {
            _children[index] = _InputOTPChild.withNewChild(
              _children[index],
              child,
            );
          } else {
            _children.add(
              _InputOTPChild(
                focusNode: FocusNode(),
                child: child,
                value: getInitialValue(index),
                groupIndex: groupIndex,
                relativeIndex: relativeIndex,
              ),
            );
          }
          index++;
          relativeIndex++;
        } else {
          // update previous group length
          for (int i = index - relativeIndex; i < index; i++) {
            _children[i].groupLength = relativeIndex;
          }
          groupIndex++;
          relativeIndex = 0;
        }
      }
      for (int i = index - relativeIndex; i < index; i++) {
        _children[i].groupLength = relativeIndex;
      }
      formValue = value;
    }
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<Widget> children = [];
    int i = 0;
    for (final child in widget.children) {
      if (child.hasValue) {
        children.add(
          child.build(
            context,
            InputOTPChildData._(
              this,
              _children[i].key,
              focusNode: _children[i].focusNode,
              index: i,
              groupIndex: _children[i].groupIndex,
              relativeIndex: _children[i].relativeIndex,
              previousFocusNode: i == 0 ? null : _children[i - 1].focusNode,
              nextFocusNode: i == _children.length - 1
                  ? null
                  : _children[i + 1].focusNode,
              value: _children[i].value,
              groupLength: _children[i].groupLength,
            ),
          ),
        );
        i++;
      } else {
        children.add(
          child.build(
            context,
            InputOTPChildData._(
              this,
              null,
              focusNode: null,
              index: -1,
              groupIndex: -1,
              relativeIndex: -1,
              previousFocusNode: null,
              nextFocusNode: null,
              value: null,
              groupLength: -1,
            ),
          ),
        );
      }
    }
    final compTheme = ComponentTheme.maybeOf<InputOTPTheme>(context);
    return SizedBox(
      height: compTheme?.height ?? theme.scaling * 36,
      child: IntrinsicWidth(
        child: Row(
          children: [for (final child in children) Expanded(child: child)],
        ),
      ),
    );
  }

  /// Performs `didReplaceFormValue` logic for this form component.
  @override
  void didReplaceFormValue(OTPCodepointList value) {
    widget.onChanged?.call(value);
  }
}
