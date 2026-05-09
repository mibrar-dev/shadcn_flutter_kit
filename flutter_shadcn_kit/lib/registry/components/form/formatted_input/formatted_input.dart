// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' hide Form;

import '../../../shared/primitives/clickable.dart';
import '../../../shared/primitives/form_control.dart';
import '../../../shared/primitives/focus_outline.dart';
import '../../../shared/primitives/overlay.dart';
import '../../../shared/primitives/text.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/color_extensions.dart';
import '../../../shared/utils/text_input_utils.dart';
import '../../../shared/utils/util.dart';
import '../../control/button/button.dart';
import '../form/form.dart';
import '../../layout/outlined_container/outlined_container.dart';
import '../text_field/text_field.dart';

part '_impl/themes/base/formatted_input_theme.dart';

part '_impl/utils/_editable_part_controller.dart';
part '_impl/core/_editable_part_widget.dart';
part '_impl/state/_editable_part_widget_state.dart';
part '_impl/state/_formatted_input_state.dart';
part '_impl/utils/_formatted_object_controller.dart';
part '_impl/state/_formatted_object_input_state.dart';
part '_impl/core/_static_part_widget.dart';
part '_impl/state/_static_part_widget_state.dart';
part '_impl/core/editable_part.dart';
part '_impl/utils/formatted_input_controller.dart';
part '_impl/core/formatted_input_data.dart';
part '_impl/core/formatted_object_input.dart';
part '_impl/core/formatted_value.dart';
part '_impl/core/formatted_value_part.dart';
part '_impl/core/input_part.dart';
part '_impl/core/static_part.dart';
part '_impl/core/widget_part.dart';

/// A controlled input widget for structured data entry with formatting.
///
/// This widget provides a sophisticated input system that combines static text
/// elements with editable fields in a single input interface. It's ideal for
/// formatted inputs like phone numbers, credit cards, dates, or any structured
/// data that requires specific formatting patterns.
///
/// The FormattedInput manages multiple editable segments, each with their own
/// validation, formatting, and input restrictions. It automatically handles
/// focus management between segments and provides a seamless user experience
/// with proper keyboard navigation.
///
/// Example:
/// ```dart
/// FormattedInput(
///   style: TextStyle(fontFamily: 'monospace'),
///   leading: Icon(Icons.phone),
///   initialValue: FormattedValue([
///     FormattedValuePart.static('('),
///     FormattedValuePart.editable('555', length: 3),
///     FormattedValuePart.static(') '),
///     FormattedValuePart.editable('123', length: 3),
///     FormattedValuePart.static('-'),
///     FormattedValuePart.editable('4567', length: 4),
///   ]),
/// );
/// ```
class FormattedInput extends StatefulWidget
    with ControlledComponent<FormattedValue> {
  @override
  final FormattedValue? initialValue;
  @override
  final ValueChanged<FormattedValue>? onChanged;
  @override
  final bool enabled;
  @override
  final FormattedInputController? controller;

  /// Text style applied to all input segments.
  ///
  /// This style affects both static text and editable input fields within
  /// the formatted input. Using a monospace font family is recommended
  /// for consistent character spacing across segments.
  final TextStyle? style;

  /// Widget displayed at the beginning of the input.
  ///
  /// Commonly used for icons or labels that provide context for the input
  /// content, such as a phone icon for phone number inputs.
  final Widget? leading;

  /// Widget displayed at the end of the input.
  ///
  /// Can be used for action buttons, status indicators, or additional
  /// context related to the input content.
  final Widget? trailing;

  /// Creates a [FormattedInput].
  ///
  /// The input structure is defined by the [initialValue] or [controller]
  /// value, which contains the mix of static text and editable segments.
  /// Each editable segment can have its own length restrictions and formatting.
  ///
  /// Parameters:
  /// - [initialValue] (FormattedValue?, optional): Initial structure and values
  /// - [onChanged] (`ValueChanged<FormattedValue>?`, optional): Callback for value changes
  /// - [style] (TextStyle?, optional): Text styling for all segments
  /// - [leading] (Widget?, optional): Widget displayed before the input
  /// - [trailing] (Widget?, optional): Widget displayed after the input
  /// - [enabled] (bool, default: true): Whether the input accepts user interaction
  /// - [controller] (FormattedInputController?, optional): External controller for programmatic control
  ///
  /// Example:
  /// ```dart
  /// FormattedInput(
  ///   initialValue: FormattedValue([
  ///     FormattedValuePart.static('$'),
  ///     FormattedValuePart.editable('0.00', length: 8),
  ///   ]),
  ///   leading: Icon(Icons.attach_money),
  ///   style: TextStyle(fontSize: 16),
  /// );
  /// ```
  const FormattedInput({
    super.key,
    this.initialValue,
    this.onChanged,
    this.style,
    this.leading,
    this.trailing,
    this.enabled = true,
    this.controller,
  });

  /// Creates the `State` object for this widget.
  @override
  State<FormattedInput> createState() => _FormattedInputState();
}

/// A function type for building custom popup content for formatted object inputs.
///
/// Parameters:
/// - [context]: The build context.
/// - [controller]: The controller managing the input value.
///
/// Returns: A widget to display in the popup.
typedef FormattedInputPopupBuilder<T> =
    Widget Function(BuildContext context, ComponentController<T?> controller);
