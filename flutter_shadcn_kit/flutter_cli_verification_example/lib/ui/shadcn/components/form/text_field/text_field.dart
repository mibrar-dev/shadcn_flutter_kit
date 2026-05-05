import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:data_widget/data_widget.dart';
import 'package:flutter/cupertino.dart'
    show
        ConstrainedBox,
        CupertinoSpellCheckSuggestionsToolbar,
        cupertinoDesktopTextSelectionHandleControls;
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/foundation.dart'
    show IterableProperty, defaultTargetPlatform, listEquals;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../layout/card/card.dart';
import '../../control/button/button.dart';
import '../../../shared/icons/lucide_icons.dart';
import '../../../shared/primitives/form_value_supplier.dart';
import '../../../shared/primitives/focus_outline.dart';
import '../../../shared/primitives/hidden.dart';
import '../../../shared/primitives/overlay.dart';
import '../../../shared/primitives/clickable.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/border_utils.dart';
import '../../../shared/utils/chip_utils.dart';
import '../../../shared/utils/color_extensions.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/style_value.dart';
import '../../../shared/utils/text_input_utils.dart';
import '../../../shared/utils/util.dart';

part '_impl/core/_always_visible_input_feature_visibility.dart';
part '_impl/core/_attached_input_feature.dart';
part '_impl/state/_auto_complete_feature_state.dart';
part '_impl/core/_auto_complete_item.dart';
part '_impl/state/_auto_complete_item_state.dart';
part '_impl/state/_auto_complete_state.dart';
part '_impl/core/_focused_input_feature_visibility.dart';
part '_impl/core/_has_selection_input_feature_visibility.dart';
part '_impl/core/_hovered_input_feature_visibility.dart';
part '_impl/state/_input_clear_feature_state.dart';
part '_impl/state/_input_copy_feature_state.dart';
part '_impl/state/_input_hint_feature_state.dart';
part '_impl/state/_input_leading_feature_state.dart';
part '_impl/state/_input_password_toggle_feature_state.dart';
part '_impl/state/_input_paste_feature_state.dart';
part '_impl/state/_input_revalidate_feature_state.dart';
part '_impl/state/_input_spinner_feature_state.dart';
part '_impl/state/_input_trailing_feature_state.dart';
part '_impl/core/_logic_and_input_feature_visibility.dart';
part '_impl/core/_logic_or_input_feature_visibility.dart';
part '_impl/core/_negate_input_feature_visibility.dart';
part '_impl/core/_never_visible_input_feature_visibility.dart';
part '_impl/core/_text_empty_input_feature_visibility.dart';
part '_impl/core/_text_not_empty_input_feature_visibility.dart';
part '_impl/utils/accept_suggestion_intent.dart';
part '_impl/core/auto_complete.dart';
part '_impl/utils/auto_complete_intent.dart';
part '_impl/core/auto_complete_mode.dart';
part '_impl/core/input_auto_complete_feature.dart';
part '_impl/core/input_clear_feature.dart';
part '_impl/core/input_copy_feature.dart';
part '_impl/state/input_feature_state.dart';
part '_impl/core/input_hint_feature.dart';
part '_impl/core/input_leading_feature.dart';
part '_impl/core/input_password_toggle_feature.dart';
part '_impl/core/input_paste_feature.dart';
part '_impl/core/input_revalidate_feature.dart';
part '_impl/utils/input_show_hint_intent.dart';
part '_impl/core/input_spinner_feature.dart';
part '_impl/core/input_trailing_feature.dart';
part '_impl/utils/navigate_suggestion_intent.dart';
part '_impl/core/password_peek_mode.dart';
part '_impl/utils/text_field_clear_intent.dart';
part '_impl/utils/text_field_replace_current_word_intent.dart';
part '_impl/utils/text_field_select_all_and_copy_intent.dart';
part '_impl/utils/text_field_set_selection_intent.dart';
part '_impl/utils/text_field_set_text_intent.dart';

part '_impl/themes/base/text_field_theme.dart';
part '_impl/core/input_feature_visibility.dart';
part '_impl/core/input_feature_base.dart';
part '_impl/core/text_field_gestures.dart';
part '_impl/core/text_input_mixin.dart';
part '_impl/core/text_input_stateful_widget.dart';
part '_impl/core/text_input_stateful_widget_cont.dart';
part '_impl/core/text_field_widget.dart';
part '_impl/state/text_field_state_part1.dart';
part '_impl/utils/text_field_intents.dart';
part '_impl/core/input_features_basic.dart';
part '_impl/core/input_features_autocomplete.dart';
part '_impl/core/input_features_spinner.dart';
part '_impl/core/input_features_copy_paste.dart';
part '_impl/themes/variants/auto_complete_theme.dart';
part '_impl/core/auto_complete_widget.dart';

Widget buildEditableTextContextMenu(
  BuildContext context,
  EditableTextState editableTextState,
) {
  return material.AdaptiveTextSelectionToolbar.editableText(
    editableTextState: editableTextState,
  );
}
