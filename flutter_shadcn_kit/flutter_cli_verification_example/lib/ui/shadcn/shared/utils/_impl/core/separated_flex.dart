part of '../../util.dart';


/// SeparatedFlex defines a reusable type for this registry module.
class SeparatedFlex extends StatefulWidget {
/// Stores `direction` state/configuration for this implementation.
  final Axis direction;
/// Stores `mainAxisAlignment` state/configuration for this implementation.
  final MainAxisAlignment mainAxisAlignment;
/// Stores `mainAxisSize` state/configuration for this implementation.
  final MainAxisSize mainAxisSize;
/// Stores `crossAxisAlignment` state/configuration for this implementation.
  final CrossAxisAlignment crossAxisAlignment;
/// Stores `textDirection` state/configuration for this implementation.
  final TextDirection? textDirection;
/// Stores `verticalDirection` state/configuration for this implementation.
  final VerticalDirection verticalDirection;
/// Stores `textBaseline` state/configuration for this implementation.
  final TextBaseline? textBaseline;
/// Stores `clipBehavior` state/configuration for this implementation.
  final Clip clipBehavior;
/// Stores `separator` state/configuration for this implementation.
  final Widget separator;
/// Stores `children` state/configuration for this implementation.
  final List<Widget> children;

/// Creates a `SeparatedFlex` instance.
  const SeparatedFlex({
    super.key,
    required this.direction,
    required this.mainAxisAlignment,
    required this.mainAxisSize,
    required this.crossAxisAlignment,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.clipBehavior = Clip.none,
    required this.separator,
    required this.children,
  });

  @override
/// Executes `createState` behavior for this component/composite.
  State<SeparatedFlex> createState() => _SeparatedFlexState();
}
