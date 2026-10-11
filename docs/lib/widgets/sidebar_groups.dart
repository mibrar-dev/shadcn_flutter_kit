// The docs sidebar's row model (P6-B3): the Sections / Components / Blocks
// groups as plain data, so the sidebar widget only paints.
//
// Components are grouped by their generated category (P6-B1 taxonomy) and
// building blocks (`listed: false` in the manifest) are omitted — they stay
// installable and reachable through the component pager/API links, but never
// appear in the browsable surfaces. Blocks are grouped by their block family.
//
// Split out of `docs_sidebar.dart` for the ~400-line rule.

import 'package:flutter/foundation.dart';

import '../generated/docs_blocks.dart';
import '../generated/docs_data.dart';
import '../routing/docs_nav.dart';

/// One sidebar row: a group label, a category sub-label, or a link.
@immutable
class SidebarRow {
  const SidebarRow._({
    required this.label,
    required this.location,
    required this.isLabel,
    required this.isSubLabel,
  });

  /// A group label (`Sections`, `Components`, `Blocks`).
  const SidebarRow.label(String text)
    : this._(label: text, location: null, isLabel: true, isSubLabel: false);

  /// A category sub-label inside a group (`Forms & Inputs`, `Dashboard`).
  const SidebarRow.subLabel(String text)
    : this._(label: text, location: null, isLabel: false, isSubLabel: true);

  /// A navigable row.
  const SidebarRow.link({required String text, required String location})
    : this._(
        label: text,
        location: location,
        isLabel: false,
        isSubLabel: false,
      );

  /// Visible label.
  final String label;

  /// In-app location for link rows; null for labels.
  final String? location;

  /// Whether the row is a group label.
  final bool isLabel;

  /// Whether the row is a category sub-label.
  final bool isSubLabel;

  /// Whether the row navigates.
  bool get isLink => !isLabel && !isSubLabel;
}

/// Builds the sidebar rows for [activeLocation], top to bottom.
List<SidebarRow> buildSidebarRows(String activeLocation) {
  return <SidebarRow>[
    const SidebarRow.label('Sections'),
    for (final DocsNavLink link in kDocsSections)
      SidebarRow.link(text: link.label, location: link.location),
    const SidebarRow.label('Components'),
    for (final DocsComponentCategory category
        in kComponentCategoryGroups) ...<SidebarRow>[
      SidebarRow.subLabel(category.id),
      for (final DocsComponentLink component in category.components)
        SidebarRow.link(
          text: component.name,
          location: '/docs/components/${component.id}',
        ),
    ],
    const SidebarRow.label('Blocks'),
    for (final DocsBlockCategory category in kBlockCategories) ...<SidebarRow>[
      SidebarRow.subLabel(category.id),
      for (final DocsBlock block in category.blocks)
        SidebarRow.link(text: block.name, location: '/blocks/${block.id}'),
    ],
  ];
}
