// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

part '_impl/state/_controlled_component_adapter_state.dart';
part '_impl/utils/component_value_controller.dart';
part '_impl/core/controlled_component.dart';
part '_impl/utils/controlled_component_adapter.dart';
part '_impl/core/controlled_component_data.dart';

/// A mixin that defines the interface for controlling component values.
///
/// This mixin combines the capabilities of [ValueNotifier] to provide
/// a standardized way for widgets to expose their current value and
/// notify listeners of changes. Components that implement this interface
/// can be controlled programmatically and integrated with form validation
/// systems.
///
/// The generic type [T] represents the type of value this controller manages.
mixin ComponentController<T> implements ValueNotifier<T> {}
