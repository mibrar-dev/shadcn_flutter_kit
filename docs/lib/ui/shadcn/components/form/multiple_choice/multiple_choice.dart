// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:data_widget/data_widget.dart';
import 'package:flutter/widgets.dart';

import '../../../shared/primitives/form_control.dart';
import '../../../shared/primitives/form_value_supplier.dart';
import '../../../shared/theme/theme.dart';

part '_impl/themes/base/multiple_choice_theme.dart';

part '_impl/state/_multiple_answer_state.dart';
part '_impl/state/_multiple_choice_state.dart';
part '_impl/core/choice.dart';
part '_impl/core/controlled_multiple_answer.dart';
part '_impl/core/controlled_multiple_choice.dart';
part '_impl/core/multiple_answer.dart';
part '_impl/utils/multiple_answer_controller.dart';
part '_impl/utils/multiple_choice_controller.dart';

/// A widget for single-selection choice scenarios.
///
/// [MultipleChoice] manages a single selected value from multiple options.
/// It prevents multiple selections and optionally allows deselecting the
/// current choice by clicking it again.
///
/// This widget is typically used with choice items like [ChoiceChip] or
/// [ChoiceButton] which integrate with the inherited [Choice] data.
///
/// Example:
/// ```dart
/// MultipleChoice<String>(
///   value: selectedOption,
///   onChanged: (value) => setState(() => selectedOption = value),
///   child: Wrap(
///     children: [
///       ChoiceChip(value: 'A', child: Text('Option A')),
///       ChoiceChip(value: 'B', child: Text('Option B')),
///     ],
///   ),
/// )
/// ```
class MultipleChoice<T> extends StatefulWidget {
  /// The child widget tree containing choice items.
  final Widget child;

  /// The currently selected value.
  final T? value;

  /// Callback when the selection changes.
  final ValueChanged<T?>? onChanged;

  /// Whether choices are enabled.
  final bool? enabled;

  /// Whether the current selection can be unselected.
  final bool? allowUnselect;

  /// Creates a [MultipleChoice].
  ///
  /// Parameters:
  /// - [child] (`Widget`, required): Widget tree with choice items.
  /// - [value] (`T?`, optional): Currently selected value.
  /// - [onChanged] (`ValueChanged<T?>?`, optional): Selection callback.
  /// - [enabled] (`bool?`, optional): Whether choices are enabled.
  /// - [allowUnselect] (`bool?`, optional): Allow deselecting the current choice.
  const MultipleChoice({
    super.key,
    required this.child,
    this.value,
    this.onChanged,
    this.enabled,
    this.allowUnselect,
  });

  /// Creates the `State` object for this widget.
  @override
  State<MultipleChoice<T>> createState() => _MultipleChoiceState<T>();
}
