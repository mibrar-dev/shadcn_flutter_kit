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
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 48),
      child: Card(
        padding: EdgeInsets.zero,
        borderWidth: 1,
        borderColor: ThemedColor.value(theme.colors.border),
        borderRadius: theme.borderRadiusXl,
        shadows: const <BoxShadow>[],
        clipBehavior: clipBehavior,
        child: child,
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
    return Container(
      height: DocsMetrics.previewStageHeight,
      width: double.infinity,
      color: theme.colors.background,
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      child: child,
    );
  }
}
