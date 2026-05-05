part of '../../theme.dart';

/// AdaptiveScaler defines a reusable type for this registry module.
class AdaptiveScaler extends StatelessWidget {
  /// Gets the default adaptive scaling for the current context.
  ///
  /// Returns [AdaptiveScaling.mobile] for iOS/Android platforms,
  /// [AdaptiveScaling.desktop] for other platforms.
  static AdaptiveScaling defaultScalingOf(BuildContext context) {
    final theme = Theme.of(context);
    return defaultScaling(theme);
  }

  /// Gets the default adaptive scaling for the given theme.
  ///
  /// Returns [AdaptiveScaling.mobile] for iOS/Android platforms,
  /// [AdaptiveScaling.desktop] for other platforms.
  static AdaptiveScaling defaultScaling(ThemeData theme) {
    switch (theme.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.android:
        return AdaptiveScaling.mobile;
      default:
        return AdaptiveScaling.desktop;
    }
  }

  /// The scaling to apply.
  final AdaptiveScaling scaling;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Creates an [AdaptiveScaler].
  ///
  /// Parameters:
  /// - [scaling] (`AdaptiveScaling`, required): Scaling factors to apply.
  /// - [child] (`Widget`, required): Child widget.
  const AdaptiveScaler({
    super.key,
    required this.scaling,
    required this.child,
  });

  @override
/// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: scaling.scale(theme),
      child: child,
    );
  }
}

/// The theme data for shadcn_flutter.
///
/// Contains all theming information including colors, typography,
/// scaling, and platform-specific settings.
