// Named examples for the `command` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../primitives/subfocus_list_item.dart';
import '../../theme/theme.dart';
import 'command.dart';

/// Fruit list the palette filters over.
const List<String> _commandValues = <String>[
  'Calendar',
  'Search Emoji',
  'Launch',
  'Profile',
  'Mail',
  'Settings',
];

/// The palette itself, sized to the stage.
class _CommandPalette extends StatelessWidget {
  const _CommandPalette({this.buildGroups = false});

  final bool buildGroups;

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Center(
      child: SizedBox(
        width: 320,
        height: 300,
        child: Command(
          debounceDuration: Duration.zero,
          builder: (context, query) async* {
            final List<Widget> items = <Widget>[];
            if (!buildGroups) {
              for (final String value in _commandValues) {
                if (query == null ||
                    value.toLowerCase().contains(query.toLowerCase())) {
                  items.add(SubFocusListItem(title: Text(value), onTap: () {}));
                }
              }
            } else {
              for (final String group in const <String>[
                'Suggestions',
                'Settings',
              ]) {
                items.add(
                  // shadcn group heading: `px-2 py-1.5 text-xs font-medium`
                  // in the muted colour.
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: Text(
                      group,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: ShadcnTheme.of(context).colors.mutedForeground,
                      ),
                    ),
                  ),
                );
                for (final String value in _commandValues) {
                  if (query == null ||
                      value.toLowerCase().contains(query.toLowerCase())) {
                    items.add(
                      SubFocusListItem(title: Text(value), onTap: () {}),
                    );
                  }
                }
                items.add(SizedBox(height: spacing.sm));
              }
            }
            yield items;
          },
        ),
      ),
    );
  }
}

/// The default palette.
Widget _commandDefault(BuildContext context) => const _CommandPalette();

/// The palette with grouped results.
Widget _commandWithGroups(BuildContext context) =>
    const _CommandPalette(buildGroups: true);

/// Named docs examples for `command`; the first entry is the default.
const List<ComponentPreview> commandPreviews = <ComponentPreview>[
  ComponentPreview('Default', _commandDefault),
  ComponentPreview('With groups', _commandWithGroups),
];
