// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../text_field/text_field.dart';
import '../../../shared/theme/theme.dart';

part '_impl/state/text_area_state.dart';
part '_impl/core/text_area_handle.dart';

/// Multi-line text input with resizable dimensions.
class TextArea extends TextInputStatefulWidget {
  /// Field storing `expandableHeight` for this form implementation.
  final bool expandableHeight;

  /// Field storing `expandableWidth` for this form implementation.
  final bool expandableWidth;

  /// Field storing `initialHeight` for this form implementation.
  final double initialHeight;

  /// Field storing `initialWidth` for this form implementation.
  final double initialWidth;

  /// Callback invoked for `onHeightChanged` events.
  final ValueChanged<double>? onHeightChanged;

  /// Callback invoked for `onWidthChanged` events.
  final ValueChanged<double>? onWidthChanged;

  /// Field storing `minWidth` for this form implementation.
  final double minWidth;

  /// Field storing `minHeight` for this form implementation.
  final double minHeight;

  /// Field storing `maxWidth` for this form implementation.
  final double maxWidth;

  /// Field storing `maxHeight` for this form implementation.
  final double maxHeight;

  /// Constructs `TextArea` with the provided parameters.
  const TextArea({
    super.key,
    super.groupId,
    super.controller,
    super.focusNode,
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
    super.contextMenuBuilder,
    super.initialValue,
    super.hintText,
    super.border,
    super.borderRadius,
    super.filled,
    super.statesController,
    super.magnifierConfiguration,
    super.spellCheckConfiguration,
    super.undoController,
    super.features,
    super.submitFormatters,
    super.skipInputFeatureFocusTraversal,
    this.expandableHeight = false,
    this.expandableWidth = false,
    this.initialHeight = 100,
    this.initialWidth = double.infinity,
    this.onHeightChanged,
    this.onWidthChanged,
    this.minWidth = 100,
    this.minHeight = 100,
    this.maxWidth = double.infinity,
    this.maxHeight = double.infinity,
  });

  /// Creates the `State` object for this widget.
  @override
  State<TextArea> createState() => _TextAreaState();
}
