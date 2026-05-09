// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../filter_bar.dart';

/// _FilterBarContent defines a reusable type for this registry module.
class _FilterBarContent extends StatelessWidget {
  /// Creates a `_FilterBarContent` instance.
  const _FilterBarContent({
    required this.state,
    required this.searchController,
    required this.sortOptions,
    required this.enableDateRange,
    required this.resultsCount,
    required this.searchPlaceholder,
    required this.searchLabel,
    required this.trailingFilters,
    required this.customFilters,
    required this.style,
    required this.showClearAllWhenEmpty,
    required this.activeFilterCountLabel,
    required this.clearAllLabel,
    required this.sortLabel,
    required this.dateRangeLabel,
    required this.presentation,
    required this.sheetBreakpoint,
    required this.sheetTriggerLabel,
    required this.sheetTitle,
    required this.sheetPosition,
    required this.useRootSheetOverlay,
    required this.sheetConstraints,
    required this.sheetContentPadding,
    required this.groups,
    required this.onSearchChanged,
    required this.onSortChanged,
    required this.onRemoveChip,
    required this.onDateRangeChanged,
    required this.onClearDateRange,
    required this.onClearAll,
    required this.onStateChanged,
  });

  /// Stores `state` state/configuration for this implementation.
  final FilterState state;

  /// Stores `searchController` state/configuration for this implementation.
  final TextEditingController searchController;

  /// Stores `sortOptions` state/configuration for this implementation.
  final List<FilterSortOption> sortOptions;

  /// Stores `enableDateRange` state/configuration for this implementation.
  final bool enableDateRange;

  /// Stores `resultsCount` state/configuration for this implementation.
  final int? resultsCount;

  /// Stores `searchPlaceholder` state/configuration for this implementation.
  final String searchPlaceholder;

  /// Stores `searchLabel` state/configuration for this implementation.
  final String searchLabel;

  /// Stores `trailingFilters` state/configuration for this implementation.
  final List<Widget> trailingFilters;

  /// Stores `customFilters` state/configuration for this implementation.
  final List<FilterCustomFilter> customFilters;

  /// Stores `style` state/configuration for this implementation.
  final FilterBarStyle style;

  /// Stores `showClearAllWhenEmpty` state/configuration for this implementation.
  final bool showClearAllWhenEmpty;

  /// Stores `activeFilterCountLabel` state/configuration for this implementation.
  final String? activeFilterCountLabel;

  /// Stores `clearAllLabel` state/configuration for this implementation.
  final String clearAllLabel;

  /// Stores `sortLabel` state/configuration for this implementation.
  final String sortLabel;

  /// Stores `dateRangeLabel` state/configuration for this implementation.
  final String dateRangeLabel;

  /// Stores `presentation` state/configuration for this implementation.
  final FilterBarPresentation presentation;

  /// Stores `sheetBreakpoint` state/configuration for this implementation.
  final double sheetBreakpoint;

  /// Stores `sheetTriggerLabel` state/configuration for this implementation.
  final String sheetTriggerLabel;

  /// Stores `sheetTitle` state/configuration for this implementation.
  final String sheetTitle;

  /// Stores `sheetPosition` state/configuration for this implementation.
  final OverlayPosition sheetPosition;

  /// Stores `useRootSheetOverlay` state/configuration for this implementation.
  final bool useRootSheetOverlay;

  /// Stores `sheetConstraints` state/configuration for this implementation.
  final BoxConstraints? sheetConstraints;

  /// Stores `sheetContentPadding` state/configuration for this implementation.
  final EdgeInsetsGeometry? sheetContentPadding;

  /// Stores `groups` state/configuration for this implementation.
  final List<FilterGroup> groups;

  /// Stores `onSearchChanged` state/configuration for this implementation.
  final ValueChanged<String> onSearchChanged;

  /// Stores `onSortChanged` state/configuration for this implementation.
  final ValueChanged<String?> onSortChanged;

  /// Stores `onRemoveChip` state/configuration for this implementation.
  final ValueChanged<FilterChipData> onRemoveChip;

  /// Stores `onDateRangeChanged` state/configuration for this implementation.
  final ValueChanged<DateTimeRange?> onDateRangeChanged;

  /// Stores `onClearDateRange` state/configuration for this implementation.
  final VoidCallback onClearDateRange;

  /// Stores `onClearAll` state/configuration for this implementation.
  final VoidCallback onClearAll;

  /// Stores `onStateChanged` state/configuration for this implementation.
  final FilterStateChanged onStateChanged;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final resolvedTheme = _FilterBarResolvedTheme.resolve(context, style);
    final countLabel = _resolveCountLabel();

    /// Stores `showClearAll` state/configuration for this implementation.
    final showClearAll = showClearAllWhenEmpty || state.hasActiveFilters;

    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = _FilterBarLayout.resolve(
          maxWidth: constraints.maxWidth,
          style: style,
          trailingControlCount: trailingFilters.length + customFilters.length,
          hasSortControl: sortOptions.isNotEmpty,
          hasDateControl: enableDateRange,
          hasCounterText: countLabel != null,
          hasClearAction: showClearAll,
        );
        final useSheet = _shouldUseSheet(constraints.maxWidth);
        final showInlineGrouped = !useSheet && groups.isNotEmpty;

        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: resolvedTheme.borderRadius,
            border: Border.fromBorderSide(resolvedTheme.borderSide),
          ),
          child: Padding(
            padding: resolvedTheme.contentPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Creates a `Wrap` instance.
                Wrap(
                  spacing: style.spacing,
                  runSpacing: style.runSpacing,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    /// Creates a `ConstrainedBox` instance.
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: style.minSearchWidth,
                        maxWidth: layout.maxSearchWidth,
                      ),
                      child: Semantics(
                        textField: true,
                        label: searchLabel,
                        child: TextField(
                          controller: searchController,
                          onChanged: onSearchChanged,
                          placeholder: Text(searchPlaceholder),
                          features: const [
                            /// Creates a `InputFeature.leading` instance.
                            InputFeature.leading(Icon(LucideIcons.search)),

                            /// Creates a `InputFeature.clear` instance.
                            InputFeature.clear(),
                          ],
                        ),
                      ),
                    ),
                    if (sortOptions.isNotEmpty && !useSheet)
                      /// Creates a `_buildSortControl` instance.
                      _buildSortControl(
                        layout.sortWidth,
                        state: state,
                        onStateChanged: onStateChanged,
                      ),
                    if (enableDateRange && !useSheet)
                      _buildDateRangeControl(
                        context,
                        state: state,
                        onStateChanged: onStateChanged,
                        width: style.minSortWidth,
                      ),
                    if (useSheet)
                      SecondaryButton(
                        size: style.dense
                            ? ButtonSize.small
                            : ButtonSize.normal,
                        onPressed: () => _openMobileSheet(context),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(LucideIcons.slidersHorizontal),
                            SizedBox(width: 6 * Theme.of(context).scaling),
                            Text(
                              state.activeFilterCount > 0
                                  ? '$sheetTriggerLabel (${state.activeFilterCount})'
                                  : sheetTriggerLabel,
                            ),
                          ],
                        ),
                      )
                    else ...[
                      if (!showInlineGrouped)
                        ...customFilters.map(
                          (customFilter) =>
                              /// Creates a `customFilter.builder` instance.
                              customFilter.builder(
                                context,
                                state,
                                onStateChanged,
                              ),
                        ),
                      if (!showInlineGrouped) ...trailingFilters,
                    ],
                    if (countLabel != null)
                      /// Creates a `Padding` instance.
                      Padding(
                        padding: EdgeInsets.only(
                          top: layout.isSingleRow ? 0 : 4,
                        ),
                        child: Text(
                          countLabel,
                          style: resolvedTheme.helperTextStyle,
                        ),
                      ),
                    if (showClearAll)
                      /// Creates a `GhostButton` instance.
                      GhostButton(
                        size: style.dense
                            ? ButtonSize.small
                            : ButtonSize.normal,
                        onPressed: state.hasActiveFilters ? onClearAll : null,
                        child: Text(clearAllLabel),
                      ),
                  ],
                ),
                if (showInlineGrouped) ...[
                  SizedBox(height: style.runSpacing),
                  ..._buildGroupedInlineContent(context),
                ],
                if (state.chips.isNotEmpty) ...[
                  /// Creates a `SizedBox` instance.
                  SizedBox(height: style.runSpacing),

                  /// Creates a `Wrap` instance.
                  Wrap(
                    spacing: style.spacing,
                    runSpacing: style.runSpacing,
                    children: state.chips
                        .map(
                          (chip) => Chip(
                            trailing: ChipButton(
                              onPressed: () => onRemoveChip(chip),
                              child: const Icon(LucideIcons.x),
                            ),
                            child: Text(chip.label),
                          ),
                        )
                        .toList(growable: false),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  /// Executes `_resolveCountLabel` behavior for this component/composite.
  String? _resolveCountLabel() {
    if (resultsCount != null) {
      return _formatResultsCount(resultsCount!);
    }
    if (activeFilterCountLabel != null &&
        activeFilterCountLabel!.trim().isNotEmpty) {
      return activeFilterCountLabel;
    }

    /// Stores `activeCount` state/configuration for this implementation.
    final activeCount = state.activeFilterCount;
    if (activeCount > 0) {
      return _formatActiveFilterCount(activeCount);
    }
    return null;
  }

  /// Executes `_resolveSortValue` behavior for this component/composite.
  String? _resolveSortValue(FilterState state) {
    /// Stores `sortId` state/configuration for this implementation.
    final sortId = state.sortId;
    if (sortId == null) {
      return null;
    }
    final exists = sortOptions.any((option) => option.id == sortId);
    return exists ? sortId : null;
  }

  /// Executes `_buildSortControl` behavior for this component/composite.
  Widget _buildSortControl(
    double width, {
    required FilterState state,
    required FilterStateChanged onStateChanged,
  }) {
    return SizedBox(
      width: width,
      child: Select<String>(
        value: _resolveSortValue(state),
        onChanged: (next) => onStateChanged(state.copyWith(sortId: next)),
        placeholder: Text(sortLabel),
        itemBuilder: (context, value) {
          final option = sortOptions.firstWhere(
            (item) => item.id == value,
            orElse: () => FilterSortOption(id: value, label: value),
          );
          return Text(option.label);
        },
        popup: SelectPopup<String>(
          items: SelectItemList(
            children: sortOptions
                .map(
                  (option) => SelectItemButton<String>(
                    value: option.id,
                    child: Text(option.label),
                  ),
                )
                .toList(growable: false),
          ),
        ).call,
      ),
    );
  }

  /// Executes `_buildDateRangeControl` behavior for this component/composite.
  Widget _buildDateRangeControl(
    BuildContext context, {
    required FilterState state,
    required FilterStateChanged onStateChanged,
    required double width,
  }) {
    /// Stores `hasDateRange` state/configuration for this implementation.
    final hasDateRange = state.dateRange != null;
    final localizations = ShadcnLocalizations.of(context);

    final field = ObjectFormField<DateTimeRange>(
      mode: PromptMode.popover,
      value: _toDateTimeRange(state.dateRange),
      onChanged: (value) {
        onStateChanged(
          state.copyWith(
            dateRange: value == null
                ? null
                : FilterDateRange(start: value.start, end: value.end),
          ),
        );
      },
      placeholder: Text(dateRangeLabel),
      trailing: const Icon(LucideIcons.calendarRange),
      builder: (context, value) {
        return Text(
          /// Creates a `_formatCompactDateRangeLabel` instance.
          _formatCompactDateRangeLabel(localizations, value),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      },
      editorBuilder: (context, handler) {
        /// Stores `value` state/configuration for this implementation.
        DateTimeRange? value = handler.value;
        return LayoutBuilder(
          builder: (context, constraints) {
            return DatePickerDialog(
              selectionMode: CalendarSelectionMode.range,
              viewMode: constraints.biggest.width < 500
                  ? CalendarSelectionMode.single
                  : CalendarSelectionMode.range,
              initialViewType: CalendarViewType.date,
              initialValue: value == null
                  ? null
                  : CalendarValue.range(value.start, value.end),
              onChanged: (value) {
                if (value == null) {
                  handler.value = null;
                } else {
                  final range = value.toRange();
                  handler.value = DateTimeRange(range.start, range.end);
                }
              },
            );
          },
        );
      },
    );

    final clearButton = hasDateRange
        ? GhostButton(
            onPressed: () => onStateChanged(state.copyWith(dateRange: null)),
            size: ButtonSize.small,
            child: const Icon(LucideIcons.x),
          )
        : null;

    if (width.isFinite) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: width, child: field),
          if (clearButton != null) clearButton,
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: field),
        if (clearButton != null) clearButton,
      ],
    );
  }

  List<Widget> _buildGroupedInlineContent(BuildContext context) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    final filterMap = <String, FilterCustomFilter>{
      for (final filter in customFilters) filter.id: filter,
    };
    final children = <Widget>[];
    final usedFilterIds = <String>{};
    for (final group in groups) {
      final groupItems = <Widget>[];
      for (final id in group.filterIds) {
        usedFilterIds.add(id);
        final filter = filterMap[id];
        if (filter != null) {
          groupItems.add(filter.builder(context, state, onStateChanged));
        }
      }
      if (group.itemBuilder != null) {
        groupItems.add(group.itemBuilder!(context, state, onStateChanged));
      }
      if (groupItems.isEmpty) {
        continue;
      }
      children.add(
        Container(
          margin: EdgeInsets.only(bottom: 8 * scaling),
          padding: EdgeInsets.all(12 * scaling),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.border),
            borderRadius: theme.borderRadiusMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(group.title, style: theme.typography.medium),
              SizedBox(height: 8 * scaling),
              Wrap(
                spacing: style.spacing,
                runSpacing: style.runSpacing,
                children: groupItems,
              ),
            ],
          ),
        ),
      );
    }
    final ungrouped = customFilters
        .where((filter) => !usedFilterIds.contains(filter.id))
        .map((filter) => filter.builder(context, state, onStateChanged))
        .toList(growable: false);
    if (ungrouped.isNotEmpty) {
      children.add(
        Wrap(
          spacing: style.spacing,
          runSpacing: style.runSpacing,
          children: ungrouped,
        ),
      );
    }
    if (trailingFilters.isNotEmpty) {
      children.add(SizedBox(height: 8 * scaling));
      children.add(
        Wrap(
          spacing: style.spacing,
          runSpacing: style.runSpacing,
          children: trailingFilters,
        ),
      );
    }
    return children;
  }

  bool _shouldUseSheet(double maxWidth) {
    switch (presentation) {
      case FilterBarPresentation.inline:
        return false;
      case FilterBarPresentation.sheet:
        return true;
      case FilterBarPresentation.autoSheet:
        return _useSheetForStagedWidth(maxWidth, sheetBreakpoint);
    }
  }

  Future<void> _openMobileSheet(BuildContext context) async {
    final hasControls =
        sortOptions.isNotEmpty ||
        enableDateRange ||
        customFilters.isNotEmpty ||
        trailingFilters.isNotEmpty ||
        showClearAllWhenEmpty ||
        state.hasActiveFilters;
    if (!hasControls) {
      return;
    }

    await openSheet<void>(
      context: context,
      position: sheetPosition,
      useRootDrawerOverlay: useRootSheetOverlay,
      draggable: true,
      constraints: sheetConstraints,
      builder: (context) {
        return _FilterBarMobileSheet(
          initialState: state,
          presentation: presentation,
          sheetBreakpoint: sheetBreakpoint,
          sortOptions: sortOptions,
          enableDateRange: enableDateRange,
          customFilters: customFilters,
          groups: groups,
          trailingFilters: trailingFilters,
          clearAllLabel: clearAllLabel,
          title: sheetTitle,
          showClearAllWhenEmpty: showClearAllWhenEmpty,
          sheetContentPadding: sheetContentPadding,
          onStateChanged: onStateChanged,
          buildSortControl: (sheetState, onChanged) => _buildSortControl(
            double.infinity,
            state: sheetState,
            onStateChanged: onChanged,
          ),
          buildDateRangeControl: (sheetState, onChanged) =>
              _buildDateRangeControl(
                context,
                state: sheetState,
                onStateChanged: onChanged,
                width: double.infinity,
              ),
          onClearAll: onClearAll,
        );
      },
    );
  }
}

/// _FilterBarMobileSheetBuilder defines a reusable type for this registry module.
typedef _FilterBarMobileSheetBuilder =
    Widget Function(FilterState state, FilterStateChanged onStateChanged);

/// _FilterBarMobileSheet defines a reusable type for this registry module.
class _FilterBarMobileSheet extends StatefulWidget {
  /// Creates a `_FilterBarMobileSheet` instance.
  const _FilterBarMobileSheet({
    required this.initialState,
    required this.presentation,
    required this.sheetBreakpoint,
    required this.sortOptions,
    required this.enableDateRange,
    required this.customFilters,
    required this.groups,
    required this.trailingFilters,
    required this.clearAllLabel,
    required this.title,
    required this.showClearAllWhenEmpty,
    required this.sheetContentPadding,
    required this.onStateChanged,
    required this.buildSortControl,
    required this.buildDateRangeControl,
    required this.onClearAll,
  });

  /// Stores `initialState` state/configuration for this implementation.
  final FilterState initialState;

  /// Stores `presentation` state/configuration for this implementation.
  final FilterBarPresentation presentation;

  /// Stores `sheetBreakpoint` state/configuration for this implementation.
  final double sheetBreakpoint;

  /// Stores `sortOptions` state/configuration for this implementation.
  final List<FilterSortOption> sortOptions;

  /// Stores `enableDateRange` state/configuration for this implementation.
  final bool enableDateRange;

  /// Stores `customFilters` state/configuration for this implementation.
  final List<FilterCustomFilter> customFilters;

  /// Stores `groups` state/configuration for this implementation.
  final List<FilterGroup> groups;

  /// Stores `trailingFilters` state/configuration for this implementation.
  final List<Widget> trailingFilters;

  /// Stores `clearAllLabel` state/configuration for this implementation.
  final String clearAllLabel;

  /// Stores `title` state/configuration for this implementation.
  final String title;

  /// Stores `showClearAllWhenEmpty` state/configuration for this implementation.
  final bool showClearAllWhenEmpty;

  /// Stores `sheetContentPadding` state/configuration for this implementation.
  final EdgeInsetsGeometry? sheetContentPadding;

  /// Stores `onStateChanged` state/configuration for this implementation.
  final FilterStateChanged onStateChanged;

  /// Stores `buildSortControl` state/configuration for this implementation.
  final _FilterBarMobileSheetBuilder buildSortControl;

  /// Stores `buildDateRangeControl` state/configuration for this implementation.
  final _FilterBarMobileSheetBuilder buildDateRangeControl;

  /// Stores `onClearAll` state/configuration for this implementation.
  final VoidCallback onClearAll;

  @override
  /// Executes `createState` behavior for this component/composite.
  State<_FilterBarMobileSheet> createState() => _FilterBarMobileSheetState();
}

/// _FilterBarMobileSheetState defines a reusable type for this registry module.
class _FilterBarMobileSheetState extends State<_FilterBarMobileSheet> {
  /// Stores `_state` state/configuration for this implementation.
  late FilterState _state;
  bool _closeScheduled = false;

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    _state = widget.initialState;
  }

  /// Executes `_updateState` behavior for this component/composite.
  void _updateState(FilterState next) {
    setState(() {
      _state = next;
    });
    widget.onStateChanged(next);
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final shouldCloseForDesktop =
            widget.presentation == FilterBarPresentation.inline ||
            (widget.presentation == FilterBarPresentation.autoSheet &&
                !_useSheetForStagedWidth(width, widget.sheetBreakpoint));
        if (shouldCloseForDesktop) {
          if (!_closeScheduled) {
            _closeScheduled = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) {
                return;
              }
              closeSheet(context);
            });
          }
          return const SizedBox.shrink();
        }
        _closeScheduled = false;
        final showClearAll =
            widget.showClearAllWhenEmpty || _state.hasActiveFilters;
        final customWidgets = widget.customFilters
            .map((filter) => filter.builder(context, _state, _updateState))
            .toList(growable: false);

        return FilterBarSheetScaffold(
          title: widget.title,
          contentPadding: widget.sheetContentPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widget.groups.isEmpty
                ? _buildDefaultMobileContent(customWidgets)
                : _buildGroupedMobileContent(context),
          ),
          footer: showClearAll
              ? GhostButton(
                  onPressed: _state.hasActiveFilters
                      ? () {
                          widget.onClearAll();
                          closeSheet(context);
                        }
                      : null,
                  child: Text(widget.clearAllLabel),
                )
              : null,
        );
      },
    );
  }

  List<Widget> _buildDefaultMobileContent(List<Widget> customWidgets) {
    return [
      if (widget.sortOptions.isNotEmpty)
        widget.buildSortControl(_state, _updateState),
      if (widget.sortOptions.isNotEmpty && widget.enableDateRange)
        const SizedBox(height: 8),
      if (widget.enableDateRange)
        widget.buildDateRangeControl(_state, _updateState),
      if (customWidgets.isNotEmpty) const SizedBox(height: 8),
      ...customWidgets,
      if (widget.trailingFilters.isNotEmpty) const SizedBox(height: 8),
      ...widget.trailingFilters,
    ];
  }

  List<Widget> _buildGroupedMobileContent(BuildContext context) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    final filterMap = <String, FilterCustomFilter>{
      for (final filter in widget.customFilters) filter.id: filter,
    };

    final children = <Widget>[
      if (widget.sortOptions.isNotEmpty)
        widget.buildSortControl(_state, _updateState),
      if (widget.sortOptions.isNotEmpty && widget.enableDateRange)
        const SizedBox(height: 8),
      if (widget.enableDateRange)
        widget.buildDateRangeControl(_state, _updateState),
    ];

    for (final group in widget.groups) {
      final groupItems = <Widget>[];
      for (final id in group.filterIds) {
        final filter = filterMap[id];
        if (filter != null) {
          groupItems.add(filter.builder(context, _state, _updateState));
        }
      }
      if (group.itemBuilder != null) {
        groupItems.add(group.itemBuilder!(context, _state, _updateState));
      }
      if (groupItems.isEmpty) {
        continue;
      }

      children.add(SizedBox(height: 8 * scaling));
      children.add(
        Container(
          padding: EdgeInsets.all(12 * scaling),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.border),
            borderRadius: theme.borderRadiusMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(group.title, style: theme.typography.medium),
              SizedBox(height: 8 * scaling),
              ...groupItems,
            ],
          ),
        ),
      );
    }

    if (widget.trailingFilters.isNotEmpty) {
      children.add(SizedBox(height: 8 * scaling));
      children.addAll(widget.trailingFilters);
    }
    return children;
  }
}

bool _useSheetForStagedWidth(double width, double sheetBreakpoint) {
  if (!width.isFinite || width <= 0) {
    return true;
  }
  final stagedWidth = StageBreakpoint.defaultBreakpoints.getMinWidth(width);
  return stagedWidth <= sheetBreakpoint;
}

DateTimeRange? _toDateTimeRange(FilterDateRange? value) {
  if (value == null || value.start == null || value.end == null) {
    return null;
  }
  return DateTimeRange(value.start!, value.end!);
}
