// The `backdrop_transform` component: how the content behind a sheet or
// drawer moves while it opens.
//
// Ported from `components/overlay/backdrop_transform/**`. Fixes, all verified
// against the old source:
//   * `ScaleBackdropTransform.resolveExtraSize` divided the scaled extent by
//     `minScale` for the root layer, which is algebraically zero at every `t`:
//     at `t = 1`, `w - (w * minScale) / minScale == 0`; at `t = 0.5`,
//     `w - 0.975w / 0.95` is negative and was clamped to `0`. The root layer
//     therefore never freed any layout space. One formula now serves both
//     layers: `size - size * scale`.
//   * `minScale` was unchecked; `0` made the old root formula divide by zero
//     and any value above `1` grew the backdrop past its box. It is now
//     asserted to be in `(0, 1]`.
//   * `scaleAt(t)` extrapolated outside `0..1` (`animateTo` overshoots on some
//     curves), shrinking or growing the backdrop past its closed/open bounds.
//     The progress is clamped.
//   * `cornerRadius` fell back to `Theme.of(context).radiusXxl`, which is the
//     old theme object; the new tree reads `ShadcnTheme.of(context)`.
//   * `part` + a suppress-all-lints pragma are gone.

import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';

/// Describes how the backdrop behind a sheet or drawer is transformed as it
/// animates between closed (`t == 0`) and fully open (`t == 1`).
///
/// Implementations control the visual wrapping ([wrapBackdrop]) and how much
/// layout space the transform frees along each axis ([resolveExtraSize]); the
/// freed space is what lets a drawer slide into the gap the scaled backdrop
/// leaves behind.
abstract class BackdropTransform {
  /// Const constructor for subclasses.
  const BackdropTransform();

  /// A transform that does nothing: the backdrop is untouched and no extra
  /// layout space is produced. Used by sheets that do not scale the backdrop.
  static const BackdropTransform none = NoBackdropTransform();

  /// Wraps [child] (the backdrop content) for progress [t].
  ///
  /// [isRoot] is true for the bottom-most layer in a stack of sheets (the one
  /// wrapping the actual app content); root layers may additionally clip their
  /// corners as they scale in.
  Widget wrapBackdrop(
    BuildContext context,
    Widget child,
    double t, {
    bool isRoot = true,
  });

  /// Space freed per axis by this transform for a backdrop of [size] at
  /// progress [t]. Returns [Size.zero] when nothing is freed.
  Size resolveExtraSize(Size size, double t, {bool isRoot = true});
}

/// A [BackdropTransform] that leaves the backdrop untouched.
class NoBackdropTransform extends BackdropTransform {
  /// Creates an identity backdrop transform.
  const NoBackdropTransform();

  @override
  Widget wrapBackdrop(
    BuildContext context,
    Widget child,
    double t, {
    bool isRoot = true,
  }) => child;

  @override
  Size resolveExtraSize(Size size, double t, {bool isRoot = true}) => Size.zero;
}

/// The default [BackdropTransform]: scales the backdrop down from `1.0` to
/// [minScale] as the sheet opens and, for the root layer, clips its corners
/// with an animated radius.
///
/// This is the classic drawer "zoom-out" effect where the content shrinks
/// slightly to reveal the drawer sliding in from the edge.
class ScaleBackdropTransform extends BackdropTransform {
  /// Creates a scaling backdrop transform.
  const ScaleBackdropTransform({this.minScale = 0.95, this.cornerRadius})
    : assert(
        minScale > 0 && minScale <= 1,
        'minScale must be in (0, 1]; 0 divides by zero and >1 grows the '
        'backdrop past its box.',
      );

  /// Scale applied when fully open.
  final double minScale;

  /// Corner radius the root backdrop clips to when fully open; null uses
  /// `radiusXxl` of the ambient theme.
  final double? cornerRadius;

  /// The scale factor at progress [t] (1.0 at `t = 0`, [minScale] at `t = 1`).
  double scaleAt(double t) => 1 - (1 - minScale) * t.clamp(0.0, 1.0);

  @override
  Widget wrapBackdrop(
    BuildContext context,
    Widget child,
    double t, {
    bool isRoot = true,
  }) {
    final double progress = t.clamp(0.0, 1.0);
    Widget result = child;
    if (isRoot) {
      final double radius = cornerRadius ?? ShadcnTheme.of(context).radiusXxl;
      result = ClipRRect(
        borderRadius: BorderRadius.circular(radius * progress),
        child: result,
      );
    }
    return Transform.scale(scale: scaleAt(progress), child: result);
  }

  @override
  Size resolveExtraSize(Size size, double t, {bool isRoot = true}) {
    final double scale = scaleAt(t);
    final double freedWidth = size.width * (1 - scale);
    final double freedHeight = size.height * (1 - scale);
    return Size(
      freedWidth.clamp(0.0, double.infinity),
      freedHeight.clamp(0.0, double.infinity),
    );
  }
}
