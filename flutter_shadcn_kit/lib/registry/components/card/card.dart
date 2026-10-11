// The `card` component: the [Card] surface plus the shadcn card slots
// ([CardHeader], [CardTitle], [CardDescription], [CardContent],
// [CardFooter]).
//
// The old `SurfaceCard` is deleted: its only difference was a translucent
// blurred fill (glass, not a token) and a sheet-overlay special case that
// dropped the chrome inside a drawer. The pilot `dialog` and `input` already
// dropped it, and `SheetOverlayHandler` has no new-tree consumer.
//
// `CardButton` is deleted as well: it was a button variant with zero users
// (only the old button barrel and its theme registry referenced it), and a
// pressable card is `Card(child: Clickable(...))`.

import 'package:flutter/widgets.dart';

import '../../primitives/sheet_overlay.dart';
import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import 'card_style.dart';

export 'card_style.dart';

/// A rounded surface with a border, a token fill and a soft shadow.
///
/// Inside a sheet overlay (see [SheetOverlayHandler]) only the padding is
/// applied: the sheet already provides the surface, so a second card chrome on
/// top of it would draw a border inside a border.
class Card extends StatelessWidget {
  /// Creates a card.
  const Card({
    super.key,
    required this.child,
    this.padding,
    this.background,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.shadows,
    this.clipBehavior = Clip.none,
    this.theme,
  });

  /// Card content.
  final Widget child;

  /// Padding between the card border and its content; null falls back to
  /// `cardDefaults.padding`, a density-scaled shadcn `p-6` that `Card`
  /// resolves against `density.baseContentPadding * scaling`. A literal
  /// override passes through unchanged.
  final EdgeInsetsGeometry? padding;

  /// Fill override; null falls back to `CardTheme.background`.
  final ThemedColor? background;

  /// Border colour override; null falls back to `CardTheme.borderColor`.
  final ThemedColor? borderColor;

  /// Border width override; `0` hides the border.
  final double? borderWidth;

  /// Corner radius override; null resolves the ambient `radiusXl`.
  final BorderRadiusGeometry? borderRadius;

  /// Shadow override; null resolves the ambient `shadowSm`.
  final List<BoxShadow>? shadows;

  /// How the card clips its content.
  final Clip clipBehavior;

  /// Widget-leg override, merged over the component/app/defaults legs.
  final CardTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final CardTheme style = resolveComponentStyle<CardTheme, CardTheme>(
      context,
      widget: theme,
      select: (t) => t,
      defaults: cardDefaults,
    );
    // This `Padding` is the single place the card's chrome paints, so it is
    // also the only place the density multipliers are resolved.
    final EdgeInsetsGeometry padding = resolveEdgeInsets(
      this.padding ?? style.padding ?? cardDefaultPadding,
      ambient.density.baseContentPadding * ambient.scaling,
    );
    final Widget content = Padding(padding: padding, child: child);
    if (SheetOverlayHandler.isSheetOverlay(context)) {
      return content;
    }
    final ShadcnColors colors = ambient.colors;
    final Color? border = (borderColor ?? style.borderColor)?.resolve(colors);
    final double width = borderWidth ?? style.borderWidth ?? 0;
    final List<BoxShadow> boxShadow =
        shadows ??
        style.shadows ??
        (style.themeShadows ?? ambient.tokens.shadows).shadowSm;
    final BorderRadiusGeometry radius =
        borderRadius ?? style.borderRadius ?? ambient.borderRadiusXl;
    Widget body = content;
    if (clipBehavior != Clip.none) {
      // A non-uniform `BorderRadiusGeometry` cannot round a clip, so it falls
      // back to a rectangular clip instead of silently dropping the radius.
      body = radius is BorderRadius
          ? ClipRRect(borderRadius: radius, child: content)
          : ClipRect(child: content);
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        color: (background ?? style.background)?.resolve(colors),
        borderRadius: radius,
        border: border == null || width <= 0
            ? null
            : Border.all(color: border, width: width),
        boxShadow: boxShadow.isEmpty ? null : boxShadow,
      ),
      child: body,
    );
  }
}

/// Vertical container for the card header block (shadcn `CardHeader`).
class CardHeader extends StatelessWidget {
  /// Creates a card header.
  const CardHeader({super.key, required this.child, this.padding});

  /// Header content, usually a [CardTitle] plus a [CardDescription].
  final Widget child;

  /// Padding override; null falls back to the card padding.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[child],
      ),
    );
  }
}

/// Card heading (shadcn `CardTitle`): semibold, tight tracking.
class CardTitle extends StatelessWidget {
  /// Creates a card title.
  const CardTitle({super.key, required this.child, this.style});

  /// Title content.
  final Widget child;

  /// Text style override.
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final CardTheme theme = resolveComponentStyle<CardTheme, CardTheme>(
      context,
      select: (t) => t,
      defaults: cardDefaults,
    );
    final Color color =
        theme.foreground?.resolve(ShadcnTheme.of(context).colors) ??
        _foreground(context);
    return DefaultTextStyle.merge(
      style:
          (style ?? const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
              .copyWith(color: color),
      child: child,
    );
  }
}

/// Card supporting text (shadcn `CardDescription`): muted, 14px.
class CardDescription extends StatelessWidget {
  /// Creates a card description.
  const CardDescription({super.key, required this.child, this.style});

  /// Description content.
  final Widget child;

  /// Text style override.
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: (style ?? const TextStyle(fontSize: 14)).copyWith(
        color: ShadcnTheme.of(context).colors.mutedForeground,
      ),
      child: child,
    );
  }
}

/// Body of the card (shadcn `CardContent`).
class CardContent extends StatelessWidget {
  /// Creates card content.
  const CardContent({super.key, required this.child, this.padding});

  /// Content.
  final Widget child;

  /// Padding override; null falls back to the card padding.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: padding ?? EdgeInsets.zero, child: child);
  }
}

/// Card footer (shadcn `CardFooter`), aligned to the end by default.
class CardFooter extends StatelessWidget {
  /// Creates a card footer.
  const CardFooter({
    super.key,
    required this.child,
    this.padding,
    this.alignment = MainAxisAlignment.end,
  });

  /// Footer content, usually a row of buttons.
  final Widget child;

  /// Padding override; null falls back to the card padding.
  final EdgeInsetsGeometry? padding;

  /// Main-axis alignment of the footer row.
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(mainAxisAlignment: alignment, children: <Widget>[child]),
    );
  }
}

Color _foreground(BuildContext context) =>
    ShadcnTheme.of(context).colors.cardForeground;
