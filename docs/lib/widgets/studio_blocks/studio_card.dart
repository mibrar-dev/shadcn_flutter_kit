// The shared card shell of the Theme Studio canvas (spec §2.7).
//
// One card = one canvas block. It wraps a `Card` around a header and a body
// and takes no height, no stretch and no flex: every card is exactly as tall
// as its content, which is what lets the masonry pack the columns tightly.
// Spacing, colours, radius, fonts and shadows all come from the live theme,
// so a rail edit shows up in the chrome as well as the contents.

import 'package:flutter/widgets.dart';

import '../../ui/shadcn/components/card/card.dart';
import '../../ui/shadcn/components/progress/progress.dart';
import '../../ui/shadcn/foundation/gap.dart';
import '../../ui/shadcn/theme/theme.dart';

/// The default inner padding of a canvas card.
const EdgeInsets kStudioCardPadding = EdgeInsets.all(20);

/// No-op callback for showcase buttons that must render enabled.
void studioNoop() {}

/// A canvas card: `card` fill, themed border and radius, and a header.
///
/// Deliberately free of `height`, `Expanded`, `Flexible` and any cross-axis
/// stretch: the body is laid out at its natural size.
class StudioCard extends StatelessWidget {
  /// Creates a card.
  const StudioCard({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.trailing,
    this.padding = kStudioCardPadding,
  });

  /// The card body, laid out at its natural height.
  final Widget child;

  /// Optional title, rendered above the body.
  final String? title;

  /// Optional muted line under [title].
  final String? subtitle;

  /// Optional widget at the end of the header row.
  final Widget? trailing;

  /// Inner padding of the card.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final Widget? header = title == null
        ? null
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      title!,
                      style: theme.typography.small.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (trailing != null) ...<Widget>[const Gap(8), trailing!],
                ],
              ),
              if (subtitle != null) ...<Widget>[
                const Gap(4),
                Text(
                  subtitle!,
                  style: theme.typography.small.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
              ],
            ],
          );
    return Card(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (header != null) ...<Widget>[
            header,
            Gap(theme.density.baseGap * 2),
          ],
          child,
        ],
      ),
    );
  }
}

/// The uppercase caption used above a value (`MONTHLY REVENUE`).
class StudioCaption extends StatelessWidget {
  /// Creates a caption.
  const StudioCaption(this.text, {super.key});

  /// The caption text; uppercased on build.
  final String text;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Text(
      text.toUpperCase(),
      style: theme.typography.xSmall.copyWith(
        letterSpacing: 0.6,
        color: theme.colors.mutedForeground,
      ),
    );
  }
}

/// A large formatted number (`$48,320`).
class StudioValue extends StatelessWidget {
  /// Creates a value line.
  const StudioValue(this.text, {super.key, this.size = 26});

  /// The formatted number.
  final String text;

  /// Font size; scales down with the viewport through the caller.
  final double size;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.typography.h3.copyWith(
        fontSize: size,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
    );
  }
}

/// A label/value row used by the list blocks (`Net Royalties $0.00`).
class StudioRow extends StatelessWidget {
  /// Creates a row.
  const StudioRow({super.key, required this.label, required this.value});

  /// The leading caption.
  final String label;

  /// The trailing value.
  final String value;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: theme.typography.small.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
          ),
          const Gap(12),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: theme.typography.small.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A form label styled the way shadcn labels a field (`Preferred Currency`).
class StudioFieldLabel extends StatelessWidget {
  /// Creates a field label.
  const StudioFieldLabel(this.text, {super.key});

  /// The label text.
  final String text;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Text(
      text,
      style: theme.typography.small.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

/// A muted helper line under a control or a heading.
class StudioHelper extends StatelessWidget {
  /// Creates a helper line.
  const StudioHelper(this.text, {super.key});

  /// The helper text.
  final String text;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Text(
      text,
      style: theme.typography.small.copyWith(
        color: theme.colors.mutedForeground,
      ),
    );
  }
}

/// A value together with an uppercase caption above it.
class StudioStat extends StatelessWidget {
  /// Creates a stat block.
  const StudioStat({
    super.key,
    required this.label,
    required this.value,
    this.caption,
    this.progress,
  });

  /// The uppercase caption above the number.
  final String label;

  /// The formatted number.
  final String value;

  /// The muted line under the progress bar.
  final String? caption;

  /// Optional 0..1 progress behind the caption.
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StudioCaption(label),
        const Gap(6),
        StudioValue(value),
        if (progress != null || caption != null) ...<Widget>[
          const Gap(10),
          if (progress case final double value$)
            StudioProgressBar(value: value$),
          if (caption != null) ...<Widget>[
            const Gap(8),
            Text(
              caption!,
              style: theme.typography.small.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
          ],
        ],
      ],
    );
  }
}

/// The thin progress rule under a stat (`65% achieved`).
///
/// Lives here rather than in `studio_stats.dart` because several blocks share
/// it and this is the shared shell.
class StudioProgressBar extends StatelessWidget {
  /// Creates the bar.
  const StudioProgressBar({super.key, required this.value});

  /// The fraction complete in 0..1.
  final double value;

  @override
  Widget build(BuildContext context) {
    return Progress(
      value: value.clamp(0, 1),
      height: 6,
      semanticsLabel: '${(value * 100).round()} percent',
    );
  }
}
