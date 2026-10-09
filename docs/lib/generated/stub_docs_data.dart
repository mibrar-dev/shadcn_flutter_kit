// D1 TEST STUB — replaced by D2's generated data. Delete with the codegen drop.
//
// The docs batches run in parallel: D3/D4 compile against these types before
// `docs/tool/gen_docs_data.dart` exists. The shapes mirror the P6 build plan
// §2.2 (`docs_data.dart` / `docs_search.dart`); the contents are three sample
// components, three sample presets and a short search index — deliberately
// NOT registry facts. D2 replaces this file with the real generated outputs
// (`generated/docs_data.dart`, `generated/docs_search.dart`,
// `generated/app_theme.dart`) and must re-point `lib/main.dart` at them.

import 'dart:ui' show Brightness;

import '../ui/shadcn/theme/color_tokens.dart';
import '../ui/shadcn/theme/theme.dart';

/// One installable component, generated from the registry manifest.
class DocsComponent {
  /// Creates a component entry.
  const DocsComponent({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.install,
    required this.import,
    required this.fileCount,
    required this.stability,
  });

  /// Registry id / directory name.
  final String id;

  /// Display name.
  final String name;

  /// Manifest category (`form`, `overlay`, `display`, …).
  final String category;

  /// One-line description from the manifest.
  final String description;

  /// `flutter_shadcn add <id>` from the manifest.
  final String install;

  /// Corrected import line for the docs mirror layout.
  final String import;

  /// Number of installed Dart files (manifest `files` + user-owned theme).
  final int fileCount;

  /// Stability marker (`stable` for now).
  final String stability;
}

/// One preset, generated from `themes/index.json`.
class DocsPreset {
  /// Creates a preset entry.
  const DocsPreset({required this.id, required this.name, required this.modes});

  /// Preset id (`modern-minimal`).
  final String id;

  /// Display name (`Modern Minimal`).
  final String name;

  /// Supported modes (`light`, `dark`).
  final List<String> modes;
}

/// Landing stats band values, each derived in the D2 codegen.
class DocsStats {
  /// Creates the stats block.
  const DocsStats({
    required this.components,
    required this.presets,
    required this.materialImports,
    required this.modes,
  });

  /// Installable component count.
  final int components;

  /// Preset count.
  final int presets;

  /// Material/Cupertino imports found in the registry (must be 0).
  final int materialImports;

  /// Theme modes (`2`: light + dark).
  final int modes;
}

/// Palette/search group a [DocsSearchEntry] belongs to.
enum DocsSearchKind {
  /// A component page.
  component,

  /// A CLI command.
  command,

  /// A theme preset.
  preset,
}

/// One searchable row (`kDocsSearchIndex`).
class DocsSearchEntry {
  /// Creates a search entry.
  const DocsSearchEntry({
    required this.label,
    required this.kind,
    required this.route,
    this.tag,
  });

  /// Display label.
  final String label;

  /// Group in the palette.
  final DocsSearchKind kind;

  /// In-app route (`/docs/components/button`).
  final String route;

  /// Right-aligned hint (`1 file`, `CLI`, `preset`).
  final String? tag;
}

/// Sample component catalog (D2 emits all 118).
const List<DocsComponent> kComponents = <DocsComponent>[
  DocsComponent(
    id: 'button',
    name: 'Button',
    category: 'form',
    description: 'Clickable action with variants, sizes and loading state.',
    install: 'flutter_shadcn add button',
    import:
        "import 'package:<your_app>/ui/shadcn/components/button/button.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'dialog',
    name: 'Dialog',
    category: 'overlay',
    description: 'Modal surface with scrim, focus trap and Esc dismissal.',
    install: 'flutter_shadcn add dialog',
    import:
        "import 'package:<your_app>/ui/shadcn/components/dialog/dialog.dart';",
    fileCount: 2,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'command',
    name: 'Command',
    category: 'overlay',
    description: 'Command palette with async results and keyboard navigation.',
    install: 'flutter_shadcn add command',
    import:
        "import 'package:<your_app>/ui/shadcn/components/command/command.dart';",
    fileCount: 2,
    stability: 'stable',
  ),
];

/// Sample presets (D2 emits all 42).
const List<DocsPreset> kPresets = <DocsPreset>[
  DocsPreset(
    id: 'modern-minimal',
    name: 'Modern Minimal',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'tangerine',
    name: 'Tangerine',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(id: 'claude', name: 'Claude', modes: <String>['light', 'dark']),
];

/// Sample stats (D2 derives the real numbers).
const DocsStats kStats = DocsStats(
  components: 3,
  presets: 3,
  materialImports: 0,
  modes: 2,
);

/// Sample search index (D2 emits components + commands + presets).
const List<DocsSearchEntry> kDocsSearchIndex = <DocsSearchEntry>[
  DocsSearchEntry(
    label: 'button',
    kind: DocsSearchKind.component,
    route: '/docs/components/button',
    tag: '3 files',
  ),
  DocsSearchEntry(
    label: 'dialog',
    kind: DocsSearchKind.component,
    route: '/docs/components/dialog',
    tag: '2 files',
  ),
  DocsSearchEntry(
    label: 'command',
    kind: DocsSearchKind.component,
    route: '/docs/components/command',
    tag: '2 files',
  ),
  DocsSearchEntry(
    label: 'add <component>',
    kind: DocsSearchKind.command,
    route: '/docs/cli',
    tag: 'CLI',
  ),
  DocsSearchEntry(
    label: 'init --preset',
    kind: DocsSearchKind.command,
    route: '/docs/cli',
    tag: 'CLI',
  ),
  DocsSearchEntry(
    label: 'modern-minimal',
    kind: DocsSearchKind.preset,
    route: '/themes',
    tag: 'preset',
  ),
];

/// TEMPORARY theme resolver: fallback palettes only.
///
/// D2's `generated/app_theme.dart` exposes one `build<Id>Theme(Brightness)`
/// factory per preset and becomes the `DocsState.resolveTheme` argument in
/// `main.dart`.
ShadcnThemeData buildStubDocsTheme(String presetId, Brightness brightness) {
  return brightness == Brightness.dark
      ? const ShadcnThemeData(colors: ShadcnColors.darkFallback)
      : const ShadcnThemeData();
}
