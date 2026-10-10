// The component preview frame + stage (spec §2.4, decision recorded here):
//
//  * The frame is `R:card` with `padding: 0`, `borderWidth: 1` and no shadow
//    — the registry card supports border-only, no-padding surfaces, so the
//    old plan's `D:PreviewFrame` is NOT needed (spec §6 open question 3).
//  * [PreviewStage] is the 288 px / 40 px padded centered stage that hosts
//    the deferred `preview.dart` export (D4 wires the loader).

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

  /// Frame content (stage and/or code teaser).
  final Widget child;

  /// Clip behaviour; defaults to clipping the rounded corners.
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final ThemedColor themedBorder = ThemedColor.value(theme.colors.border);
    final Color border = theme.colors.border;
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 48),
      child: Card(
        padding: EdgeInsets.zero,
        borderWidth: 1,
        borderColor: themedBorder,
        borderRadius: theme.borderRadiusXl,
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
                    borderRadius: theme.borderRadiusXl,
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

/// The chromeless preview stage: 288 px tall, 40 px padding, centered.
///
/// When [child] is null the stage renders empty (D4 loads the deferred
/// preview and passes it in).
class PreviewStage extends StatelessWidget {
  /// Creates a preview stage.
  const PreviewStage({super.key, this.child, this.chromeless = false});

  /// The preview widget (external previews should not paint their own page
  /// background; the stage supplies it).
  final Widget? child;

  /// Chromeless variant (spec §2.4): `h-auto`, `p-0` — no fixed stage box.
  final bool chromeless;

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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double viewport = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : DocsMetrics.articleWidth;
        final double maxContent = viewport - 80 > 0 ? viewport - 80 : 0;
        return Container(
          width: double.infinity,
          constraints: const BoxConstraints(
            minHeight: DocsMetrics.previewStageHeight,
          ),
          color: theme.colors.background,
          padding: const EdgeInsets.all(40),
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContent),
            child: Align(
              alignment: Alignment.center,
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        );
      },
    );
  }
}
