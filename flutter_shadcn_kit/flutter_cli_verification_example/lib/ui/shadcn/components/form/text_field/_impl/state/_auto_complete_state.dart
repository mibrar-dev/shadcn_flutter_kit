part of '../../text_field.dart';

/// _AutoCompleteState stores and manages mutable widget state.
class _AutoCompleteState extends State<AutoComplete> {
  final ValueNotifier<List<String>> _suggestions = ValueNotifier([]);
  final ValueNotifier<int> _selectedIndex = ValueNotifier(-1);
  final PopoverController _popoverController = PopoverController();

  /// Focus node/reference used by `_isFocused` interactions.
  bool _isFocused = false;

  AutoCompleteMode get _mode {
    final compTheme = ComponentTheme.maybeOf<AutoCompleteTheme>(context);
    return styleValue(
      widgetValue: widget.mode,
      themeValue: compTheme?.mode,
      defaultValue: AutoCompleteMode.replaceWord,
    );
  }

  /// Initializes stateful resources for this widget.
  @override
  void initState() {
    super.initState();
    _suggestions.addListener(_onSuggestionsChanged);
    if (widget.suggestions.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        _suggestions.value = widget.suggestions;
        _selectedIndex.value = widget.suggestions.isEmpty ? -1 : 0;
      });
    }
  }

  /// Performs `_onSuggestionsChanged` logic for this form component.
  void _onSuggestionsChanged() {
    if ((_suggestions.value.isEmpty && _popoverController.hasOpenPopover) ||
        !_isFocused) {
      _popoverController.close();
    } else if (!_popoverController.hasOpenPopover &&
        _suggestions.value.isNotEmpty) {
      final compTheme = ComponentTheme.maybeOf<AutoCompleteTheme>(context);
      _selectedIndex.value = -1;
      _popoverController.show(
        context: context,
        handler: const PopoverOverlayHandler(),
        builder: (context) {
          final theme = Theme.of(context);
          final compTheme = ComponentTheme.maybeOf<AutoCompleteTheme>(context);
          final popoverConstraints = styleValue<BoxConstraints>(
            widgetValue: widget.popoverConstraints,
            themeValue: compTheme?.popoverConstraints,
            defaultValue: BoxConstraints(maxHeight: 300 * theme.scaling),
          );
          return TextFieldTapRegion(
            child: ConstrainedBox(
              constraints: popoverConstraints,
              child: SurfaceCard(
                padding: EdgeInsets.all(
                  theme.density.baseGap * theme.scaling * 0.5,
                ),
                child: AnimatedBuilder(
                  animation: Listenable.merge([_suggestions, _selectedIndex]),
                  builder: (context, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: _suggestions.value.length,
                      itemBuilder: (context, index) {
                        final suggestion = _suggestions.value[index];
                        return _AutoCompleteItem(
                          suggestion: suggestion,
                          selected: index == _selectedIndex.value,
                          onSelected: () {
                            _selectedIndex.value = index;
                            _handleProceed();
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          );
        },
        widthConstraint: styleValue(
          widgetValue: widget.popoverWidthConstraint,
          themeValue: compTheme?.popoverWidthConstraint,
          defaultValue: PopoverConstraint.anchorFixedSize,
        ),
        anchorAlignment: styleValue(
          widgetValue: widget.popoverAnchorAlignment,
          themeValue: compTheme?.popoverAnchorAlignment,
          defaultValue: AlignmentDirectional.bottomStart,
        ),
        alignment: styleValue(
          widgetValue: widget.popoverAlignment,
          themeValue: compTheme?.popoverAlignment,
          defaultValue: AlignmentDirectional.topStart,
        ),
      );
    }
  }

  /// Performs `_handleProceed` logic for this form component.
  void _handleProceed() {
    final selectedIndex = _selectedIndex.value;
    if (selectedIndex < 0 || selectedIndex >= _suggestions.value.length) {
      return;
    }
    _popoverController.close();
    var suggestion = _suggestions.value[selectedIndex];
    suggestion = widget.completer(suggestion);
    invokeActionOnFocusedWidget(AutoCompleteIntent(suggestion, _mode));
  }

  /// Reacts to widget configuration updates from the parent.
  @override
  void didUpdateWidget(covariant AutoComplete oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.suggestions, widget.suggestions)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        _suggestions.value = widget.suggestions;
        _selectedIndex.value = widget.suggestions.isEmpty ? -1 : 0;
      });
    }
  }

  /// Performs `_onFocusChanged` logic for this form component.
  void _onFocusChanged(bool focused) {
    _isFocused = focused;
    if (!focused) {
      _popoverController.close();
    }
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _selectedIndex,
      builder: (context, child) {
        return FocusableActionDetector(
          onFocusChange: _onFocusChanged,
          shortcuts: _popoverController.hasOpenPopover
              ? {
                  LogicalKeySet(LogicalKeyboardKey.arrowDown):
                      const NavigateSuggestionIntent(1),
                  LogicalKeySet(LogicalKeyboardKey.arrowUp):
                      const NavigateSuggestionIntent(-1),
                  if (widget.suggestions.isNotEmpty &&
                      _selectedIndex.value != -1)
                    LogicalKeySet(LogicalKeyboardKey.tab):
                        const AcceptSuggestionIntent(),
                }
              : null,
          actions: _popoverController.hasOpenPopover
              ? {
                  NavigateSuggestionIntent:
                      CallbackAction<NavigateSuggestionIntent>(
                        onInvoke: (intent) {
                          final direction = intent.direction;
                          final selectedIndex = _selectedIndex.value;
                          final suggestions = _suggestions.value;
                          if (suggestions.isEmpty) {
                            return;
                          }
                          final newSelectedIndex =
                              (selectedIndex + direction) % suggestions.length;
                          _selectedIndex.value = newSelectedIndex < 0
                              ? suggestions.length - 1
                              : newSelectedIndex;
                          return;
                        },
                      ),
                  AcceptSuggestionIntent:
                      CallbackAction<AcceptSuggestionIntent>(
                        onInvoke: (intent) {
                          _handleProceed();
                          return;
                        },
                      ),
                }
              : null,
          child: widget.child,
        );
      },
    );
  }
}
