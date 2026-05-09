// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../../../shared/theme/theme.dart';
import '../../../../../shared/primitives/text.dart';

/// CommandKeyboardDisplay defines a reusable type for this registry module.
class CommandKeyboardDisplay extends StatelessWidget {
  const CommandKeyboardDisplay({super.key, required this.keys});

  /// Factory constructor that creates `CommandKeyboardDisplay.fromActivator` instances.
  factory CommandKeyboardDisplay.fromActivator({
    required SingleActivator activator,
  }) {
    /// Stores `keys` state/configuration for this implementation.
    final keys = <LogicalKeyboardKey>[];
    if (activator.control) keys.add(LogicalKeyboardKey.control);
    if (activator.shift) keys.add(LogicalKeyboardKey.shift);
    if (activator.alt) keys.add(LogicalKeyboardKey.alt);
    if (activator.meta) keys.add(LogicalKeyboardKey.meta);
    keys.add(activator.trigger);
    return CommandKeyboardDisplay(
      key: ValueKey(keys.map((key) => key.keyId).join('-')),
      keys: keys,
    );
  }

  /// Stores `keys` state/configuration for this implementation.
  final List<LogicalKeyboardKey> keys;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    if (keys.isEmpty) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    return Wrap(
      spacing: theme.density.baseGap * theme.scaling * gapXs,
      children: keys.map((key) {
        final label = key.keyLabel.isNotEmpty
            ? key.keyLabel
            : key.debugName ?? key.toString();
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: theme.density.baseGap * theme.scaling * 0.75,
            vertical: theme.density.baseGap * theme.scaling * 0.25,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.card,
            borderRadius: BorderRadius.circular(theme.radiusSm),
            border: Border.all(color: theme.colorScheme.border, width: 1),
          ),
          child: Text(label).small(),
        );
      }).toList(),
    );
  }
}
