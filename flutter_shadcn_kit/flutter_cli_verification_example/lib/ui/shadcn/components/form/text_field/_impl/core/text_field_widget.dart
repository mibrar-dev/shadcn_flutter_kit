part of '../../text_field.dart';

/// TextField represents a form-related type in the registry.
class TextField extends TextInputStatefulWidget {
  /// Returns a native platform context menu builder.
  ///
  /// Uses the platform's default text selection toolbar.
  static EditableTextContextMenuBuilder nativeContextMenuBuilder() {
    return (context, editableTextState) {
      return material.AdaptiveTextSelectionToolbar.editableText(
        editableTextState: editableTextState,
      );
    };
  }

  /// Returns a Cupertino-style context menu builder.
  ///
  /// Uses iOS-style text selection toolbar.
  static EditableTextContextMenuBuilder cupertinoContextMenuBuilder() {
    return (context, editableTextState) {
      return cupertino.CupertinoAdaptiveTextSelectionToolbar.editableText(
        editableTextState: editableTextState,
      );
    };
  }

  /// Returns a Material Design context menu builder.
  ///
  /// Uses Material Design text selection toolbar.
  static EditableTextContextMenuBuilder materialContextMenuBuilder() {
    return (context, editableTextState) {
      final anchors = editableTextState.contextMenuAnchors;
      return material.TextSelectionToolbar(
        anchorAbove: anchors.primaryAnchor,
        anchorBelow: anchors.secondaryAnchor == null
            ? anchors.primaryAnchor
            : anchors.secondaryAnchor!,
        children: _getMaterialButtons(
          context,
          editableTextState.contextMenuButtonItems,
        ),
      );
    };
  }

  static List<Widget> _getMaterialButtons(
    BuildContext context,
    List<ContextMenuButtonItem> buttonItems,
  ) {
    final List<Widget> buttons = <Widget>[];
    for (int i = 0; i < buttonItems.length; i++) {
      final ContextMenuButtonItem buttonItem = buttonItems[i];
      buttons.add(
        material.TextSelectionToolbarTextButton(
          padding: material.TextSelectionToolbarTextButton.getPadding(
            i,
            buttonItems.length,
          ),
          onPressed: buttonItem.onPressed,
          alignment: AlignmentDirectional.centerStart,
          child: Text(_getMaterialButtonLabel(context, buttonItem)),
        ),
      );
    }
    return buttons;
  }

  static String _getMaterialButtonLabel(
    BuildContext context,
    ContextMenuButtonItem buttonItem,
  ) {
    final localizations = material.MaterialLocalizations.of(context);
    return switch (buttonItem.type) {
      ContextMenuButtonType.cut => localizations.cutButtonLabel,
      ContextMenuButtonType.copy => localizations.copyButtonLabel,
      ContextMenuButtonType.paste => localizations.pasteButtonLabel,
      ContextMenuButtonType.selectAll => localizations.selectAllButtonLabel,
      ContextMenuButtonType.delete =>
        localizations.deleteButtonTooltip.toUpperCase(),
      ContextMenuButtonType.lookUp => localizations.lookUpButtonLabel,
      ContextMenuButtonType.searchWeb => localizations.searchWebButtonLabel,
      ContextMenuButtonType.share => localizations.shareButtonLabel,
      ContextMenuButtonType.liveTextInput => localizations.scanTextButtonLabel,
      ContextMenuButtonType.custom => '',
    };
  }

  /// Creates a text input field widget.
  ///
  /// A comprehensive text field implementation with support for various input
  /// types, validation, formatting, and interactive features. All parameters
  /// are forwarded to the parent [TextInputStatefulWidget] constructor.
  ///
  /// This constructor provides extensive customization options matching Flutter's
  /// [EditableText] while adding custom features like input decorations, features,
  /// and form integration.
  ///
  /// Example:
  /// ```dart
  /// TextField(
  ///   controller: myController,
  ///   hintText: 'Enter text',
  ///   keyboardType: TextInputType.text,
  ///   maxLines: 3,
  ///   onChanged: (value) => print(value),
  /// )
  /// ```
  ///
  /// See [TextInputStatefulWidget] and [TextInput] for parameter details.
  const TextField({
    super.key,
    super.groupId,
    super.controller,
    super.initialValue,
    super.focusNode,
    super.undoController,
    super.decoration,
    super.padding,
    super.placeholder,
    super.crossAxisAlignment,
    super.clearButtonSemanticLabel,
    super.keyboardType,
    super.textInputAction,
    super.textCapitalization,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.textAlignVertical,
    super.textDirection,
    super.readOnly,
    super.showCursor,
    super.autofocus,
    super.obscuringCharacter,
    super.obscureText,
    super.autocorrect,
    super.smartDashesType,
    super.smartQuotesType,
    super.enableSuggestions,
    super.maxLines,
    super.minLines,
    super.expands,
    super.maxLength,
    super.maxLengthEnforcement,
    super.onChanged,
    super.onEditingComplete,
    super.onSubmitted,
    super.onTapOutside,
    super.onTapUpOutside,
    super.inputFormatters,
    super.enabled,
    super.cursorWidth,
    super.cursorHeight,
    super.cursorRadius,
    super.cursorOpacityAnimates,
    super.cursorColor,
    super.selectionHeightStyle,
    super.selectionWidthStyle,
    super.keyboardAppearance,
    super.scrollPadding,
    super.enableInteractiveSelection,
    super.selectionControls,
    super.dragStartBehavior,
    super.scrollController,
    super.scrollPhysics,
    super.onTap,
    super.autofillHints,
    super.clipBehavior,
    super.restorationId,
    super.stylusHandwritingEnabled,
    super.enableIMEPersonalizedLearning,
    super.contentInsertionConfiguration,
    super.contextMenuBuilder = defaultContextMenuBuilder,
    super.hintText,
    super.border,
    super.borderRadius,
    super.filled,
    super.statesController,
    super.magnifierConfiguration,
    super.spellCheckConfiguration,
    super.features,
    super.submitFormatters,
    super.skipInputFeatureFocusTraversal,
  });

  /// Default context menu builder for editable text.
  ///
  /// Builds the standard context menu for text selection operations.
  static Widget defaultContextMenuBuilder(
    BuildContext context,
    EditableTextState editableTextState,
  ) {
    return buildEditableTextContextMenu(context, editableTextState);
  }

  /// Default spell check suggestions toolbar builder.
  ///
  /// Builds the toolbar showing spell check suggestions.
  @visibleForTesting
  static Widget defaultSpellCheckSuggestionsToolbarBuilder(
    BuildContext context,
    EditableTextState editableTextState,
  ) {
    return CupertinoSpellCheckSuggestionsToolbar.editableText(
      editableTextState: editableTextState,
    );
  }

  /// Creates the `State` object for this widget.
  @override
  State<TextField> createState() => TextFieldState();

  /// Performs `debugFillProperties` logic for this form component.
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<TextEditingController>(
        'controller',
        controller,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<FocusNode>(
        'focusNode',
        focusNode,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<UndoHistoryController>(
        'undoController',
        undoController,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<BoxDecoration>('decoration', decoration),
    );
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties.add(
      DiagnosticsProperty<String>(
        'clearButtonSemanticLabel',
        clearButtonSemanticLabel,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextInputType>(
        'keyboardType',
        keyboardType,
        defaultValue: TextInputType.text,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>('style', style, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty<bool>('autofocus', autofocus, defaultValue: false),
    );
    properties.add(
      DiagnosticsProperty<String>(
        'obscuringCharacter',
        obscuringCharacter,
        defaultValue: '•',
      ),
    );
    properties.add(
      DiagnosticsProperty<bool>(
        'obscureText',
        obscureText,
        defaultValue: false,
      ),
    );
    properties.add(
      DiagnosticsProperty<bool>('autocorrect', autocorrect, defaultValue: true),
    );
    properties.add(
      EnumProperty<SmartDashesType>(
        'smartDashesType',
        smartDashesType,
        defaultValue: obscureText
            ? SmartDashesType.disabled
            : SmartDashesType.enabled,
      ),
    );
    properties.add(
      EnumProperty<SmartQuotesType>(
        'smartQuotesType',
        smartQuotesType,
        defaultValue: obscureText
            ? SmartQuotesType.disabled
            : SmartQuotesType.enabled,
      ),
    );
    properties.add(
      DiagnosticsProperty<bool>(
        'enableSuggestions',
        enableSuggestions,
        defaultValue: true,
      ),
    );
    properties.add(IntProperty('maxLines', maxLines, defaultValue: 1));
    properties.add(IntProperty('minLines', minLines, defaultValue: null));
    properties.add(
      DiagnosticsProperty<bool>('expands', expands, defaultValue: false),
    );
    properties.add(IntProperty('maxLength', maxLength, defaultValue: null));
    properties.add(
      EnumProperty<MaxLengthEnforcement>(
        'maxLengthEnforcement',
        maxLengthEnforcement,
        defaultValue: null,
      ),
    );
    properties.add(
      DoubleProperty('cursorWidth', cursorWidth, defaultValue: 2.0),
    );
    properties.add(
      DoubleProperty('cursorHeight', cursorHeight, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty<Radius>(
        'cursorRadius',
        cursorRadius,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<bool>(
        'cursorOpacityAnimates',
        cursorOpacityAnimates,
        defaultValue: true,
      ),
    );
    properties.add(ColorProperty('cursorColor', cursorColor));
    properties.add(
      DiagnosticsProperty<TextSelectionControls>(
        'selectionControls',
        selectionControls,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<ScrollController>(
        'scrollController',
        scrollController,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<ScrollPhysics>(
        'scrollPhysics',
        scrollPhysics,
        defaultValue: null,
      ),
    );
    properties.add(
      EnumProperty<TextAlign>(
        'textAlign',
        textAlign,
        defaultValue: TextAlign.start,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextAlignVertical>(
        'textAlignVertical',
        textAlignVertical,
        defaultValue: null,
      ),
    );
    properties.add(
      EnumProperty<TextDirection>(
        'textDirection',
        textDirection,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<Clip>(
        'clipBehavior',
        clipBehavior,
        defaultValue: Clip.hardEdge,
      ),
    );
    properties.add(
      DiagnosticsProperty<bool>(
        'stylusHandwritingEnabled',
        stylusHandwritingEnabled,
        defaultValue: EditableText.defaultStylusHandwritingEnabled,
      ),
    );
    properties.add(
      DiagnosticsProperty<bool>(
        'enableIMEPersonalizedLearning',
        enableIMEPersonalizedLearning,
        defaultValue: true,
      ),
    );
    properties.add(
      DiagnosticsProperty<SpellCheckConfiguration>(
        'spellCheckConfiguration',
        spellCheckConfiguration,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<List<String>>(
        'contentCommitMimeTypes',
        contentInsertionConfiguration?.allowedMimeTypes ?? const <String>[],
        defaultValue: contentInsertionConfiguration == null
            ? const <String>[]
            : kDefaultContentInsertionMimeTypes,
      ),
    );
    properties.add(IterableProperty<InputFeature>('features', features));
  }
}
