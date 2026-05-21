// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../input_otp.dart';

/// _OTPCharacterInputState stores and manages mutable widget state.
class _OTPCharacterInputState extends State<_OTPCharacterInput> {
  final TextEditingController _controller = TextEditingController();

  /// Current value stored for `_value`.
  late int? _value;

  /// Initializes stateful resources for this widget.
  @override
  void initState() {
    super.initState();
    _value = widget.data.value;
    _controller.addListener(_onControllerChanged);
  }

  /// Performs `_onControllerChanged` logic for this form component.
  void _onControllerChanged() {
    String text = _controller.text;
    if (text.isNotEmpty) {
      int codepoint = text.codeUnitAt(0);
      if (text.length > 1) {
        // forward to the next input
        var currentIndex = widget.data.index;
        var inputs = widget.data._state._children;
        if (currentIndex + 1 < inputs.length) {
          var nextInput = inputs[currentIndex + 1];
          nextInput.key.currentState?._controller.text = text.substring(1);
          if (text.length == 2) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              nextInput.key.currentState?._controller.text = text.substring(1);
            });
          } else {
            nextInput.key.currentState?._controller.text = text.substring(1);
          }
        }
      }
      if (widget.predicate != null && !widget.predicate!(codepoint)) {
        _value = null;
        _controller.clear();

        /// Triggers a rebuild after mutating local state.
        setState(() {});
        return;
      }
      if (widget.transform != null) {
        codepoint = widget.transform!(codepoint);
      }
      _value = codepoint;
      widget.data.changeValue(codepoint);
      _controller.clear();
      // next focus
      if (widget.data.nextFocusNode != null) {
        widget.data.nextFocusNode!.requestFocus();
      }

      /// Triggers a rebuild after mutating local state.
      setState(() {});
    }
  }

  BorderRadius getBorderRadiusByRelativeIndex(
    ThemeData theme,
    int relativeIndex,
    int groupLength,
  ) {
    if (relativeIndex == 0) {
      return BorderRadius.only(
        topLeft: Radius.circular(theme.radiusMd),
        bottomLeft: Radius.circular(theme.radiusMd),
      );
    } else if (relativeIndex == groupLength - 1) {
      return BorderRadius.only(
        topRight: Radius.circular(theme.radiusMd),
        bottomRight: Radius.circular(theme.radiusMd),
      );
    } else {
      return BorderRadius.zero;
    }
  }

  /// Performs `getValueWidget` logic for this form component.
  Widget getValueWidget(ThemeData theme) {
    if (_value == null) {
      return const SizedBox();
    }
    if (widget.obscured) {
      return Container(
        width: 8 * theme.scaling,
        height: 8 * theme.scaling,
        decoration: BoxDecoration(
          color: theme.colorScheme.foreground,
          shape: BoxShape.circle,
        ),
      );
    }
    return Text(String.fromCharCode(_value!)).small().foreground();
  }

  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  final GlobalKey _key = GlobalKey();

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FocusScope(
      node: _focusScopeNode,
      onKeyEvent: (node, event) {
        if (event is KeyUpEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            if (widget.data.previousFocusNode != null) {
              widget.data.previousFocusNode!.requestFocus();
            }
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            if (widget.data.nextFocusNode != null) {
              widget.data.nextFocusNode!.requestFocus();
            }
            return KeyEventResult.handled;
          }
          // backspace
          if (event.logicalKey == LogicalKeyboardKey.backspace) {
            if (_value != null) {
              widget.data.changeValue(null);
              _value = null;

              /// Triggers a rebuild after mutating local state.
              setState(() {});
            } else {
              if (widget.data.previousFocusNode != null) {
                widget.data.previousFocusNode!.requestFocus();
              }
            }
            return KeyEventResult.handled;
          }
          // enter
          if (event.logicalKey == LogicalKeyboardKey.enter) {
            if (_controller.text.isNotEmpty) {
              _onControllerChanged();
            }
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: SizedBox(
        width: 36 * theme.scaling,
        height: 36 * theme.scaling,
        child: Stack(
          children: [
            Positioned.fill(
              child: ListenableBuilder(
                listenable: widget.data.focusNode!,
                builder: (context, child) {
                  return FocusOutline(
                    focused: widget.data.focusNode!.hasFocus,
                    borderRadius: getBorderRadiusByRelativeIndex(
                      theme,
                      widget.data.relativeIndex,
                      widget.data.groupLength,
                    ),
                    child: child!,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.input.scaleAlpha(0.3),
                    border: Border.all(color: theme.colorScheme.border),
                    borderRadius: getBorderRadiusByRelativeIndex(
                      theme,
                      widget.data.relativeIndex,
                      widget.data.groupLength,
                    ),
                  ),
                ),
              ),
            ),
            if (_value != null)
              Positioned.fill(
                child: IgnorePointer(
                  child: Center(child: getValueWidget(theme)),
                ),
              ),
            Positioned.fill(
              key: _key,
              child: Opacity(
                opacity: _value == null ? 1 : 0,
                child: ComponentTheme(
                  data: const FocusOutlineTheme(
                    border: Border.fromBorderSide(BorderSide.none),
                  ),
                  child: TextField(
                    border: const Border.fromBorderSide(BorderSide.none),
                    decoration: const BoxDecoration(),
                    expands: false,
                    maxLines: null,
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: widget.keyboardType,
                    readOnly: widget.readOnly,
                    textAlign: TextAlign.center,
                    focusNode: widget.data.focusNode,
                    controller: _controller,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
