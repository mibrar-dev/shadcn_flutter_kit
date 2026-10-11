// The `hover_card` component: [HoverCard], a rich preview shown while the
// pointer rests on [child] (or presses it on touch screens).
//
// Ported from `components/overlay/hover_card/**`. Fixed: `adaptiveOverlay`
// is deleted (it reached into `overlay_configuration`, the same path the
// tooltip pilot dropped); the custom `MouseRegion` timers are the `Hover`
// primitive; the card surface paints from tokens instead of an unthemed box.

import 'package:flutter/widgets.dart';

import '../../primitives/hover.dart';
import '../../primitives/overlay.dart';
import '../../primitives/popover_controller.dart';
import '../../theme/theme.dart';
import 'hover_card_style.dart';

export 'hover_card_style.dart';

/// A rich preview card shown while the pointer rests on [child].
///
/// [hoverBuilder] returns the bare content; the widget wraps it in the themed
/// popover surface itself, so return content (not a surface).
class HoverCard extends StatefulWidget {
  /// Creates a hover card.
  const HoverCard({
    super.key,
    required this.child,
    required this.hoverBuilder,
    this.debounce,
    this.wait,
    this.popoverAlignment,
    this.anchorAlignment,
    this.popoverOffset,
    this.behavior,
    this.controller,
    this.theme,
  });

  /// The anchor the card points at.
  final Widget child;

  /// Builds the card content.
  final WidgetBuilder hoverBuilder;

  /// Hide delay after the pointer leaves; null resolves the theme default.
  final Duration? debounce;

  /// Show delay after the pointer enters; null resolves the theme default.
  final Duration? wait;

  /// Card placement; null resolves the theme default.
  final AlignmentGeometry? popoverAlignment;

  /// Anchor edge; null resolves the theme default.
  final AlignmentGeometry? anchorAlignment;

  /// Gap between anchor and card; null resolves the theme default.
  final Offset? popoverOffset;

  /// Hit-test behaviour of the anchor; null resolves the theme default.
  final HitTestBehavior? behavior;

  /// External popover controller; owned internally when null.
  final PopoverController? controller;

  /// Widget-leg theme override.
  final HoverCardTheme? theme;

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  PopoverController? _owned;
  PopoverController get _controller =>
      widget.controller ?? (_owned ??= PopoverController());

  @override
  void dispose() {
    _owned?.dispose();
    super.dispose();
  }

  HoverCardTheme _resolved(BuildContext context) =>
      resolveComponentStyle<HoverCardTheme, HoverCardTheme>(
        context,
        widget: widget.theme,
        select: (t) => t,
        defaults: hoverCardDefaults,
      );

  void _show(BuildContext context) {
    final HoverCardTheme style = _resolved(context);
    _controller.show<void>(
      context: context,
      handler: OverlayHandler.popover,
      modal: false,
      dismissBackdropFocus: false,
      alignment:
          widget.popoverAlignment ??
          style.popoverAlignment ??
          Alignment.topCenter,
      anchorAlignment:
          widget.anchorAlignment ??
          style.anchorAlignment ??
          Alignment.bottomCenter,
      offset: widget.popoverOffset ?? style.popoverOffset ?? const Offset(0, 8),
      builder: (context) =>
          _HoverCardSurface(child: widget.hoverBuilder(context)),
    );
  }

  void _hide() => _controller.close();

  @override
  Widget build(BuildContext context) {
    final HoverCardTheme style = _resolved(context);
    return Hover(
      waitDuration: widget.wait ?? style.wait,
      minDuration: widget.debounce ?? style.debounce,
      showDuration: Duration.zero,
      onHover: (hovered) => hovered ? _show(context) : _hide(),
      child: GestureDetector(
        behavior:
            widget.behavior ?? style.behavior ?? HitTestBehavior.deferToChild,
        onLongPress: () => _show(context),
        child: widget.child,
      ),
    );
  }
}

/// The themed popover surface card content is painted on.
class _HoverCardSurface extends StatelessWidget {
  const _HoverCardSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData app = ShadcnTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: app.colors.popover,
        border: Border.all(color: app.colors.border),
        borderRadius: app.borderRadiusMd,
        // Quiet popover elevation, like every other overlay surface.
        boxShadow: app.tokens.shadows.shadowMd,
      ),
      child: DefaultTextStyle(
        style: app.typography.small.copyWith(
          color: app.colors.popoverForeground,
        ),
        child: IconTheme.merge(
          data: IconThemeData(color: app.colors.popoverForeground),
          child: child,
        ),
      ),
    );
  }
}
