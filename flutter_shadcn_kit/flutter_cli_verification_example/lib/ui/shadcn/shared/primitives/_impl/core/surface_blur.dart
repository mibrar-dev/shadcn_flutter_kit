part of '../../outlined_container.dart';

/// SurfaceBlur defines a reusable type for this registry module.
class SurfaceBlur extends StatefulWidget {
  /// The child widget to display with blurred background.
  final Widget child;

  /// The amount of blur to apply (sigma value for blur filter).
  final double? surfaceBlur;

  /// Border radius for clipping the blur effect.
  final BorderRadiusGeometry? borderRadius;

/// Creates a `SurfaceBlur` instance.
  const SurfaceBlur({
    super.key,
    required this.child,
    this.surfaceBlur,
    this.borderRadius,
  });

  @override
/// Executes `createState` behavior for this component/composite.
  State<SurfaceBlur> createState() => _SurfaceBlurState();
}
