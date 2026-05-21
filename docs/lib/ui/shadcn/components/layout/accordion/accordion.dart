// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:math';

import 'package:data_widget/data_widget.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:flutter/services.dart';

import '../../../shared/primitives/text.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/constants.dart';

part '_impl/core/accordion_item.dart';
part '_impl/themes/base/accordion_theme.dart';
part '_impl/core/accordion_trigger.dart';
part '_impl/state/accordion_state.dart';
part '_impl/state/_accordion_trigger_state.dart';
part '_impl/state/_accordion_item_state.dart';

/// A container of expandable sections where only one panel may be open at once.
class Accordion extends StatefulWidget {
  /// Creates an accordion with the provided [items].
  const Accordion({super.key, required this.items});

  /// The children that make up the accordion.
  final List<Widget> items;

  @override
  /// Executes `createState` behavior for this component/composite.
  AccordionState createState() => AccordionState();
}

/// State helper that tracks the currently expanded item.
