// Gallery preview for the `command` component.

import 'package:flutter/widgets.dart';

import '../../primitives/subfocus_list_item.dart';
import '../../theme/theme.dart';
import 'command.dart';

/// Shows an inline command palette with static results.
class CommandPreview extends StatelessWidget {
  /// Creates the preview.
  const CommandPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Center(
      child: SizedBox(
        width: 320,
        height: 300,
        child: Command(
          debounceDuration: Duration.zero,
          builder: (context, query) async* {
            const List<String> values = <String>[
              'Calendar',
              'Search Emoji',
              'Launch',
              'Profile',
              'Mail',
              'Settings',
            ];
            final List<Widget> items = <Widget>[
              for (final String value in values)
                if (query == null ||
                    value.toLowerCase().contains(query.toLowerCase()))
                  SubFocusListItem(
                    padding: EdgeInsets.symmetric(
                      horizontal: theme.spacing.sm,
                      vertical: theme.spacing.sm,
                    ),
                    title: Text(value),
                    onTap: () {},
                  ),
            ];
            yield items;
          },
        ),
      ),
    );
  }
}
