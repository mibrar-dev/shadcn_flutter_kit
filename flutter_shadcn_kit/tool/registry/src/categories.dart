// The single source of truth for registry categories (P6-B1).
//
// Two taxonomies live here because a component and a block answer different
// questions in the docs:
//   * a component is a widget family, so it is grouped by what it *is*
//     ([componentCategories]);
//   * a block is a whole page, so it is grouped by what a developer is looking
//     for when they browse the Blocks section ([blockCategories]).
//
// Both lists are enforced by `gen_registry_manifest.dart --check`, by the
// `blocks` rules of `tool/rearch/check_layers.dart`, and by the JSON Schema
// in rearch/reports/registry_manifest.v2.schema.json.

/// Category taxonomy for `lib/registry/components/**/meta.json`.
///
/// Ordered as the docs sidebar groups them.
const List<String> componentCategories = <String>[
  'Forms & Inputs',
  'Buttons & Actions',
  'Overlays',
  'Menus',
  'Navigation',
  'Data Display',
  'Feedback',
  'Layout',
  'Typography & Media',
  'Date & Time',
  'Color',
  'Animation & Effects',
  'Utilities (building blocks)',
];

/// Category taxonomy for `lib/registry/blocks/**/meta.json`.
///
/// Block families rather than widget families: a visitor of the Blocks section
/// looks for "Login", not for "Forms & Inputs". A block still composes
/// categorized components, and its README lists them, so the widget taxonomy
/// stays reachable from the block page.
const List<String> blockCategories = <String>[
  'Dashboard',
  'Sidebar',
  'Authentication',
  'Calendar & Scheduling',
  'Settings & Account',
  'Marketing',
];

/// Viewport hints a block may declare; a block that is inherently phone-first
/// says `mobile`, everything else `desktop`.
const List<String> blockViewports = <String>['desktop', 'mobile'];

/// Whether [category] is a legal component category.
bool isComponentCategory(String category) =>
    componentCategories.contains(category);

/// Whether [category] is a legal block category.
bool isBlockCategory(String category) => blockCategories.contains(category);
