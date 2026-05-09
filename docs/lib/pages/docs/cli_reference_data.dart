import 'blocks.dart';

class CliExampleDoc {
  final String title;
  final String command;
  final String description;

  const CliExampleDoc({
    required this.title,
    required this.command,
    required this.description,
  });
}

class CliReferenceDoc {
  final String id;
  final String title;
  final String summary;
  final List<String> syntax;
  final List<DocsOptionRow> options;
  final List<CliExampleDoc> examples;
  final List<String> behavior;
  final List<String> related;

  const CliReferenceDoc({
    required this.id,
    required this.title,
    required this.summary,
    this.syntax = const <String>[],
    this.options = const <DocsOptionRow>[],
    this.examples = const <CliExampleDoc>[],
    this.behavior = const <String>[],
    this.related = const <String>[],
  });
}

class CliReferenceSection {
  final String title;
  final List<String> pageIds;

  const CliReferenceSection({
    required this.title,
    required this.pageIds,
  });
}

final Map<String, CliReferenceDoc> cliReferenceDocs = <String, CliReferenceDoc>{
  'cli-overview': const CliReferenceDoc(
    id: 'cli-overview',
    title: 'CLI Overview',
    summary:
        'flutter_shadcn is the registry installer and diagnostics toolchain for the docs site and consumer apps. Use it to initialize a project, install components, apply theme payloads, and inspect registry health.',
    syntax: <String>[
      'flutter_shadcn <command> [options]',
      'flutter_shadcn <command> @namespace [args]',
      'flutter_shadcn --registry-name namespace <command> [args]',
      'flutter_shadcn --advanced <command> [args]',
    ],
    options: <DocsOptionRow>[
      DocsOptionRow(
        name: '--registry-name',
        value: 'namespace',
        description:
            'Select the active registry namespace for the command without using an inline @namespace token.',
      ),
      DocsOptionRow(
        name: '--advanced',
        value: 'flag',
        description:
            'Show and enable developer and experimental features, including local registry overrides and generated docs tooling.',
      ),
      DocsOptionRow(
        name: '--offline',
        value: 'flag',
        description:
            'Disable network fetches and use cached registry/theme data only.',
      ),
      DocsOptionRow(
        name: '--verbose',
        value: 'flag',
        description: 'Print extra logging details during command execution.',
      ),
    ],
    examples: <CliExampleDoc>[
      CliExampleDoc(
        title: 'Initialize then install a component',
        command: 'flutter_shadcn init --yes\nflutter_shadcn add button',
        description:
            'Bootstrap the current project and copy the button component with its shared dependencies.',
      ),
      CliExampleDoc(
        title: 'Target a registry namespace explicitly',
        command: 'flutter_shadcn theme @shadcn --list',
        description:
            'Resolve the command against the shadcn namespace even if another registry is the default.',
      ),
    ],
    behavior: <String>[
      'Namespace selection is resolved before registry loading, theme fetching, or install-plan execution.',
      'Global theme presets are discovered from a registry theme index. Theme payload installation is delegated to the registry converter.',
      'Widget theming is intentionally converter-owned. The CLI fetches and caches payload JSON, then invokes the registry converter with project-local paths.',
      'Most read-only commands can emit JSON for automation or CI usage.',
      'Developer registry overrides and experimental file/URL theme imports require --advanced.',
    ],
    related: <String>[
      'cli-init',
      'cli-add',
      'cli-theme',
      'cli-doctor',
      'cli-exit-codes',
      'cli-troubleshooting',
      'cli-development',
    ],
  ),
  'cli-init': const CliReferenceDoc(
    id: 'cli-init',
    title: 'init',
    summary:
        'Initializes flutter_shadcn for the current project and runs inline bootstrap actions for the selected namespace.',
    syntax: <String>[
      'flutter_shadcn init',
      'flutter_shadcn init shadcn',
      'flutter_shadcn init --yes',
    ],
    options: <DocsOptionRow>[
      DocsOptionRow(
        name: '--yes, -y',
        value: 'flag',
        description: 'Run non-interactively and accept the default setup.',
      ),
    ],
    examples: <CliExampleDoc>[
      CliExampleDoc(
        title: 'Bootstrap the default registry',
        command: 'flutter_shadcn init --yes',
        description:
            'Writes .shadcn config/state defaults and installs the base shared modules without prompts.',
      ),
      CliExampleDoc(
        title: 'Bootstrap a specific namespace',
        command: 'flutter_shadcn init shadcn --yes',
        description:
            'Runs the init flow using the selected namespace instead of the current default registry.',
      ),
    ],
    behavior: <String>[
      'init is routed through the multi-registry bootstrap flow rather than the standard single-installer path.',
      'The command updates .shadcn/config.json and .shadcn/state.json so future add/theme/sync commands resolve consistently.',
      'If a project is already initialized, rerunning init reuses saved settings unless you override them.',
    ],
    related: <String>['cli-add', 'cli-assets', 'cli-sync'],
  ),
  'cli-add': const CliReferenceDoc(
    id: 'cli-add',
    title: 'add',
    summary:
        'Installs one or more components from the active registry and copies the required shared files, assets, and pubspec dependencies.',
    syntax: <String>[
      'flutter_shadcn add button',
      'flutter_shadcn add button badge accordion',
      'flutter_shadcn add @shadcn/button',
    ],
    options: <DocsOptionRow>[
      DocsOptionRow(
        name: '--include-files',
        value: 'readme|preview|meta',
        description:
            'Limit the copied file kinds to the listed values. Repeat the option or pass a comma-separated list.',
      ),
      DocsOptionRow(
        name: '--exclude-files',
        value: 'readme|preview|meta',
        description:
            'Skip optional file kinds during install. Cannot be combined with --include-files.',
      ),
    ],
    examples: <CliExampleDoc>[
      CliExampleDoc(
        title: 'Install multiple components',
        command: 'flutter_shadcn add button badge accordion',
        description:
            'Copies each component and de-duplicates shared helpers and pubspec dependencies.',
      ),
      CliExampleDoc(
        title: 'Install only production files',
        command:
            'flutter_shadcn add button --exclude-files readme,preview,meta',
        description:
            'Skips optional docs and preview artifacts when you only want runtime code.',
      ),
    ],
    behavior: <String>[
      'Component references can be namespace-qualified as @namespace/component or resolved through the enabled/default registries.',
      'The installer batches dependency updates and shared file copies so overlapping requirements are written once.',
      'If a component reference is ambiguous across registries, the command fails and asks for an explicit namespace.',
    ],
    related: <String>['cli-dry-run', 'cli-remove', 'cli-info'],
  ),
  'cli-remove': const CliReferenceDoc(
    id: 'cli-remove',
    title: 'remove',
    summary:
        'Removes installed components, cleans generated aliases, and optionally rolls back inline asset actions.',
    syntax: <String>[
      'flutter_shadcn remove button',
      'flutter_shadcn remove button badge',
      'flutter_shadcn remove --all',
    ],
    options: <DocsOptionRow>[
      DocsOptionRow(
        name: '--all, -a',
        value: 'flag',
        description: 'Remove every installed component in the current project.',
      ),
      DocsOptionRow(
        name: '--force, -f',
        value: 'flag',
        description:
            'Force removal even when dependency metadata says another component still needs the target.',
      ),
    ],
    examples: <CliExampleDoc>[
      CliExampleDoc(
        title: 'Remove a single widget',
        command: 'flutter_shadcn remove button',
        description: 'Deletes button-owned files and rewrites alias exports.',
      ),
      CliExampleDoc(
        title: 'Wipe installed components',
        command: 'flutter_shadcn remove --all',
        description:
            'Clears installed components and rolls back inline typography/icon asset actions for the selected namespace.',
      ),
    ],
    behavior: <String>[
      'remove enforces dependency checks by default and fails when a remaining component depends on the one you are deleting.',
      'Namespace-qualified component refs require the active namespace to match unless the alias is explicitly allowed as the default namespace.',
      'Generated alias files are regenerated after successful removals.',
    ],
    related: <String>['cli-add', 'cli-audit', 'cli-doctor'],
  ),
  'cli-theme': const CliReferenceDoc(
    id: 'cli-theme',
    title: 'theme',
    summary:
        'Lists and applies global registry theme presets. Preset IDs come from the registry theme index; installation is performed by the registry converter.',
    syntax: <String>[
      'flutter_shadcn theme --list',
      'flutter_shadcn theme --apply modern-minimal',
      'flutter_shadcn --advanced theme --apply-url https://example.com/theme.json',
    ],
    options: <DocsOptionRow>[
      DocsOptionRow(
        name: '--list',
        value: 'flag',
        description:
            'Show all global presets exposed by the selected registry.',
      ),
      DocsOptionRow(
        name: '--refresh',
        value: 'flag',
        description:
            'Refresh the cached theme index before listing or applying presets.',
      ),
      DocsOptionRow(
        name: '--apply, -a',
        value: 'presetId',
        description: 'Apply a preset by ID from the registry theme index.',
      ),
      DocsOptionRow(
        name: '--apply-file',
        value: 'path',
        description:
            'Read a theme payload from a local JSON file. Requires --advanced.',
      ),
      DocsOptionRow(
        name: '--apply-url',
        value: 'url',
        description:
            'Fetch a theme payload over HTTP, cache it in the project, and hand it to the registry converter. Requires --advanced.',
      ),
    ],
    examples: <CliExampleDoc>[
      CliExampleDoc(
        title: 'List shadcn presets',
        command: 'flutter_shadcn theme @shadcn --list',
        description:
            'Reads the selected namespace theme index and prints the available preset IDs and names.',
      ),
      CliExampleDoc(
        title: 'Apply a preset payload from a URL',
        command:
            'flutter_shadcn --advanced theme @shadcn --apply-url https://registry.dev/themes/modern-minimal.json',
        description:
            'Downloads the payload, stores it under .shadcn/cache/themes/<namespace>/, and invokes the converter with the cached file path.',
      ),
    ],
    behavior: <String>[
      'Theme-by-ID still depends on the registry theme index so the CLI can resolve the preset metadata before calling the converter.',
      'Theme-by-file and theme-by-URL require --advanced and do not parse theme structure in the CLI. The CLI only caches payload JSON and forwards it to the converter.',
      'A registry can support global themes without supporting widget themes, or vice versa.',
    ],
    related: <String>['cli-theme-widget', 'cli-sync', 'cli-troubleshooting'],
  ),
  'cli-theme-widget': const CliReferenceDoc(
    id: 'cli-theme-widget',
    title: 'theme widget',
    summary:
        'Delegates per-widget theming to the registry converter. The CLI only handles namespace resolution, payload fetching, project-local caching, and install-plan execution.',
    syntax: <String>[
      'flutter_shadcn theme widget --list',
      'flutter_shadcn theme widget button --list-targets',
      'flutter_shadcn --advanced theme widget button --apply-url https://example.com/widget-theme.json',
      'flutter_shadcn theme widget button --reset',
    ],
    options: <DocsOptionRow>[
      DocsOptionRow(
        name: '--list',
        value: 'flag',
        description:
            'Ask the converter to list themeable widgets for the active namespace and project.',
      ),
      DocsOptionRow(
        name: '--list-targets',
        value: 'flag',
        description:
            'Ask the converter to list the available theme targets for the selected installed component.',
      ),
      DocsOptionRow(
        name: '--apply-file',
        value: 'path',
        description:
            'Read a widget-theme payload from a local JSON file, cache it under .shadcn/cache/widget_themes/, then invoke the converter. Requires --advanced.',
      ),
      DocsOptionRow(
        name: '--apply-url',
        value: 'url',
        description:
            'Fetch a widget-theme payload from a URL, cache it in the current project, then invoke the converter. Requires --advanced.',
      ),
      DocsOptionRow(
        name: '--reset',
        value: 'flag',
        description:
            'Request that the converter remove widget-specific overrides for the selected component.',
      ),
    ],
    examples: <CliExampleDoc>[
      CliExampleDoc(
        title: 'Discover widget theme support',
        command: 'flutter_shadcn theme widget @shadcn --list',
        description:
            'The converter inspects the current project and reports which installed components expose widget theme config.',
      ),
      CliExampleDoc(
        title: 'Apply a button theme payload',
        command:
            'flutter_shadcn --advanced theme widget @shadcn button --apply-url https://registry.dev/widget-theme/button-primary.json',
        description:
            'Caches the payload locally and lets the converter patch the installed button theme override files.',
      ),
    ],
    behavior: <String>[
      'Widget theme structure is not hardcoded in the CLI. Unsupported registries should fail through the converter response, not through CLI assumptions.',
      'The converter decides whether a widget is installed, whether it supports theming, which targets exist, and which files must be written or patched.',
      'Widget theme file and URL payload imports require --advanced. Listing, target discovery, and reset stay public.',
      'Reset also goes through the converter so registries can restore their own default theme shape safely.',
    ],
    related: <String>['cli-theme', 'cli-troubleshooting', 'cli-development'],
  ),
  'cli-assets': const CliReferenceDoc(
    id: 'cli-assets',
    title: 'assets',
    summary:
        'Installs registry-managed icon and typography assets through inline registry actions.',
    syntax: <String>[
      'flutter_shadcn assets --icons',
      'flutter_shadcn assets --typography',
      'flutter_shadcn assets --all',
    ],
    options: <DocsOptionRow>[
      DocsOptionRow(
          name: '--icons',
          value: 'flag',
          description: 'Install icon font assets.'),
      DocsOptionRow(
          name: '--typography',
          value: 'flag',
          description: 'Install typography font assets.'),
      DocsOptionRow(
          name: '--fonts',
          value: 'flag',
          description: 'Alias for --typography.'),
      DocsOptionRow(
          name: '--list',
          value: 'flag',
          description: 'List available asset bundles.'),
      DocsOptionRow(
          name: '--all, -a',
          value: 'flag',
          description: 'Install icon and typography assets together.'),
    ],
    examples: <CliExampleDoc>[
      CliExampleDoc(
        title: 'Install typography only',
        command: 'flutter_shadcn assets --typography',
        description:
            'Adds the registry typography assets without installing icons.',
      ),
      CliExampleDoc(
        title: 'Inspect supported asset bundles',
        command: 'flutter_shadcn assets --list',
        description: 'Shows the built-in asset bundle IDs handled by the CLI.',
      ),
    ],
    behavior: <String>[
      'Assets are handled by the current inline registry action engine.',
      'The CLI does not use component-ID fallback for asset installation.',
    ],
    related: <String>['cli-init', 'cli-remove'],
  ),
  'cli-sync': const CliReferenceDoc(
    id: 'cli-sync',
    title: 'sync',
    summary:
        'Re-applies the current .shadcn/config.json settings, including install paths and active global theme, to an already initialized project.',
    syntax: <String>[
      'flutter_shadcn sync',
      'flutter_shadcn sync @shadcn',
    ],
    behavior: <String>[
      'sync is useful after you change path aliases, install roots, or theme configuration and want generated files to match the new config.',
      'The command uses the same namespace-aware installer selection as add/remove/theme.',
    ],
    examples: <CliExampleDoc>[
      CliExampleDoc(
        title: 'Reapply current config',
        command: 'flutter_shadcn sync',
        description:
            'Normalizes installed files to the current config and theme selection.',
      ),
    ],
    related: <String>['cli-init', 'cli-theme', 'cli-doctor'],
  ),
  'cli-dry-run': const CliReferenceDoc(
    id: 'cli-dry-run',
    title: 'dry-run',
    summary:
        'Builds and prints an install plan without modifying files so you can inspect dependencies, shared modules, assets, and fonts before installing.',
    syntax: <String>[
      'flutter_shadcn dry-run button dialog',
      'flutter_shadcn dry-run --all',
    ],
    options: <DocsOptionRow>[
      DocsOptionRow(
          name: '--all, -a',
          value: 'flag',
          description: 'Preview the plan for every available component.'),
      DocsOptionRow(
          name: '--json',
          value: 'flag',
          description: 'Emit the dry-run plan as machine-readable JSON.'),
    ],
    examples: <CliExampleDoc>[
      CliExampleDoc(
        title: 'Preview a bundle install',
        command: 'flutter_shadcn dry-run button dialog --json',
        description:
            'Returns the file/dependency plan without writing anything.',
      ),
    ],
    behavior: <String>[
      'dry-run returns a non-zero exit code when one or more requested components are missing.',
      'The plan includes synthetic inline asset components when you use --all.',
    ],
    related: <String>['cli-add', 'cli-audit'],
  ),
  'cli-list': const CliReferenceDoc(
    id: 'cli-list',
    title: 'list',
    summary: 'Lists available components from the selected registry index.',
    syntax: <String>[
      'flutter_shadcn list',
      'flutter_shadcn list @shadcn --refresh',
    ],
    options: <DocsOptionRow>[
      DocsOptionRow(
          name: '--refresh',
          value: 'flag',
          description: 'Refresh the cached component index from the registry.'),
      DocsOptionRow(
          name: '--json',
          value: 'flag',
          description: 'Emit list results as JSON.'),
    ],
    behavior: <String>[
      'list accepts an inline namespace token but no search query text. Use search when you need filtering.',
      'The command reads the registry index, not the installed project state.',
    ],
    examples: <CliExampleDoc>[
      CliExampleDoc(
        title: 'Browse a registry namespace',
        command: 'flutter_shadcn list @shadcn',
        description:
            'Lists every component entry from the selected namespace index.',
      ),
    ],
    related: <String>['cli-search', 'cli-info', 'cli-registries'],
  ),
  'cli-search': const CliReferenceDoc(
    id: 'cli-search',
    title: 'search',
    summary:
        'Searches the registry index by component name, description, and tags.',
    syntax: <String>[
      'flutter_shadcn search button',
      'flutter_shadcn search @shadcn overlay',
    ],
    options: <DocsOptionRow>[
      DocsOptionRow(
          name: '--refresh',
          value: 'flag',
          description: 'Refresh the cached component index before searching.'),
      DocsOptionRow(
          name: '--json',
          value: 'flag',
          description: 'Emit search results as JSON.'),
    ],
    behavior: <String>[
      'If no query text is supplied, search falls back to the list command behavior for the selected namespace.',
      'Namespace can be provided inline as the first token.',
    ],
    examples: <CliExampleDoc>[
      CliExampleDoc(
        title: 'Search inside a namespace',
        command: 'flutter_shadcn search @shadcn button group',
        description:
            'Searches for components matching the combined query string.',
      ),
    ],
    related: <String>['cli-list', 'cli-info'],
  ),
  'cli-info': const CliReferenceDoc(
    id: 'cli-info',
    title: 'info',
    summary: 'Shows detailed metadata for a single registry component.',
    syntax: <String>[
      'flutter_shadcn info button',
      'flutter_shadcn info @shadcn/button',
    ],
    options: <DocsOptionRow>[
      DocsOptionRow(
          name: '--refresh',
          value: 'flag',
          description:
              'Refresh the cached component index before reading the component entry.'),
      DocsOptionRow(
          name: '--json',
          value: 'flag',
          description: 'Emit component metadata as JSON.'),
    ],
    behavior: <String>[
      'A fully qualified component reference sets the namespace automatically.',
      'info is read-only and does not inspect the installed project state.',
    ],
    examples: <CliExampleDoc>[
      CliExampleDoc(
        title: 'Inspect component metadata',
        command: 'flutter_shadcn info @shadcn/button',
        description:
            'Prints install command hints, dependencies, and descriptive metadata for the button component.',
      ),
    ],
    related: <String>['cli-list', 'cli-search', 'cli-add'],
  ),
  'cli-doctor': const CliReferenceDoc(
    id: 'cli-doctor',
    title: 'doctor',
    summary:
        'Diagnoses registry resolution, schema validation, config path issues, and required theme files in the current project.',
    syntax: <String>[
      'flutter_shadcn doctor',
      'flutter_shadcn doctor --json',
    ],
    options: <DocsOptionRow>[
      DocsOptionRow(
          name: '--json',
          value: 'flag',
          description: 'Emit diagnostics as machine-readable JSON.'),
    ],
    examples: <CliExampleDoc>[
      CliExampleDoc(
        title: 'Check project health before filing a bug',
        command: 'flutter_shadcn doctor',
        description:
            'Prints resolved registry paths, config paths, schema status, and platform target state.',
      ),
    ],
    behavior: <String>[
      'doctor validates both registry data and project configuration. It can fail for schema errors, config path problems, or both.',
      'The command checks for color_scheme.dart in the configured shared theme path because theme installs depend on that file layout.',
    ],
    related: <String>['cli-validate', 'cli-audit', 'cli-troubleshooting'],
  ),
  'cli-validate': const CliReferenceDoc(
    id: 'cli-validate',
    title: 'validate',
    summary:
        'Validates registry metadata such as components.json and registry file dependencies.',
    syntax: <String>[
      'flutter_shadcn validate',
      'flutter_shadcn validate --json',
    ],
    options: <DocsOptionRow>[
      DocsOptionRow(
          name: '--json',
          value: 'flag',
          description: 'Emit validation output as JSON.'),
    ],
    behavior: <String>[
      'validate is registry-focused. It checks registry correctness, not the installed project state.',
      'Use it during local registry development before pushing changes or testing installs.',
    ],
    examples: <CliExampleDoc>[
      CliExampleDoc(
        title: 'Validate a local registry clone',
        command:
            'flutter_shadcn --advanced --registry-path /absolute/path/to/registry validate',
        description:
            'Runs schema and dependency validation against a local registry root.',
      ),
    ],
    related: <String>['cli-doctor', 'cli-development'],
  ),
  'cli-audit': const CliReferenceDoc(
    id: 'cli-audit',
    title: 'audit',
    summary:
        'Audits installed components against registry metadata to detect drift between the project and the source registry.',
    syntax: <String>[
      'flutter_shadcn audit',
      'flutter_shadcn audit --json',
    ],
    options: <DocsOptionRow>[
      DocsOptionRow(
          name: '--json',
          value: 'flag',
          description: 'Emit audit results as JSON.'),
    ],
    behavior: <String>[
      'audit is project-focused. It compares the installed state to registry metadata for the selected namespace.',
      'Use it after manual edits or large upgrades to see what diverged.',
    ],
    examples: <CliExampleDoc>[
      CliExampleDoc(
        title: 'Audit installed files before syncing',
        command: 'flutter_shadcn audit',
        description:
            'Highlights drift so you can decide whether to sync or reinstall components.',
      ),
    ],
    related: <String>['cli-sync', 'cli-doctor', 'cli-dry-run'],
  ),
  'cli-deps': const CliReferenceDoc(
    id: 'cli-deps',
    title: 'deps',
    summary:
        'Compares registry dependency versions against the current pubspec.yaml.',
    syntax: <String>[
      'flutter_shadcn deps',
      'flutter_shadcn deps --all --json',
    ],
    options: <DocsOptionRow>[
      DocsOptionRow(
          name: '--all, -a',
          value: 'flag',
          description:
              'Compare dependency versions for all registry components, not only installed ones.'),
      DocsOptionRow(
          name: '--json',
          value: 'flag',
          description: 'Emit dependency comparison output as JSON.'),
    ],
    behavior: <String>[
      'deps is useful when registry manifests change package versions and you want to see whether the project is behind or over-pinned.',
    ],
    examples: <CliExampleDoc>[
      CliExampleDoc(
        title: 'Compare everything against the registry',
        command: 'flutter_shadcn deps --all',
        description: 'Prints a full dependency comparison report.',
      ),
    ],
    related: <String>['cli-audit', 'cli-doctor'],
  ),
  'cli-platform': const CliReferenceDoc(
    id: 'cli-platform',
    title: 'platform',
    summary:
        'Lists, sets, and resets platform target path overrides stored in .shadcn/config.json.',
    syntax: <String>[
      'flutter_shadcn platform --list',
      'flutter_shadcn platform --set ios.infoPlist=ios/Runner/Info.plist',
      'flutter_shadcn platform --reset ios.infoPlist',
    ],
    options: <DocsOptionRow>[
      DocsOptionRow(
          name: '--list',
          value: 'flag',
          description: 'Print the merged platform target map.'),
      DocsOptionRow(
          name: '--set',
          value: 'platform.section=path',
          description: 'Set a platform target override. Repeatable.'),
      DocsOptionRow(
          name: '--reset',
          value: 'platform.section',
          description: 'Remove a platform target override. Repeatable.'),
    ],
    behavior: <String>[
      'Overrides are merged with the built-in defaults and saved back into .shadcn/config.json.',
    ],
    examples: <CliExampleDoc>[
      CliExampleDoc(
        title: 'Override the iOS Info.plist location',
        command:
            'flutter_shadcn platform --set ios.infoPlist=ios/Runner/Info.plist',
        description:
            'Stores a project-specific override for later install/update flows.',
      ),
    ],
    related: <String>['cli-doctor', 'cli-development'],
  ),
  'cli-registries': const CliReferenceDoc(
    id: 'cli-registries',
    title: 'registries',
    summary:
        'Lists configured and discoverable registries, including the default namespace and capability flags.',
    syntax: <String>[
      'flutter_shadcn registries',
      'flutter_shadcn registries --json',
    ],
    options: <DocsOptionRow>[
      DocsOptionRow(
          name: '--json',
          value: 'flag',
          description: 'Emit registry summaries as JSON.'),
    ],
    examples: <CliExampleDoc>[
      CliExampleDoc(
        title: 'Inspect configured namespaces',
        command: 'flutter_shadcn registries',
        description:
            'Shows namespace, source, mode, path/base URL, and enabled capabilities.',
      ),
    ],
    behavior: <String>[
      'Use registries to confirm that a namespace is configured before running add/theme/widget-theme commands against it.',
    ],
    related: <String>['cli-default', 'cli-overview'],
  ),
  'cli-default': const CliReferenceDoc(
    id: 'cli-default',
    title: 'default',
    summary:
        'Shows or updates the default registry namespace used when a command does not receive an explicit namespace token.',
    syntax: <String>[
      'flutter_shadcn default',
      'flutter_shadcn default shadcn',
    ],
    examples: <CliExampleDoc>[
      CliExampleDoc(
        title: 'Check the active default namespace',
        command: 'flutter_shadcn default',
        description: 'Prints the current default registry namespace.',
      ),
      CliExampleDoc(
        title: 'Switch the default namespace',
        command: 'flutter_shadcn default shadcn',
        description:
            'Updates .shadcn/config.json so future commands resolve to the new namespace by default.',
      ),
    ],
    behavior: <String>[
      'This command is the safest way to change default namespace resolution across the whole project.',
    ],
    related: <String>['cli-registries', 'cli-overview'],
  ),
  'cli-docs': const CliReferenceDoc(
    id: 'cli-docs',
    title: 'docs',
    summary:
        'Regenerates generated command reference markdown under docs/reference/commands. This is an advanced maintainer command.',
    syntax: <String>[
      'flutter_shadcn --advanced docs',
      'flutter_shadcn docs --advanced --generate',
    ],
    options: <DocsOptionRow>[
      DocsOptionRow(
          name: '--generate, -g',
          value: 'flag',
          description:
              'Regenerate docs/reference/commands from Dart command metadata. This is the default action.'),
    ],
    behavior: <String>[
      'docs requires --advanced and writes the committed generated command reference.',
      'The generated markdown is protected by a stale-docs test so command metadata and reference pages stay synchronized.',
    ],
    related: <String>['cli-development'],
  ),
  'cli-feedback': const CliReferenceDoc(
    id: 'cli-feedback',
    title: 'feedback',
    summary:
        'Submits feedback, bug reports, feature requests, documentation issues, questions, or performance reports.',
    syntax: <String>[
      'flutter_shadcn feedback',
      'flutter_shadcn feedback --type bug --title "Button issue" --body "Describe the issue"',
      'flutter_shadcn feedback @shadcn',
    ],
    options: <DocsOptionRow>[
      DocsOptionRow(
          name: '--type, -t',
          value: 'type',
          description:
              'Feedback type: bug, feature, docs, question, performance, or other.'),
      DocsOptionRow(
          name: '--title',
          value: 'text',
          description: 'Issue title for non-interactive feedback.'),
      DocsOptionRow(
          name: '--body',
          value: 'text',
          description: 'Issue body for non-interactive feedback.'),
      DocsOptionRow(
          name: '@namespace',
          value: 'token',
          description:
              'Optional registry context to include with the feedback report.'),
    ],
    examples: <CliExampleDoc>[
      CliExampleDoc(
        title: 'Open the interactive feedback flow',
        command: 'flutter_shadcn feedback',
        description: 'Prompts for feedback type, title, and details.',
      ),
      CliExampleDoc(
        title: 'Submit a bug report with registry context',
        command:
            'flutter_shadcn feedback @shadcn --type bug --title "Button issue" --body "Describe the issue"',
        description:
            'Includes shadcn registry context with the submitted feedback.',
      ),
    ],
    behavior: <String>[
      'feedback is public and does not require --advanced.',
      'When GitHub CLI is available and authenticated, the command can create an issue directly; otherwise it falls back to browser-based submission.',
    ],
    related: <String>['cli-doctor', 'cli-version'],
  ),
  'cli-install-skill': const CliReferenceDoc(
    id: 'cli-install-skill',
    title: 'install-skill',
    summary:
        'Installs AI skill files for local model workflows. This is an advanced command.',
    syntax: <String>[
      'flutter_shadcn --advanced install-skill --available',
      'flutter_shadcn --advanced install-skill --list',
      'flutter_shadcn --advanced install-skill --skill flutter-shadcn-ui --model claude',
    ],
    options: <DocsOptionRow>[
      DocsOptionRow(
          name: '--available, -a',
          value: 'flag',
          description: 'List skills available from the skill registry.'),
      DocsOptionRow(
          name: '--list',
          value: 'flag',
          description: 'List locally installed skills.'),
      DocsOptionRow(
          name: '--skill, -s',
          value: 'id',
          description: 'Select a skill to install.'),
      DocsOptionRow(
          name: '--model, -m',
          value: 'name',
          description: 'Select the target model folder.'),
      DocsOptionRow(
          name: '--skills-url',
          value: 'url-or-path',
          description: 'Override the skill registry source.'),
      DocsOptionRow(
          name: '--symlink',
          value: 'flag',
          description: 'Symlink a shared skill into a target model folder.'),
      DocsOptionRow(
          name: '--uninstall',
          value: 'id',
          description:
              'Uninstall a skill. Use --model for single-model removal.'),
      DocsOptionRow(
          name: '--uninstall-interactive',
          value: 'flag',
          description: 'Choose skills and models interactively for removal.'),
      DocsOptionRow(
          name: '--interactive, -i',
          value: 'flag',
          description: 'Run interactive multi-skill installation.'),
    ],
    examples: <CliExampleDoc>[
      CliExampleDoc(
        title: 'List available skills',
        command: 'flutter_shadcn --advanced install-skill --available',
        description:
            'Shows skills that can be installed for local model tools.',
      ),
      CliExampleDoc(
        title: 'Install one skill for one model',
        command:
            'flutter_shadcn --advanced install-skill --skill flutter-shadcn-ui --model claude',
        description:
            'Copies the selected skill into the requested model folder.',
      ),
    ],
    behavior: <String>[
      'install-skill requires --advanced so the default CLI remains focused on component workflows.',
      'The command is intended for local model tooling and maintainer workflows.',
    ],
    related: <String>['cli-docs', 'cli-development'],
  ),
  'cli-version': const CliReferenceDoc(
    id: 'cli-version',
    title: 'version',
    summary:
        'Prints the installed flutter_shadcn_cli version and can check pub.dev for updates.',
    syntax: <String>[
      'flutter_shadcn version',
      'flutter_shadcn version --check',
    ],
    options: <DocsOptionRow>[
      DocsOptionRow(
          name: '--check',
          value: 'flag',
          description: 'Check whether a newer CLI version is available.'),
    ],
    related: <String>['cli-upgrade'],
  ),
  'cli-upgrade': const CliReferenceDoc(
    id: 'cli-upgrade',
    title: 'upgrade',
    summary:
        'Upgrades flutter_shadcn_cli to the latest version published on pub.dev.',
    syntax: <String>[
      'flutter_shadcn upgrade',
      'flutter_shadcn upgrade --force',
    ],
    options: <DocsOptionRow>[
      DocsOptionRow(
          name: '--force, -f',
          value: 'flag',
          description:
              'Force the upgrade even when the current version already appears up to date.'),
    ],
    related: <String>['cli-version', 'cli-troubleshooting'],
  ),
  'cli-exit-codes': const CliReferenceDoc(
    id: 'cli-exit-codes',
    title: 'Exit Codes',
    summary:
        'flutter_shadcn returns 0 for success and a documented non-zero process exit code for command failures. JSON-capable commands also expose the same number in meta.exitCode and use the matching label as the machine-readable error code when available.',
    examples: <CliExampleDoc>[
      CliExampleDoc(
        title: 'Read the exit code in a shell',
        command: 'flutter_shadcn doctor\necho \$?',
        description:
            'Use the numeric process status in CI or shell scripts after any flutter_shadcn command.',
      ),
      CliExampleDoc(
        title: 'Read the exit code from JSON',
        command: 'flutter_shadcn validate --json',
        description:
            'JSON output includes meta.exitCode and error labels such as schema_invalid or validation_failed.',
      ),
    ],
    behavior: <String>[
      '0 success: the command completed without a blocking error.',
      '1 unknown_error: an unexpected failure was reported outside a more specific category. Re-run with --verbose and report the command/output if it repeats.',
      '2 usage_error: command syntax or option usage is invalid, such as missing arguments, incompatible flags, or advanced-only options without --advanced.',
      '10 registry_not_found: the selected namespace, configured registry, registry path, or registry directory entry could not be resolved.',
      '20 schema_invalid: registries.json, a component manifest, an index, a theme payload, or local registry metadata failed schema validation.',
      '30 component_missing: the requested component could not be found or resolved from the active registry selection.',
      '31 file_missing: a required registry file, manifest-referenced file, installed file, or generated project file is missing.',
      '40 network_error: the CLI needed online registry, theme, or version data and the network fetch failed.',
      '41 offline_unavailable: --offline was requested but the required cached registry or theme data is not available yet.',
      '50 validation_failed: diagnostics found project, registry, dependency, installed-file, or theme drift that must be repaired.',
      '60 config_invalid: .shadcn/config.json, .shadcn/state.json, platform target config, locale config, or Flutter project setup is invalid.',
      '70 io_error: a required read, write, copy, open, launch, activation, or filesystem safety operation failed.',
    ],
    related: <String>[
      'cli-doctor',
      'cli-validate',
      'cli-audit',
      'cli-troubleshooting',
    ],
  ),
  'cli-troubleshooting': const CliReferenceDoc(
    id: 'cli-troubleshooting',
    title: 'Troubleshooting',
    summary:
        'Use this page when installs, theme application, or registry resolution do not behave as expected.',
    examples: <CliExampleDoc>[
      CliExampleDoc(
        title: 'Check project and registry state',
        command: 'flutter_shadcn doctor\nflutter_shadcn audit',
        description:
            'doctor catches registry/config issues; audit shows drift between installed files and the registry.',
      ),
      CliExampleDoc(
        title: 'Validate a local registry before blaming the installer',
        command:
            'flutter_shadcn --advanced --registry-path /absolute/path/to/registry validate',
        description:
            'Make sure the registry itself is valid before debugging install behavior.',
      ),
    ],
    behavior: <String>[
      'If flutter_shadcn is not found, confirm that your pub cache bin directory is on PATH.',
      'If a namespace is missing, run flutter_shadcn registries and check the configured default with flutter_shadcn default.',
      'If widget theming fails, verify that the selected registry exposes a theme converter and that the installed component actually provides widget theme files.',
      'If global theme apply-file or apply-url fails, make sure you passed --advanced and that the payload is valid JSON.',
      'If offline mode fails, rerun once online to warm the registry/theme caches first.',
      'If a patch anchor is missing, the converter or installed files have drifted. Re-run sync, then audit, then inspect the registry converter output.',
      'If a script or CI job fails, check the process exit code. The Exit Codes page maps every numeric value to its label, meaning, and recovery path.',
    ],
    related: <String>[
      'cli-doctor',
      'cli-validate',
      'cli-audit',
      'cli-exit-codes',
      'cli-theme-widget'
    ],
  ),
  'cli-development': const CliReferenceDoc(
    id: 'cli-development',
    title: 'Development Workflow',
    summary:
        'This is the maintainer workflow for local registry iteration, namespace-aware testing, and theme converter development.',
    examples: <CliExampleDoc>[
      CliExampleDoc(
        title: 'Test against a local registry clone',
        command:
            'flutter_shadcn --advanced --registry-path /absolute/path/to/registry validate\nflutter_shadcn --advanced --registry-path /absolute/path/to/registry list',
        description:
            'Validate and browse a local registry before using it for installs.',
      ),
      CliExampleDoc(
        title: 'Exercise converter-driven theme flows',
        command:
            'flutter_shadcn theme @shadcn --list\nflutter_shadcn --advanced theme @shadcn --apply-file ./theme.json\nflutter_shadcn --advanced theme widget @shadcn button --apply-url https://registry.dev/widget-theme/button.json',
        description:
            'Use the same CLI surface your users will run while keeping all theme semantics inside the registry converter.',
      ),
      CliExampleDoc(
        title: 'Regenerate command docs for the CLI workspace',
        command: 'flutter_shadcn --advanced docs --generate',
        description:
            'Refreshes generated markdown under docs/reference/commands.',
      ),
    ],
    behavior: <String>[
      'Prefer validate before add, and doctor plus audit after large registry refactors.',
      'Namespace-aware testing matters: a command that succeeds in the default namespace can still fail in a secondary registry because install roots and converter behavior differ.',
      'Global theme presets should stay index-driven, while widget theming should remain converter-owned and payload-driven.',
      'When developing theme converters, keep network fetches in the CLI and hand the converter cached local payload files plus project context.',
      'Developer registry overrides, generated docs, install-skill, and file/URL theme imports all require --advanced.',
    ],
    related: <String>[
      'cli-theme',
      'cli-theme-widget',
      'cli-validate',
      'cli-docs',
      'cli-install-skill'
    ],
  ),
};

const List<String> cliReferenceOrder = <String>[
  'cli-overview',
  'cli-init',
  'cli-add',
  'cli-remove',
  'cli-theme',
  'cli-theme-widget',
  'cli-assets',
  'cli-sync',
  'cli-dry-run',
  'cli-list',
  'cli-search',
  'cli-info',
  'cli-platform',
  'cli-registries',
  'cli-default',
  'cli-doctor',
  'cli-validate',
  'cli-audit',
  'cli-deps',
  'cli-feedback',
  'cli-docs',
  'cli-install-skill',
  'cli-version',
  'cli-upgrade',
  'cli-exit-codes',
  'cli-troubleshooting',
  'cli-development',
];

const List<CliReferenceSection> cliReferenceSections = <CliReferenceSection>[
  CliReferenceSection(
    title: 'Getting Started',
    pageIds: <String>[
      'cli-overview',
      'cli-init',
      'cli-add',
      'cli-remove',
      'cli-sync',
      'cli-dry-run',
    ],
  ),
  CliReferenceSection(
    title: 'Discovery',
    pageIds: <String>[
      'cli-list',
      'cli-search',
      'cli-info',
    ],
  ),
  CliReferenceSection(
    title: 'Themes & Assets',
    pageIds: <String>[
      'cli-theme',
      'cli-theme-widget',
      'cli-assets',
    ],
  ),
  CliReferenceSection(
    title: 'Registry & Config',
    pageIds: <String>[
      'cli-registries',
      'cli-default',
      'cli-platform',
    ],
  ),
  CliReferenceSection(
    title: 'Diagnostics',
    pageIds: <String>[
      'cli-doctor',
      'cli-validate',
      'cli-audit',
      'cli-deps',
      'cli-exit-codes',
    ],
  ),
  CliReferenceSection(
    title: 'Tooling',
    pageIds: <String>[
      'cli-feedback',
      'cli-version',
      'cli-upgrade',
    ],
  ),
  CliReferenceSection(
    title: 'Advanced',
    pageIds: <String>[
      'cli-docs',
      'cli-install-skill',
    ],
  ),
  CliReferenceSection(
    title: 'Guides',
    pageIds: <String>[
      'cli-troubleshooting',
      'cli-development',
    ],
  ),
];
