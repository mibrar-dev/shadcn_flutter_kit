// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

part '_impl/core/animated_value_builder.dart';
part '_impl/state/__animated_value_builder_state.dart';

/// Type alias for `AnimatedValueWidgetBuilder` used by public or internal APIs.
typedef AnimatedValueWidgetBuilder<T> =
    Widget Function(BuildContext context, T value, Widget? child);

/// Type alias for `AnimatedValueLerp` used by public or internal APIs.
typedef AnimatedValueLerp<T> = T? Function(T? a, T? b, double t);
