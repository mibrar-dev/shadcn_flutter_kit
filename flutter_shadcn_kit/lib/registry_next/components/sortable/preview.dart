// Gallery preview for the `sortable` component: a reorderable list with a
// drag handle, ghost and candidate fallback. Widgets-only.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import 'sortable.dart';

/// Renders the sortable gallery.
class SortablePreview extends StatelessWidget {
  /// Creates the preview.
  const SortablePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 14),
        child: ColoredBox(
          color: theme.colors.background,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(width: 280, child: const _SortableDemo()),
          ),
        ),
      ),
    );
  }
}

class _SortableDemo extends StatefulWidget {
  const _SortableDemo();

  @override
  State<_SortableDemo> createState() => _SortableDemoState();
}

class _SortableDemoState extends State<_SortableDemo> {
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
    return SortableLayer(
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
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.item, this.candidate = false});

  final String item;
  final bool candidate;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
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
            child: Text(
              '::',
              style: TextStyle(
                fontSize: 14,
                color: theme.colors.mutedForeground,
              ),
            ),
          ),
          const Gap(12),
          Expanded(child: Text(item)),
        ],
      ),
    );
  }
}
