// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:async';
import 'dart:collection';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import '_impl/themes/base/file_upload_dropzone_theme.dart';
import '_impl/utils/file_drop_adapter.dart';
import '_impl/utils/file_like.dart';
import '_impl/utils/file_upload_controller.dart';
import '_impl/utils/file_upload_models.dart';
import '_impl/utils/file_validation.dart';
import '../../../shared/icons/radix_icons.dart';
import '../../../shared/primitives/outlined_container.dart';
import '../../../shared/primitives/overlay.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/color_extensions.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/geometry_extensions.dart';
import '../../control/button/button.dart';
import '../../display/linear_progress_indicator/linear_progress_indicator.dart';
import '../dropzone/dropzone.dart';
import '../file_input/file_input.dart';

export '_impl/themes/base/file_upload_dropzone_theme.dart';
export '_impl/utils/file_like.dart';
export '_impl/utils/file_upload_controller.dart';
export '_impl/utils/file_upload_models.dart';

part '_impl/core/file_upload_options.dart';
part '_impl/core/file_upload_widget.dart';
part '_impl/core/file_item.dart';
part '_impl/core/file_upload_items_view.dart';
part '_impl/state/file_upload_state.dart';
part '_impl/state/file_upload_state_compact.dart';
part '_impl/state/file_upload_state_uploads.dart';
part '_impl/state/file_upload_state_surfaces.dart';
part '_impl/utils/file_upload_formatters.dart';
