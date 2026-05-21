// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:async';

import 'package:data_widget/data_widget.dart';
import 'package:flutter/services.dart' show Clipboard, LogicalKeyboardKey;
import 'package:flutter/widgets.dart';

import '../../../shared/icons/lucide_icons.dart';
import '../../../shared/primitives/form_value_supplier.dart';
import '../../../shared/primitives/overlay.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/util.dart';
import '../../control/button/button.dart';
import '../text_field/text_field.dart';

part '_impl/state/_auto_complete_feature_state.dart';
part '_impl/state/_input_clear_feature_state.dart';
part '_impl/state/_input_copy_feature_state.dart';
part '_impl/state/_input_hint_feature_state.dart';
part '_impl/state/_input_above_below_feature_state.dart';
part '_impl/state/_input_leading_feature_state.dart';
part '_impl/state/_input_password_toggle_feature_state.dart';
part '_impl/state/_input_paste_feature_state.dart';
part '_impl/state/_input_revalidate_feature_state.dart';
part '_impl/state/_input_spinner_feature_state.dart';
part '_impl/state/_input_stepper_button_feature_state.dart';
part '_impl/state/_input_trailing_feature_state.dart';
part '_impl/core/input_auto_complete_feature.dart';
part '_impl/core/input_above_below_feature.dart';
part '_impl/core/input_clear_feature.dart';
part '_impl/core/input_copy_feature.dart';
part '_impl/core/input_hint_feature.dart';
part '_impl/core/input_leading_feature.dart';
part '_impl/core/input_password_toggle_feature.dart';
part '_impl/core/input_paste_feature.dart';
part '_impl/core/input_revalidate_feature.dart';
part '_impl/utils/input_show_hint_intent.dart';
part '_impl/core/input_spinner_feature.dart';
part '_impl/core/input_stepper_button_feature.dart';
part '_impl/core/input_trailing_feature.dart';
part '_impl/core/password_peek_mode.dart';

/// Position where an input feature is displayed.
///
/// Determines whether an input feature (icon, button, widget) appears on
/// the leading (left/start) or trailing (right/end) side of the input.
enum InputFeaturePosition {
  /// Display the feature on the leading side.
  leading,

  /// Display the feature on the trailing side.
  trailing,

  /// Display the feature above the input text.
  above,

  /// Display the feature below the input text.
  below,
}

/// A callback that provides suggestions based on a query string.
///
/// Parameters:
/// - [query] (`String`): The current input text to generate suggestions for.
///
/// Returns: `FutureOr<Iterable<String>>` — The list of suggestion strings.
typedef SuggestionBuilder = FutureOr<Iterable<String>> Function(String query);
