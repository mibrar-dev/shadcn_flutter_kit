part of '../../outlined_container.dart';

/// _SurfaceBlurState defines a reusable type for this registry module.
class _SurfaceBlurState extends State<SurfaceBlur> {
  final GlobalKey _mainContainerKey = GlobalKey();

  @override
/// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    if (widget.surfaceBlur == null || widget.surfaceBlur! <= 0) {
      return KeyedSubtree(key: _mainContainerKey, child: widget.child);
    }
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: widget.surfaceBlur!,
          sigmaY: widget.surfaceBlur!,
        ),
        child: KeyedSubtree(key: _mainContainerKey, child: widget.child),
      ),
    );
  }
}

/// Theme configuration for [OutlinedContainer] appearance.
