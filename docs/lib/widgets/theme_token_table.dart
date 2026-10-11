// The global theme token table for `/docs/theming` (spec §2.6): one row per
// token, generated from the registry theme layer (`kThemeTokens`), with the
// prose "what it controls" column kept docs-side. A test asserts every
// generated token has a description, so a new registry token fails loudly.

import 'package:flutter/widgets.dart';

import '../generated/docs_data.dart';
import 'typeset_tables.dart';

/// What each generated token controls (docs-side prose).
const Map<String, String> kThemeTokenDescriptions = <String, String>{
  'background': 'The default app background.',
  'foreground': 'Default text and icon colour.',
  'card': 'Elevated surfaces.',
  'cardForeground': 'Content on card surfaces.',
  'popover': 'Floating surfaces.',
  'popoverForeground': 'Content on floating surfaces.',
  'primary': 'High-emphasis actions and brand surfaces.',
  'primaryForeground': 'Content on primary surfaces.',
  'secondary': 'Lower-emphasis filled actions.',
  'secondaryForeground': 'Content on secondary surfaces.',
  'muted': 'Subtle surfaces.',
  'mutedForeground': 'Lower-emphasis content.',
  'accent': 'Interactive hover, focus and active surfaces.',
  'accentForeground': 'Content on accent surfaces.',
  'destructive': 'Destructive actions and errors.',
  'destructiveForeground': 'Content on destructive surfaces.',
  'border': 'Default borders and separators.',
  'input': 'Form control borders and backgrounds.',
  'ring': 'Focus rings and outlines.',
  'chart1': 'Chart palette series 1.',
  'chart2': 'Chart palette series 2.',
  'chart3': 'Chart palette series 3.',
  'chart4': 'Chart palette series 4.',
  'chart5': 'Chart palette series 5.',
  'sidebar': 'Sidebar surface.',
  'sidebarForeground': 'Default sidebar text.',
  'sidebarPrimary': 'High-emphasis actions inside the sidebar.',
  'sidebarPrimaryForeground': 'Content on sidebar primary.',
  'sidebarAccent': 'Sidebar hover and selected surfaces.',
  'sidebarAccentForeground': 'Content on sidebar accent.',
  'sidebarBorder': 'Sidebar borders and separators.',
  'sidebarRing': 'Focus rings inside the sidebar.',
  'radius': 'Base corner-radius factor; the sm/md/lg/xl steps derive from it.',
};

/// The typeset token table (Token | CSS variable | What it controls).
class ThemeTokenTable extends StatelessWidget {
  /// Creates the token table.
  const ThemeTokenTable({super.key});

  @override
  Widget build(BuildContext context) {
    return TypesetTable(
      headers: const <String>['Token', 'CSS variable', 'What it controls'],
      rows: <TypesetRow>[
        for (final DocsThemeToken token in kThemeTokens)
          TypesetRow(<TypesetCell>[
            TypesetCell(text: token.name, mono: true),
            TypesetCell(text: token.cssVar, mono: true),
            TypesetCell(text: kThemeTokenDescriptions[token.name] ?? ''),
          ]),
      ],
    );
  }
}
