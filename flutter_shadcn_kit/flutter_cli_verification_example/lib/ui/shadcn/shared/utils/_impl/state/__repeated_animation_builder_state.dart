part of '../../util.dart';


/// _RepeatedAnimationBuilderState defines a reusable type for this registry module.
class _RepeatedAnimationBuilderState extends State<RepeatedAnimationBuilder>
    with SingleTickerProviderStateMixin {
/// Stores `_controller` state/configuration for this implementation.
  late final AnimationController _controller;
/// Stores `_animation` state/configuration for this implementation.
  late final Animation<double> _animation;

  @override
/// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
  }

  @override
/// Executes `dispose` behavior for this component/composite.
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
/// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) {
        final value = widget.start +
            (widget.end - widget.start) * _animation.value;
        return widget.builder(context, value, child);
      },
    );
  }
}
