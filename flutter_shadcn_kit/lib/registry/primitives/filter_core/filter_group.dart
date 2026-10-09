// Custom filters and the grouped layout of the `filter_bar` engine: one
// [FilterCustomFilter] per filter, one [FilterGroup] per titled group, and
// [FilterBarGroupedContent], the widget that renders them (group headers plus
// the ungrouped remainder).
//
// Pure widgets only (Text/Wrap/Column): no components, so it stays in the
// primitive layer. The flat (no groups) rendering is the same widget with an
// empty [FilterGroup] list.

import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'filter_controller.dart';
import 'filter_matching.dart';
import 'filter_state.dart';

/// Receives the next [FilterState].
typedef FilterStateChanged = void Function(FilterState next);

/// Builds one custom filter from the state and its setter.
typedef FilterCustomFilterBuilder =
    Widget Function(
      BuildContext context,
      FilterState state,
      FilterStateChanged onStateChanged,
    );

/// Builds one typed custom filter from its current value.
typedef FilterTypedCustomFilterBuilder<T> =
    Widget Function(BuildContext context, T? value, ValueChanged<T?> onChanged);

/// One custom filter entry: [id] identifies it, [builder] renders it.
@immutable
class FilterCustomFilter {
  /// Creates a custom filter.
  const FilterCustomFilter({required this.id, required this.builder});

  /// Stable id.
  final String id;

  /// Renders the filter for the current state.
  final FilterCustomFilterBuilder builder;

  /// Creates a filter backed by a [FilterField], reading its value from the
  /// state and writing changes back.
  static FilterCustomFilter typed<T>({
    required FilterField<T> field,
    required FilterTypedCustomFilterBuilder<T> builder,
  }) {
    return FilterCustomFilter(
      id: field.id,
      builder:
          (
            BuildContext context,
            FilterState state,
            FilterStateChanged onChanged,
          ) {
            return builder(context, state.valueOf<T>(field), (T? next) {
              onChanged(state.setValue<T>(field, next));
            });
          },
    );
  }
}

/// One titled group of custom filters.
@immutable
class FilterGroup {
  /// Creates a group.
  const FilterGroup({
    required this.id,
    required this.title,
    this.filterIds = const <String>[],
    this.itemBuilder,
  });

  /// Stable id.
  final String id;

  /// Group heading.
  final String title;

  /// Custom filter ids that belong to this group.
  final List<String> filterIds;

  /// Optional per-item renderer; when null the filter's own builder is used.
  final FilterCustomFilterBuilder? itemBuilder;
}

/// Renders custom filters under [FilterGroup] headers.
///
/// Every filter renders exactly once: grouped ids under their group, all
/// other ids (and [trailing] controls) in a final ungrouped wrap. With an
/// empty [groups] list this is the flat control wrap.
class FilterBarGroupedContent extends StatelessWidget {
  /// Creates the grouped (or flat) filter content.
  const FilterBarGroupedContent({
    super.key,
    required this.state,
    required this.onChanged,
    required this.groups,
    required this.customFilters,
    this.trailing = const <Widget>[],
    this.spacing = 12,
    this.runSpacing = 8,
  });

  /// Current filter state.
  final FilterState state;

  /// Receives the next state from a custom filter.
  final FilterStateChanged onChanged;

  /// Groups to render; empty renders [customFilters] and [trailing] flat.
  final List<FilterGroup> groups;

  /// Custom filters offered by the bar.
  final List<FilterCustomFilter> customFilters;

  /// Controls appended after the groups (sort/date/trailing widgets).
  final List<Widget> trailing;

  /// Gap between controls on the same run.
  final double spacing;

  /// Gap between wrapped runs.
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    final Map<String, Widget> byId = <String, Widget>{};
    for (final FilterCustomFilter filter in customFilters) {
      byId[filter.id] = filter.builder(context, state, onChanged);
    }
    final Set<String> used = <String>{};
    final List<Widget> blocks = <Widget>[];
    for (final FilterGroup group in groups) {
      final List<Widget> items = <Widget>[];
      for (final String id in group.filterIds) {
        final Widget? item =
            group.itemBuilder?.call(context, state, onChanged) ?? byId[id];
        if (item != null) {
          items.add(item);
        }
      }
      used.addAll(group.filterIds);
      if (items.isEmpty) {
        continue;
      }
      blocks.add(
        _FilterGroupBlock(
          title: group.title,
          items: items,
          spacing: spacing,
          runSpacing: runSpacing,
        ),
      );
    }
    final List<Widget> ungrouped = <Widget>[
      for (final FilterCustomFilter filter in customFilters)
        if (!used.contains(filter.id)) byId[filter.id]!,
      ...trailing,
    ];
    if (blocks.isEmpty) {
      return Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: ungrouped,
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (final Widget block in blocks) ...<Widget>[
          block,
          SizedBox(height: runSpacing),
        ],
        if (ungrouped.isNotEmpty)
          Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: ungrouped,
          ),
      ],
    );
  }
}

/// One group heading over its wrapped filters.
class _FilterGroupBlock extends StatelessWidget {
  const _FilterGroupBlock({
    required this.title,
    required this.items,
    required this.spacing,
    required this.runSpacing,
  });

  final String title;
  final List<Widget> items;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: ambient.typography.small.copyWith(
            color: ambient.colors.mutedForeground,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: runSpacing),
        Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: items,
        ),
      ],
    );
  }
}
