// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../command/command.dart';

/// CommandPreview defines a reusable type for this registry module.
class CommandPreview extends StatelessWidget {
  const CommandPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Command(
          builder: (context, query) async* {
            final items = <String, List<String>>{
              'Suggestions': ['Calendar', 'Search Emoji', 'Launch'],
              'Settings': ['Profile', 'Mail', 'Settings'],
            };
            final icons = <String, Widget>{
              'Calendar': const Icon(Icons.calendar_today),
              'Search Emoji': const Icon(Icons.emoji_emotions_outlined),
              'Launch': const Icon(Icons.rocket_launch_outlined),
              'Profile': const Icon(Icons.person_outline),
              'Mail': const Icon(Icons.mail_outline),
              'Settings': const Icon(Icons.settings_outlined),
            };
            for (final values in items.entries) {
              /// Stores `resultItems` state/configuration for this implementation.
              final resultItems = <Widget>[];
              for (final item in values.value) {
                if (query == null ||
                    /// Creates a `item.toLowerCase` instance.
                    item.toLowerCase().contains(query.toLowerCase())) {
                  /// Creates a `resultItems.add` instance.
                  resultItems.add(
                    /// Creates a `CommandItem` instance.
                    CommandItem(
                      title: Text(item),
                      leading: icons[item],
                      onTap: () {},
                    ),
                  );
                }
              }
              if (resultItems.isNotEmpty) {
                yield [
                  /// Creates a `CommandCategory` instance.
                  CommandCategory(
                    title: Text(values.key),
                    children: resultItems,
                  ),
                ];
              }
            }
          },
        ),
      ),
    );
  }
}
