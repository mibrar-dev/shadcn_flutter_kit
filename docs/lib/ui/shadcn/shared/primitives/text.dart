// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:data_widget/data_widget.dart';
import 'package:flutter/material.dart' show SelectableText;
import 'package:flutter/widgets.dart';

import '../theme/theme.dart';

part '_impl/core/__bullet_painter.dart';
part '_impl/core/__rich_text_then_widget.dart';
part '_impl/core/__selectable_text_then_widget.dart';
part '_impl/core/__text_then_widget.dart';
part '_impl/core/text_modifier.dart';
part '_impl/core/unordered_list_data.dart';
part '_impl/core/wrapped_text.dart';

/// Abstract base class for text modifier widgets.
///
/// Text modifiers provide a fluent API for applying text styles and
/// transformations. They extend [Widget] and can be called as functions
/// to apply additional style properties.
///
/// Use the [TextExtension] methods to create and chain text modifiers.
