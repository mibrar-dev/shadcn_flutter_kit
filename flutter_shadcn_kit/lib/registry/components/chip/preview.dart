// Named examples for the `chip` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';
import 'chip.dart';

/// Static chips with and without slot icons.
Widget _chipStatic(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Wrap(
    spacing: spacing.sm,
    runSpacing: spacing.sm,
    children: const <Widget>[
      Chip(child: Text('static')),
      Chip(leading: Icon(LucideIcons.star, size: 12), child: Text('leading')),
      Chip(
        trailing: Icon(LucideIcons.chevronRight, size: 12),
        child: Text('trailing'),
      ),
    ],
  );
}

/// Pressable chip counting its presses.
class _ChipPressableChip extends StatefulWidget {
  const _ChipPressableChip();

  @override
  State<_ChipPressableChip> createState() => _ChipPressableChipState();
}

class _ChipPressableChipState extends State<_ChipPressableChip> {
  int _presses = 0;

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Wrap(
      spacing: spacing.sm,
      runSpacing: spacing.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Chip(
          onPressed: () => setState(() => _presses++),
          child: const Text('pressable'),
        ),
        Text('pressed $_presses'),
      ],
    );
  }
}

/// Chips that remove themselves from the example's own list.
class _ChipRemovableChips extends StatefulWidget {
  const _ChipRemovableChips();

  @override
  State<_ChipRemovableChips> createState() => _ChipRemovableChipsState();
}

class _ChipRemovableChipsState extends State<_ChipRemovableChips> {
  final List<String> _tags = <String>['flutter', 'shadcn', 'widgets'];

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Wrap(
      spacing: spacing.sm,
      runSpacing: spacing.sm,
      children: <Widget>[
        for (final tag in _tags)
          Chip(
            trailing: ChipButton(
              onPressed: () => setState(() => _tags.remove(tag)),
              child: const Icon(LucideIcons.x, size: 12),
            ),
            child: Text(tag),
          ),
        if (_tags.isEmpty) const Chip(child: Text('all removed')),
      ],
    );
  }
}

Widget _chipPressable(BuildContext context) => const _ChipPressableChip();

Widget _chipRemovable(BuildContext context) => const _ChipRemovableChips();

/// Named docs examples for `chip`; the first entry is the default.
const List<ComponentPreview> chipPreviews = <ComponentPreview>[
  ComponentPreview('Static', _chipStatic),
  ComponentPreview('Pressable', _chipPressable),
  ComponentPreview('Removable', _chipRemovable),
];
