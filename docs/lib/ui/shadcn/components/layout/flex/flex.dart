// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:ui' show Clip, Offset;

import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/rendering.dart' as rendering;
import 'package:flutter/widgets.dart' as widgets;

export 'package:flutter/widgets.dart'
        /// Stores `Positioned` state/configuration for this implementation.
        hide
        ErrorWidgetBuilder,
        Flexible,
        Expanded,
        Form,
        FormField,
        FormState,
        RadioGroup,
        Row,
        Column,
        Flex,
        Stack,
        Positioned,
        TableCell;

export 'package:flutter/rendering.dart'
    show
        FlexFit,
        MainAxisSize,
        MainAxisAlignment,
        CrossAxisAlignment,
        VerticalDirection,
        StackFit;

part '_impl/core/flex_parent_data.dart';
part '_impl/core/flex_widget.dart';
part '_impl/core/flexible_widgets.dart';
part '_impl/core/paint_order_mixin.dart';
part '_impl/core/paint_order_parent_data_mixin.dart';
part '_impl/core/positioned_widget.dart';
part '_impl/core/render_flex.dart';
part '_impl/core/render_stack.dart';
part '_impl/core/stack_parent_data.dart';
part '_impl/core/stack_widget.dart';
