import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../docs_page.dart';
import 'blocks.dart';
import '../../ui/shadcn/shared/primitives/text.dart';

class InstallationPage extends StatelessWidget {
  const InstallationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final OnThisPage cliKey = OnThisPage();
    final OnThisPage initKey = OnThisPage();
    final OnThisPage addKey = OnThisPage();
    final OnThisPage assetsKey = OnThisPage();
    final OnThisPage registryKey = OnThisPage();
    return DocsPage(
      name: 'installation',
      onThisPage: {
        'CLI setup': cliKey,
        'Initialize a project': initKey,
        'Add components': addKey,
        'Install assets': assetsKey,
        'Registry modes': registryKey,
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Installation').h1(),
          const SizedBox(height: 12),
          const DocsParagraph(
            text:
                'The docs app is powered by registry components installed through the flutter_shadcn CLI. Use the CLI to copy widgets and shared helpers into your Flutter project with dependency-aware installs.',
          ),
          TextButton(
            onPressed: () => context.goNamed(
              'cli_reference',
              pathParameters: {'id': 'cli-overview'},
            ),
            child: const Text('Open the full CLI command guide'),
          ),
          TextButton(
            onPressed: () => context.goNamed('complete-guide'),
            child: const Text('Open the complete A-Z user guide'),
          ),
          const SizedBox(height: 12),
          DocsSectionTitle(title: 'CLI setup', anchor: cliKey),
          const SizedBox(height: 12),
          const DocsParagraph(
            text:
                'Install the CLI globally from pub.dev and make sure your pub cache bin directory is on PATH.',
          ),
          const DocsCodeBlock(
            code: 'dart pub global activate flutter_shadcn_cli',
            mode: 'bash',
          ),
          const SizedBox(height: 12),
          const DocsParagraph(
            text:
                'Add the pub cache bin directory to your PATH if needed. The CLI also provides a short alias: `shadcn`.',
          ),
          const DocsCodeBlock(code: r'$HOME/.pub-cache/bin', mode: 'bash'),
          const SizedBox(height: 12),
          const DocsCodeBlock(code: 'flutter_shadcn --help', mode: 'bash'),
          const SizedBox(height: 20),
          DocsSectionTitle(title: 'Initialize a project', anchor: initKey),
          const SizedBox(height: 12),
          const DocsParagraph(
            text:
                'Initialize the registry install path and shared assets. The docs app uses `lib/ui/shadcn`.',
          ),
          const DocsCodeBlock(
            code:
                'flutter_shadcn init --install-path ui/shadcn --shared-path ui/shadcn/shared',
            mode: 'bash',
          ),
          const SizedBox(height: 12),
          const DocsParagraph(text: 'Skip prompts and use defaults:'),
          const DocsCodeBlock(code: 'flutter_shadcn init --yes', mode: 'bash'),
          const SizedBox(height: 12),
          const DocsParagraph(
            text: 'Install typography + icon assets during init:',
          ),
          const DocsCodeBlock(
            code: 'flutter_shadcn init --install-fonts --install-icons',
            mode: 'bash',
          ),
          const SizedBox(height: 12),
          const DocsParagraph(
            text: 'Non-interactive setup with explicit options:',
          ),
          const DocsCodeBlock(
            code:
                'flutter_shadcn init --yes --install-path ui/shadcn --shared-path ui/shadcn/shared --include-meta --include-readme=false --include-preview=false --theme modern-minimal',
            mode: 'bash',
          ),
          const SizedBox(height: 12),
          const DocsParagraph(
            text:
                'One-line setup: initialize and install components in the same command.',
          ),
          const DocsCodeBlock(
            code: 'flutter_shadcn init button dialog',
            mode: 'bash',
          ),
          const SizedBox(height: 20),
          DocsSectionTitle(title: 'Add components', anchor: addKey),
          const SizedBox(height: 12),
          const DocsParagraph(
            text:
                'Install components in batches. Each component pulls shared primitives when needed.',
          ),
          const DocsCodeBlock(
            code: 'flutter_shadcn add button badge accordion breadcrumb',
            mode: 'bash',
          ),
          const SizedBox(height: 12),
          const DocsParagraph(
            text: 'Namespace install from a specific registry:',
          ),
          const DocsCodeBlock(
            code: 'flutter_shadcn add @shadcn/button',
            mode: 'bash',
          ),
          const SizedBox(height: 12),
          const DocsParagraph(text: 'Add multiple components at once:'),
          const DocsCodeBlock(
            code: 'flutter_shadcn add command dialog',
            mode: 'bash',
          ),
          const SizedBox(height: 12),
          const DocsParagraph(
            text: 'Install all components from the active registry:',
          ),
          const DocsCodeBlock(code: 'flutter_shadcn add --all', mode: 'bash'),
          const SizedBox(height: 12),
          const DocsParagraph(text: 'Control optional files during install:'),
          const DocsCodeBlock(
            code: 'flutter_shadcn add @shadcn/button --include-files=preview',
            mode: 'bash',
          ),
          const SizedBox(height: 12),
          const DocsCodeBlock(
            code:
                'flutter_shadcn add @shadcn/button --exclude-files=readme,meta',
            mode: 'bash',
          ),
          const SizedBox(height: 12),
          const DocsParagraph(text: 'Remove a component:'),
          const DocsCodeBlock(
            code: 'flutter_shadcn remove button',
            mode: 'bash',
          ),
          const SizedBox(height: 20),
          DocsSectionTitle(title: 'Install assets', anchor: assetsKey),
          const SizedBox(height: 12),
          const DocsParagraph(
            text:
                'Install icon and typography assets on demand, or install everything in one command.',
          ),
          const SizedBox(height: 12),
          const DocsCodeBlock(
            code: 'flutter_shadcn assets --all',
            mode: 'bash',
          ),
          const SizedBox(height: 12),
          const DocsCodeBlock(
            code: 'flutter_shadcn assets --icons',
            mode: 'bash',
          ),
          const SizedBox(height: 12),
          const DocsCodeBlock(
            code: 'flutter_shadcn assets --fonts',
            mode: 'bash',
          ),
          const SizedBox(height: 20),
          DocsSectionTitle(title: 'Registry modes', anchor: registryKey),
          const SizedBox(height: 12),
          const DocsParagraph(
            text:
                'Use local registry mode for development, or remote/CDN mode for production installs. You can also persist dev mode globally for your workspace.',
          ),
          const DocsCodeBlock(
            code:
                'flutter_shadcn add button --registry local --registry-path /absolute/path/to/registry',
            mode: 'bash',
          ),
          const SizedBox(height: 12),
          const DocsCodeBlock(
            code: 'flutter_shadcn add button --registry remote',
            mode: 'bash',
          ),
          const SizedBox(height: 12),
          const DocsCodeBlock(
            code:
                'flutter_shadcn add button --registry remote --registry-url https://cdn.jsdelivr.net/gh/ibrar-x/shadcn_flutter_kit@latest/flutter_shadcn_kit/lib',
            mode: 'bash',
          ),
          const SizedBox(height: 12),
          const DocsCodeBlock(
            code:
                'flutter_shadcn --dev --dev-path /absolute/path/to/registry init',
            mode: 'bash',
          ),
          const SizedBox(height: 12),
          const DocsCodeBlock(code: 'flutter_shadcn registries', mode: 'bash'),
        ],
      ),
    );
  }
}
