// The `tracker` component: [Tracker], a compact row of coloured segments
// (one per [TrackerData]) each carrying a hover tooltip.
//
// Ported from `components/display/tracker/**` (a 15-line barrel plus five
// `part`s). Fixes, all verified against the old source:
//   * `tracker.dart` imported `package:flutter/material.dart` for `Colors` —
//     banned; the four level colours now live in `TrackerTheme`.
//   * The levels were `static const` literals (`Colors.green`, `Colors.orange`,
//     `Colors.red`, `Colors.grey`), so no preset could restyle them. They are
//     `ThemedColor` rows now.
//   * `TrackerThemeDefaults` (radius 6 / gap 2 / height 32) was never read: the
//     widget used `trackerTheme?.radius ?? theme.radiusMd`. The defaults now
//     feed the resolver and `radius` resolves the ambient `radiusMd`.
//   * The old widget double-wrapped its content in a `TooltipContainer`; the
//     `Tooltip` component already wraps it, so the segment passes the bare
//     tooltip widget.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../tooltip/tooltip.dart';
import 'tracker_style.dart';

export 'tracker_style.dart';

/// One segment of a [Tracker]: a level (its colour) and the tooltip shown
/// while the pointer rests on it.
class TrackerData {
  /// Creates a tracker segment.
  const TrackerData({required this.tooltip, required this.level});

  /// Tooltip content; the `Tooltip` component supplies the surface.
  final Widget tooltip;

  /// Activity level of this segment.
  final TrackerLevel level;
}

/// A row of coloured activity segments.
///
/// ```dart
/// Tracker(
///   data: <TrackerData>[
///     TrackerData(tooltip: const Text('Healthy'), level: TrackerLevel.fine),
///     TrackerData(tooltip: const Text('Down'), level: TrackerLevel.critical),
///   ],
/// );
/// ```
class Tracker extends StatelessWidget {
  /// Creates a tracker.
  const Tracker({super.key, required this.data, this.theme});

  /// Segments, in visual order.
  final List<TrackerData> data;

  /// Widget-leg override, merged over the component/app/defaults legs.
  final TrackerTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final TrackerTheme resolved =
        resolveComponentStyle<TrackerTheme, TrackerTheme>(
          context,
          widget: theme,
          select: (t) => t,
          defaults: trackerDefaults,
        );
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }
    final ShadcnColors colors = ambient.colors;
    final double gap = resolved.gap ?? trackerDefaultGap;
    final double height = resolved.itemHeight ?? trackerDefaultItemHeight;
    final BorderRadius radius = BorderRadius.circular(
      resolved.radius ?? ambient.radiusMd,
    );
    final List<Widget> segments = <Widget>[];
    for (var i = 0; i < data.length; i++) {
      if (i > 0) {
        segments.add(Gap(gap));
      }
      final TrackerData entry = data[i];
      final Color fill = resolved.forLevel(entry.level)!.resolve(colors);
      segments.add(
        Expanded(
          child: Tooltip(
            // A tracker segment is an "instant" tooltip: no hover delay.
            waitDuration: Duration.zero,
            tooltip: (BuildContext context) => entry.tooltip,
            child: SizedBox(
              height: height,
              child: ColoredBox(color: fill),
            ),
          ),
        ),
      );
    }
    return ClipRRect(
      borderRadius: radius,
      child: Row(children: segments),
    );
  }
}
