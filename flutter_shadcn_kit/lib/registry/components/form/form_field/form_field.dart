// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:data_widget/data_widget.dart';
import 'package:flutter/widgets.dart';

import '../../../shared/localizations/shadcn_localizations.dart';
import '../../../shared/primitives/form_value_supplier.dart';
import '../../../shared/primitives/overlay.dart';
import '../../../shared/primitives/text.dart';
import '../../../shared/theme/theme.dart';
import '../../layout/card/card.dart';
import '../../control/button/button.dart';
import '../../overlay/dialog/dialog.dart';
import '../../overlay/alert_dialog/alert_dialog.dart';

part '_impl/core/_object_form_field_dialog.dart';
part '_impl/state/_object_form_field_dialog_state.dart';
part '_impl/core/_object_form_field_popup.dart';
part '_impl/state/_object_form_field_popup_state.dart';
part '_impl/core/object_form_field.dart';
part '_impl/core/object_form_field_dialog_result.dart';
part '_impl/state/object_form_field_state.dart';
part '_impl/core/object_form_handler.dart';

/// Type definition for the save button in an object input form field.
typedef ObjectInputSaveButton = PrimaryButton;

/// Type definition for the cancel button in an object input form field.
typedef ObjectInputCancelButton = OutlineButton;

/// Defines how a form field editor is presented to the user.
///
/// [PromptMode] determines whether the field editor appears in a modal
/// dialog or a popover overlay.
enum PromptMode {
  /// Display the editor in a modal dialog.
  dialog,

  /// Display the editor in a popover overlay.
  popover,
}
