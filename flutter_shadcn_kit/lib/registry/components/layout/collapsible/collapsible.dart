// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:data_widget/data_widget.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:gap/gap.dart';

import '../../../shared/primitives/text.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/util.dart';
import '../../control/button/button.dart';

part '_impl/core/collapsible_content.dart';
part '_impl/state/collapsible_state_data.dart';
part '_impl/themes/base/collapsible_theme.dart';
part '_impl/core/collapsible_trigger.dart';
part '_impl/state/collapsible_state.dart';

/// Expandable layout that keeps its own open/close state by default.
class Collapsible extends StatefulWidget {
  /// Creates a widget that expands/collapses a set of children.
  const Collapsible({
    super.key,
    required this.children,
    this.isExpanded,
    this.onExpansionChanged,
  });

  /// Children are usually a trigger followed by one or more content widgets.
  final List<Widget> children;

  /// Controls the initial expansion for uncontrolled mode.
  final bool? isExpanded;

  /// Called when the user toggles the collapse state.
  final ValueChanged<bool>? onExpansionChanged;

  @override
  /// Executes `createState` behavior for this component/composite.
  State<Collapsible> createState() => CollapsibleState();
}

/// Tracks the current expansion state and exposes an event for children.
