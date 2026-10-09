// One row of the Theme Studio rail (spec §2.7).
//
// The reference's rail rows are a bordered card holding a 12 px muted label
// over the current value, with a swatch or glyph on the right; tapping the row
// opens a popup. `rail_pickers.dart` provides the popup bodies.

import 'package:flutter/widgets.dart';

import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/primitives/clickable.dart';
import '../ui/shadcn/theme/color_tokens.dart';
import '../ui/shadcn/theme/theme.dart';
import 'docs_tokens.dart';

/// A rail row: label over value, with a trailing swatch or glyph.
class RailRow extends StatelessWidget {
  /// Creates a row.
  const RailRow({
    super.key,
    required this.label,
    required this.value,
    required this.onPressed,
    this.trailing,
    this.selected = false,
  });

  /// The 12 px muted label (`Base Color`).
  final String label;

  /// The current value (`Neutral`, `10 px`, `Geist`).
  final String value;

  /// Opens the row's picker.
  final VoidCallback onPressed;

  /// The right-hand swatch or glyph; omitted when a row is text-only.
  final Widget? trailing;

  /// Whether the row's value is the one in effect (accent fill + border).
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ClickableCard(
        onPressed: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? theme.colors.accent : theme.colors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? theme.colors.accent : theme.colors.border,
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: docsText(
                        context,
                        size: 12,
                        color: theme.colors.mutedForeground,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: docsText(
                        context,
                        size: 14,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...<Widget>[
                const Gap(8),
                SizedBox(width: 20, height: 20, child: trailing),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A circle swatch in [color] (the colour rows' trailing glyph).
class RailSwatch extends StatelessWidget {
  /// Creates a swatch.
  const RailSwatch({super.key, required this.color, this.selected = false});

  /// The swatch fill.
  final Color color;

  /// Whether to draw the selection ring.
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Center(
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? theme.colors.foreground : theme.colors.border,
          ),
        ),
      ),
    );
  }
}

/// A four-quadrant preset swatch (the `Preset` row's trailing glyph).
class RailPresetSwatch extends StatelessWidget {
  /// Creates the glyph.
  const RailPresetSwatch({super.key, required this.colors});

  /// Four colours, painted as quadrants.
  final List<Color> colors;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(3),
    child: SizedBox.expand(
      child: Column(
        children: <Widget>[
          for (int row = 0; row < 2; row++)
            Expanded(
              child: Row(
                children: <Widget>[
                  for (int column = 0; column < 2; column++)
                    Expanded(
                      child: ColoredBox(color: colors[row * 2 + column]),
                    ),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}

/// A card-shaped clickable with the reference's 150 ms hover colour change.
class ClickableCard extends StatelessWidget {
  /// Creates a clickable card.
  const ClickableCard({
    super.key,
    required this.child,
    required this.onPressed,
  });

  /// The content.
  final Widget child;

  /// Called on tap.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return Clickable(
      onPressed: onPressed,
      behavior: HitTestBehavior.opaque,
      decoration: WidgetStateProperty.resolveWith<Decoration?>((
        Set<WidgetState> states,
      ) {
        return BoxDecoration(
          color: colors.muted.withValues(
            alpha: states.contains(WidgetState.hovered) ? 0.6 : 0.4,
          ),
        );
      }),
      child: child,
    );
  }
}
