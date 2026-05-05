part of '../../animated_value_builder.dart';

class AnimatedValueBuilder<T> extends StatefulWidget {
  final T? value;
  final T? initialValue;
  final Duration duration;
  final Curve curve;
  final AnimatedValueLerp<T>? lerp;
  final AnimatedValueWidgetBuilder<T> builder;
  final Widget? child;
  final ValueChanged<T?>? onEnd;

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
  State<AnimatedValueBuilder<T>> createState() =>
      _AnimatedValueBuilderState<T>();
}
