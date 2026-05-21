// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../state/command_item_state.dart';

/// A single selectable command entry.
class CommandItem extends StatefulWidget {
  /// Optional leading widget (icon, etc.).
  final Widget? leading;

  /// Primary title for the command.
  final Widget title;

  /// Optional trailing widget (shortcut, badge).
  final Widget? trailing;

  /// Callback when the item is activated.
  final VoidCallback? onTap;

  /// Creates a command item.
  const CommandItem({
    super.key,
    this.leading,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<CommandItem> createState() => CommandItemState();
}
