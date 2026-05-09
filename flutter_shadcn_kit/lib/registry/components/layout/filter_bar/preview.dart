// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../control/button/button.dart';
import '../../form/checkbox/checkbox.dart';
import '../../form/select/select.dart';
import '../../form/text_field/text_field.dart';
import '../../overlay/drawer/drawer.dart';
import '../outlined_container/outlined_container.dart';
import '../scaffold/scaffold.dart' as shadcn_scaffold;
import 'filter_bar.dart';
import '../../../shared/theme/theme.dart';

/// FilterBarPreview defines a reusable type for this registry module.
class FilterBarPreview extends StatelessWidget {
  const FilterBarPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final scaling = Theme.of(context).scaling;

    return shadcn_scaffold.Scaffold(
      headers: const [shadcn_scaffold.AppBar(title: Text('FilterBar Preview'))],
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16 * scaling),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _SimpleExample(),
            SizedBox(height: 12 * scaling),
            const _IntermediateExample(),
            SizedBox(height: 12 * scaling),
            const _AdvancedExample(),
            SizedBox(height: 12 * scaling),
            const _MobileOnlySheetExample(),
          ],
        ),
      ),
    );
  }
}

class _ExampleSection extends StatelessWidget {
  const _ExampleSection({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;

    return OutlinedContainer(
      padding: EdgeInsets.all(12 * scaling),
      child: ClipRect(
        child: DrawerOverlay(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.typography.large),
              SizedBox(height: 6 * scaling),
              Text(description, style: theme.typography.small),
              SizedBox(height: 10 * scaling),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _SimpleExample extends StatefulWidget {
  const _SimpleExample();

  @override
  State<_SimpleExample> createState() => _SimpleExampleState();
}

class _SimpleExampleState extends State<_SimpleExample> {
  FilterState _state = const FilterState(sortId: 'newest');

  static const _sortOptions = [
    FilterSortOption(id: 'newest', label: 'Newest'),
    FilterSortOption(id: 'oldest', label: 'Oldest'),
  ];

  static const _items = [
    'Invoice #1019 - Samantha',
    'Invoice #1018 - Jason',
    'Invoice #1016 - Maria',
    'Invoice #1015 - Alex',
    'Invoice #1014 - Nina',
  ];

  @override
  Widget build(BuildContext context) {
    final query = _state.search.trim().toLowerCase();
    final filtered = _items
        .where((item) => item.toLowerCase().contains(query))
        .toList(growable: false);

    return _ExampleSection(
      title: 'Simple',
      description:
          'Basic search + sort + date range, scoped to this outlined container only.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilterBar(
            state: _state,
            presentation: FilterBarPresentation.inline,
            sortOptions: _sortOptions,
            enableDateRange: true,
            resultsCount: filtered.length,
            onStateChanged: (next) => setState(() => _state = next),
          ),
          const SizedBox(height: 8),
          ...filtered.map((item) => _resultTile(context, item)),
        ],
      ),
    );
  }
}

class _IntermediateExample extends StatefulWidget {
  const _IntermediateExample();

  @override
  State<_IntermediateExample> createState() => _IntermediateExampleState();
}

class _IntermediateExampleState extends State<_IntermediateExample> {
  FilterState _state = const FilterState(sortId: 'priority_desc');

  final _assigneeController = TextEditingController();

  static final _statusField = FilterField<String>(
    id: 'status',
    matcher: FilterMatchers.exact<String>(),
  );

  static final _assigneeField = FilterField<String>(
    id: 'assignee_query',
    defaultMatcherId: 'contains',
    matchers: [
      FilterMatcherOption(
        id: 'contains',
        label: 'Contains',
        matcher: FilterMatchers.contains(),
      ),
      FilterMatcherOption(
        id: 'is',
        label: 'Is',
        matcher: FilterMatchers.exact<String>(),
      ),
      FilterMatcherOption(
        id: 'starts',
        label: 'Starts with',
        matcher: FilterMatchers.startsWith(),
      ),
    ],
  );

  static const _tickets = [
    _Ticket(title: 'Fix mobile overflow', status: 'open', assignee: 'Samantha'),
    _Ticket(
      title: 'Review analytics event map',
      status: 'closed',
      assignee: 'Jason',
    ),
    _Ticket(
      title: 'Implement export endpoint',
      status: 'open',
      assignee: 'Maria',
    ),
    _Ticket(
      title: 'Refactor billing card',
      status: 'in_progress',
      assignee: 'Alex',
    ),
  ];

  @override
  void dispose() {
    _assigneeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible = _state
        .whereMatches(_tickets, [
          TypedFilterBinding<_Ticket, String>(
            field: _statusField,
            selector: (item) => item.status,
          ),
          TypedFilterBinding<_Ticket, String>(
            field: _assigneeField,
            selector: (item) => item.assignee,
          ),
        ])
        .toList(growable: false);

    return _ExampleSection(
      title: 'Intermediate',
      description:
          'Typed filters with multiple matchers. Custom widgets drive filter state.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilterBar(
            state: _state,
            presentation: FilterBarPresentation.inline,
            resultsCount: visible.length,
            sortOptions: const [
              FilterSortOption(id: 'priority_desc', label: 'Priority ↓'),
              FilterSortOption(id: 'priority_asc', label: 'Priority ↑'),
            ],
            customFilters: [
              FilterCustomFilter.typed<String>(
                field: _statusField,
                builder: (context, value, onChanged) {
                  return Select<String>(
                    value: value,
                    canUnselect: true,
                    placeholder: const Text('Status'),
                    itemBuilder: (context, value) => Text(value),
                    popup: SelectPopup<String>(
                      items: SelectItemList(
                        children: const [
                          SelectItemButton<String>(
                            value: 'open',
                            child: Text('Open'),
                          ),
                          SelectItemButton<String>(
                            value: 'in_progress',
                            child: Text('In progress'),
                          ),
                          SelectItemButton<String>(
                            value: 'closed',
                            child: Text('Closed'),
                          ),
                        ],
                      ),
                    ).call,
                    onChanged: onChanged,
                  );
                },
              ),
              FilterCustomFilter(
                id: _assigneeField.id,
                builder: (context, state, onStateChanged) {
                  _assigneeController.value = _assigneeController.value
                      .copyWith(
                        text: state.valueOf(_assigneeField) ?? '',
                        selection: TextSelection.collapsed(
                          offset: (state.valueOf(_assigneeField) ?? '').length,
                        ),
                      );

                  return SizedBox(
                    width: 320,
                    child: Row(
                      children: [
                        Expanded(
                          child: Select<String>(
                            value: state.matcherIdOf(_assigneeField),
                            itemBuilder: (context, value) {
                              final option = _assigneeField.matchers
                                  .where((item) => item.id == value)
                                  .first;
                              return Text(option.label);
                            },
                            popup: SelectPopup<String>(
                              items: SelectItemList(
                                children: _assigneeField.matchers
                                    .map(
                                      (option) => SelectItemButton<String>(
                                        value: option.id,
                                        child: Text(option.label),
                                      ),
                                    )
                                    .toList(growable: false),
                              ),
                            ).call,
                            onChanged: (next) {
                              onStateChanged(
                                state.setMatcherIdOf(_assigneeField, next),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _assigneeController,
                            placeholder: const Text('Assignee'),
                            onChanged: (value) {
                              onStateChanged(
                                state.setValue(
                                  _assigneeField,
                                  value.trim().isEmpty ? null : value,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
            onStateChanged: (next) => setState(() => _state = next),
          ),
          const SizedBox(height: 8),
          ...visible.map((item) => _resultTile(context, item.title)),
        ],
      ),
    );
  }
}

class _AdvancedExample extends StatefulWidget {
  const _AdvancedExample();

  @override
  State<_AdvancedExample> createState() => _AdvancedExampleState();
}

class _AdvancedExampleState extends State<_AdvancedExample> {
  FilterState _state = const FilterState(sortId: 'relevance');

  static final _categoryField = FilterField<String>(
    id: 'category',
    matcher: FilterMatchers.exact<String>(),
  );

  static final _priceBandField = FilterField<String>(
    id: 'price_band',
    matcher: FilterMatchers.exact<String>(),
  );

  static final _retailerField = FilterField<Set<String>>(
    id: 'retailers',
    matcher: FilterMatchers.inSet<String>(),
  );

  static const _catalog = [
    _Product(
      name: 'Nova Keyboard',
      category: 'electronics',
      priceBand: '200-600',
      retailer: 'direct',
    ),
    _Product(
      name: 'CloudDesk Chair',
      category: 'furniture',
      priceBand: '>600',
      retailer: 'marketplace',
    ),
    _Product(
      name: 'Pixel Dock',
      category: 'electronics',
      priceBand: '<200',
      retailer: 'reseller',
    ),
    _Product(
      name: 'Studio Lamp',
      category: 'home',
      priceBand: '<200',
      retailer: 'direct',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final visible = _state
        .whereMatches(_catalog, [
          TypedFilterBinding<_Product, String>(
            field: _categoryField,
            selector: (item) => item.category,
          ),
          TypedFilterBinding<_Product, String>(
            field: _priceBandField,
            selector: (item) => item.priceBand,
          ),
          TypedFilterBinding<_Product, String>(
            field: FilterField<String>(
              id: _retailerField.id,
              matcher: FilterMatcher<String>((selected, candidate) {
                final picked = _state.valueOf(_retailerField) ?? <String>{};
                if (picked.isEmpty) {
                  return true;
                }
                return candidate is String && picked.contains(candidate);
              }),
            ),
            selector: (item) => item.retailer,
          ),
        ])
        .toList(growable: false);

    return _ExampleSection(
      title: 'Advanced',
      description:
          'Grouped filters with custom widgets (select + segmented + multi-checkbox).',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilterBar(
            state: _state,
            presentation: FilterBarPresentation.inline,
            sheetTitle: 'Product filters',
            sheetTriggerLabel: 'Filters',
            groups: const [
              FilterGroup(
                id: 'catalog',
                title: 'Catalog',
                filterIds: ['category', 'price_band'],
              ),
              FilterGroup(
                id: 'retailers',
                title: 'Retailers',
                filterIds: ['retailers'],
              ),
            ],
            customFilters: [
              FilterCustomFilter.typed<String>(
                field: _categoryField,
                builder: (context, value, onChanged) {
                  return Select<String>(
                    value: value,
                    canUnselect: true,
                    placeholder: const Text('Category'),
                    itemBuilder: (context, value) => Text(value),
                    popup: SelectPopup<String>(
                      items: SelectItemList(
                        children: const [
                          SelectItemButton<String>(
                            value: 'electronics',
                            child: Text('Electronics'),
                          ),
                          SelectItemButton<String>(
                            value: 'furniture',
                            child: Text('Furniture'),
                          ),
                          SelectItemButton<String>(
                            value: 'home',
                            child: Text('Home'),
                          ),
                        ],
                      ),
                    ).call,
                    onChanged: onChanged,
                  );
                },
              ),
              FilterCustomFilter.typed<String>(
                field: _priceBandField,
                builder: (context, value, onChanged) {
                  return Select<String>(
                    value: value,
                    canUnselect: true,
                    placeholder: const Text('Price'),
                    itemBuilder: (context, value) => Text(value),
                    popup: SelectPopup<String>(
                      items: SelectItemList(
                        children: const [
                          SelectItemButton<String>(
                            value: '<200',
                            child: Text('< 200'),
                          ),
                          SelectItemButton<String>(
                            value: '200-600',
                            child: Text('200-600'),
                          ),
                          SelectItemButton<String>(
                            value: '>600',
                            child: Text('> 600'),
                          ),
                        ],
                      ),
                    ).call,
                    onChanged: onChanged,
                  );
                },
              ),
              FilterCustomFilter(
                id: _retailerField.id,
                builder: (context, state, onStateChanged) {
                  final selected = state.valueOf(_retailerField) ?? <String>{};

                  Widget checkboxTile(String id, String label) {
                    final checked = selected.contains(id);
                    return GhostButton(
                      alignment: Alignment.centerLeft,
                      onPressed: () {
                        final next = <String>{...selected};
                        if (next.contains(id)) {
                          next.remove(id);
                        } else {
                          next.add(id);
                        }
                        onStateChanged(
                          state.setValue(
                            _retailerField,
                            next.isEmpty ? null : next,
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            state: checked
                                ? CheckboxState.checked
                                : CheckboxState.unchecked,
                            onChanged: (_) {},
                          ),
                          const SizedBox(width: 6),
                          Text(label),
                        ],
                      ),
                    );
                  }

                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      checkboxTile('direct', 'Direct'),
                      checkboxTile('marketplace', 'Marketplace'),
                      checkboxTile('reseller', 'Reseller'),
                    ],
                  );
                },
              ),
            ],
            trailingFilters: [
              PrimaryButton(
                onPressed: () {},
                child: Text('Show ${visible.length}'),
              ),
            ],
            resultsCount: visible.length,
            onStateChanged: (next) => setState(() => _state = next),
          ),
          const SizedBox(height: 8),
          ...visible.map((item) => _resultTile(context, item.name)),
        ],
      ),
    );
  }
}

class _MobileOnlySheetExample extends StatefulWidget {
  const _MobileOnlySheetExample();

  @override
  State<_MobileOnlySheetExample> createState() =>
      _MobileOnlySheetExampleState();
}

class _MobileOnlySheetExampleState extends State<_MobileOnlySheetExample> {
  FilterState _state = const FilterState();

  @override
  Widget build(BuildContext context) {
    return _ExampleSection(
      title: 'Mobile-only Sheet (Scoped)',
      description:
          'Forces sheet mode with a bottom sheet scoped to this outlined container.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final maxHeight = constraints.maxHeight;
              return FilterBar(
                state: _state,
                presentation: FilterBarPresentation.sheet,
                useRootSheetOverlay: false,
                sheetTitle: 'Mobile Filters',
                sheetTriggerLabel: 'Open Filters',
                sheetPosition: OverlayPosition.bottom,
                sheetConstraints: BoxConstraints(
                  maxWidth: constraints.maxWidth,
                  maxHeight: maxHeight > 300 ? 300 : maxHeight,
                ),
                sheetContentPadding: const EdgeInsets.all(12),
                sortOptions: const [
                  FilterSortOption(id: 'newest', label: 'Newest'),
                  FilterSortOption(id: 'oldest', label: 'Oldest'),
                ],
                enableDateRange: true,
                customFilters: [
                  FilterCustomFilter(
                    id: 'quick_status',
                    builder: (context, state, onStateChanged) {
                      final status = state.customValue<String>('quick_status');
                      return Select<String>(
                        value: status,
                        canUnselect: true,
                        placeholder: const Text('Quick status'),
                        itemBuilder: (context, value) => Text(value),
                        popup: SelectPopup<String>(
                          items: SelectItemList(
                            children: const [
                              SelectItemButton<String>(
                                value: 'open',
                                child: Text('Open'),
                              ),
                              SelectItemButton<String>(
                                value: 'closed',
                                child: Text('Closed'),
                              ),
                            ],
                          ),
                        ).call,
                        onChanged: (next) {
                          onStateChanged(
                            state.setCustomValue('quick_status', next),
                          );
                        },
                      );
                    },
                  ),
                ],
                onStateChanged: (next) => setState(() => _state = next),
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget _resultTile(BuildContext context, String text) {
  final theme = Theme.of(context);
  return Container(
    margin: const EdgeInsets.only(bottom: 6),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      border: Border.all(color: theme.colorScheme.border),
      borderRadius: theme.borderRadiusMd,
    ),
    child: Text(text),
  );
}

class _Ticket {
  final String title;
  final String status;
  final String assignee;

  const _Ticket({
    required this.title,
    required this.status,
    required this.assignee,
  });
}

class _Product {
  final String name;
  final String category;
  final String priceBand;
  final String retailer;

  const _Product({
    required this.name,
    required this.category,
    required this.priceBand,
    required this.retailer,
  });
}
