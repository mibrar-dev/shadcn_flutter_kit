// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../control/button/button.dart';
import '../../display/chip/chip.dart';
import '../../display/calendar/calendar.dart';
import '../../form/date_picker/date_picker.dart';
import '../../form/form_field/form_field.dart';
import '../../form/select/select.dart';
import '../../form/text_field/text_field.dart';
import '../stage_container/stage_container.dart';
import '../../overlay/drawer/drawer.dart';
import '../../../shared/icons/lucide_icons.dart';
import '../../../shared/localizations/shadcn_localizations.dart';
import '../../../shared/theme/theme.dart';
import 'filter_bar_logic.dart';

export 'filter_bar_logic.dart';

part '_impl/core/filter_bar_content.dart';
part '_impl/styles/filter_bar_style.dart';
part '_impl/themes/base/filter_bar_theme.dart';
part '_impl/utils/filter_bar_utils.dart';
part '_impl/variants/filter_bar_layout.dart';

/// FilterBar defines a reusable type for this registry module.
class FilterBar extends StatefulWidget {
  /// Creates a `FilterBar` instance.
  const FilterBar({
    super.key,
    this.state,
    this.onStateChanged,
    this.controller,
    this.sortOptions = const [],
    this.enableDateRange = false,
    this.resultsCount,
    this.searchPlaceholder = 'Search',
    this.searchLabel = 'Search',
    this.searchDebounce,
    this.trailingFilters = const [],
    this.customFilters = const [],
    this.style,
    this.clearPolicy = const FilterClearPolicy(),
    this.onClearAll,
    this.showClearAllWhenEmpty = false,
    this.activeFilterCountLabel,
    this.clearAllLabel = 'Clear all',
    this.sortLabel = 'Sort',
    this.dateRangeLabel = 'Date range',
    this.presentation = FilterBarPresentation.autoSheet,
    this.sheetBreakpoint = 720,
    this.sheetTriggerLabel = 'Filters',
    this.sheetTitle = 'Filters',
    this.sheetPosition = OverlayPosition.bottom,
    this.useRootSheetOverlay = false,
    this.sheetConstraints,
    this.sheetContentPadding,
    this.groups = const [],
  }) : assert(
         controller != null || (state != null && onStateChanged != null),
         'Provide either controller or both state and onStateChanged.',
       );

  /// Stores `state` state/configuration for this implementation.
  final FilterState? state;

  /// Stores `onStateChanged` state/configuration for this implementation.
  final ValueChanged<FilterState>? onStateChanged;

  /// Stores `controller` state/configuration for this implementation.
  final FilterBarController? controller;

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

  /// Stores `searchDebounce` state/configuration for this implementation.
  final Duration? searchDebounce;

  /// Stores `trailingFilters` state/configuration for this implementation.
  final List<Widget> trailingFilters;

  /// Stores `customFilters` state/configuration for this implementation.
  final List<FilterCustomFilter> customFilters;

  /// Stores `style` state/configuration for this implementation.
  final FilterBarStyle? style;

  /// Stores `clearPolicy` state/configuration for this implementation.
  final FilterClearPolicy clearPolicy;

  /// Stores `onClearAll` state/configuration for this implementation.
  final FilterBarClearResolver? onClearAll;

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

  @override
  /// Executes `createState` behavior for this component/composite.
  State<FilterBar> createState() => _FilterBarState();
}

/// _FilterBarState defines a reusable type for this registry module.
class _FilterBarState extends State<FilterBar> {
  /// Stores `_searchController` state/configuration for this implementation.
  late final TextEditingController _searchController;

  /// Stores `_searchDebouncer` state/configuration for this implementation.
  _Debouncer? _searchDebouncer;

  FilterState get _effectiveState => widget.controller?.value ?? widget.state!;

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: _effectiveState.search);
    widget.controller?.addListener(_onControllerChanged);
    _syncDebouncer();
  }

  @override
  /// Executes `didUpdateWidget` behavior for this component/composite.
  void didUpdateWidget(covariant FilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      widget.controller?.addListener(_onControllerChanged);
    }
    if (_searchController.text != _effectiveState.search) {
      _searchController.value = _searchController.value.copyWith(
        text: _effectiveState.search,
        selection: TextSelection.collapsed(
          offset: _effectiveState.search.length,
        ),
      );
    }
    if (oldWidget.searchDebounce != widget.searchDebounce) {
      _syncDebouncer();
    }
  }

  @override
  /// Executes `dispose` behavior for this component/composite.
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    _searchDebouncer?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (!mounted) {
      return;
    }
    final next = _effectiveState;
    if (_searchController.text != next.search) {
      _searchController.value = _searchController.value.copyWith(
        text: next.search,
        selection: TextSelection.collapsed(offset: next.search.length),
      );
    }
    setState(() {});
  }

  /// Executes `_syncDebouncer` behavior for this component/composite.
  void _syncDebouncer() {
    /// Stores `debounce` state/configuration for this implementation.
    final debounce = widget.searchDebounce;
    if (debounce == null || debounce <= Duration.zero) {
      _searchDebouncer?.dispose();
      _searchDebouncer = null;
      return;
    }
    _searchDebouncer ??= _Debouncer(debounce);
    _searchDebouncer!.duration = debounce;
  }

  /// Executes `_emit` behavior for this component/composite.
  void _emit(FilterState next) {
    if (next == _effectiveState) {
      return;
    }
    widget.controller?.setState(next);
    widget.onStateChanged?.call(next);
    if (widget.controller == null) {
      setState(() {});
    }
  }

  /// Executes `_onSearchChanged` behavior for this component/composite.
  void _onSearchChanged(String value) {
    if (_searchDebouncer == null) {
      _emit(_effectiveState.copyWith(search: value));
      return;
    }
    _searchDebouncer!.schedule(() {
      if (!mounted) {
        return;
      }
      _emit(_effectiveState.copyWith(search: value));
    });
  }

  /// Executes `_onSortChanged` behavior for this component/composite.
  void _onSortChanged(String? sortId) {
    _emit(_effectiveState.copyWith(sortId: sortId));
  }

  /// Executes `_onRemoveChip` behavior for this component/composite.
  void _onRemoveChip(FilterChipData chip) {
    _emit(_effectiveState.withoutChip(chip.key));
  }

  /// Executes `_onDateRangeChanged` behavior for this component/composite.
  void _onDateRangeChanged(DateTimeRange? range) {
    /// Creates a `_emit` instance.
    _emit(
      _effectiveState.copyWith(
        dateRange: range == null
            ? null
            : FilterDateRange(start: range.start, end: range.end),
      ),
    );
  }

  /// Executes `_onClearDateRange` behavior for this component/composite.
  void _onClearDateRange() {
    _emit(_effectiveState.copyWith(dateRange: null));
  }

  /// Executes `_onClearAll` behavior for this component/composite.
  void _onClearAll() {
    /// Stores `clearResolver` state/configuration for this implementation.
    final clearResolver = widget.onClearAll;
    final next = clearResolver != null
        ? clearResolver(_effectiveState)
        : _effectiveState.cleared(policy: widget.clearPolicy);
    _emit(next);
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return _FilterBarContent(
      state: _effectiveState,
      searchController: _searchController,
      sortOptions: widget.sortOptions,
      enableDateRange: widget.enableDateRange,
      resultsCount: widget.resultsCount,
      searchPlaceholder: widget.searchPlaceholder,
      searchLabel: widget.searchLabel,
      trailingFilters: widget.trailingFilters,
      customFilters: widget.customFilters,
      style: widget.style ?? const FilterBarStyle(),
      showClearAllWhenEmpty: widget.showClearAllWhenEmpty,
      activeFilterCountLabel: widget.activeFilterCountLabel,
      clearAllLabel: widget.clearAllLabel,
      sortLabel: widget.sortLabel,
      dateRangeLabel: widget.dateRangeLabel,
      presentation: widget.presentation,
      sheetBreakpoint: widget.sheetBreakpoint,
      sheetTriggerLabel: widget.sheetTriggerLabel,
      sheetTitle: widget.sheetTitle,
      sheetPosition: widget.sheetPosition,
      useRootSheetOverlay: widget.useRootSheetOverlay,
      sheetConstraints: widget.sheetConstraints,
      sheetContentPadding: widget.sheetContentPadding,
      groups: widget.groups,
      onSearchChanged: _onSearchChanged,
      onSortChanged: _onSortChanged,
      onRemoveChip: _onRemoveChip,
      onDateRangeChanged: _onDateRangeChanged,
      onClearDateRange: _onClearDateRange,
      onClearAll: _onClearAll,
      onStateChanged: _emit,
    );
  }
}
