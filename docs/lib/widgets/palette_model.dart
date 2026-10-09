// The command palette's data model: entries built from the generated registry
// data (Pages / Components / Presets, spec §5.3 D2 delta). Split from
// `palette.dart` to keep both files under the ~400-line rule.

import 'package:flutter/widgets.dart';

import '../generated/docs_data.dart';
import '../generated/docs_tables.dart';
import '../routing/docs_nav.dart';
import '../ui/shadcn/foundation/icons/lucide_icons.dart';
import 'docs_tokens.dart';

class PaletteEntry {
  const PaletteEntry({
    required this.group,
    required this.label,
    required this.route,
    required this.icon,
    this.tag,
    this.action,
    this.keywords = const <String>[],
  });

  final PaletteGroup group;
  final String label;
  final String route;
  final IconData icon;
  final String? tag;
  final String? action;
  final List<String> keywords;

  bool matches(String query) {
    if (label.toLowerCase().contains(query)) {
      return true;
    }
    if (tag != null && tag!.toLowerCase().contains(query)) {
      return true;
    }
    return keywords.any(
      (String keyword) => keyword.toLowerCase().contains(query),
    );
  }
}

List<PaletteEntry> buildPaletteEntries() {
  final List<PaletteEntry> items = <PaletteEntry>[];
  final Set<String> seen = <String>{};
  for (final DocsNavLink link in <DocsNavLink>[
    ...kHeaderNav,
    ...kDocsSections,
  ]) {
    if (!seen.add(link.location)) {
      continue;
    }
    items.add(
      PaletteEntry(
        group: PaletteGroup.pages,
        label: link.label,
        route: link.location,
        icon: paletteIconFor(link.location),
      ),
    );
  }
  for (final DocsCliCommand command in kCliCommands) {
    items.add(
      PaletteEntry(
        group: PaletteGroup.pages,
        label: command.label,
        route: '/docs/cli',
        icon: LucideIcons.terminal,
        tag: 'CLI',
        action: command.invocation,
        keywords: <String>[command.summary, command.usage],
      ),
    );
  }
  for (final DocsComponent component in kComponents) {
    items.add(
      PaletteEntry(
        group: PaletteGroup.components,
        label: component.name,
        route: '/docs/components/${component.id}',
        icon: LucideIcons.component,
        tag: '${component.fileCount} files',
        action: component.install,
        // Names + tags only, mirroring the generated search index: the long
        // description would make incidental matches dominate.
        keywords: <String>[component.id, component.category],
      ),
    );
  }
  for (final DocsPreset preset in kPresets) {
    items.add(
      PaletteEntry(
        group: PaletteGroup.presets,
        label: preset.name,
        route: '/themes',
        icon: LucideIcons.palette,
        tag: 'preset',
        action: preset.id,
        keywords: <String>[preset.id],
      ),
    );
  }
  return items;
}

IconData paletteIconFor(String location) {
  return switch (location) {
    '/' => LucideIcons.house,
    '/docs' => LucideIcons.fileText,
    '/docs/components' => LucideIcons.component,
    '/themes' => LucideIcons.palette,
    '/docs/installation' => LucideIcons.download,
    _ => LucideIcons.fileText,
  };
}
