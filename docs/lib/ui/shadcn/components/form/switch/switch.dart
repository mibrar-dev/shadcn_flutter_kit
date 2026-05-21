// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../shared/primitives/focus_outline.dart';
import '../../../shared/primitives/form_control.dart';
import '../../../shared/primitives/form_value_supplier.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/border_utils.dart';
import '../../../shared/utils/style_value.dart';

part '_impl/state/_switch_state.dart';

part '_impl/themes/base/switch_theme.dart';
part '_impl/utils/switch_controller.dart';
part '_impl/core/controlled_switch.dart';
part '_impl/core/switch_widget.dart';

const kSwitchDuration = Duration(milliseconds: 100);
