// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../outlined_container.dart';

/// OutlinedContainer defines a reusable type for this registry module.
class OutlinedContainer extends StatefulWidget {
  /// Creates a `OutlinedContainer` instance.
  const OutlinedContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.borderWidth,
    this.borderStyle,
    this.boxShadow,
    this.padding,
    this.clipBehavior = Clip.antiAlias,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.width,
    this.height,
    this.duration,
  });

  /// Stores `child` state/configuration for this implementation.
  final Widget child;

  /// Stores `backgroundColor` state/configuration for this implementation.
  final Color? backgroundColor;

  /// Stores `borderColor` state/configuration for this implementation.
  final Color? borderColor;

  /// Stores `borderRadius` state/configuration for this implementation.
  final BorderRadiusGeometry? borderRadius;

  /// Stores `borderWidth` state/configuration for this implementation.
  final double? borderWidth;

  /// Stores `borderStyle` state/configuration for this implementation.
  final BorderStyle? borderStyle;

  /// Stores `boxShadow` state/configuration for this implementation.
  final List<BoxShadow>? boxShadow;

  /// Stores `padding` state/configuration for this implementation.
  final EdgeInsetsGeometry? padding;

  /// Stores `clipBehavior` state/configuration for this implementation.
  final Clip clipBehavior;

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

  @override
  /// Executes `createState` behavior for this component/composite.
  State<OutlinedContainer> createState() => _OutlinedContainerState();
}
