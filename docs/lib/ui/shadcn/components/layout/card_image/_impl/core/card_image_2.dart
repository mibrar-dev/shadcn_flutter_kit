// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../card_image.dart';

/// CardImage defines a reusable type for this registry module.
class CardImage extends StatefulWidget {
  /// Stores `image` state/configuration for this implementation.
  final Widget image;

  /// Stores `title` state/configuration for this implementation.
  final Widget? title;

  /// Stores `subtitle` state/configuration for this implementation.
  final Widget? subtitle;

  /// Stores `trailing` state/configuration for this implementation.
  final Widget? trailing;

  /// Stores `leading` state/configuration for this implementation.
  final Widget? leading;

  /// Stores `onPressed` state/configuration for this implementation.
  final VoidCallback? onPressed;

  /// Stores `enabled` state/configuration for this implementation.
  final bool? enabled;

  /// Stores `style` state/configuration for this implementation.
  final AbstractButtonStyle? style;

  /// Stores `direction` state/configuration for this implementation.
  final Axis? direction;

  /// Stores `hoverScale` state/configuration for this implementation.
  final double? hoverScale;

  /// Stores `normalScale` state/configuration for this implementation.
  final double? normalScale;

  /// Stores `backgroundColor` state/configuration for this implementation.
  final Color? backgroundColor;

  /// Stores `borderColor` state/configuration for this implementation.
  final Color? borderColor;

  /// Stores `gap` state/configuration for this implementation.
  final double? gap;

  /// Creates a `CardImage` instance.
  const CardImage({
    super.key,
    required this.image,
    this.title,
    this.subtitle,
    this.trailing,
    this.leading,
    this.onPressed,
    this.enabled,
    this.style,
    this.direction,
    this.hoverScale,
    this.normalScale,
    this.backgroundColor,
    this.borderColor,
    this.gap,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<CardImage> createState() => _CardImageState();
}
