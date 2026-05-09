// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:async';

import 'package:data_widget/data_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'
    hide Theme, TextField, ButtonStyle, Chip, ErrorWidgetBuilder;
import 'package:flutter/services.dart';

import '../../utility/async/async.dart';
import '../../control/button/button.dart';
import '../../display/chip/chip.dart';
import '../../control/command/command.dart';
import '../../overlay/dialog/dialog.dart';
import '../../control/hover/hover.dart';
import '../../overlay/menu/menu.dart'
    hide MenuIconStyleExtensions, MenuTextStyleExtensions;
import '../text_field/text_field.dart';
import '../../../shared/icons/lucide_icons.dart';
import '../../../shared/icons/radix_icons.dart';
import '../../../shared/primitives/clickable.dart';
import '../../../shared/primitives/focus_outline.dart';
import '../../../shared/primitives/form_control.dart';
import '../../../shared/primitives/form_value_supplier.dart';
import '../../../shared/primitives/icon_extensions.dart';
import '../../../shared/primitives/overlay.dart';
import '../../../shared/primitives/subfocus.dart';
import '../../../shared/primitives/text.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/style_value.dart';
import '../../../shared/utils/util.dart';

part '_impl/themes/base/select_theme.dart';

part '_impl/state/_select_popup_state.dart';
part '_impl/core/controlled_multi_select.dart';
part '_impl/core/controlled_select.dart';
part '_impl/core/empty_select_item.dart';
part '_impl/core/multi_select.dart';
part '_impl/core/multi_select_chip.dart';
part '_impl/utils/multi_select_controller.dart';
part '_impl/core/select_base.dart';
part '_impl/utils/select_controller.dart';
part '_impl/core/select_data.dart';
part '_impl/core/select_group.dart';
part '_impl/core/select_item.dart';
part '_impl/utils/select_item_builder.dart';
part '_impl/core/select_item_button.dart';
part '_impl/utils/select_item_delegate.dart';
part '_impl/core/select_item_list.dart';
part '_impl/core/select_label.dart';
part '_impl/core/select_popup.dart';
part '_impl/core/select_popup_handle.dart';
part '_impl/state/select_state.dart';

/// Builder function for select popup content.
///
/// Returns the widget tree for the dropdown/popup menu.
typedef SelectPopupBuilder = Widget Function(BuildContext context);

/// Builder function for rendering selected values.
///
/// Parameters:
/// - [context] (`BuildContext`): Build context.
/// - [value] (`T`): The selected value.
///
/// Returns: Widget representation of the value.
typedef SelectValueBuilder<T> = Widget Function(BuildContext context, T value);

/// Handler for custom selection logic.
///
/// Parameters:
/// - [oldValue] (`T?`): Previous selection.
/// - [value] (`Object?`): Newly selected item.
/// - [selected] (`bool`): Whether item is being selected (true) or deselected (false).
///
/// Returns: `T?` — the new selection state.
typedef SelectValueSelectionHandler<T> =
    T? Function(T? oldValue, Object? value, bool selected);

/// Predicate for testing value selection state.
///
/// Parameters:
/// - [value] (`T?`): Current selection.
/// - [test] (`Object?`): Value to test against.
///
/// Returns: `bool` — true if test matches selection.
typedef SelectValueSelectionPredicate<T> =
    bool Function(T? value, Object? test);

T? _defaultSingleSelectValueSelectionHandler<T>(
  T? oldValue,
  Object? value,
  bool selected,
) {
  if (value is! T?) {
    return null;
  }
  return selected ? value : null;
}

bool _defaultSingleSelectValueSelectionPredicate<T>(T? value, Object? test) {
  return value == test;
}

Iterable<T>? _defaultMultiSelectValueSelectionHandler<T>(
  Iterable<T>? oldValue,
  Object? newValue,
  bool selected,
) {
  if (newValue == null) {
    return null;
  }
  Iterable<T> wrappedNewValue = [newValue as T];
  if (oldValue == null) {
    return selected ? wrappedNewValue : null;
  }
  if (selected) {
    return oldValue.followedBy(wrappedNewValue);
  } else {
    var newIterable = oldValue.where((element) => element != newValue);
    return newIterable.isEmpty ? null : newIterable;
  }
}

bool _defaultMultiSelectValueSelectionPredicate<T>(
  Iterable<T>? value,
  Object? test,
) {
  if (value == null) {
    return test == null;
  }
  if (test == null) {
    return false;
  }
  return value.contains(test);
}

/// A customizable dropdown selection widget for single-value selection.
///
/// [Select] provides a comprehensive dropdown selection experience with support for
/// custom item rendering, keyboard navigation, search functionality, and extensive
/// customization options. It displays a trigger button that opens a popup containing
/// selectable options when activated.
///
/// Key features:
/// - Single-value selection with optional null/unselect capability
/// - Customizable item rendering through builder functions
/// - Keyboard navigation and accessibility support
/// - Configurable popup positioning and constraints
/// - Search and filtering capabilities
/// - Focus management and interaction handling
/// - Theming and visual customization
/// - Form integration and validation support
///
/// The widget supports various configuration modes:
/// - Filled or outlined appearance styles
/// - Custom popup positioning and alignment
/// - Conditional item visibility and selection
/// - Hover effects and interaction feedback
/// - Auto-closing popup behavior
///
/// Selection behavior can be customized through:
/// - [valueSelectionHandler]: Custom logic for handling selection
/// - [valueSelectionPredicate]: Conditions for allowing selection
/// - [showValuePredicate]: Conditions for displaying items
/// - [canUnselect]: Whether to allow deselecting the current value
///
/// Example:
/// ```dart
/// Select<String>(
///   value: selectedItem,
///   placeholder: Text('Choose an option'),
///   onChanged: (value) => setState(() => selectedItem = value),
///   popup: SelectPopup.menu(
///     children: [
///       SelectItem(value: 'option1', child: Text('Option 1')),
///       SelectItem(value: 'option2', child: Text('Option 2')),
///       SelectItem(value: 'option3', child: Text('Option 3')),
///     ],
///   ),
/// );
/// ```
class Select<T> extends StatefulWidget with SelectBase<T> {
  /// Default maximum height for select popups in logical pixels.
  static const kDefaultSelectMaxHeight = 240.0;
  @override
  final ValueChanged<T?>? onChanged; // if null, then it's a disabled combobox
  @override
  final Widget? placeholder; // placeholder when value is null
  /// Field storing `filled` for this form implementation.
  @override
  final bool filled;

  /// Focus node/reference used by `focusNode` interactions.
  @override
  final FocusNode? focusNode;

  /// Field storing `constraints` for this form implementation.
  @override
  final BoxConstraints? constraints;

  /// Field storing `popupConstraints` for this form implementation.
  @override
  final BoxConstraints? popupConstraints;

  /// Field storing `popupWidthConstraint` for this form implementation.
  @override
  final PopoverConstraint popupWidthConstraint;

  /// The currently selected value.
  final T? value;

  /// Field storing `borderRadius` for this form implementation.
  @override
  final BorderRadiusGeometry? borderRadius;

  /// Field storing `padding` for this form implementation.
  @override
  final EdgeInsetsGeometry? padding;

  /// Field storing `popoverAlignment` for this form implementation.
  @override
  final AlignmentGeometry popoverAlignment;

  /// Field storing `popoverAnchorAlignment` for this form implementation.
  @override
  final AlignmentGeometry? popoverAnchorAlignment;

  /// Field storing `disableHoverEffect` for this form implementation.
  @override
  final bool disableHoverEffect;

  /// Field storing `canUnselect` for this form implementation.
  @override
  final bool canUnselect;

  /// Field storing `autoClosePopover` for this form implementation.
  @override
  final bool? autoClosePopover;

  /// Whether the select is enabled for user interaction.
  final bool? enabled;

  /// Field storing `popup` for this form implementation.
  @override
  final SelectPopupBuilder popup;

  /// Field storing `itemBuilder` for this form implementation.
  @override
  final SelectValueBuilder<T> itemBuilder;

  /// Current value stored for `valueSelectionHandler`.
  @override
  final SelectValueSelectionHandler<T>? valueSelectionHandler;

  /// Current value stored for `valueSelectionPredicate`.
  @override
  final SelectValueSelectionPredicate<T>? valueSelectionPredicate;

  /// Current value stored for `showValuePredicate`.
  @override
  final Predicate<T>? showValuePredicate;

  /// Creates a single-selection dropdown widget.
  ///
  /// The [popup] and [itemBuilder] parameters are required to define the
  /// dropdown content and how selected values are displayed.
  ///
  /// Parameters:
  /// - [key] (Key?): Widget key for controlling widget identity
  /// - [onChanged] (`ValueChanged<T?>?`): Callback when selection changes; if null, select is disabled
  /// - [placeholder] (Widget?): Widget shown when no value is selected
  /// - [filled] (bool): Whether to use filled background style, defaults to false
  /// - [focusNode] (FocusNode?): Focus node for keyboard interaction
  /// - [constraints] (BoxConstraints?): Size constraints for the select button
  /// - [popupConstraints] (BoxConstraints?): Size constraints for the popup menu
  /// - [popupWidthConstraint] (PopoverConstraint): Width constraint mode for popup, defaults to `PopoverConstraint.anchorFixedSize`
  /// - [value] (T?): Currently selected value
  /// - [disableHoverEffect] (bool): Whether to disable hover visual feedback, defaults to false
  /// - [borderRadius] (BorderRadiusGeometry?): Custom border radius
  /// - [padding] (EdgeInsetsGeometry?): Custom padding
  /// - [popoverAlignment] (AlignmentGeometry): Popup alignment, defaults to `Alignment.topCenter`
  /// - [popoverAnchorAlignment] (AlignmentGeometry?): Anchor alignment for popup positioning
  /// - [canUnselect] (bool): Whether user can deselect current value, defaults to false
  /// - [autoClosePopover] (bool?): Whether popup closes after selection, defaults to true
  /// - [enabled] (bool?): Whether select is enabled for interaction
  /// - [valueSelectionHandler] (`SelectValueSelectionHandler<T>?`): Custom selection logic
  /// - [valueSelectionPredicate] (`SelectValueSelectionPredicate<T>?`): Predicate for allowing selection
  /// - [showValuePredicate] (`Predicate<T>?`): Predicate for showing items
  /// - [popup] (SelectPopupBuilder): Required builder for popup content
  /// - [itemBuilder] (`SelectValueBuilder<T>`): Required builder for selected value display
  const Select({
    super.key,
    this.onChanged,
    this.placeholder,
    this.filled = false,
    this.focusNode,
    this.constraints,
    this.popupConstraints,
    this.popupWidthConstraint = PopoverConstraint.anchorFixedSize,
    this.value,
    this.disableHoverEffect = false,
    this.borderRadius,
    this.padding,
    this.popoverAlignment = Alignment.topCenter,
    this.popoverAnchorAlignment,
    this.canUnselect = false,
    this.autoClosePopover = true,
    this.enabled,
    this.valueSelectionHandler,
    this.valueSelectionPredicate,
    this.showValuePredicate,
    required this.popup,
    required this.itemBuilder,
  });

  /// Creates the `State` object for this widget.
  @override
  SelectState<T> createState() => SelectState<T>();
}

/// Callback type for handling selection changes in select components.
///
/// Returns true if the change was successful, false otherwise.
typedef SelectValueChanged<T> = bool Function(T value, bool selected);

/// Builder function type for creating select item delegates.
///
/// Takes the build context and optional search query, returns a delegate
/// for rendering select items.
typedef SelectItemsBuilder<T> =
    FutureOr<SelectItemDelegate> Function(
      BuildContext context,
      String? searchQuery,
    );

/// Builder function type for creating select item widgets.
///
/// Takes the build context and item index, returns the widget for that item.
typedef SelectItemWidgetBuilder =
    Widget Function(BuildContext context, int index);
