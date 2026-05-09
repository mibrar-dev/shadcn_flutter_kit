// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:data_widget/data_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import '../../utility/alpha/alpha.dart';
import '../../control/button/button.dart';
import '../../../shared/theme/theme.dart';

part '_impl/utils/_color_list_notifier.dart';
part '_impl/core/color_history_storage.dart';
part '_impl/core/recent_colors_scope.dart';
part '_impl/state/recent_colors_scope_state.dart';

/// A grid widget that displays a history of previously used colors.
///
/// [ColorHistoryGrid] presents colors from a [ColorHistoryStorage] in a grid
/// layout, allowing users to quickly reuse recently selected colors. The grid
/// can highlight the currently selected color and supports custom layouts.
class ColorHistoryGrid extends StatelessWidget {
  /// The storage containing the color history.
  final ColorHistoryStorage storage;

  /// Called when a color from the history is picked.
  final ValueChanged<Color>? onColorPicked;

  /// Spacing between grid items.
  final double? spacing;

  /// Number of columns in the grid.
  final int crossAxisCount;

  /// The currently selected color to highlight.
  final Color? selectedColor;

  /// The amount of colors to display in the history.
  final int? maxTotalColors;

  /// Creates a [ColorHistoryGrid].
  const ColorHistoryGrid({
    super.key,
    required this.storage,
    this.onColorPicked,
    this.spacing,
    this.crossAxisCount = 10,
    this.selectedColor,
    this.maxTotalColors,
  });

  /// Performs `_buildGridTile` logic for this form component.
  Widget _buildGridTile(BuildContext context, Color? color, ThemeData theme) {
    if (color == null) {
      return const AspectRatio(
        aspectRatio: 1,
        child: Button(
          style: ButtonStyle.outline(density: ButtonDensity.compact),
          child: SizedBox.shrink(),
        ),
      );
    }
    return Container(
      decoration: selectedColor != null && color == selectedColor
          ? BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.primary,
                width: 2 * theme.scaling,
              ),
              borderRadius: BorderRadius.circular(theme.radiusMd),
            )
          : null,
      child: AspectRatio(
        aspectRatio: 1,
        child: Button(
          style: const ButtonStyle.outline(density: ButtonDensity.compact),
          onPressed: () {
            onColorPicked?.call(color);
          },
          child: Stack(
            children: [
              Positioned.fill(
                top: selectedColor != null && color == selectedColor ? -2 : 0,
                left: selectedColor != null && color == selectedColor ? -2 : 0,
                child: ClipRRect(
                  borderRadius: theme.borderRadiusSm,
                  child: CustomPaint(painter: AlphaPainter()),
                ),
              ),
              Positioned.fill(child: Container(color: color)),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing =
        this.spacing ?? (theme.density.baseGap * theme.scaling * 0.5);
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 100),
      child: ListenableBuilder(
        listenable: storage,
        builder: (context, child) {
          List<Widget> rows = [];
          for (
            int i = 0;
            i < storage.capacity &&
                (maxTotalColors == null || i < maxTotalColors!);
            i += crossAxisCount
          ) {
            List<Widget> tiles = [];
            for (int j = 0; j < crossAxisCount; j++) {
              final index = i + j;
              final color = index < storage.recentColors.length
                  ? storage.recentColors[index]
                  : null;
              if (index >= storage.capacity ||
                  (maxTotalColors != null && index >= maxTotalColors!)) {
                tiles.add(const Expanded(child: SizedBox()));
              } else {
                tiles.add(
                  Expanded(
                    child: SizedBox(
                      width: 32 * theme.scaling,
                      height: 32 * theme.scaling,
                      child: _buildGridTile(context, color, theme),
                    ),
                  ),
                );
              }
              if (j < crossAxisCount - 1) {
                tiles.add(Gap(spacing));
              }
            }
            rows.add(
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: tiles,
                ),
              ),
            );
            if (i < storage.capacity - crossAxisCount) {
              rows.add(Gap(spacing));
            }
          }
          return IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: rows,
            ),
          );
        },
      ),
    );
  }
}
