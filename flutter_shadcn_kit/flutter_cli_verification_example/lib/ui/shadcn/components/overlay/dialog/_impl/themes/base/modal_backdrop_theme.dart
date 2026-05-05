part of '../../../dialog.dart';

/// ModalBackdropTheme defines a reusable type for this registry module.
class ModalBackdropTheme extends ComponentThemeData {
  /// Border radius applied to the modal surface.
  final BorderRadiusGeometry? borderRadius;

  /// Padding around the modal content area.
  final EdgeInsetsGeometry? padding;

  /// Color of the barrier that appears behind the modal.
  final Color? barrierColor;

  /// Whether the backdrop behaves as a modal (blocking interaction).
  final bool? modal;

  /// Whether to clip the surface for visual effects.
  final bool? surfaceClip;

  /// Creates a [ModalBackdropTheme].
  ///
  /// All parameters are optional and will use system defaults when null.
  ///
  /// Parameters:
  /// - [borderRadius] (BorderRadiusGeometry?, optional): corner radius for the modal surface
  /// - [padding] (EdgeInsetsGeometry?, optional): padding around modal content
  /// - [barrierColor] (Color?, optional): backdrop color, typically semi-transparent
  /// - [modal] (bool?, optional): whether backdrop blocks user interaction
  /// - [surfaceClip] (bool?, optional): whether to clip surface for visual effects
  ///
  /// Example:
  /// ```dart
  /// const ModalBackdropTheme(
  ///   borderRadius: BorderRadius.circular(8),
  ///   barrierColor: Color.fromRGBO(0, 0, 0, 0.5),
  ///   modal: true,
  /// )
  /// ```
  const ModalBackdropTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.borderRadius,
    this.padding,
    this.barrierColor,
    this.modal,
    this.surfaceClip,
  });

  /// Creates a copy of this theme with the given fields replaced.
  ///
  /// Uses [ValueGetter] functions to allow null value assignments.
  /// Any parameter set to null will use the current value.
  ///
  /// Returns:
  /// A new [ModalBackdropTheme] with updated values.
  ///
  /// Example:
  /// ```dart
  /// final newTheme = theme.copyWith(
  ///   barrierColor: () => Colors.red.withOpacity(0.3),
  ///   modal: () => false,
  /// );
  /// ```
  ModalBackdropTheme copyWith({
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<Color?>? barrierColor,
    ValueGetter<bool?>? modal,
    ValueGetter<bool?>? surfaceClip,
  }) {
    return ModalBackdropTheme(
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      padding: padding == null ? this.padding : padding(),
      barrierColor: barrierColor == null ? this.barrierColor : barrierColor(),
      modal: modal == null ? this.modal : modal(),
      surfaceClip: surfaceClip == null ? this.surfaceClip : surfaceClip(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    return other is ModalBackdropTheme &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.barrierColor == barrierColor &&
        other.modal == modal &&
        other.surfaceClip == surfaceClip;
  }

  @override
  int get hashCode =>
      Object.hash(borderRadius, padding, barrierColor, modal, surfaceClip);
}

/// A visual backdrop widget that creates modal-style overlays.
///
/// Creates a semi-transparent barrier behind modal content with support for
/// custom colors, clipping, and animation. The backdrop can be configured
/// to prevent interaction with content below when modal behavior is enabled.
///
/// Features:
/// - Customizable barrier color and opacity
/// - Surface clipping for visual effects
/// - Animation support with fade transitions
/// - Configurable modal behavior
/// - Theme integration
///
/// Example:
/// ```dart
/// ModalBackdrop(
///   barrierColor: Colors.black54,
///   borderRadius: BorderRadius.circular(12),
///   modal: true,
///   child: MyDialogContent(),
/// )
/// ```
