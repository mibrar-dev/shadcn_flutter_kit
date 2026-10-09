// The docs-site navigation model: header items, sidebar sections and pager
// order. Component links come from the generated `kComponentLinks`; these page
// links are docs-side route constants, not registry facts.

import 'package:flutter/foundation.dart';

import '../generated/docs_data.dart';

/// One navigation target (label + in-app location).
@immutable
class DocsNavLink {
  /// Creates a nav link.
  const DocsNavLink({required this.label, required this.location});

  /// Visible label.
  final String label;

  /// Canonical in-app location (`/docs/installation`).
  final String location;

  /// Whether this link is the current page.
  bool isActiveFor(String currentLocation) => currentLocation == location;

  @override
  bool operator ==(Object other) =>
      other is DocsNavLink &&
      other.label == label &&
      other.location == location;

  @override
  int get hashCode => Object.hash(label, location);
}

/// Header items (Home, Docs, Components, Themes — spec §5.1).
const List<DocsNavLink> kHeaderNav = <DocsNavLink>[
  DocsNavLink(label: 'Home', location: '/'),
  DocsNavLink(label: 'Docs', location: '/docs'),
  DocsNavLink(label: 'Components', location: '/docs/components'),
  DocsNavLink(label: 'Themes', location: '/themes'),
];

/// The sidebar `Sections` group, top to bottom (spec §1).
const List<DocsNavLink> kDocsSections = <DocsNavLink>[
  DocsNavLink(label: 'Introduction', location: '/docs'),
  DocsNavLink(label: 'Components', location: '/docs/components'),
  DocsNavLink(label: 'Installation', location: '/docs/installation'),
  DocsNavLink(label: 'Theming', location: '/docs/theming'),
  DocsNavLink(label: 'Dark Mode', location: '/docs/dark-mode'),
  DocsNavLink(label: 'CLI', location: '/docs/cli'),
];

/// Pager chain for prose pages.
///
/// The Components index is excluded: its "next" is the first component in
/// [kComponentLinks], matching the reference pager.
const List<DocsNavLink> kDocsPageChain = <DocsNavLink>[
  DocsNavLink(label: 'Introduction', location: '/docs'),
  DocsNavLink(label: 'Installation', location: '/docs/installation'),
  DocsNavLink(label: 'Theming', location: '/docs/theming'),
  DocsNavLink(label: 'Dark Mode', location: '/docs/dark-mode'),
  DocsNavLink(label: 'CLI', location: '/docs/cli'),
];

/// Previous/next links in [kDocsPageChain] for [location].
({DocsNavLink? previous, DocsNavLink? next}) docsPageNeighbors(
  String location,
) {
  final int index = kDocsPageChain.indexWhere(
    (DocsNavLink link) => link.location == location,
  );
  if (index < 0) {
    return (previous: null, next: null);
  }
  return (
    previous: index > 0 ? kDocsPageChain[index - 1] : null,
    next: index < kDocsPageChain.length - 1 ? kDocsPageChain[index + 1] : null,
  );
}

/// Previous/next component ids in the alphabetical [kComponentLinks] order
/// (used by D4's component page pager).
({String? previousId, String? nextId}) componentNeighbors(String id) {
  final int index = kComponentLinks.indexWhere(
    (DocsComponentLink link) => link.id == id,
  );
  if (index < 0) {
    return (previousId: null, nextId: null);
  }
  return (
    previousId: index > 0 ? kComponentLinks[index - 1].id : null,
    nextId: index < kComponentLinks.length - 1
        ? kComponentLinks[index + 1].id
        : null,
  );
}
