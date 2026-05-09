// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../animated_value_builder.dart';

/// AnimatedValueBuilder defines a reusable type for this registry module.
class AnimatedValueBuilder<T> extends StatefulWidget {
  /// Stores `value` state/configuration for this implementation.
  final T? value;

  /// Stores `initialValue` state/configuration for this implementation.
  final T? initialValue;

  /// Stores `duration` state/configuration for this implementation.
  final Duration duration;

  /// Stores `curve` state/configuration for this implementation.
  final Curve curve;

  /// Stores `lerp` state/configuration for this implementation.
  final AnimatedValueLerp<T>? lerp;

  /// Stores `builder` state/configuration for this implementation.
  final AnimatedValueWidgetBuilder<T> builder;

  /// Stores `child` state/configuration for this implementation.
  final Widget? child;

  /// Stores `onEnd` state/configuration for this implementation.
  final ValueChanged<T?>? onEnd;

  /// Creates a `AnimatedValueBuilder` instance.
  const AnimatedValueBuilder({
    super.key,
    required this.value,
    required this.builder,
    this.initialValue,
    this.duration = Duration.zero,
    this.curve = Curves.linear,
    this.lerp,
    this.child,
    this.onEnd,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<AnimatedValueBuilder<T>> createState() =>
      _AnimatedValueBuilderState<T>();
}
