part of '../../theme.dart';

/// AnimatedTheme defines a reusable type for this registry module.
class AnimatedTheme extends ImplicitlyAnimatedWidget {
  /// The target theme data to animate to.
  final ThemeData data;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Creates an [AnimatedTheme].
  ///
  /// Parameters:
  /// - [data] (`ThemeData`, required): Target theme.
  /// - [duration] (`Duration`, required): Animation duration.
  /// - [curve] (`Curve`, optional): Animation curve.
  /// - [child] (`Widget`, required): Child widget.
  const AnimatedTheme({
    super.key,
    required this.data,
    required super.duration,
    super.curve,
    required this.child,
  });

  @override
/// Executes `createState` behavior for this component/composite.
  AnimatedWidgetBaseState<AnimatedTheme> createState() => _AnimatedThemeState();
}
