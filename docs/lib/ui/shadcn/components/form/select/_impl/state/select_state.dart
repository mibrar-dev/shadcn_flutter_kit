// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../select.dart';

/// State class for the [Select] widget managing selection and popup interactions.
///
/// This state class handles the select dropdown's internal state including:
/// - Focus management for keyboard navigation
/// - Popup controller for opening/closing the dropdown menu
/// - Value change notifications
/// - Theme integration
///
/// The state implements [FormValueSupplier] to integrate with form validation
/// and value management systems.
///
/// See also:
/// - [Select], the widget that uses this state
/// - [PopoverController], used to control the dropdown popup
/// - [FormValueSupplier], the mixin providing form integration
class SelectState<T> extends State<Select<T>>
    with FormValueSupplier<T, Select<T>> {
  late FocusNode _focusNode;
  final PopoverController _popoverController = PopoverController();
  late ValueNotifier<T?> _valueNotifier;

  SelectTheme? _theme;

  /// Updates derived state when inherited dependencies change.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = widget.theme ?? ComponentTheme.maybeOf<SelectTheme>(context);
  }

  BoxConstraints? get _popupConstraints => styleValue(
    widgetValue: widget.popupConstraints,
    themeValue: _theme?.popupConstraints,
    defaultValue: null,
  );

  OverlayConfiguration? get _overlayConfigurationOverride =>
      widget.overlayConfiguration ?? _theme?.overlayConfiguration;

  // NOTE: widget.adaptiveOverlay / theme.adaptiveOverlay are accepted and
  // stored for upstream API parity, but the registry overlay always presents
  // a popover (no adaptive drawer conversion), so there is nothing to
  // resolve here yet.

  AlignmentGeometry get _popoverAlignment => styleValue(
    widgetValue: widget.popoverAlignment,
    themeValue: _theme?.popoverAlignment,
    defaultValue: Alignment.topCenter,
  );

  AlignmentGeometry? get _popoverAnchorAlignment => styleValue(
    widgetValue: widget.popoverAnchorAlignment,
    themeValue: _theme?.popoverAnchorAlignment,
    defaultValue: null,
  );

  BorderRadiusGeometry? get _borderRadius => styleValue(
    widgetValue: widget.borderRadius,
    themeValue: _theme?.borderRadius,
    defaultValue: null,
  );

  EdgeInsetsGeometry? get _padding => styleValue(
    widgetValue: widget.padding,
    themeValue: _theme?.padding,
    defaultValue: null,
  );

  WidgetStatePropertyDelegate<Decoration>? get _decoration => styleValue(
    widgetValue: widget.decoration,
    themeValue: _theme?.decoration,
    defaultValue: null,
  );

  bool get _disableHoverEffect => styleValue(
    widgetValue: widget.disableHoverEffect,
    themeValue: _theme?.disableHoverEffect,
    defaultValue: false,
  );

  bool get _canUnselect => styleValue(
    widgetValue: widget.canUnselect,
    themeValue: _theme?.canUnselect,
    defaultValue: false,
  );

  bool get _autoClosePopover => styleValue(
    widgetValue: widget.autoClosePopover,
    themeValue: _theme?.autoClosePopover,
    defaultValue: true,
  );

  /// Initializes stateful resources for this widget.
  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _valueNotifier = ValueNotifier(widget.value);
    formValue = widget.value;
  }

  /// Reacts to widget configuration updates from the parent.
  @override
  void didUpdateWidget(Select<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode = widget.focusNode ?? FocusNode();
    }
    if (widget.value != oldWidget.value) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _valueNotifier.value = widget.value;
      });
      formValue = widget.value;
    } else if (widget.valueSelectionPredicate !=
        oldWidget.valueSelectionPredicate) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _valueNotifier.value = widget.value;
      });
    }
    if (widget.enabled != oldWidget.enabled ||
        widget.onChanged != oldWidget.onChanged) {
      bool enabled = widget.enabled ?? widget.onChanged != null;
      if (!enabled) {
        _focusNode.unfocus();
        _popoverController.close();
      }
    }
  }

  Widget get _placeholder {
    if (widget.placeholder != null) {
      return widget.placeholder!;
    }
    return const SizedBox();
  }

  /// Performs `didReplaceFormValue` logic for this form component.
  @override
  void didReplaceFormValue(T value) {
    widget.onChanged?.call(value);
  }

  /// Releases resources owned by this state object.
  @override
  void dispose() {
    _popoverController.dispose();
    super.dispose();
  }

  /// Applies [Select.borderRadius] and then [Select.decoration], so a decoration
  /// delegate sees — and can override — the border radius the select resolved.
  Decoration _overrideDecoration(
    BuildContext context,
    Set<WidgetState> states,
    Decoration value,
  ) {
    var result = value;
    if (_borderRadius != null) {
      result = (result as BoxDecoration).copyWith(borderRadius: _borderRadius);
    }
    return _decoration?.call(context, states, result) ?? result;
  }

  EdgeInsetsGeometry _overridePadding(
    BuildContext context,
    Set<WidgetState> states,
    EdgeInsetsGeometry value,
  ) {
    return _padding!;
  }

  /// Performs `_onChanged` logic for this form component.
  bool _onChanged(Object? value, bool selected) {
    if (!selected && !_canUnselect) {
      return false;
    }
    var selectionHandler =
        widget.valueSelectionHandler ??
        _defaultSingleSelectValueSelectionHandler;
    var newValue = selectionHandler(widget.value, value, selected);
    widget.onChanged?.call(newValue);
    return true;
  }

  /// Performs `_isSelected` logic for this form component.
  bool _isSelected(Object? value) {
    final selectionPredicate =
        widget.valueSelectionPredicate ??
        _defaultSingleSelectValueSelectionPredicate;
    return selectionPredicate(widget.value, value);
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    var enabled = widget.enabled ?? widget.onChanged != null;
    final overlay = _overlayConfigurationOverride;
    final popoverConfig = overlay is PopoverConfiguration ? overlay : null;
    return IntrinsicWidth(
      child: ConstrainedBox(
        constraints: widget.constraints ?? const BoxConstraints(),
        child: TapRegion(
          onTapOutside: (event) {
            _focusNode.unfocus();
          },
          child: Button(
            enabled: enabled,
            disableHoverEffect: _disableHoverEffect,
            focusNode: _focusNode,
            style:
                (widget.filled
                        ? ButtonVariance.secondary
                        : ButtonVariance.outline)
                    .copyWith(
                      decoration: _borderRadius != null || _decoration != null
                          ? _overrideDecoration
                          : null,
                      padding: _padding != null ? _overridePadding : null,
                    ),
            onPressed: widget.onChanged == null
                ? null
                : () {
                    // to prevent entire ListView from rebuilding
                    // while the Data<SelectData> is being updated
                    GlobalKey popupKey = GlobalKey();
                    _popoverController
                        .show(
                          context: context,
                          offset:
                              popoverConfig?.offset ?? Offset(0, 8 * scaling),
                          alignment:
                              popoverConfig?.alignment ?? _popoverAlignment,
                          anchorAlignment:
                              popoverConfig?.anchorAlignment ??
                              _popoverAnchorAlignment,
                          widthConstraint:
                              popoverConfig?.widthConstraint ??
                              widget.popupWidthConstraint,
                          heightConstraint:
                              popoverConfig?.heightConstraint ??
                              PopoverConstraint.flexible,
                          modal: popoverConfig?.modal ?? true,
                          margin: popoverConfig?.margin,
                          onTickFollow: popoverConfig?.onTickFollow,
                          follow: popoverConfig?.follow ?? true,
                          allowInvertHorizontal:
                              popoverConfig?.allowInvertHorizontal ?? true,
                          allowInvertVertical:
                              popoverConfig?.allowInvertVertical ?? true,
                          dismissBackdropFocus:
                              popoverConfig?.dismissBackdropFocus ?? true,
                          regionGroupId: popoverConfig?.regionGroupId,
                          transitionAlignment:
                              popoverConfig?.transitionAlignment,
                          consumeOutsideTaps:
                              popoverConfig?.consumeOutsideTaps ?? true,
                          showDuration: popoverConfig?.showDuration,
                          hideDuration: popoverConfig?.dismissDuration,
                          overlayBarrier:
                              popoverConfig?.overlayBarrier ??
                              OverlayBarrier(
                                padding: EdgeInsets.symmetric(
                                  vertical: theme.density.baseGap * scaling,
                                ),
                                borderRadius: BorderRadius.circular(
                                  theme.radiusLg,
                                ),
                              ),
                          builder: (context) {
                            return ConstrainedBox(
                              constraints:
                                  _popupConstraints ??
                                  BoxConstraints(
                                    maxHeight:
                                        Select.kDefaultSelectMaxHeight *
                                        scaling,
                                  ),
                              child: ListenableBuilder(
                                listenable: _valueNotifier,
                                builder: (context, _) {
                                  return Data.inherit(
                                    key: ValueKey(widget.value),
                                    data: SelectData(
                                      enabled: enabled,
                                      autoClose: _autoClosePopover,
                                      isSelected: _isSelected,
                                      onChanged: _onChanged,
                                      hasSelection: widget.value != null,
                                      expandIcon: widget.expandIcon,
                                    ),
                                    child: Builder(
                                      key: popupKey,
                                      builder: (context) {
                                        return widget.popup(context);
                                      },
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        )
                        .then((value) {
                          _focusNode.requestFocus();
                        });
                  },
            child: WidgetStatesProvider.boundary(
              child: widget.expandIcon != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Data.inherit(
                          data: SelectData(
                            enabled: enabled,
                            autoClose: _autoClosePopover,
                            isSelected: _isSelected,
                            onChanged: _onChanged,
                            hasSelection: widget.value != null,
                            expandIcon: widget.expandIcon,
                          ),
                          child: Expanded(
                            child:
                                widget.value != null &&
                                    (widget.showValuePredicate?.call(
                                          widget.value as T,
                                        ) ??
                                        true)
                                ? Builder(
                                    builder: (context) {
                                      return widget.itemBuilder(
                                        context,
                                        widget.value as T,
                                      );
                                    },
                                  )
                                : _placeholder,
                          ),
                        ),
                        SizedBox(width: 8 * scaling),
                        IconTheme.merge(
                          data: IconThemeData(
                            color: theme.colorScheme.foreground,
                            opacity: 0.5,
                          ),
                          child: widget.expandIcon!,
                        ),
                      ],
                    )
                  : Data.inherit(
                      data: SelectData(
                        enabled: enabled,
                        autoClose: _autoClosePopover,
                        isSelected: _isSelected,
                        onChanged: _onChanged,
                        hasSelection: widget.value != null,
                        expandIcon: widget.expandIcon,
                      ),
                      child:
                          widget.value != null &&
                              (widget.showValuePredicate?.call(
                                    widget.value as T,
                                  ) ??
                                  true)
                          ? Builder(
                              builder: (context) {
                                return widget.itemBuilder(
                                  context,
                                  widget.value as T,
                                );
                              },
                            )
                          : _placeholder,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
