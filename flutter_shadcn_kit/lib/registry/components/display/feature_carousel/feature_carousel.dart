// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '_impl/state/feature_carousel_controller.dart';
import '_impl/utils/feature_carousel_animation_style.dart';
import '_impl/utils/feature_carousel_models.dart';
import '_impl/themes/base/feature_carousel_theme.dart';
import '../../../shared/theme/theme.dart' as shadcn_theme;

export '_impl/utils/feature_carousel_models.dart';
export '_impl/utils/feature_carousel_animation_style.dart';
export '_impl/state/feature_carousel_controller.dart';
export '_impl/themes/base/feature_carousel_theme.dart';

part '_impl/core/_carousel_intent.dart';
part '_impl/core/_center_card.dart';
part '_impl/core/_cta_button.dart';
part '_impl/core/_feature_card_carousel_state.dart';
part '_impl/core/_ghost_card.dart';
part '_impl/core/_ghost_transform.dart';
part '_impl/core/_nav_arrow.dart';
part '_impl/core/feature_card_carousel.dart';

/// _CarouselDirection enumerates fixed values used by this implementation.
enum _CarouselDirection { left, right }
