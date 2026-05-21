// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:data_widget/data_widget.dart';
import 'package:flutter/material.dart' hide Theme, Chip;
import 'package:flutter/services.dart';

import '../../../shared/icons/lucide_icons.dart';
import '../../../shared/primitives/form_value_supplier.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/style_value.dart';
import '../autocomplete/autocomplete.dart';
import '../../display/chip/chip.dart';
import '../text_field/text_field.dart' hide AutoCompleteIntent;

part '_impl/themes/base/chip_input_theme.dart';

part '_impl/utils/_chip_provider.dart';
part '_impl/utils/chip_editing_controller.dart';
part '_impl/state/chip_input_state.dart';
part '_impl/utils/chip_submit_intent.dart';

/// Function signature for building custom chip widgets in chip input fields.
///
/// Takes a [BuildContext] and chip data of type [T], returning a widget that
/// represents the chip visually. Allows complete customization of chip appearance
/// and behavior within chip input components.
typedef ChipWidgetBuilder<T> = Widget Function(BuildContext context, T chip);

/// Callback type for converting text to a chip.
///
/// Takes the chip text and returns a chip object, or null if conversion fails.
typedef ChipSubmissionCallback<T> = T? Function(String chipText);

/// A text input widget that supports inline chip elements.
///
/// Allows users to create chip tokens within a text field, useful for
/// tags, email recipients, or any multi-item input scenario.
class ChipInput<T> extends TextInputStatefulWidget {
  /// Checks if a code unit represents a chip character.
  static bool isChipUnicode(int codeUnit) {
    return codeUnit >= ChipEditingController._chipStart &&
        codeUnit <= ChipEditingController._chipEnd;
  }

  /// Checks if a string character is a chip character.
  static bool isChipCharacter(String character) {
    if (character.isEmpty) return false;
    int codeUnit = character.codeUnitAt(0);
    return isChipUnicode(codeUnit);
  }

  /// Builder function for creating chip widgets.
  final ChipWidgetBuilder<T> chipBuilder;

  /// Callback to convert text into a chip object.
  final ChipSubmissionCallback<T> onChipSubmitted;

  /// Callback invoked when the list of chips changes.
  final ValueChanged<List<T>>? onChipsChanged;

  /// Whether to display items as visual chips (defaults to theme setting).
  final bool? useChips;

  /// Initial chips to display in the input.
  final List<T>? initialChips;

  /// Whether to automatically insert autocomplete suggestions as chips.
  final bool autoInsertSuggestion;

  /// Creates a chip input widget.
  const ChipInput({
    super.key,
    super.groupId,
    ChipEditingController<T>? super.controller,
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
    required this.chipBuilder,
    required this.onChipSubmitted,
    this.autoInsertSuggestion = true,
    this.onChipsChanged,
    this.useChips,
    this.initialChips,
  });

  @override
  ChipEditingController<T>? get controller =>
      super.controller as ChipEditingController<T>?;

  /// Creates the `State` object for this widget.
  @override
  State<ChipInput<T>> createState() => ChipInputState();
}
