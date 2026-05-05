part of '../../util.dart';


/// RepeatedAnimationBuilder defines a reusable type for this registry module.
class RepeatedAnimationBuilder extends StatefulWidget {
/// Stores `start` state/configuration for this implementation.
  final double start;
/// Stores `end` state/configuration for this implementation.
  final double end;
/// Stores `duration` state/configuration for this implementation.
  final Duration duration;
/// Stores `curve` state/configuration for this implementation.
  final Curve curve;
/// Stores `builder` state/configuration for this implementation.
  final RepeatedAnimationWidgetBuilder builder;
/// Stores `child` state/configuration for this implementation.
  final Widget? child;

/// Creates a `RepeatedAnimationBuilder` instance.
  const RepeatedAnimationBuilder({
    super.key,
    required this.start,
    required this.end,
    required this.duration,
    this.curve = Curves.linear,
    required this.builder,
    this.child,
  });

  @override
/// Executes `createState` behavior for this component/composite.
  State<RepeatedAnimationBuilder> createState() =>
      _RepeatedAnimationBuilderState();
}
