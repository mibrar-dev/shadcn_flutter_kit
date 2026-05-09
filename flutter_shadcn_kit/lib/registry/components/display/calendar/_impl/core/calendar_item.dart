// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../calendar.dart';

/// Individual calendar date cell with interactive behavior and visual states.
///
/// Represents a single date item within a calendar grid, handling touch interactions,
/// visual state management, and theme integration. Supports different visual states
/// for selection, ranges, and special dates like today.
///
/// Key Features:
/// - **Visual States**: Multiple appearance modes based on selection status
/// - **Interactive**: Touch/click handling with callbacks
/// - **Responsive Sizing**: Configurable width/height with theme scaling
/// - **Accessibility**: Screen reader support and focus management
/// - **State Management**: Enabled/disabled states with visual feedback
/// - **Range Support**: Special styling for range start/end/middle positions
///
/// The item automatically applies appropriate button styling based on its [type]
/// and handles edge cases for range visualization at row boundaries.
///
/// Example:
/// ```dart
/// CalendarItem(
///   type: CalendarItemType.selected,
///   indexAtRow: 2,
///   rowCount: 7,
///   state: DateState.enabled,
///   onTap: () => handleDateTap(date),
///   child: Text('15'),
/// )
/// ```
class CalendarItem extends StatelessWidget {
  /// The widget to display as the date content.
  final Widget child;

  /// The visual state type for this calendar item.
  final CalendarItemType type;

  /// Callback invoked when the item is tapped.
  final VoidCallback? onTap;

  /// The position of this item in its row (0-indexed).
  final int indexAtRow;

  /// The total number of items per row.
  final int rowCount;

  /// Optional fixed width for the item.
  final double? width;

  /// Optional fixed height for the item.
  final double? height;

  /// The interaction state of this date (enabled/disabled).
  final DateState state;

  /// Creates a calendar item with the specified properties.
  const CalendarItem({
    super.key,
    required this.child,
    required this.type,
    required this.indexAtRow,
    required this.rowCount,
    this.onTap,
    this.width,
    this.height,
    required this.state,
  });

  /// Builds the widget tree for calendar.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    var type = this.type;
    if ((indexAtRow == 0 || indexAtRow == rowCount - 1) &&
        (type == CalendarItemType.startRangeSelected ||
            type == CalendarItemType.endRangeSelected ||
            type == CalendarItemType.startRangeSelectedShort ||
            type == CalendarItemType.endRangeSelectedShort)) {
      type = CalendarItemType.selected;
    }
    switch (type) {
      case CalendarItemType.none:
        return SizedBox(
          width: width ?? theme.scaling * 32,
          height: height ?? theme.scaling * 32,
          child: GhostButton(
            density: ButtonDensity.compact,
            alignment: Alignment.center,
            enabled: state == DateState.enabled,
            onPressed: onTap,
            child: child,
          ),
        );
      case CalendarItemType.today:
        return SizedBox(
          width: width ?? theme.scaling * 32,
          height: height ?? theme.scaling * 32,
          child: SecondaryButton(
            density: ButtonDensity.compact,
            alignment: Alignment.center,
            enabled: state == DateState.enabled,
            onPressed: onTap,
            child: child,
          ),
        );
      case CalendarItemType.selected:
        return SizedBox(
          width: width ?? theme.scaling * 32,
          height: height ?? theme.scaling * 32,
          child: PrimaryButton(
            density: ButtonDensity.compact,
            alignment: Alignment.center,
            enabled: state == DateState.enabled,
            onPressed: onTap,
            child: child,
          ),
        );
      case CalendarItemType.inRange:
        return SizedBox(
          width: width ?? theme.scaling * 32,
          height: height ?? theme.scaling * 32,
          child: Button(
            alignment: Alignment.center,
            onPressed: onTap,
            enabled: state == DateState.enabled,
            style:
                const ButtonStyle(
                  variance: ButtonVariance.secondary,
                  density: ButtonDensity.compact,
                ).copyWith(
                  decoration: (context, states, value) {
                    return (value as BoxDecoration).copyWith(
                      borderRadius: indexAtRow == 0
                          ? BorderRadius.only(
                              topLeft: Radius.circular(theme.radiusMd),
                              bottomLeft: Radius.circular(theme.radiusMd),
                            )
                          : indexAtRow == rowCount - 1
                          ? BorderRadius.only(
                              topRight: Radius.circular(theme.radiusMd),
                              bottomRight: Radius.circular(theme.radiusMd),
                            )
                          : BorderRadius.zero,
                    );
                  },
                ),
            child: child,
          ),
        );
      case CalendarItemType.startRange:
        return SizedBox(
          width: width ?? theme.scaling * 32,
          height: height ?? theme.scaling * 32,
          child: Button(
            alignment: Alignment.center,
            onPressed: onTap,
            enabled: state == DateState.enabled,
            style:
                const ButtonStyle(
                  variance: ButtonVariance.secondary,
                  density: ButtonDensity.compact,
                ).copyWith(
                  decoration: (context, states, value) {
                    return (value as BoxDecoration).copyWith(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(theme.radiusMd),
                        bottomLeft: Radius.circular(theme.radiusMd),
                      ),
                    );
                  },
                ),
            child: child,
          ),
        );
      case CalendarItemType.endRange:
        return SizedBox(
          width: width ?? theme.scaling * 32,
          height: height ?? theme.scaling * 32,
          child: Button(
            alignment: Alignment.center,
            onPressed: onTap,
            enabled: state == DateState.enabled,
            style:
                const ButtonStyle(
                  variance: ButtonVariance.secondary,
                  density: ButtonDensity.compact,
                ).copyWith(
                  decoration: (context, states, value) {
                    return (value as BoxDecoration).copyWith(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(theme.radiusMd),
                        bottomRight: Radius.circular(theme.radiusMd),
                      ),
                    );
                  },
                ),
            child: child,
          ),
        );
      case CalendarItemType.startRangeSelected:
        return SizedBox(
          width: width ?? theme.scaling * 32,
          height: height ?? theme.scaling * 32,
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              Container(
                width: width ?? theme.scaling * 32,
                height: height ?? theme.scaling * 32,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(theme.radiusMd),
                    bottomLeft: Radius.circular(theme.radiusMd),
                  ),
                ),
              ),

              PrimaryButton(
                density: ButtonDensity.compact,
                alignment: Alignment.center,
                enabled: state == DateState.enabled,
                onPressed: onTap,
                child: child,
              ),
            ],
          ),
        );
      case CalendarItemType.endRangeSelected:
        return SizedBox(
          width: width ?? theme.scaling * 32,
          height: height ?? theme.scaling * 32,
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              Container(
                width: width ?? theme.scaling * 32,
                height: height ?? theme.scaling * 32,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(theme.radiusMd),
                    bottomRight: Radius.circular(theme.radiusMd),
                  ),
                ),
              ),

              PrimaryButton(
                density: ButtonDensity.compact,
                alignment: Alignment.center,
                enabled: state == DateState.enabled,
                onPressed: onTap,
                child: child,
              ),
            ],
          ),
        );
      case CalendarItemType.startRangeSelectedShort:
        return SizedBox(
          width: width ?? theme.scaling * 32,
          height: height ?? theme.scaling * 32,
          child: Button(
            alignment: Alignment.center,
            onPressed: onTap,
            enabled: state == DateState.enabled,
            style:
                const ButtonStyle(
                  variance: ButtonVariance.primary,
                  density: ButtonDensity.compact,
                ).copyWith(
                  decoration: (context, states, value) {
                    return (value as BoxDecoration).copyWith(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(theme.radiusMd),
                        bottomLeft: Radius.circular(theme.radiusMd),
                      ),
                    );
                  },
                ),
            child: child,
          ),
        );
      case CalendarItemType.endRangeSelectedShort:
        return SizedBox(
          width: width ?? theme.scaling * 32,
          height: height ?? theme.scaling * 32,
          child: Button(
            alignment: Alignment.center,
            onPressed: onTap,
            enabled: state == DateState.enabled,
            style:
                const ButtonStyle(
                  variance: ButtonVariance.primary,
                  density: ButtonDensity.compact,
                ).copyWith(
                  decoration: (context, states, value) {
                    return (value as BoxDecoration).copyWith(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(theme.radiusMd),
                        bottomRight: Radius.circular(theme.radiusMd),
                      ),
                    );
                  },
                ),
            child: child,
          ),
        );
      case CalendarItemType.inRangeSelectedShort:
        return SizedBox(
          width: width ?? theme.scaling * 32,
          height: height ?? theme.scaling * 32,
          child: Button(
            alignment: Alignment.center,
            enabled: state == DateState.enabled,
            onPressed: onTap,
            style:
                const ButtonStyle(
                  variance: ButtonVariance.primary,
                  density: ButtonDensity.compact,
                ).copyWith(
                  decoration: (context, states, value) {
                    return (value as BoxDecoration).copyWith(
                      borderRadius: BorderRadius.zero,
                    );
                  },
                ),
            child: child,
          ),
        );
    }
  }
}

/// Data structure representing a complete calendar month grid.
///
/// Contains all the information needed to render a calendar grid including
/// dates from the current month and overflow dates from adjacent months
/// to fill complete weeks.
