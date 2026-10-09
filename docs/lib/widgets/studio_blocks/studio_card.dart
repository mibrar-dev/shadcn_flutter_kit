// The shared card shell of the Theme Studio canvas (spec §2.7).
//
// The reference's `/create` canvas is a masonry grid of block cards (form
// card, stat card with progress, transactions list, empty state, tabs,
// calendar, table). These blocks are built only from registry components so
// every token the rail edits is exercised by something real.

import 'package:flutter/widgets.dart';

import '../../ui/shadcn/components/card/card.dart';
import '../../ui/shadcn/components/progress/progress.dart';
import '../../ui/shadcn/foundation/gap.dart';
import '../../ui/shadcn/theme/theme.dart';

/// A canvas card: `card` fill, `--card` border, `radius-xl`, 20 px padding.
class StudioCard extends StatelessWidget {
  /// Creates a card.
  const StudioCard({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.trailing,
    this.padding = const EdgeInsets.all(20),
    this.height,
  });

  /// The card body.
  final Widget child;

  /// Optional 14/600 title.
  final String? title;

  /// Optional 12 muted subtitle.
  final String? subtitle;

  /// Optional trailing header widget (the reference's `x` close chip).
  final Widget? trailing;

  /// Card padding.
  final EdgeInsetsGeometry padding;

  /// Optional fixed height, so a grid row stays even.
  final double? height;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final Widget? heading = title == null
        ? null
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      title!,
                      style: theme.typography.h4.copyWith(fontSize: 15),
                    ),
                  ),
                  ?trailing,
                ],
              ),
              if (subtitle != null) ...<Widget>[
                const Gap(2),
                Text(
                  subtitle!,
                  style: theme.typography.small.copyWith(
                    fontSize: 12,
                    color: theme.colors.mutedForeground,
                  ),
                ),
              ],
            ],
          );
    return SizedBox(
      height: height,
      child: Card(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (heading != null) ...<Widget>[heading, const Gap(16)],
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}

/// A large number with a muted caption (the reference's `$420,000` blocks).
class StudioStat extends StatelessWidget {
  /// Creates a stat block.
  const StudioStat({
    super.key,
    required this.label,
    required this.value,
    this.caption,
    this.progress,
  });

  /// The 11 px uppercase caption above the number.
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
      children: <Widget>[
        Text(
          label.toUpperCase(),
          style: theme.typography.small.copyWith(
            fontSize: 10.5,
            letterSpacing: 0.6,
            color: theme.colors.mutedForeground,
          ),
        ),
        const Gap(6),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: theme.typography.h3.copyWith(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
        ),
        if (progress != null || caption != null) ...<Widget>[
          const Gap(10),
          if (progress case final double value$)
            StudioProgressBar(value: value$),
          if (caption != null) ...<Widget>[
            const Gap(8),
            Text(
              caption!,
              style: theme.typography.small.copyWith(
                fontSize: 12,
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
/// Lives here rather than in `studio_stats.dart` because both `StudioStat`
/// and the savings card need it and this is the shared shell.
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
