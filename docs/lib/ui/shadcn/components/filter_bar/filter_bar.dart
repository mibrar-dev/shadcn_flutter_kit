// The `filter_bar` component: search + sort + date + custom filters, chips,
// a clear action and an optional mobile sheet.
//
// Widgets-only. The value engine lives in `primitives/filter_core/`, the
// theme, descriptors, sheet chrome and control sub-widgets in
// `filter_bar_style.dart`; chips come from `chip` and the sheet route from
// `drawer`.
//
// Old bugs fixed, not ported: the search debounce could resurrect cleared
// text; the sheet went stale while open (it listens to a state mirror); the
// staged `sheetBreakpoint` comparison (720 behaved like 768) is a raw compare;
// a half-null date range maps to a one-day span; `controller` + `state` is an
// assert; labels come from `primitives/localizations`.

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/filter_core/filter_controller.dart';
import '../../primitives/filter_core/filter_group.dart';
import '../../primitives/filter_core/filter_state.dart';
import '../../primitives/localizations/localizations.dart';
import '../../theme/theme.dart';
import '../chip/chip.dart';
import '../drawer/drawer.dart';
import 'filter_bar_style.dart';

export 'filter_bar_style.dart';
export '../../primitives/filter_core/filter_controller.dart'
    show
        FilterBarController,
        FilterClearPolicy,
        FilterStateExtensions,
        TypedFilterBinding;
export '../../primitives/filter_core/filter_matching.dart'
    show
        FilterBinding,
        FilterField,
        FilterMatcher,
        FilterMatcherOption,
        FilterMatchers;
export '../../primitives/filter_core/filter_state.dart'
    show FilterChipData, FilterDateRange, FilterSortOption, FilterState;

/// A controlled filter bar: search, sort, date range, custom filters, chips
/// and an optional sheet presentation (`FilterBar(state: ..., ...)`).
class FilterBar extends StatefulWidget {
  /// Creates a filter bar; provide a [controller] or [state]+[onStateChanged].
  const FilterBar({
    super.key,
    this.state,
    this.onStateChanged,
    this.controller,
    this.sortOptions = const <FilterSortOption>[],
    this.enableDateRange = false,
    this.resultsCount,
    this.searchDebounce,
    this.trailingFilters = const <Widget>[],
    this.customFilters = const <FilterCustomFilter>[],
    this.clearPolicy = const FilterClearPolicy(),
    this.onClearAll,
    this.showClearAllWhenEmpty = false,
    this.presentation = FilterBarPresentation.autoSheet,
    this.sheetBreakpoint = 720,
    this.sheetPosition = OverlayPosition.bottom,
    this.useRootNavigator = true,
    this.sheetContentPadding,
    this.groups = const <FilterGroup>[],
    this.theme,
  }) : assert(
         controller != null || (state != null && onStateChanged != null),
         'Provide either controller or both state and onStateChanged.',
       ),
       assert(
         controller == null || (state == null && onStateChanged == null),
         'controller and state/onStateChanged are mutually exclusive.',
       );

  final FilterState? state;
  final ValueChanged<FilterState>? onStateChanged;
  final FilterBarController? controller;
  final List<FilterSortOption> sortOptions;
  final bool enableDateRange;
  final int? resultsCount;
  final Duration? searchDebounce;
  final List<Widget> trailingFilters;
  final List<FilterCustomFilter> customFilters;
  final FilterClearPolicy clearPolicy;
  final FilterBarClearResolver? onClearAll;
  final bool showClearAllWhenEmpty;
  final FilterBarPresentation presentation;
  final double sheetBreakpoint;
  final OverlayPosition sheetPosition;
  final bool useRootNavigator;
  final EdgeInsetsGeometry? sheetContentPadding;
  final List<FilterGroup> groups;
  final FilterBarTheme? theme;

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  late final TextEditingController _search = TextEditingController(
    text: _current.search,
  );
  final ValueNotifier<FilterState> _mirror = ValueNotifier<FilterState>(
    const FilterState(),
  );
  Timer? _debounce;
  String _emittedSearch = '';
  FilterBarController? _attached;

  FilterState get _current =>
      widget.controller?.value ?? widget.state ?? const FilterState();

  FilterBarTheme _style(BuildContext context) =>
      resolveComponentStyle<FilterBarTheme, FilterBarTheme>(
        context,
        widget: widget.theme,
        select: (t) => t,
        defaults: filterBarDefaults,
      );

  @override
  void initState() {
    super.initState();
    _attached = widget.controller;
    _attached?.addListener(_onControllerChanged);
    _emittedSearch = _current.search;
    _mirror.value = _current;
  }

  @override
  void didUpdateWidget(covariant FilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _attached?.removeListener(_onControllerChanged);
      _attached = widget.controller;
      _attached?.addListener(_onControllerChanged);
    }
    if (widget.searchDebounce != oldWidget.searchDebounce) {
      _debounce?.cancel();
    }
    _syncSearch();
    _mirror.value = _current;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _attached?.removeListener(_onControllerChanged);
    _search.dispose();
    _mirror.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    _syncSearch();
    _mirror.value = _current;
    if (mounted) {
      setState(() {});
    }
  }

  void _syncSearch() {
    final String next = _current.search;
    if (next != _emittedSearch) {
      _emittedSearch = next;
      _search.text = next;
    }
  }

  void _emit(FilterState next) {
    if (next == _current) return;
    _mirror.value = next;
    widget.controller?.setValue(next);
    widget.onStateChanged?.call(next);
    if (widget.controller == null) setState(() {});
  }

  void _onSearchChanged(String value) {
    // Cancel first: the old code let a pending timer fire after "clear all".
    _debounce?.cancel();
    _emittedSearch = value;
    void emit() => _emit(_current.copyWith(search: value));
    final Duration? delay = widget.searchDebounce;
    if (delay == null || delay == Duration.zero) {
      emit();
    } else {
      _debounce = Timer(delay, () {
        if (mounted) emit();
      });
    }
  }

  void _clearAll() {
    _debounce?.cancel();
    final FilterState next =
        widget.onClearAll?.call(_current) ??
        _current.cleared(policy: widget.clearPolicy);
    _emittedSearch = next.search;
    if (_search.text != next.search) {
      _search.text = next.search;
    }
    _emit(next);
  }

  bool _hasSheetContent(FilterState current) =>
      widget.sortOptions.isNotEmpty ||
      widget.enableDateRange ||
      widget.customFilters.isNotEmpty ||
      widget.trailingFilters.isNotEmpty ||
      current.chips.isNotEmpty;

  bool _useSheet(double width) => switch (widget.presentation) {
    FilterBarPresentation.inline => false,
    FilterBarPresentation.sheet => true,
    FilterBarPresentation.autoSheet =>
      width.isFinite && width < widget.sheetBreakpoint,
  };

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final FilterBarTheme style = _style(context);
    final ShadcnLocalizations l10n = ShadcnLocalizations.of(context);
    final FilterState current = _current;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool sheet = _useSheet(constraints.maxWidth);
        final Widget body = sheet
            ? Wrap(
                spacing: style.spacing ?? 12,
                runSpacing: style.runSpacing ?? 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  FilterBarSearchField(
                    controller: _search,
                    onChanged: _onSearchChanged,
                    width: style.searchWidth ?? 220,
                  ),
                  // No dead trigger: render it only when the sheet has content.
                  if (_hasSheetContent(current))
                    FilterBarSheetTrigger(
                      activeCount: current.activeFilterCount,
                      onPressed: () => _openSheet(context),
                      dense: style.dense ?? false,
                    ),
                ],
              )
            : _content(context, current, style, l10n, inSheet: false);
        return DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: ambient.colors.border),
            borderRadius: ambient.borderRadiusMd,
          ),
          child: Padding(
            padding: EdgeInsets.all((style.dense ?? false) ? 8 : 12),
            child: body,
          ),
        );
      },
    );
  }

  Widget _content(
    BuildContext context,
    FilterState current,
    FilterBarTheme style,
    ShadcnLocalizations l10n, {
    required bool inSheet,
  }) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final String? sortValue =
        widget.sortOptions.any(
          (FilterSortOption option) => option.id == current.sortId,
        )
        ? current.sortId
        : null;
    final TextStyle muted = ambient.typography.textMuted.copyWith(
      color: ambient.colors.mutedForeground,
    );
    final List<Widget> others = <Widget>[
      if (widget.sortOptions.isNotEmpty)
        FilterBarSortControl(
          value: sortValue,
          options: widget.sortOptions,
          onChanged: (String? next) => _emit(current.copyWith(sortId: next)),
          width: style.controlWidth ?? 180,
        ),
      if (widget.enableDateRange)
        FilterBarDateControl(
          value: current.dateRange,
          onChanged: (FilterDateRange? next) =>
              _emit(current.copyWith(dateRange: next)),
          width: style.controlWidth ?? 180,
        ),
      ...widget.trailingFilters,
    ];
    final Widget controls = FilterBarGroupedContent(
      state: current,
      onChanged: _emit,
      groups: widget.groups,
      customFilters: widget.customFilters,
      trailing: others,
      spacing: style.spacing ?? 12,
      runSpacing: style.runSpacing ?? 8,
    );
    final List<Widget> slots = <Widget>[
      if (!inSheet)
        FilterBarSearchField(
          controller: _search,
          onChanged: _onSearchChanged,
          width: style.searchWidth ?? 220,
        ),
      if (widget.groups.isEmpty)
        controls
      else
        SizedBox(width: double.infinity, child: controls),
    ];
    final String? counter = _counterText(current, l10n);
    if (counter != null) {
      slots.add(Text(counter, style: muted));
    }
    if (widget.showClearAllWhenEmpty || current.hasActiveFilters) {
      slots.add(
        FilterBarClearButton(
          enabled: current.hasActiveFilters,
          onPressed: _clearAll,
          dense: style.dense ?? false,
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: style.spacing ?? 12,
          runSpacing: style.runSpacing ?? 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: slots,
        ),
        if (current.chips.isNotEmpty) ...<Widget>[
          Gap(style.runSpacing ?? 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              for (final FilterChipData chip in current.chips)
                Chip(
                  trailing: ChipButton(
                    onPressed: () => _emit(current.withoutChip(chip.key)),
                    child: const Icon(LucideIcons.x),
                  ),
                  child: Text(chip.label),
                ),
            ],
          ),
        ],
      ],
    );
  }

  String? _counterText(FilterState current, ShadcnLocalizations l10n) {
    if (widget.resultsCount != null) {
      return l10n.filterResultsCount(widget.resultsCount!);
    }
    final int count = current.activeFilterCount;
    return count == 0 ? null : l10n.filterActiveCount(count);
  }

  Future<void> _openSheet(BuildContext context) {
    final FilterBarTheme style = _style(context);
    return openSheet<void>(
      context: context,
      position: widget.sheetPosition,
      useRootNavigator: widget.useRootNavigator,
      builder: (BuildContext sheetContext) {
        final ShadcnLocalizations l10n = ShadcnLocalizations.of(sheetContext);
        return FilterBarSheetScaffold(
          title: l10n.filterFilters,
          contentPadding: widget.sheetContentPadding,
          onClose: () => closeSheet(sheetContext),
          child: ValueListenableBuilder<FilterState>(
            valueListenable: _mirror,
            builder: (BuildContext context, FilterState current, _) =>
                _content(context, current, style, l10n, inSheet: true),
          ),
        );
      },
    );
  }
}
