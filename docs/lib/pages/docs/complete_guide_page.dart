import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../docs_page.dart';
import '../../ui/shadcn/shared/primitives/text.dart';
import 'blocks.dart';

class CompleteGuidePage extends StatelessWidget {
  const CompleteGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final overviewKey = OnThisPage();
    final installKey = OnThisPage();
    final firstRunKey = OnThisPage();
    final dailyKey = OnThisPage();
    final commandsKey = OnThisPage();
    final themingKey = OnThisPage();
    final registriesKey = OnThisPage();
    final ciKey = OnThisPage();
    final troubleshootKey = OnThisPage();

    return DocsPage(
      name: 'complete-guide',
      onThisPage: {
        'Overview': overviewKey,
        'Install': installKey,
        'First run': firstRunKey,
        'Daily workflow': dailyKey,
        'Commands': commandsKey,
        'Themes and assets': themingKey,
        'Registries': registriesKey,
        'CI and QA': ciKey,
        'Troubleshooting': troubleshootKey,
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageItemWidget(
            onThisPage: overviewKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Complete User Guide').h1(),
                const SizedBox(height: 12),
                const DocsParagraph(
                  text:
                      'This guide covers the full flutter_shadcn workflow from installation through production QA. The CLI copies registry-owned Flutter components into your app, records what it installed under .shadcn, and keeps dependency, theme, asset, and diagnostic workflows in one place.',
                ),
                const DocsCodeBlock(
                  code:
                      'dart pub global activate flutter_shadcn_cli\nflutter_shadcn init --yes\nflutter_shadcn add button file_picker gooey_toast\nflutter analyze\nflutter build web',
                  mode: 'bash',
                ),
                const DocsLinkCard(
                  icon: Icons.picture_as_pdf,
                  title: 'Download PDF guide',
                  description:
                      'A complete install, command, troubleshooting, and production QA guide for offline use.',
                  url: 'flutter_shadcn_complete_user_guide.pdf',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          DocsSectionTitle(title: 'Install', anchor: installKey),
          const SizedBox(height: 12),
          const DocsParagraph(
            text:
                'Install the CLI globally with Dart. The executable is named flutter_shadcn; the package also exposes the shorter shadcn alias when your shell can find pub global executables.',
          ),
          const DocsCodeBlock(
            code:
                'dart pub global activate flutter_shadcn_cli\nflutter_shadcn version\nflutter_shadcn --help',
            mode: 'bash',
          ),
          const DocsParagraph(
            text:
                'If the command is not found, add the Dart pub cache bin directory to PATH and restart your shell.',
          ),
          const DocsCodeBlock(
            code:
                'export PATH="\$PATH:\$HOME/.pub-cache/bin"\n# zsh users usually add that line to ~/.zshrc\n# bash users usually add it to ~/.bashrc or ~/.bash_profile',
            mode: 'bash',
          ),
          const SizedBox(height: 20),
          DocsSectionTitle(title: 'First run', anchor: firstRunKey),
          const SizedBox(height: 12),
          const DocsParagraph(
            text:
                'Run init from the root of a Flutter project. It creates .shadcn/config.json and .shadcn/state.json, then runs the registry bootstrap actions for shared primitives, theme files, localization helpers, and required dependencies.',
          ),
          const DocsCodeBlock(
            code:
                'flutter create my_app\ncd my_app\nflutter_shadcn init --yes\nflutter_shadcn add button\nflutter pub get\nflutter analyze',
            mode: 'bash',
          ),
          const DocsParagraph(
            text:
                'Use namespace-qualified component addresses when you have more than one registry enabled or want to be explicit.',
          ),
          const DocsCodeBlock(
            code:
                'flutter_shadcn add @shadcn/button\nflutter_shadcn add @shadcn/file_picker @shadcn/gooey_toast',
            mode: 'bash',
          ),
          TextButton(
            onPressed: () => context.goNamed(
              'cli_reference',
              pathParameters: {'id': 'cli-add'},
            ),
            child: const Text('Open the add command reference'),
          ),
          TextButton(
            onPressed: () => context.goNamed(
              'cli_reference',
              pathParameters: {'id': 'cli-app-setup'},
            ),
            child: const Text('Open required ShadcnApp and overlay setup'),
          ),
          const SizedBox(height: 20),
          DocsSectionTitle(title: 'Daily workflow', anchor: dailyKey),
          const SizedBox(height: 12),
          const DocsBulletList(
            items: [
              'Discover components with list, search, and info before adding code.',
              'Preview broad changes with dry-run before installing a large batch.',
              'Install components in small groups so diffs stay reviewable.',
              'Run doctor after init or whenever registry resolution looks wrong.',
              'Run audit and deps before release to catch drift between your app and the registry.',
              'Commit .shadcn files and installed component files with your app source.',
            ],
          ),
          const DocsCodeBlock(
            code:
                'flutter_shadcn list\nflutter_shadcn search toast\nflutter_shadcn info gooey_toast\nflutter_shadcn dry-run button dialog\nflutter_shadcn add button dialog\nflutter_shadcn doctor\nflutter_shadcn audit\nflutter_shadcn deps',
            mode: 'bash',
          ),
          const SizedBox(height: 20),
          DocsSectionTitle(title: 'Commands', anchor: commandsKey),
          const SizedBox(height: 12),
          const DocsOptionsTable(
            rows: [
              DocsOptionRow(
                name: 'init',
                value: 'project setup',
                description:
                    'Initializes .shadcn config/state and runs registry bootstrap actions.',
              ),
              DocsOptionRow(
                name: 'add',
                value: 'components',
                description:
                    'Installs one or more components, shared files, assets, and pubspec dependencies.',
              ),
              DocsOptionRow(
                name: 'remove / rm',
                value: 'components',
                description:
                    'Removes installed component files and protects dependencies unless --force is used.',
              ),
              DocsOptionRow(
                name: 'dry-run',
                value: 'preview',
                description:
                    'Shows what an install would write without changing files.',
              ),
              DocsOptionRow(
                name: 'list / ls',
                value: 'catalog',
                description:
                    'Lists available components in the selected registry.',
              ),
              DocsOptionRow(
                name: 'search',
                value: 'catalog',
                description:
                    'Searches component names, descriptions, and tags.',
              ),
              DocsOptionRow(
                name: 'info / i',
                value: 'catalog',
                description:
                    'Shows details for a component, including install command and dependencies.',
              ),
              DocsOptionRow(
                name: 'registries',
                value: 'registry',
                description:
                    'Lists available and configured registries, including namespace and source mode.',
              ),
              DocsOptionRow(
                name: 'default',
                value: 'registry',
                description: 'Shows or changes the default registry namespace.',
              ),
              DocsOptionRow(
                name: 'sync',
                value: 'project',
                description:
                    'Synchronizes paths and theme files from .shadcn/config.json.',
              ),
              DocsOptionRow(
                name: 'project',
                value: 'project',
                description:
                    'Runs project repair and cleanup subcommands such as reset, undo, and refresh.',
              ),
              DocsOptionRow(
                name: 'assets',
                value: 'assets',
                description: 'Installs registry-managed font and icon assets.',
              ),
              DocsOptionRow(
                name: 'theme',
                value: 'theme',
                description: 'Lists and applies registry theme presets.',
              ),
              DocsOptionRow(
                name: 'platform',
                value: 'config',
                description:
                    'Lists or overrides platform target files used by registry actions.',
              ),
              DocsOptionRow(
                name: 'doctor',
                value: 'diagnostics',
                description:
                    'Prints registry, config, schema, path, and project health information.',
              ),
              DocsOptionRow(
                name: 'validate',
                value: 'diagnostics',
                description:
                    'Validates registry metadata, schemas, and referenced files.',
              ),
              DocsOptionRow(
                name: 'audit',
                value: 'diagnostics',
                description:
                    'Compares installed components with current registry metadata.',
              ),
              DocsOptionRow(
                name: 'deps',
                value: 'diagnostics',
                description:
                    'Compares registry dependency requirements with pubspec.yaml.',
              ),
              DocsOptionRow(
                name: 'feedback',
                value: 'tooling',
                description:
                    'Starts a guided issue, docs, bug, or feature feedback flow.',
              ),
              DocsOptionRow(
                name: 'version',
                value: 'tooling',
                description:
                    'Shows the installed CLI version and can check for updates.',
              ),
              DocsOptionRow(
                name: 'upgrade',
                value: 'tooling',
                description:
                    'Upgrades the globally activated CLI from pub.dev.',
              ),
            ],
          ),
          const SizedBox(height: 12),
          const DocsParagraph(
            text:
                'Global flags: --verbose prints extra detail, --offline disables network calls, --registry-name selects a namespace, and --advanced enables developer registry overrides plus experimental tooling.',
          ),
          const DocsCodeBlock(
            code:
                'flutter_shadcn --verbose add button\nflutter_shadcn --offline list\nflutter_shadcn --registry-name shadcn validate\nflutter_shadcn --advanced --help',
            mode: 'bash',
          ),
          const SizedBox(height: 20),
          DocsSectionTitle(title: 'Themes and assets', anchor: themingKey),
          const SizedBox(height: 12),
          const DocsParagraph(
            text:
                'Themes are registry-owned presets. The CLI lists available presets and applies generated theme artifacts to your project. Assets are installed through registry bootstrap actions so fonts and icon files are copied to the right location and recorded in project state.',
          ),
          const DocsCodeBlock(
            code:
                'flutter_shadcn theme --list\nflutter_shadcn theme --apply amber-minimal\nflutter_shadcn assets --all\nflutter_shadcn assets --icons\nflutter_shadcn assets --fonts',
            mode: 'bash',
          ),
          const SizedBox(height: 20),
          DocsSectionTitle(title: 'Registries', anchor: registriesKey),
          const SizedBox(height: 12),
          const DocsParagraph(
            text:
                'A registry is a folder or remote repository that publishes components.json, optional theme indexes, shared files, and component source files. The default public registry is resolved from the live registry directory, so most users do not need custom registry flags.',
          ),
          const DocsCodeBlock(
            code:
                'flutter_shadcn registries\nflutter_shadcn registries --json\nflutter_shadcn default\nflutter_shadcn default shadcn',
            mode: 'bash',
          ),
          const DocsParagraph(
            text:
                'Local registry development is advanced mode. Use it only when authoring or testing a registry before publishing.',
          ),
          const DocsCodeBlock(
            code:
                'flutter_shadcn --advanced --registry-path /absolute/path/to/registry list\nflutter_shadcn --advanced --registries-path /absolute/path/to/registries.json registries\nflutter_shadcn --advanced --skip-integrity add button',
            mode: 'bash',
          ),
          const SizedBox(height: 20),
          DocsSectionTitle(title: 'CI and QA', anchor: ciKey),
          const SizedBox(height: 12),
          const DocsParagraph(
            text:
                'For production checks, run the CLI diagnostics and Flutter verification commands in the same app where components are installed.',
          ),
          const DocsCodeBlock(
            code:
                'flutter_shadcn validate\nflutter_shadcn audit\nflutter_shadcn deps\nflutter analyze\nflutter test\nflutter build web',
            mode: 'bash',
          ),
          const DocsParagraph(
            text:
                'For machine-readable automation, use --json on read-only commands such as registries, list, search, info, dry-run, validate, audit, deps, and doctor.',
          ),
          const DocsCodeBlock(
            code:
                'flutter_shadcn registries --json\nflutter_shadcn dry-run button dialog --json\nflutter_shadcn doctor --json',
            mode: 'bash',
          ),
          const SizedBox(height: 20),
          DocsSectionTitle(title: 'Troubleshooting', anchor: troubleshootKey),
          const SizedBox(height: 12),
          const DocsBulletList(
            items: [
              'Command not found: add the Dart pub cache bin directory to PATH and reopen the terminal.',
              'Component name is ambiguous: use @namespace/component or --registry-name namespace.',
              'Network or registry fetch failed: rerun with --verbose, check registries, or use --offline only after a cache exists.',
              'Analyzer errors after install: run flutter pub get, then doctor, audit, and deps to confirm generated files and dependencies are in sync.',
              'Need to recover project state: use project reset with a snapshot, then project undo if the reset was accidental.',
            ],
          ),
          const DocsCodeBlock(
            code:
                'flutter_shadcn doctor\nflutter_shadcn audit --json\nflutter_shadcn deps --json\nflutter_shadcn project reset\nflutter_shadcn project undo',
            mode: 'bash',
          ),
        ],
      ),
    );
  }
}
