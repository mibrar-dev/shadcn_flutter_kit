// The component preview frame + stage (spec §2.4, P7-D1 polish, P7-D1b centring):
//
//  * The frame is `R:card` with `padding: 0`, `borderWidth: 1` and no shadow
//    — the registry card supports border-only, no-padding surfaces, so the
//    old plan's `D:PreviewFrame` is NOT needed (spec §6 open question 3).
//    P7-D1: the corner radius is `rounded-lg` (the shadcn card radius).
//  * [PreviewStage] is the centered stage that hosts the deferred
//    `preview.dart` export (D4 wires the loader). P7-D1: responsive padding
//    (`p-10` desktop / `p-4` mobile), a configurable minimum height (350 px
//    for the main demo, 200 px for example cards) and a subtle dotted-grid
//    background drawn from the border token.
//    P7-D1b: the stage centres the example bounding box on both axes
//    (`Container(alignment: center)` + `ConstrainedBox` + `Align.center`);
//    the examples themselves are centred by design (button `Align.center`,
//    badge/calendar `Column(center)`, inputs/tables/alerts/cards with explicit
//    max widths, never stretched), so the Button demo no longer sits at the
//    left edge.

import 'package:flutter/widgets.dart';

import '../ui/shadcn/components/card/card.dart';
import '../ui/shadcn/theme/color_tokens.dart';
import '../ui/shadcn/theme/theme.dart';
import 'docs_tokens.dart';

/// The bordered, rounded preview card frame (640×~399 at 1440).
class PreviewFrame extends StatelessWidget {
  /// Creates the frame.
  const PreviewFrame({
    super.key,
    required this.child,
    this.clipBehavior = Clip.antiAlias,
  });

  /// Frame content (toolbar, stage and/or code teaser).
  final Widget child;

  /// Clip behaviour; defaults to clipping the rounded corners.
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final ThemedColor themedBorder = ThemedColor.value(theme.colors.border);
    final Color border = theme.colors.border;
    final BorderRadius radius = theme.borderRadiusLg;
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 48),
      child: Card(
        padding: EdgeInsets.zero,
        borderWidth: 1,
        borderColor: themedBorder,
        borderRadius: radius,
        shadows: const <BoxShadow>[],
        clipBehavior: clipBehavior,
        child: Stack(
          children: <Widget>[
            child,
            // Redrawn above the child: `Card` paints its border before the
            // content, and the full-bleed stage/teaser surfaces would cover
            // it — the reference's 1 px frame stays visible on every side.
            // The overlay is paint-only: `DecoratedBox.hitTestSelf` returns
            // true for its whole rect, so it must not take pointer events
            // (that would dead-zone the stage demos and the View Code pill).
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    border: Border.all(color: border),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The preview stage: a bounded, centered box with a dotted-grid background.
///
/// When [child] is null the stage renders empty (D4 loads the deferred
/// preview and passes it in).
class PreviewStage extends StatelessWidget {
  /// Creates a preview stage.
  const PreviewStage({
    super.key,
    this.child,
    this.chromeless = false,
    this.minHeight = DocsMetrics.previewStageHeight,
    this.pattern = true,
  });

  /// The preview widget (external previews should not paint their own page
  /// background; the stage supplies it).
  final Widget? child;

  /// Chromeless variant (spec §2.4): `h-auto`, `p-0` — no fixed stage box.
  final bool chromeless;

  /// Minimum stage height (P7-D1: 350 for the main demo, 200 for examples).
  final double minHeight;

  /// Whether the subtle dotted-grid background renders.
  final bool pattern;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    if (chromeless) {
      return child ?? const SizedBox.shrink();
    }
    // P6-F4: the stage hands the preview a *bounded* box. The old harness
    // put a horizontal `SingleChildScrollView` outside the width constraint,
    // so the preview saw unbounded width (and, through the `Column`, unbounded
    // height): every `SizedBox(width: double.infinity)` / `Expanded` /
    // `EditableText` preview threw or painted blank (audit D4/D5/D6). The new
    // examples shrink-wrap (no `Expanded`, no outer fixed box, no infinite
    // width), so the stage only needs a bounded width and a minimum height.
    // Wide leftovers overflow loudly instead of vanishing, which is what the
    // render audit asserts against.
    // P7-D1b: the stage centres the example box (`Align.center`); the examples
    // are centred by design (see the button/badge/calendar/input preview
    // fixes), so no `IntrinsicWidth` is needed here — intrinsics would query
    // every example's subtree and throw for any example containing a
    // `LayoutBuilder` (the all-pages sweep caught this).
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double viewport = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : DocsMetrics.articleWidth;
        final bool compact = viewport < 640;
        final double padding = compact ? 16 : 40;
        final double maxContent = viewport - padding * 2 > 0
            ? viewport - padding * 2
            : 0;
        return Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: minHeight),
          color: theme.colors.background,
          child: CustomPaint(
            painter: pattern
                ? _DotGridPainter(color: theme.colors.border)
                : null,
            child: Container(
              padding: EdgeInsets.all(padding),
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContent),
                child: Align(
                  alignment: Alignment.center,
                  child: child ?? const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Subtle dotted grid drawn from the border token (shadcn docs texture).
class _DotGridPainter extends CustomPainter {
  /// Creates the painter.
  const _DotGridPainter({required this.color});

  /// The border token colour (drawn at low alpha).
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint dot = Paint()
      ..color = color.withValues(alpha: 0.45)
      ..style = PaintingStyle.fill;
    const double step = 20;
    for (double y = step / 2; y < size.height; y += step) {
      for (double x = step / 2; x < size.width; x += step) {
        canvas.drawCircle(Offset(x, y), 1, dot);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotGridPainter oldDelegate) =>
      oldDelegate.color != color;
}
