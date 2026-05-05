part of '../../text_field.dart';

/// Extension helpers for form-related types.
extension TextFieldCopyExtension on TextField {
  /// All parameters are optional and allow selective property replacement.
  TextField copyWith({
    ValueGetter<Key?>? key,
    ValueGetter<Object>? groupId,
    ValueGetter<TextEditingController?>? controller,
    ValueGetter<String?>? initialValue,
    ValueGetter<FocusNode?>? focusNode,
    ValueGetter<UndoHistoryController?>? undoController,
    ValueGetter<BoxDecoration?>? decoration,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<Widget?>? placeholder,
    ValueGetter<CrossAxisAlignment>? crossAxisAlignment,
    ValueGetter<String?>? clearButtonSemanticLabel,
    ValueGetter<TextInputType?>? keyboardType,
    ValueGetter<TextInputAction?>? textInputAction,
    ValueGetter<TextCapitalization>? textCapitalization,
    ValueGetter<TextStyle?>? style,
    ValueGetter<StrutStyle?>? strutStyle,
    ValueGetter<TextAlign>? textAlign,
    ValueGetter<TextAlignVertical?>? textAlignVertical,
    ValueGetter<TextDirection?>? textDirection,
    ValueGetter<bool>? readOnly,
    ValueGetter<bool?>? showCursor,
    ValueGetter<bool>? autofocus,
    ValueGetter<String>? obscuringCharacter,
    ValueGetter<bool>? obscureText,
    ValueGetter<bool>? autocorrect,
    ValueGetter<SmartDashesType>? smartDashesType,
    ValueGetter<SmartQuotesType>? smartQuotesType,
    ValueGetter<bool>? enableSuggestions,
    ValueGetter<int?>? maxLines,
    ValueGetter<int?>? minLines,
    ValueGetter<bool>? expands,
    ValueGetter<int?>? maxLength,
    ValueGetter<MaxLengthEnforcement?>? maxLengthEnforcement,
    ValueGetter<ValueChanged<String>?>? onChanged,
    ValueGetter<VoidCallback?>? onEditingComplete,
    ValueGetter<ValueChanged<String>?>? onSubmitted,
    ValueGetter<TapRegionCallback?>? onTapOutside,
    ValueGetter<TapRegionCallback?>? onTapUpOutside,
    ValueGetter<List<TextInputFormatter>?>? inputFormatters,
    ValueGetter<bool>? enabled,
    ValueGetter<double>? cursorWidth,
    ValueGetter<double?>? cursorHeight,
    ValueGetter<Radius>? cursorRadius,
    ValueGetter<bool>? cursorOpacityAnimates,
    ValueGetter<Color?>? cursorColor,
    ValueGetter<ui.BoxHeightStyle>? selectionHeightStyle,
    ValueGetter<ui.BoxWidthStyle>? selectionWidthStyle,
    ValueGetter<Brightness?>? keyboardAppearance,
    ValueGetter<EdgeInsets>? scrollPadding,
    ValueGetter<bool>? enableInteractiveSelection,
    ValueGetter<TextSelectionControls?>? selectionControls,
    ValueGetter<DragStartBehavior>? dragStartBehavior,
    ValueGetter<ScrollController?>? scrollController,
    ValueGetter<ScrollPhysics?>? scrollPhysics,
    ValueGetter<GestureTapCallback?>? onTap,
    ValueGetter<Iterable<String>?>? autofillHints,
    ValueGetter<Clip>? clipBehavior,
    ValueGetter<String?>? restorationId,
    ValueGetter<bool>? stylusHandwritingEnabled,
    ValueGetter<bool>? enableIMEPersonalizedLearning,
    ValueGetter<ContentInsertionConfiguration?>? contentInsertionConfiguration,
    ValueGetter<EditableTextContextMenuBuilder?>? contextMenuBuilder,
    ValueGetter<String?>? hintText,
    ValueGetter<Border?>? border,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<bool?>? filled,
    ValueGetter<WidgetStatesController?>? statesController,
    ValueGetter<TextMagnifierConfiguration?>? magnifierConfiguration,
    ValueGetter<SpellCheckConfiguration?>? spellCheckConfiguration,
    ValueGetter<List<InputFeature>>? features,
    ValueGetter<List<TextInputFormatter>?>? submitFormatters,
    ValueGetter<bool>? skipInputFeatureFocusTraversal,
  }) {
    return TextField(
      key: key == null ? this.key : key(),
      groupId: groupId == null ? this.groupId : groupId(),
      controller: controller == null ? this.controller : controller(),
      initialValue: initialValue == null ? this.initialValue : initialValue(),
      focusNode: focusNode == null ? this.focusNode : focusNode(),
      undoController: undoController == null
          ? this.undoController
          : undoController(),
      decoration: decoration == null ? this.decoration : decoration(),
      padding: padding == null ? this.padding : padding(),
      placeholder: placeholder == null ? this.placeholder : placeholder(),
      crossAxisAlignment: crossAxisAlignment == null
          ? this.crossAxisAlignment
          : crossAxisAlignment(),
      clearButtonSemanticLabel: clearButtonSemanticLabel == null
          ? this.clearButtonSemanticLabel
          : clearButtonSemanticLabel(),
      keyboardType: keyboardType == null ? this.keyboardType : keyboardType(),
      textInputAction: textInputAction == null
          ? this.textInputAction
          : textInputAction(),
      textCapitalization: textCapitalization == null
          ? this.textCapitalization
          : textCapitalization(),
      style: style == null ? this.style : style(),
      strutStyle: strutStyle == null ? this.strutStyle : strutStyle(),
      textAlign: textAlign == null ? this.textAlign : textAlign(),
      textAlignVertical: textAlignVertical == null
          ? this.textAlignVertical
          : textAlignVertical(),
      textDirection: textDirection == null
          ? this.textDirection
          : textDirection(),
      readOnly: readOnly == null ? this.readOnly : readOnly(),
      showCursor: showCursor == null ? this.showCursor : showCursor(),
      autofocus: autofocus == null ? this.autofocus : autofocus(),
      obscuringCharacter: obscuringCharacter == null
          ? this.obscuringCharacter
          : obscuringCharacter(),
      obscureText: obscureText == null ? this.obscureText : obscureText(),
      autocorrect: autocorrect == null ? this.autocorrect : autocorrect(),
      smartDashesType: smartDashesType == null
          ? this.smartDashesType
          : smartDashesType(),
      smartQuotesType: smartQuotesType == null
          ? this.smartQuotesType
          : smartQuotesType(),
      enableSuggestions: enableSuggestions == null
          ? this.enableSuggestions
          : enableSuggestions(),
      maxLines: maxLines == null ? this.maxLines : maxLines(),
      minLines: minLines == null ? this.minLines : minLines(),
      expands: expands == null ? this.expands : expands(),
      maxLength: maxLength == null ? this.maxLength : maxLength(),
      maxLengthEnforcement: maxLengthEnforcement == null
          ? this.maxLengthEnforcement
          : maxLengthEnforcement(),
      onChanged: onChanged == null ? this.onChanged : onChanged(),
      onEditingComplete: onEditingComplete == null
          ? this.onEditingComplete
          : onEditingComplete(),
      onSubmitted: onSubmitted == null ? this.onSubmitted : onSubmitted(),
      onTapOutside: onTapOutside == null ? this.onTapOutside : onTapOutside(),
      onTapUpOutside: onTapUpOutside == null
          ? this.onTapUpOutside
          : onTapUpOutside(),
      inputFormatters: inputFormatters == null
          ? this.inputFormatters
          : inputFormatters(),
      enabled: enabled == null ? this.enabled : enabled(),
      cursorWidth: cursorWidth == null ? this.cursorWidth : cursorWidth(),
      cursorHeight: cursorHeight == null ? this.cursorHeight : cursorHeight(),
      cursorRadius: cursorRadius == null ? this.cursorRadius : cursorRadius(),
      cursorOpacityAnimates: cursorOpacityAnimates == null
          ? this.cursorOpacityAnimates
          : cursorOpacityAnimates(),
      cursorColor: cursorColor == null ? this.cursorColor : cursorColor(),
      selectionHeightStyle: selectionHeightStyle == null
          ? this.selectionHeightStyle
          : selectionHeightStyle(),
      selectionWidthStyle: selectionWidthStyle == null
          ? this.selectionWidthStyle
          : selectionWidthStyle(),
      keyboardAppearance: keyboardAppearance == null
          ? this.keyboardAppearance
          : keyboardAppearance(),
      scrollPadding: scrollPadding == null
          ? this.scrollPadding
          : scrollPadding(),
      enableInteractiveSelection: enableInteractiveSelection == null
          ? this.enableInteractiveSelection
          : enableInteractiveSelection(),
      selectionControls: selectionControls == null
          ? this.selectionControls
          : selectionControls(),
      dragStartBehavior: dragStartBehavior == null
          ? this.dragStartBehavior
          : dragStartBehavior(),
      scrollController: scrollController == null
          ? this.scrollController
          : scrollController(),
      scrollPhysics: scrollPhysics == null
          ? this.scrollPhysics
          : scrollPhysics(),
      onTap: onTap == null ? this.onTap : onTap(),
      autofillHints: autofillHints == null
          ? this.autofillHints
          : autofillHints(),
      clipBehavior: clipBehavior == null ? this.clipBehavior : clipBehavior(),
      restorationId: restorationId == null
          ? this.restorationId
          : restorationId(),
      stylusHandwritingEnabled: stylusHandwritingEnabled == null
          ? this.stylusHandwritingEnabled
          : stylusHandwritingEnabled(),
      enableIMEPersonalizedLearning: enableIMEPersonalizedLearning == null
          ? this.enableIMEPersonalizedLearning
          : enableIMEPersonalizedLearning(),
      contentInsertionConfiguration: contentInsertionConfiguration == null
          ? this.contentInsertionConfiguration
          : contentInsertionConfiguration(),
      contextMenuBuilder: contextMenuBuilder == null
          ? this.contextMenuBuilder
          : contextMenuBuilder(),
      hintText: hintText == null ? this.hintText : hintText(),
      border: border == null ? this.border : border(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      filled: filled == null ? this.filled : filled(),
      statesController: statesController == null
          ? this.statesController
          : statesController(),
      magnifierConfiguration: magnifierConfiguration == null
          ? this.magnifierConfiguration
          : magnifierConfiguration(),
      spellCheckConfiguration: spellCheckConfiguration == null
          ? this.spellCheckConfiguration
          : spellCheckConfiguration(),
      features: features == null ? this.features : features(),
      submitFormatters: submitFormatters == null
          ? this.submitFormatters
          : submitFormatters(),
      skipInputFeatureFocusTraversal: skipInputFeatureFocusTraversal == null
          ? this.skipInputFeatureFocusTraversal
          : skipInputFeatureFocusTraversal(),
    );
  }
}
