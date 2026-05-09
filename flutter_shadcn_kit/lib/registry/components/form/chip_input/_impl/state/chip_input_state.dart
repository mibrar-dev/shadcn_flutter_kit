// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../chip_input.dart';

/// State class for [ChipInput].
///
/// Manages the chip input's internal state and chip rendering.
class ChipInputState<T> extends State<ChipInput<T>>
    with FormValueSupplier<List<T>, ChipInput<T>>
    implements _ChipProvider<T> {
  late ChipEditingController<T> _controller;

  /// Performs `buildChip` logic for this form component.
  @override
  Widget? buildChip(BuildContext context, T chip) {
    return _chipBuilder(chip);
  }

  bool get _useChips {
    final compTheme = ComponentTheme.maybeOf<ChipInputTheme>(context);
    return styleValue<bool>(
      widgetValue: widget.useChips,
      themeValue: compTheme?.useChips,
      defaultValue: true,
    );
  }

  /// Initializes stateful resources for this widget.
  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        ChipEditingController<T>(
          initialChips: widget.initialChips,
          text: widget.initialValue ?? '',
        );
    _controller.addListener(_onTextChanged);
    formValue = widget.controller?.chips ?? [];
  }

  /// Performs `_onTextChanged` logic for this form component.
  void _onTextChanged() {
    formValue = _controller.chips;
  }

  /// Performs `_chipBuilder` logic for this form component.
  Widget? _chipBuilder(T chip) {
    if (!_useChips) {
      return widget.chipBuilder(context, chip);
    }
    return Chip(
      trailing: ChipButton(
        onPressed: () {
          _controller.removeChip(chip);
          widget.onChipsChanged?.call(_controller.chips);
        },
        child: const Icon(LucideIcons.x),
      ),
      child: widget.chipBuilder(context, chip),
    );
  }

  /// Reacts to widget configuration updates from the parent.
  @override
  void didUpdateWidget(covariant ChipInput<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _controller.removeListener(_onTextChanged);
      _controller = widget.controller ?? ChipEditingController<T>();
      _controller.addListener(_onTextChanged);
      formValue = _controller.chips;
    }
  }

  /// Releases resources owned by this state object.
  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    super.dispose();
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Data<_ChipProvider<T>>.inherit(
      data: this,
      child: Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.enter): const ChipSubmitIntent(),
        },
        child: Actions(
          actions: {
            if (widget.autoInsertSuggestion)
              AutoCompleteIntent: Action.overridable(
                defaultAction: CallbackAction<AutoCompleteIntent>(
                  onInvoke: (intent) {
                    final suggestion = intent.suggestion;
                    _controller.insertChipAtCursor(
                      (text) => widget.onChipSubmitted(suggestion),
                    );
                    widget.onChipsChanged?.call(_controller.chips);
                    return;
                  },
                ),
                context: context,
              ),
            ChipSubmitIntent: Action.overridable(
              defaultAction: CallbackAction<ChipSubmitIntent>(
                onInvoke: (intent) {
                  _controller.insertChipAtCursor(
                    (text) => widget.onChipSubmitted(text),
                  );
                  widget.onChipsChanged?.call(_controller.chips);
                  return;
                },
              ),
              context: context,
            ),
          },
          child: widget.copyWith(
            controller: () => _controller,
            onSubmitted: () => (value) {
              _controller.insertChipAtCursor(widget.onChipSubmitted);
            },
            onChanged: () => (text) {
              widget.onChanged?.call(_controller.plainText);
            },
          ),
        ),
      ),
    );
  }

  /// Performs `didReplaceFormValue` logic for this form component.
  @override
  void didReplaceFormValue(List<T> value) {
    widget.onChipsChanged?.call(value);
  }
}
