part of '../../text_field.dart';

/// TextFieldState stores and manages mutable widget state.
class TextFieldState extends State<TextField>
    with
        RestorationMixin,
        AutomaticKeepAliveClientMixin<TextField>,
        FormValueSupplier<String, TextField>,
        TickerProviderStateMixin
    implements TextSelectionGestureDetectorBuilderDelegate, AutofillClient {
  final ValueNotifier<String> _effectiveText = ValueNotifier('');
  final ValueNotifier<TextSelection> _effectiveSelection = ValueNotifier(
    const TextSelection.collapsed(offset: -1),
  );
  final GlobalKey _clearGlobalKey = GlobalKey();

  final List<_AttachedInputFeature> _attachedFeatures = [];
  Timer? _revalidateDebounceTimer;

  late WidgetStatesController _statesController;

  RestorableTextEditingController? _controller;

  /// The effective text editing controller for this text field.
  ///
  /// Returns the widget's controller or the internally created controller.
  TextEditingController get effectiveController =>
      widget.controller ?? _controller!.value;

  FocusNode? _focusNode;
  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());

  MaxLengthEnforcement get _effectiveMaxLengthEnforcement =>
      widget.maxLengthEnforcement ??
      LengthLimitingTextInputFormatter.getDefaultMaxLengthEnforcement();

  bool _showSelectionHandles = false;

  late _TextFieldSelectionGestureDetectorBuilder
  _selectionGestureDetectorBuilder;

  /// Performs `_setStateFeature` logic for this form component.
  void _setStateFeature(VoidCallback fn) {
    setState(fn);
  }

  // API for TextSelectionGestureDetectorBuilderDelegate.
  @override
  bool get forcePressEnabled => true;

  @override
  final GlobalKey<EditableTextState> editableTextKey =
      GlobalKey<EditableTextState>();

  @override
  bool get selectionEnabled =>
      widget.enableInteractiveSelection && widget.enabled;
  // End of API for TextSelectionGestureDetectorBuilderDelegate.

  /// Initializes stateful resources for this widget.
  @override
  void initState() {
    super.initState();
    _selectionGestureDetectorBuilder =
        _TextFieldSelectionGestureDetectorBuilder(state: this);
    if (widget.controller == null) {
      _createLocalController(
        widget.initialValue != null
            ? TextEditingValue(text: widget.initialValue!)
            : null,
      );
    } else {
      widget.controller!.addListener(_handleControllerChanged);
    }
    _effectiveFocusNode.canRequestFocus = widget.enabled;
    _effectiveFocusNode.addListener(_handleFocusChanged);
    _statesController = widget.statesController ?? WidgetStatesController();
    String effectiveText = widget.controller?.text ?? widget.initialValue ?? '';
    formValue = effectiveText.isEmpty ? null : effectiveText;
    for (final feature in widget.features) {
      final state = feature.createState();
      state._attached = _AttachedInputFeature(feature, state);
      state._inputState = this;
      state.initState();
      _attachedFeatures.add(state._attached!);
    }
  }

  /// Updates derived state when inherited dependencies change.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final attached in _attachedFeatures) {
      attached.state.didChangeDependencies();
    }
  }

  /// Reacts to widget configuration updates from the parent.
  @override
  void didUpdateWidget(TextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && oldWidget.controller != null) {
      _createLocalController(oldWidget.controller!.value);
    } else if (widget.controller != null && oldWidget.controller == null) {
      unregisterFromRestoration(_controller!);
      _controller!.dispose();
      _controller = null;
    }

    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);
      if (widget.controller != null) {
        _handleControllerChanged();
      }
    }

    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _focusNode)?.removeListener(_handleFocusChanged);
      (widget.focusNode ?? _focusNode)?.addListener(_handleFocusChanged);
    }
    _effectiveFocusNode.canRequestFocus = widget.enabled;

    for (
      var i = 0;
      i < max(oldWidget.features.length, widget.features.length);
      i++
    ) {
      if (i >= oldWidget.features.length) {
        final newFeature = widget.features[i];
        final newState = newFeature.createState();
        newState._attached = _AttachedInputFeature(newFeature, newState);
        newState._inputState = this;
        newState.initState();
        newState.didChangeDependencies();
        _attachedFeatures.add(newState._attached!);
        continue;
      }
      if (i >= widget.features.length) {
        final oldState = _attachedFeatures[i].state;
        oldState.dispose();
        _attachedFeatures.removeAt(i);
        continue;
      }
      final oldFeature = oldWidget.features[i];
      final newFeature = widget.features[i];
      final oldState = _attachedFeatures[i].state;
      if (!InputFeature.canUpdate(oldFeature, newFeature)) {
        oldState.dispose();
        final newState = newFeature.createState();
        newState._attached = _AttachedInputFeature(newFeature, newState);
        newState._inputState = this;
        newState.initState();
        newState.didChangeDependencies();
        _attachedFeatures[i] = newState._attached!;
      } else {
        oldState._attached!.feature = newFeature;
        oldState.didFeatureUpdate(oldFeature);
      }
    }
  }

  /// Performs `restoreState` logic for this form component.
  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    if (_controller != null) {
      _registerController();
    }
  }

  /// Performs `_registerController` logic for this form component.
  void _registerController() {
    assert(_controller != null);
    registerForRestoration(_controller!, 'controller');
    _controller!.value.addListener(updateKeepAlive);
    _controller!.value.addListener(_handleControllerChanged);
  }

  /// Performs `_handleControllerChanged` logic for this form component.
  void _handleControllerChanged() {
    _effectiveText.value = effectiveController.text;
    _effectiveSelection.value = effectiveController.selection;
    formValue = effectiveController.text.isEmpty
        ? null
        : effectiveController.text;
  }

  /// Performs `_createLocalController` logic for this form component.
  void _createLocalController([TextEditingValue? value]) {
    assert(_controller == null);
    _controller = value == null
        ? RestorableTextEditingController()
        : RestorableTextEditingController.fromValue(value);
    if (value != null) {
      _effectiveText.value = value.text;
      _effectiveSelection.value = value.selection;
    }
    if (!restorePending) {
      _registerController();
    }
  }

  @override
  String? get restorationId => widget.restorationId;

  /// Releases resources owned by this state object.
  @override
  void dispose() {
    _revalidateDebounceTimer?.cancel();
    for (final attached in _attachedFeatures) {
      attached.state.dispose();
    }
    _effectiveFocusNode.removeListener(_handleFocusChanged);
    _focusNode?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  EditableTextState get _editableText => editableTextKey.currentState!;

  /// Performs `_requestKeyboard` logic for this form component.
  void _requestKeyboard() {
    _editableText.requestKeyboard();
  }

  /// Performs `_handleFocusChanged` logic for this form component.
  void _handleFocusChanged() {
    /// Triggers a rebuild after mutating local state.
    setState(() {
      // Rebuild the widget on focus change to show/hide the text selection
      // highlight.
    });
    _statesController.update(WidgetState.focused, _effectiveFocusNode.hasFocus);
    if (!_effectiveFocusNode.hasFocus) {
      _formatSubmit();
    }
  }

  /// Performs `_formatSubmit` logic for this form component.
  void _formatSubmit() {
    _flushFormRevalidate();
    if (widget.submitFormatters != null) {
      TextEditingValue value = effectiveController.value;
      for (var formatter in widget.submitFormatters!) {
        value = formatter.formatEditUpdate(value, value);
      }
      if (value != effectiveController.value) {
        effectiveController.value = value;
        widget.onChanged?.call(value.text);
      }
    }
  }

  /// Performs `_scheduleFormRevalidate` logic for this form component.
  void _scheduleFormRevalidate() {
    _revalidateDebounceTimer?.cancel();
    _revalidateDebounceTimer = Timer(const Duration(milliseconds: 140), () {
      if (!mounted) {
        return;
      }
      Data.maybeFind<FormFieldHandle>(context)?.revalidate();
    });
  }

  /// Performs `_flushFormRevalidate` logic for this form component.
  void _flushFormRevalidate() {
    _revalidateDebounceTimer?.cancel();
    _revalidateDebounceTimer = null;
    Data.maybeFind<FormFieldHandle>(context)?.revalidate();
  }

  /// Performs `_shouldShowSelectionHandles` logic for this form component.
  bool _shouldShowSelectionHandles(SelectionChangedCause? cause) {
    // When the text field is activated by something that doesn't trigger the
    // selection overlay, we shouldn't show the handles either.
    if (!_selectionGestureDetectorBuilder.shouldShowSelectionToolbar) {
      return false;
    }

    // On iOS, we don't show handles when the selection is collapsed.
    if (effectiveController.selection.isCollapsed) {
      return false;
    }

    if (cause == SelectionChangedCause.keyboard) {
      return false;
    }

    if (cause == SelectionChangedCause.stylusHandwriting) {
      return true;
    }

    if (effectiveController.text.isNotEmpty) {
      return true;
    }

    return false;
  }

  void _handleSelectionChanged(
    TextSelection selection,
    SelectionChangedCause? cause,
  ) {
    _effectiveSelection.value = selection;
    final bool willShowSelectionHandles = _shouldShowSelectionHandles(cause);
    if (willShowSelectionHandles != _showSelectionHandles) {
      /// Triggers a rebuild after mutating local state.
      setState(() {
        _showSelectionHandles = willShowSelectionHandles;
      });
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      case TargetPlatform.fuchsia:
      case TargetPlatform.android:
        if (cause == SelectionChangedCause.longPress) {
          _editableText.bringIntoView(selection.extent);
        }
      // ignore: unreachable_switch_default
      default:
        // using the normal flutter sdk, this is unreachable.
        // but for other forks like flutter for ohos, we keep it
        // so that they can add their own platform specific behavior.
        if (cause == SelectionChangedCause.longPress) {
          _editableText.bringIntoView(selection.extent);
        }
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
      case TargetPlatform.android:
        break;
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        if (cause == SelectionChangedCause.drag) {
          _editableText.hideToolbar();
        }
      // ignore: unreachable_switch_default
      default:
        if (cause == SelectionChangedCause.drag) {
          _editableText.hideToolbar();
        }
    }

    for (final attached in _attachedFeatures) {
      attached.state.onSelectionChanged(selection);
    }
  }

  @override
  bool get wantKeepAlive => _controller?.value.text.isNotEmpty ?? false;

  // True if any surrounding decoration widgets will be shown.
  bool get _hasDecoration {
    return widget.placeholder != null || widget.features.isNotEmpty;
  }

  // Provide default behavior if widget.textAlignVertical is not set.
  // CupertinoTextField has top alignment by default, unless it has decoration
  // like a prefix or suffix, in which case it's aligned to the center.
  TextAlignVertical get _textAlignVertical {
    if (widget.textAlignVertical != null) {
      return widget.textAlignVertical!;
    }
    return _hasDecoration ? TextAlignVertical.center : TextAlignVertical.top;
  }

  @override
  TextField get widget {
    TextField widget = super.widget;
    for (final attached in _attachedFeatures) {
      widget = attached.state.interceptInput(widget);
    }
    return widget;
  }

  Widget _addTextDependentAttachments(
    Widget editableText,
    TextStyle textStyle,
    ThemeData theme,
  ) {
    var widget = this.widget;
    // If there are no surrounding widgets, just return the core editable text
    // part.
    if (!_hasDecoration) {
      return editableText;
    }

    // Otherwise, listen to the current state of the text entry.
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: effectiveController,
      child: editableText,
      builder: (BuildContext context, TextEditingValue text, Widget? child) {
        final bool hasText = text.text.isNotEmpty;
        final Widget? placeholder = widget.placeholder == null
            ? null
            // Make the placeholder invisible when hasText is true.
            : Visibility(
                maintainAnimation: true,
                maintainSize: true,
                maintainState: true,
                visible: !hasText,
                child: SizedBox(
                  width: double.infinity,
                  child: DefaultTextStyle(
                    style: textStyle
                        .merge(theme.typography.small)
                        .merge(theme.typography.normal)
                        .copyWith(color: theme.colorScheme.mutedForeground),
                    textAlign: widget.textAlign,
                    maxLines: widget.maxLines,
                    child: widget.placeholder!,
                  ),
                ),
              );

        List<Widget> leadingChildren = [];
        List<Widget> trailingChildren = [];
        for (final attached in _attachedFeatures) {
          leadingChildren.addAll(
            attached.state._internalBuildLeading().map(
              (e) => Focus(
                skipTraversal:
                    widget.skipInputFeatureFocusTraversal ||
                    attached.feature.skipFocusTraversal,
                child: e,
              ),
            ),
          );
          trailingChildren.addAll(
            attached.state._internalBuildTrailing().map(
              (e) => FocusScope(
                skipTraversal:
                    widget.skipInputFeatureFocusTraversal ||
                    attached.feature.skipFocusTraversal,
                child: e,
              ),
            ),
          );
        }

        Widget leadingWidget = Row(
          mainAxisSize: MainAxisSize.min,
          spacing: theme.density.baseGap * theme.scaling * 0.5,
          children: leadingChildren,
        );

        Widget trailingWidget = Row(
          mainAxisSize: MainAxisSize.min,
          spacing: theme.density.baseGap * theme.scaling * 0.5,
          children: trailingChildren,
        );

        final densityGap = theme.density.baseGap * theme.scaling;
        final bool isMultiline =
            widget.expands ||
            (widget.maxLines == null) ||
            (widget.maxLines != null && widget.maxLines! > 1) ||
            (widget.minLines != null && widget.minLines! > 1);
        final AlignmentDirectional placeholderAlignment = AlignmentDirectional(
          0.0,
          isMultiline ? -1.0 : 0.0,
        );

        return Row(
          crossAxisAlignment: widget.crossAxisAlignment,
          spacing: densityGap,
          children: [
            // Insert a prefix at the front if the prefix visibility mode matches
            // the current text state.
            if (leadingChildren.isNotEmpty) leadingWidget,
            // In the middle part, stack the placeholder on top of the main EditableText
            // if needed.
            Expanded(
              child: Stack(
                // Ideally this should be baseline aligned. However that comes at
                // the cost of the ability to compute the intrinsic dimensions of
                // this widget.
                // See also https://github.com/flutter/flutter/issues/13715.
                alignment: placeholderAlignment,
                textDirection: widget.textDirection,
                children: <Widget>[
                  if (placeholder != null) placeholder,
                  editableText,
                ],
              ),
            ),
            if (trailingChildren.isNotEmpty) trailingWidget,
          ],
        );
      },
    );
  }

  // AutofillClient implementation start.
  @override
  String get autofillId => _editableText.autofillId;

  /// Performs `autofill` logic for this form component.
  @override
  void autofill(TextEditingValue newEditingValue) =>
      _editableText.autofill(newEditingValue);

  @override
  TextInputConfiguration get textInputConfiguration {
    var widget = this.widget;
    final List<String>? autofillHints = widget.autofillHints?.toList(
      growable: false,
    );
    final AutofillConfiguration autofillConfiguration = autofillHints != null
        ? AutofillConfiguration(
            uniqueIdentifier: autofillId,
            autofillHints: autofillHints,
            currentEditingValue: effectiveController.value,
            hintText: widget.hintText,
          )
        : AutofillConfiguration.disabled;

    return _editableText.textInputConfiguration.copyWith(
      autofillConfiguration: autofillConfiguration,
    );
  }
  // AutofillClient implementation end.

  /// Performs `_onChanged` logic for this form component.
  void _onChanged(String value) {
    var widget = this.widget;
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
    formValue = value.isEmpty ? null : value;
    _scheduleFormRevalidate();
    _effectiveText.value = value;

    for (final attached in _attachedFeatures) {
      attached.state.onTextChanged(value);
    }
  }

  /// Performs `_onEnter` logic for this form component.
  void _onEnter(PointerEnterEvent event) {
    _statesController.update(WidgetState.hovered, true);
  }

  /// Performs `_onExit` logic for this form component.
  void _onExit(PointerExitEvent event) {
    _statesController.update(WidgetState.hovered, false);
  }

  /// Performs `_wrapActions` logic for this form component.
  Widget _wrapActions({required Widget child}) {
    Map<Type, Action<Intent>> featureActions = {};
    Map<ShortcutActivator, Intent> featureShortcuts = {};
    for (final attached in _attachedFeatures) {
      for (final action in attached.state.buildActions()) {
        featureActions[action.key] = action.value;
      }
      for (final shortcut in attached.state.buildShortcuts()) {
        featureShortcuts[shortcut.key] = shortcut.value;
      }
    }
    return Actions(
      actions: {
        TextFieldClearIntent: Action.overridable(
          context: context,
          defaultAction: CallbackAction<TextFieldClearIntent>(
            onInvoke: (intent) {
              effectiveController.clear();
              return;
            },
          ),
        ),
        TextFieldAppendTextIntent: Action.overridable(
          context: context,
          defaultAction: CallbackAction<TextFieldAppendTextIntent>(
            onInvoke: (intent) {
              _appendText(intent.text);
              return;
            },
          ),
        ),
        TextFieldReplaceCurrentWordIntent: Action.overridable(
          context: context,
          defaultAction: CallbackAction<TextFieldReplaceCurrentWordIntent>(
            onInvoke: (intent) {
              _replaceCurrentWord(intent.text);
              return;
            },
          ),
        ),
        TextFieldSetTextIntent: Action.overridable(
          context: context,
          defaultAction: CallbackAction<TextFieldSetTextIntent>(
            onInvoke: (intent) {
              _setText(intent.text);
              return;
            },
          ),
        ),
        TextFieldSetSelectionIntent: Action.overridable(
          context: context,
          defaultAction: CallbackAction<TextFieldSetSelectionIntent>(
            onInvoke: (intent) {
              effectiveController.selection = intent.selection;
              return;
            },
          ),
        ),
        TextFieldSelectAllAndCopyIntent: Action.overridable(
          context: context,
          defaultAction: CallbackAction<TextFieldSelectAllAndCopyIntent>(
            onInvoke: (intent) {
              effectiveController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: effectiveController.text.length,
              );
              var text = effectiveController.text;
              if (text.isNotEmpty) {
                Clipboard.setData(ClipboardData(text: text));
              }
              return;
            },
          ),
        ),
        AutoCompleteIntent: Action.overridable(
          context: context,
          defaultAction: CallbackAction<AutoCompleteIntent>(
            onInvoke: (intent) {
              switch (intent.mode) {
                case AutoCompleteMode.append:
                  _appendText(intent.suggestion);
                  break;
                case AutoCompleteMode.replaceWord:
                  _replaceCurrentWord(intent.suggestion);
                  break;
                case AutoCompleteMode.replaceAll:
                  _setText(intent.suggestion);
                  break;
              }
              return;
            },
          ),
        ),
        ...featureActions,
      },
      child: Shortcuts(shortcuts: featureShortcuts, child: child),
    );
  }

  /// Performs `_appendText` logic for this form component.
  void _appendText(String text) {
    final newText = effectiveController.text + text;
    effectiveController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  /// Performs `_replaceCurrentWord` logic for this form component.
  void _replaceCurrentWord(String text) {
    final replacement = text;
    final value = effectiveController.value;
    final selection = value.selection;
    if (selection.isCollapsed) {
      int start = selection.start;
      final newText = replaceWordAtCaret(value.text, start, replacement, (
        char,
      ) {
        return char == ' ' ||
            char == '\n' ||
            char == '\t' ||
            isChipCharacter(char);
      });
      effectiveController.value = TextEditingValue(
        text: newText.$2,
        selection: TextSelection.collapsed(
          offset: newText.$1 + replacement.length,
        ),
      );
    }
  }

  /// Performs `_setText` logic for this form component.
  void _setText(String text) {
    effectiveController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    var widget = this.widget;
    super.build(context); // See AutomaticKeepAliveClientMixin.
    final ThemeData theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<TextFieldTheme>(context);
    assert(debugCheckHasDirectionality(context));
    final TextEditingController controller = effectiveController;

    TextSelectionControls? textSelectionControls = widget.selectionControls;
    VoidCallback? handleDidGainAccessibilityFocus;
    VoidCallback? handleDidLoseAccessibilityFocus;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        textSelectionControls ??= cupertinoDesktopTextSelectionHandleControls;
        handleDidGainAccessibilityFocus = () {
          // Automatically activate the TextField when it receives accessibility focus.
          if (!_effectiveFocusNode.hasFocus &&
              _effectiveFocusNode.canRequestFocus) {
            _effectiveFocusNode.requestFocus();
          }
        };
        handleDidLoseAccessibilityFocus = () {
          _effectiveFocusNode.unfocus();
        };
      // ignore: unreachable_switch_default
      default:
        textSelectionControls ??= cupertinoDesktopTextSelectionHandleControls;
        handleDidGainAccessibilityFocus = () {
          // Automatically activate the TextField when it receives accessibility focus.
          if (!_effectiveFocusNode.hasFocus &&
              _effectiveFocusNode.canRequestFocus) {
            _effectiveFocusNode.requestFocus();
          }
        };
        handleDidLoseAccessibilityFocus = () {
          _effectiveFocusNode.unfocus();
        };
    }

    final bool enabled = widget.enabled;
    final List<TextInputFormatter> formatters = <TextInputFormatter>[
      ...?widget.inputFormatters,
      if (widget.maxLength != null)
        LengthLimitingTextInputFormatter(
          widget.maxLength,
          maxLengthEnforcement: _effectiveMaxLengthEnforcement,
        ),
    ];

    TextStyle defaultTextStyle;
    if (widget.style != null) {
      defaultTextStyle = DefaultTextStyle.of(context).style
          .merge(theme.typography.small)
          .merge(theme.typography.normal)
          .copyWith(color: theme.colorScheme.foreground)
          .merge(widget.style);
    } else {
      defaultTextStyle = DefaultTextStyle.of(context).style
          .merge(theme.typography.small)
          .merge(theme.typography.normal)
          .copyWith(color: theme.colorScheme.foreground);
    }

    final Brightness keyboardAppearance =
        widget.keyboardAppearance ?? theme.brightness;
    final Color cursorColor =
        widget.cursorColor ??
        DefaultSelectionStyle.of(context).cursorColor ??
        theme.colorScheme.primary;

    // Use the default disabled color only if the box decoration was not set.
    final effectiveBorder = styleValue(
      defaultValue: Border.all(
        color: theme.colorScheme.border,
        strokeAlign: BorderSide.strokeAlignCenter,
      ),
      themeValue: compTheme?.border,
      widgetValue: widget.border,
    );
    Decoration effectiveDecoration =
        widget.decoration ??
        BoxDecoration(
          borderRadius:
              optionallyResolveBorderRadius(
                context,
                widget.borderRadius ?? compTheme?.borderRadius,
              ) ??
              BorderRadius.circular(theme.radiusMd),
          color: (widget.filled ?? compTheme?.filled ?? false)
              ? theme.colorScheme.muted
              : theme.colorScheme.input.scaleAlpha(0.3),
          border: effectiveBorder,
        );

    // final inputGroup = InputGroupData.maybeOf(context);
    // if (inputGroup != null) {
    //   effectiveDecoration = inputGroup.applyBoxDecoration(effectiveDecoration, Directionality.maybeOf(context) ?? TextDirection.ltr);
    // }
    final styleOverride = Data.maybeOf<ButtonStyleOverrideData>(context);
    if (styleOverride != null) {
      effectiveDecoration =
          styleOverride.decoration?.call(
            context,
            _statesController.value,
            effectiveDecoration,
          ) ??
          effectiveDecoration;
    }

    final Color selectionColor =
        DefaultSelectionStyle.of(context).selectionColor ??
        theme.colorScheme.primary.withValues(alpha: 0.2);

    // Set configuration as disabled if not otherwise specified. If specified,
    // ensure that configuration uses Cupertino text style for misspelled words
    // unless a custom style is specified.
    final SpellCheckConfiguration spellCheckConfiguration =
        widget.spellCheckConfiguration ??
        const SpellCheckConfiguration.disabled();

    final scaling = theme.scaling;
    final Widget editable = RepaintBoundary(
      child: UnmanagedRestorationScope(
        bucket: bucket,
        child: EditableText(
          key: editableTextKey,
          controller: controller,
          undoController: widget.undoController,
          readOnly: widget.readOnly || !enabled,
          showCursor: widget.showCursor,
          showSelectionHandles: _showSelectionHandles,
          focusNode: _effectiveFocusNode,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          autofillHints: widget.autofillHints,
          style: defaultTextStyle,
          strutStyle: widget.strutStyle,
          textAlign: widget.textAlign,
          textDirection: widget.textDirection,
          autofocus: widget.autofocus,
          obscuringCharacter: widget.obscuringCharacter,
          obscureText: widget.obscureText,
          autocorrect: widget.autocorrect,
          smartDashesType: widget.smartDashesType,
          smartQuotesType: widget.smartQuotesType,
          enableSuggestions: widget.enableSuggestions,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          expands: widget.expands,
          magnifierConfiguration:
              widget.magnifierConfiguration ??
              const TextMagnifierConfiguration(),
          // Only show the selection highlight when the text field is focused.
          selectionColor: _effectiveFocusNode.hasFocus ? selectionColor : null,
          selectionControls: selectionEnabled ? textSelectionControls : null,
          groupId: widget.groupId,
          onChanged: _onChanged,
          onSelectionChanged: _handleSelectionChanged,
          onEditingComplete: () {
            widget.onEditingComplete?.call();
            _formatSubmit();
          },
          onSubmitted: (value) {
            widget.onSubmitted?.call(value);
            _formatSubmit();
          },
          onTapOutside: widget.onTapOutside,
          inputFormatters: formatters,
          rendererIgnoresPointer: true,
          cursorWidth: widget.cursorWidth,
          cursorHeight: widget.cursorHeight,
          cursorRadius: widget.cursorRadius,
          cursorColor: cursorColor,
          cursorOpacityAnimates: widget.cursorOpacityAnimates,
          paintCursorAboveText: true,
          autocorrectionTextRectColor: selectionColor,
          backgroundCursorColor: theme.colorScheme.border,
          selectionHeightStyle: widget.selectionHeightStyle,
          selectionWidthStyle: widget.selectionWidthStyle,
          scrollPadding: widget.scrollPadding,
          keyboardAppearance: keyboardAppearance,
          dragStartBehavior: widget.dragStartBehavior,
          scrollController: widget.scrollController,
          scrollPhysics: widget.scrollPhysics,
          enableInteractiveSelection: widget.enableInteractiveSelection,
          autofillClient: this,
          clipBehavior: Clip.none,
          restorationId: 'editable',
          stylusHandwritingEnabled: widget.stylusHandwritingEnabled,
          enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
          contentInsertionConfiguration: widget.contentInsertionConfiguration,
          contextMenuBuilder: widget.contextMenuBuilder,
          spellCheckConfiguration: spellCheckConfiguration,
        ),
      ),
    );

    Widget textField = MouseRegion(
      cursor: enabled ? SystemMouseCursors.text : SystemMouseCursors.forbidden,
      child: FocusOutline(
        focused: _effectiveFocusNode.hasFocus,
        borderRadius: effectiveDecoration is BoxDecoration
            ? effectiveDecoration.borderRadius
            : null,
        child: IconTheme.merge(
          data: theme.iconTheme.small.copyWith(
            color: theme.colorScheme.mutedForeground,
          ),
          child: _wrapActions(
            child: MouseRegion(
              onEnter: _onEnter,
              onExit: _onExit,
              opaque: false,
              child: Semantics(
                enabled: enabled,
                onTap: !enabled || widget.readOnly
                    ? null
                    : () {
                        if (!controller.selection.isValid) {
                          controller.selection = TextSelection.collapsed(
                            offset: controller.text.length,
                          );
                        }
                        _requestKeyboard();
                      },
                onDidGainAccessibilityFocus: handleDidGainAccessibilityFocus,
                onDidLoseAccessibilityFocus: handleDidLoseAccessibilityFocus,
                onFocus: enabled
                    ? () {
                        assert(
                          _effectiveFocusNode.canRequestFocus,
                          'Received SemanticsAction.focus from the engine. However, the FocusNode '
                          'of this text field cannot gain focus. This likely indicates a bug. '
                          'If this text field cannot be focused (e.g. because it is not '
                          'enabled), then its corresponding semantics node must be configured '
                          'such that the assistive technology cannot request focus on it.',
                        );

                        if (_effectiveFocusNode.canRequestFocus &&
                            !_effectiveFocusNode.hasFocus) {
                          _effectiveFocusNode.requestFocus();
                        } else if (!widget.readOnly) {
                          // If the platform requested focus, that means that previously the
                          // platform believed that the text field did not have focus (even
                          // though Flutter's widget system believed otherwise). This likely
                          // means that the on-screen keyboard is hidden, or more generally,
                          // there is no current editing session in this field. To correct
                          // that, keyboard must be requested.
                          //
                          // A concrete scenario where this can happen is when the user
                          // dismisses the keyboard on the web. The editing session is
                          // closed by the engine, but the text field widget stays focused
                          // in the framework.
                          _requestKeyboard();
                        }
                      }
                    : null,
                child: TextFieldTapRegion(
                  child: IgnorePointer(
                    ignoring: !enabled,
                    child: Container(
                      clipBehavior: widget.clipBehavior,
                      decoration: effectiveDecoration,
                      child: _selectionGestureDetectorBuilder
                          .buildGestureDetector(
                            behavior: HitTestBehavior.translucent,
                            child: Align(
                              alignment: Alignment(-1.0, _textAlignVertical.y),
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: Builder(
                                builder: (context) {
                                  final densityGap =
                                      theme.density.baseGap * scaling;
                                  final densityContentPadding =
                                      theme.density.baseContentPadding *
                                      scaling;
                                  final padding =
                                      widget.padding ??
                                      compTheme?.padding ??
                                      EdgeInsets.symmetric(
                                        horizontal:
                                            densityContentPadding * 0.75,
                                        vertical: densityGap,
                                      );
                                  final resolvedPadding = resolveEdgeInsets(
                                    padding,
                                    densityContentPadding,
                                  );
                                  return Padding(
                                    padding: resolvedPadding,
                                    child: _addTextDependentAttachments(
                                      editable,
                                      defaultTextStyle,
                                      theme,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    for (final attached in _attachedFeatures) {
      textField = attached.state.wrap(textField);
    }

    double fontHeight =
        (defaultTextStyle.fontSize ?? 14.0) * (defaultTextStyle.height ?? 1.0);
    final densityGap = theme.density.baseGap * scaling;
    final densityContentPadding = theme.density.baseContentPadding * scaling;
    final textDirection = widget.textDirection ?? Directionality.of(context);
    final padding =
        widget.padding ??
        compTheme?.padding ??
        EdgeInsets.symmetric(
          horizontal: densityContentPadding * 0.75,
          vertical: densityGap,
        );
    final resolvedPadding = resolveEdgeInsets(padding, densityContentPadding);
    double verticalPadding = resolvedPadding.resolve(textDirection).vertical;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: fontHeight + verticalPadding),
      child: WidgetStatesProvider(
        states: {if (_effectiveFocusNode.hasFocus) WidgetState.hovered},
        child: textField,
      ),
    );
  }

  /// Performs `didReplaceFormValue` logic for this form component.
  @override
  void didReplaceFormValue(String value) {
    effectiveController.text = value;
    widget.onChanged?.call(value);
  }
}
