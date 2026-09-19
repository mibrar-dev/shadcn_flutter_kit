// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../autocomplete.dart';

/// _AutoCompleteState stores and manages mutable widget state.
class _AutoCompleteState extends State<AutoComplete> {
  final ValueNotifier<List<String>> _suggestions = ValueNotifier([]);
  final ValueNotifier<int> _selectedIndex = ValueNotifier(-1);
  final PopoverController _popoverController = PopoverController();

  /// Focus node/reference used by `_isFocused` interactions.
  bool _isFocused = false;

  /// When `true`, the next suggestion sync must not auto-open the popover.
  ///
  /// Set right after a suggestion is accepted. Accepting a suggestion changes
  /// the field text programmatically, which fires the text field's `onChanged`
  /// and causes the parent to recompute suggestions. Those recomputed
  /// suggestions usually still match the just-completed word, which would
  /// otherwise immediately reopen the popover the user just dismissed. The flag
  /// is consumed on the next [didUpdateWidget] cycle, so subsequent typing
  /// reopens the popover as normal.
  ///
  /// Upstream parity: ported from upstream `_AutoCompleteState._suppressReopen`.
  bool _suppressReopen = false;

  AutoCompleteMode get _mode {
    final compTheme = widget.theme ?? ComponentTheme.maybeOf<AutoCompleteTheme>(context);
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
    if (widget.suggestions.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        _applySuggestions(widget.suggestions, allowOpen: true);
      });
    }
  }

  /// Stores a new suggestion list and reconciles the popover visibility.
  ///
  /// Upstream parity: ported from upstream
  /// `_AutoCompleteState._applySuggestions`, adapted to [PopoverController].
  void _applySuggestions(List<String> suggestions, {required bool allowOpen}) {
    _suggestions.value = suggestions;
    _selectedIndex.value = suggestions.isEmpty ? -1 : 0;
    _syncPopover(allowOpen: allowOpen);
  }

  /// Opens or closes the popover to match the current suggestions and focus.
  ///
  /// Closing always happens when needed, but opening is skipped when
  /// [allowOpen] is `false` (e.g. right after a suggestion was accepted).
  ///
  /// Upstream parity: ported from upstream `_AutoCompleteState._syncPopover`,
  /// adapted to [PopoverController] (the registry popover architecture).
  /// The upstream `overlayConfiguration`/`adaptiveOverlay` values are accepted
  /// and stored for API compatibility but cannot be honored here; the popover
  /// is always presented via [PopoverController.show] with the `popover*`
  /// sizing and alignment parameters.
  void _syncPopover({required bool allowOpen}) {
    final shouldOpen = _isFocused && _suggestions.value.isNotEmpty;
    if (!shouldOpen) {
      if (_popoverController.hasOpenPopover) {
        _popoverController.close();
      }
      return;
    }
    if (_popoverController.hasOpenPopover || !allowOpen) {
      return;
    }
    final compTheme = widget.theme ?? ComponentTheme.maybeOf<AutoCompleteTheme>(context);
    _selectedIndex.value = -1;
    _popoverController.show(
      context: context,
      handler: const PopoverOverlayHandler(),
      builder: (context) {
        final theme = Theme.of(context);
        final compTheme = widget.theme ?? ComponentTheme.maybeOf<AutoCompleteTheme>(context);
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

  /// Performs `_handleProceed` logic for this form component.
  void _handleProceed() {
    final selectedIndex = _selectedIndex.value;
    if (selectedIndex < 0 || selectedIndex >= _suggestions.value.length) {
      return;
    }
    // Applying the suggestion changes the field text, which fires onChanged and
    // re-derives suggestions that usually still match. Suppress the reopen it
    // would trigger so the popover stays closed until the user types again.
    _suppressReopen = true;
    _popoverController.close();
    var suggestion = _suggestions.value[selectedIndex];
    suggestion = widget.completer(suggestion);
    invokeActionOnFocusedWidget(AutoCompleteIntent(suggestion, _mode));
  }

  /// Reacts to widget configuration updates from the parent.
  @override
  void didUpdateWidget(covariant AutoComplete oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Consume the suppression flag for this update cycle: the change that
    // arrives right after an accept must not reopen the popover, but the flag
    // is cleared here so the next user edit reopens it normally.
    final allowOpen = !_suppressReopen;
    _suppressReopen = false;
    if (!listEquals(oldWidget.suggestions, widget.suggestions)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        _applySuggestions(widget.suggestions, allowOpen: allowOpen);
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
