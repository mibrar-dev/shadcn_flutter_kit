// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:data_widget/data_widget.dart';
import 'package:flutter/widgets.dart';

import 'stated_widget.dart';
import '../state/widget_states_data.dart';

/// BuilderStatedWidget defines a reusable type for this registry module.
class BuilderStatedWidget extends StatedWidget {
  final Widget Function(BuildContext context, Set<WidgetState> states) builder;

  const BuilderStatedWidget({super.key, required this.builder}) : super.base();

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    WidgetStatesData? statesData = Data.maybeOf(context);

    /// Stores `states` state/configuration for this implementation.
    Set<WidgetState> states = statesData?.states ?? {};
    return builder(context, states);
  }
}
