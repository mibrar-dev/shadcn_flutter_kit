// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tracker.dart';

/// Visual tracker display.
class Tracker extends StatelessWidget {
  /// Data consumed by `Tracker` to render tracker content.
  final List<TrackerData> data;

  const Tracker({super.key, required this.data});

  /// Builds the widget tree for tracker.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trackerTheme = ComponentTheme.maybeOf<TrackerTheme>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        trackerTheme?.radius ?? theme.radiusMd,
      ),
      child: Row(
        children: [
          for (final entry in data)
            Expanded(
              child: InstantTooltip(
                tooltipBuilder: (context) {
                  return TooltipContainer(child: entry.tooltip);
                },
                child: Container(
                  height: trackerTheme?.itemHeight ?? 32,
                  color: entry.level.color,
                ),
              ),
            ),
        ],
      ).gap(trackerTheme?.gap ?? theme.scaling * 2),
    );
  }
}
