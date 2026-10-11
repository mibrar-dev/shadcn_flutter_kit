// Named examples for the `sortable` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle. Each example owns its item order in its own state.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';
import 'sortable.dart';

/// One draggable row in theme tokens.
class _Row extends StatelessWidget {
  const _Row({required this.item, this.candidate = false});

  final String item;
  final bool candidate;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: candidate ? theme.colors.accent : theme.colors.card,
        border: Border.all(color: theme.colors.border),
        borderRadius: theme.borderRadiusMd,
      ),
      child: Row(
        children: <Widget>[
          SortableDragHandle(
            child: Icon(
              LucideIcons.gripVertical,
              size: 14,
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(theme.spacing.md),
          Expanded(child: Text(item)),
        ],
      ),
    );
  }
}

/// A reorderable vertical list.
class _ListDemo extends StatefulWidget {
  const _ListDemo();

  @override
  State<_ListDemo> createState() => _ListDemoState();
}

class _ListDemoState extends State<_ListDemo> {
  final List<String> _items = <String>['Alpha', 'Beta', 'Gamma', 'Delta'];

  void _move(String dragged, String target, bool above) {
    setState(() {
      _items.remove(dragged);
      final int index = _items.indexOf(target);
      _items.insert(above ? index : index + 1, dragged);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: SortableLayer(
        lock: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (final String item in _items)
              Sortable<String>(
                key: ValueKey<String>(item),
                data: SortableData<String>(item),
                onAcceptTop: (SortableData<String> data) =>
                    _move(data.data, item, true),
                onAcceptBottom: (SortableData<String> data) =>
                    _move(data.data, item, false),
                candidateFallback: _Row(item: item, candidate: true),
                fallback: Opacity(opacity: 0.3, child: _Row(item: item)),
                child: _Row(item: item),
              ),
          ],
        ),
      ),
    );
  }
}

/// One draggable tile in theme tokens.
class _Tile extends StatelessWidget {
  const _Tile({required this.item, this.candidate = false});

  final String item;
  final bool candidate;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Container(
      width: 104,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: candidate ? theme.colors.accent : theme.colors.card,
        border: Border.all(color: theme.colors.border),
        borderRadius: theme.borderRadiusMd,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SortableDragHandle(
            child: Icon(
              LucideIcons.gripVertical,
              size: 14,
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(theme.spacing.sm),
          Expanded(child: Text(item)),
        ],
      ),
    );
  }
}

/// The same items as a wrapping grid of tiles.
class _GridDemo extends StatefulWidget {
  const _GridDemo();

  @override
  State<_GridDemo> createState() => _GridDemoState();
}

class _GridDemoState extends State<_GridDemo> {
  final List<String> _items = <String>[
    'Alpha',
    'Beta',
    'Gamma',
    'Delta',
    'Epsilon',
    'Zeta',
  ];

  void _move(String dragged, String target, bool above) {
    setState(() {
      _items.remove(dragged);
      final int index = _items.indexOf(target);
      _items.insert(above ? index : index + 1, dragged);
    });
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return SizedBox(
      width: 340,
      child: SortableLayer(
        lock: true,
        child: Wrap(
          spacing: spacing.sm,
          runSpacing: spacing.sm,
          children: <Widget>[
            for (final String item in _items)
              Sortable<String>(
                key: ValueKey<String>(item),
                data: SortableData<String>(item),
                onAcceptTop: (SortableData<String> data) =>
                    _move(data.data, item, true),
                onAcceptBottom: (SortableData<String> data) =>
                    _move(data.data, item, false),
                candidateFallback: _Tile(item: item, candidate: true),
                fallback: Opacity(opacity: 0.3, child: _Tile(item: item)),
                child: _Tile(item: item),
              ),
          ],
        ),
      ),
    );
  }
}

Widget _default(BuildContext context) => const _ListDemo();

Widget _grid(BuildContext context) => const _GridDemo();

/// Named docs examples for `sortable`; the first entry is the default.
const List<ComponentPreview> sortablePreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Grid', _grid),
];
