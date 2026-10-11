// Content pieces of a gooey surface: the compact pill, the expanded body, the
// state icon bubble and the inline action chip.
//
// Split from `gooey_frame.dart` so each file stays under the ~400-line limit;
// all pieces are widgets-only and take resolved styles/colours.

import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../animation.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';

/// Compact pill content: leading icon, title and optional trailing widget.
///
/// [morphKey] keys the [AnimatedSwitcher], so a new title or state animates
/// instead of snapping.
class GooeySurfacePill extends StatelessWidget {
  /// Creates pill content.
  const GooeySurfacePill({
    super.key,
    required this.title,
    required this.titleStyle,
    required this.width,
    required this.height,
    required this.morphKey,
    this.leading,
    this.expandUp = false,
    this.onTap,
    this.morphDuration = const Duration(milliseconds: 400),
    this.morphCurve = Curves.easeInOutCubicEmphasized,
    this.morphSlide = const Offset(0, 0.10),
    this.morphScaleFrom = 0.80,
  });

  /// Measures the pill width needed to fit [title] and a 24px leading icon.
  static double measureWidth({
    required String title,
    required TextStyle style,
    required TextDirection direction,
    required double pillHeight,
    required double maxWidth,
  }) {
    final TextPainter painter = TextPainter(
      text: TextSpan(text: title, style: style),
      textDirection: direction,
      maxLines: 1,
    )..layout();
    const double iconWidth = 24;
    const double iconGap = 8;
    const double padding = 16;
    const double extra = 10;
    final double inner = iconWidth + iconGap + painter.width;
    return (inner + padding + extra).clamp(pillHeight, maxWidth).toDouble();
  }

  /// Compact label.
  final String title;

  /// Compact label style.
  final TextStyle titleStyle;

  /// Pill width.
  final double width;

  /// Pill height.
  final double height;

  /// Identity of the current compact content, for the morph switcher.
  final Object morphKey;

  /// Optional leading widget (state icon).
  final Widget? leading;

  /// Whether the body grows upwards, flipping the morph slide.
  final bool expandUp;

  /// Called when the pill is tapped; null keeps the pill static.
  final VoidCallback? onTap;

  /// Compact morph duration.
  final Duration morphDuration;

  /// Compact morph curve.
  final Curve morphCurve;

  /// Compact morph slide in `Offset` units.
  final Offset morphSlide;

  /// Starting scale of the morphing content.
  final double morphScaleFrom;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final Widget row = Row(
      children: <Widget>[
        if (leading != null) ...<Widget>[
          leading!,
          SizedBox(width: theme.spacing.sm),
        ],
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: titleStyle,
          ),
        ),
      ],
    );
    return MouseRegion(
      cursor: onTap == null
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(8),
          child: AnimatedSwitcher(
            duration: morphDuration,
            switchInCurve: morphCurve,
            switchOutCurve: morphCurve,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(
                      morphSlide.dx,
                      (expandUp ? -1 : 1) * morphSlide.dy,
                    ),
                    end: Offset.zero,
                  ).animate(animation),
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: morphScaleFrom,
                      end: 1,
                    ).animate(animation),
                    child: child,
                  ),
                ),
              );
            },
            child: KeyedSubtree(key: ValueKey<Object>(morphKey), child: row),
          ),
        ),
      ),
    );
  }
}

/// Expanded body content with a 16px inner padding, measured through
/// [GooeyMeasure] so the surface can size its silhouette.
class GooeySurfaceBody extends StatelessWidget {
  /// Creates body content.
  const GooeySurfaceBody({
    super.key,
    required this.width,
    required this.onSizeChanged,
    this.description,
    this.descriptionStyle,
    this.body,
    this.action,
  });

  /// Surface width.
  final double width;

  /// Called when the laid-out body size changes.
  final ValueChanged<Size> onSizeChanged;

  /// Body text; ignored when [body] is set.
  final String? description;

  /// Body text style.
  final TextStyle? descriptionStyle;

  /// Custom body replacing [description] and [action].
  final Widget? body;

  /// Action widget below the description.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final Widget content =
        body ??
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (description != null)
              Text(description!, style: descriptionStyle),
            if (action != null)
              Padding(
                padding: EdgeInsets.only(top: theme.density.baseGap * 1.5),
                child: action,
              ),
          ],
        );
    return GooeyMeasure(
      onSizeChanged: onSizeChanged,
      child: SizedBox(
        width: width,
        child: Padding(
          padding: resolveEdgeInsets(
            EdgeInsetsDensity.pxAll(16),
            theme.density.baseContentPadding * theme.scaling,
          ),
          child: content,
        ),
      ),
    );
  }
}

/// Reports its child's laid-out size after each layout pass.
class GooeyMeasure extends SingleChildRenderObjectWidget {
  /// Creates a measure widget.
  const GooeyMeasure({
    super.key,
    required this.onSizeChanged,
    required super.child,
  });

  /// Called with the new size when it changes between layout passes.
  final ValueChanged<Size> onSizeChanged;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _GooeyMeasureRender(onSizeChanged);

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as _GooeyMeasureRender).onSizeChanged = onSizeChanged;
  }
}

class _GooeyMeasureRender extends RenderProxyBox {
  _GooeyMeasureRender(this.onSizeChanged);

  ValueChanged<Size> onSizeChanged;
  Size? _lastSize;

  @override
  void performLayout() {
    super.performLayout();
    final Size next = child?.size ?? size;
    if (_lastSize == next) {
      return;
    }
    _lastSize = next;
    WidgetsBinding.instance.addPostFrameCallback((_) => onSizeChanged(next));
  }
}

/// Circular icon bubble for the compact leading slot.
///
/// [loading] spins the glyph, replacing the old Material
/// `CircularProgressIndicator` in the gooey toast.
class GooeyStateIcon extends StatelessWidget {
  /// Creates a state icon.
  const GooeyStateIcon({
    super.key,
    required this.icon,
    required this.color,
    this.loading = false,
  });

  /// Glyph shown inside the bubble.
  final IconData icon;

  /// Bubble tint; the glyph uses it at full strength.
  final Color color;

  /// Whether to spin the glyph.
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final Widget glyph = Icon(icon, size: 16, color: color);
    // A fixed `size-6` envelope around the 16px glyph, like the button size
    // table's unscaled `minHeight`: not spacing.
    return SizedBox(
      width: 24,
      height: 24,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: loading
              ? RepeatedAnimationBuilder(
                  start: 0,
                  end: math.pi * 2,
                  duration: const Duration(milliseconds: 900),
                  builder: (BuildContext context, double value, Widget? child) {
                    return Transform.rotate(angle: value, child: child);
                  },
                  child: glyph,
                )
              : glyph,
        ),
      ),
    );
  }
}

/// Inline action chip for the expanded body.
///
/// Replaces the old Material `TextButton`; height 28, stadium shape, tinted
/// with the toast tone.
class GooeyActionChip extends StatelessWidget {
  /// Creates an action chip.
  const GooeyActionChip({
    super.key,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  /// Chip label.
  final String label;

  /// Tone colour of label, tint and border.
  final Color color;

  /// Called when the chip is tapped.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onPressed,
          child: Container(
            height: 28,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: color.withValues(alpha: 0.26)),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
