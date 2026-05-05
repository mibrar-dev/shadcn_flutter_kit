part of '../../outlined_container.dart';

/// OutlinedContainer defines a reusable type for this registry module.
class OutlinedContainer extends StatefulWidget {
/// Stores `child` state/configuration for this implementation.
  final Widget child;
/// Stores `backgroundColor` state/configuration for this implementation.
  final Color? backgroundColor;
/// Stores `borderColor` state/configuration for this implementation.
  final Color? borderColor;
/// Stores `clipBehavior` state/configuration for this implementation.
  final Clip clipBehavior;
/// Stores `borderRadius` state/configuration for this implementation.
  final BorderRadiusGeometry? borderRadius;
/// Stores `borderStyle` state/configuration for this implementation.
  final BorderStyle? borderStyle;
/// Stores `borderWidth` state/configuration for this implementation.
  final double? borderWidth;
/// Stores `boxShadow` state/configuration for this implementation.
  final List<BoxShadow>? boxShadow;
/// Stores `padding` state/configuration for this implementation.
  final EdgeInsetsGeometry? padding;
/// Stores `surfaceOpacity` state/configuration for this implementation.
  final double? surfaceOpacity;
/// Stores `surfaceBlur` state/configuration for this implementation.
  final double? surfaceBlur;
/// Stores `width` state/configuration for this implementation.
  final double? width;
/// Stores `height` state/configuration for this implementation.
  final double? height;
/// Stores `duration` state/configuration for this implementation.
  final Duration? duration;

/// Creates a `OutlinedContainer` instance.
  const OutlinedContainer({
    super.key,
    required this.child,
    this.borderColor,
    this.backgroundColor,
    this.clipBehavior = Clip.antiAlias,
    this.borderRadius,
    this.borderStyle,
    this.borderWidth,
    this.boxShadow,
    this.padding,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.width,
    this.height,
    this.duration,
  });

  @override
/// Executes `createState` behavior for this component/composite.
  State<OutlinedContainer> createState() => _OutlinedContainerState();
}
