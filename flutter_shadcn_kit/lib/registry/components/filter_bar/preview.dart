// Gallery preview for the `filter_bar` component: inline, rich (date +
// custom filter + trailing) and auto-sheet variants plus a dark palette.
// Widgets-only.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import '../select/select.dart';
import 'filter_bar.dart';

/// Renders the filter-bar gallery.
class FilterBarPreview extends StatefulWidget {
  /// Creates the preview.
  const FilterBarPreview({super.key});

  @override
  State<FilterBarPreview> createState() => _FilterBarPreviewState();
}

class _FilterBarPreviewState extends State<FilterBarPreview> {
  static const List<FilterSortOption> _sortOptions = <FilterSortOption>[
    FilterSortOption(id: 'newest', label: 'Newest'),
    FilterSortOption(id: 'oldest', label: 'Oldest'),
  ];
  static final FilterField<String> _statusField = FilterField<String>(
    id: 'status',
    matcher: FilterMatchers.exact(),
  );
  static final FilterField<String> _tagField = FilterField<String>(
    id: 'tag',
    matcher: FilterMatchers.exact(),
  );

  FilterState _state = const FilterState(
    sortId: 'newest',
    chips: <FilterChipData>[FilterChipData(key: 'tag:vip', label: 'Tag: VIP')],
  );

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ColoredBox(
      color: theme.colors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _label(theme, 'Inline with sort and chips'),
            SizedBox(
              width: 720,
              child: FilterBar(
                state: _state,
                sortOptions: _sortOptions,
                resultsCount: 42,
                presentation: FilterBarPresentation.inline,
                onStateChanged: (next) => setState(() => _state = next),
              ),
            ),
            Gap(theme.spacing.xl),
            _label(theme, 'Rich: date range, custom filter, trailing action'),
            SizedBox(
              width: 900,
              child: FilterBar(
                state: _state,
                sortOptions: _sortOptions,
                enableDateRange: true,
                searchDebounce: const Duration(milliseconds: 250),
                presentation: FilterBarPresentation.inline,
                customFilters: <FilterCustomFilter>[
                  FilterCustomFilter.typed<String>(
                    field: _statusField,
                    builder: (context, value, onChanged) => SizedBox(
                      width: 160,
                      child: Select<String>(
                        value: value,
                        canUnselect: true,
                        placeholder: const Text('Status'),
                        onChanged: onChanged,
                        itemBuilder: (context, value) => Text(value),
                        items: const <Widget>[
                          SelectItem<String>(
                            value: 'open',
                            child: Text('Open'),
                          ),
                          SelectItem<String>(
                            value: 'closed',
                            child: Text('Closed'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                trailingFilters: <Widget>[
                  Button(
                    variant: ButtonVariant.outline,
                    onPressed: () {},
                    child: const Text('Export'),
                  ),
                ],
                onStateChanged: (next) => setState(() => _state = next),
              ),
            ),
            Gap(theme.spacing.xl),
            _label(theme, 'Grouped custom filters'),
            SizedBox(
              width: 720,
              child: FilterBar(
                state: _state,
                presentation: FilterBarPresentation.inline,
                customFilters: <FilterCustomFilter>[
                  FilterCustomFilter.typed<String>(
                    field: _statusField,
                    builder: (context, value, onChanged) => Button(
                      variant: ButtonVariant.outline,
                      onPressed: () =>
                          onChanged(value == 'open' ? null : 'open'),
                      child: Text(value == 'open' ? 'Open' : 'Status'),
                    ),
                  ),
                  FilterCustomFilter.typed<String>(
                    field: _tagField,
                    builder: (context, value, onChanged) => Button(
                      variant: ButtonVariant.outline,
                      onPressed: () => onChanged(value == 'vip' ? null : 'vip'),
                      child: Text(value == 'vip' ? 'VIP' : 'Tag'),
                    ),
                  ),
                ],
                groups: const <FilterGroup>[
                  FilterGroup(
                    id: 'catalog',
                    title: 'Catalog',
                    filterIds: <String>['status'],
                  ),
                  FilterGroup(
                    id: 'labels',
                    title: 'Labels',
                    filterIds: <String>['tag'],
                  ),
                ],
                onStateChanged: (next) => setState(() => _state = next),
              ),
            ),
            Gap(theme.spacing.xl),
            _label(theme, 'Auto sheet below 720px'),
            SizedBox(
              width: 420,
              child: FilterBar(
                state: _state,
                sortOptions: _sortOptions,
                enableDateRange: true,
                onStateChanged: (next) => setState(() => _state = next),
              ),
            ),
            Gap(theme.spacing.xl),
            _label(theme, 'Dark palette'),
            ShadcnTheme(
              data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
              child: SizedBox(
                width: 720,
                child: FilterBar(
                  state: _state,
                  sortOptions: _sortOptions,
                  presentation: FilterBarPresentation.inline,
                  onStateChanged: (next) => setState(() => _state = next),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(ShadcnThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: theme.colors.foreground,
        ),
      ),
    );
  }
}
