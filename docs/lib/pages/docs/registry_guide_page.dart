import 'package:flutter/material.dart';

import '../docs_page.dart';
import 'blocks.dart';
import '../../ui/shadcn/shared/primitives/text.dart';

class RegistryGuidePage extends StatelessWidget {
  const RegistryGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final OnThisPage overviewKey = OnThisPage();
    final OnThisPage structureKey = OnThisPage();
    final OnThisPage manifestKey = OnThisPage();
    final OnThisPage componentKey = OnThisPage();
    final OnThisPage sharedKey = OnThisPage();
    final OnThisPage publishKey = OnThisPage();

    return DocsPage(
      name: 'registry-guide',
      onThisPage: {
        'Overview': overviewKey,
        'Folder structure': structureKey,
        'Registry manifest': manifestKey,
        'Component shape': componentKey,
        'Shared files': sharedKey,
        'Publishing': publishKey,
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Registry Guide').h1(),
          const SizedBox(height: 12),
          const DocsParagraph(
            text:
                'This guide shows how to structure a third-party UI library so flutter_shadcn_cli can install it. The CLI expects a registry folder with a manifest (components.json), shared files, and a predictable component layout.',
          ),
          DocsSectionTitle(title: 'Overview', anchor: overviewKey),
          const SizedBox(height: 12),
          const DocsParagraph(
            text:
                'A registry is just a folder tree plus a manifest file that describes every component, its dependencies, and the files to copy. The CLI reads the manifest, copies files into the consumer project, and wires dependencies and assets.',
          ),
          const DocsBulletList(
            items: [
              'Registry root contains components.json and components.schema.json.',
              'Each component lives under components/<category>/<name>.',
              'Shared helpers live under shared/ and are pulled in via the manifest.',
              'Optional preview.dart and README.md files can be shipped for docs tooling.',
            ],
          ),
          const SizedBox(height: 20),
          DocsSectionTitle(title: 'Folder structure', anchor: structureKey),
          const SizedBox(height: 12),
          const DocsParagraph(
            text:
                'Match the folder layout below. In this repo, the registry lives under flutter_shadcn_kit/lib/registry.',
          ),
          const DocsCodeBlock(
            code:
                'flutter_shadcn_kit/lib/registry/\n  components.json\n  components.schema.json\n  shared/\n    primitives/\n    theme/\n    utils/\n  components/\n    display/\n      avatar/\n        avatar.dart\n        meta.json\n        README.md\n        preview.dart\n        _impl/\n          avatar_controller.dart\n    form/\n      text_field/\n        text_field.dart\n        meta.json\n        README.md\n        _impl/\n          input_features.dart\n  composites/\n    ...',
            mode: 'text',
          ),
          const SizedBox(height: 20),
          DocsSectionTitle(title: 'Registry manifest', anchor: manifestKey),
          const SizedBox(height: 12),
          const DocsParagraph(
            text:
                'components.json is the source of truth. It declares defaults, shared file mappings, and every component entry. The CLI validates it against components.schema.json.',
          ),
          const DocsCodeBlock(
            code: '{\n  "schemaVersion": 1,\n  "name": "my_registry",\n  "flutter": {"minSdk": ">=3.3.0"},\n  "defaults": {\n    "installPath": "lib/ui/shadcn",\n    "sharedPath": "lib/ui/shadcn/shared"\n  },\n  "shared": [\n    {\n      "id": "theme",\n      "description": "Core theme data.",\n      "files": [\n        {\n          "source": "registry/shared/theme/theme.dart",\n          "destination": "{sharedPath}/theme/theme.dart"\n        }\n      ]\n    }\n  ],\n  "components": [\n    {\n      "id": "avatar",\n      "name": "Avatar",\n      "description": "Circular avatar display.",\n      "category": "display",\n      "files": [\n        {\n          "source": "registry/components/display/avatar/avatar.dart",\n          "destination": "{installPath}/components/display/avatar/avatar.dart"\n        }\n      ],\n      "shared": ["theme"],\n      "dependsOn": [],\n      "pubspec": {"dependencies": {}},\n      "assets": [],\n      "postInstall": []\n    }\n  ]\n}',
            mode: 'json',
          ),
          const SizedBox(height: 12),
          const DocsParagraph(
            text:
                'If your registry lives under flutter_shadcn_kit/lib/registry, the manifest source paths should start with that prefix (for example flutter_shadcn_kit/lib/registry/components/...).',
          ),
          const SizedBox(height: 20),
          DocsSectionTitle(title: 'Component shape', anchor: componentKey),
          const SizedBox(height: 12),
          const DocsParagraph(
            text:
                'Every component should include a meta.json file describing its ID, name, category, and dependencies. The CLI uses this to build the catalog and to resolve shared helpers.',
          ),
          const DocsCodeBlock(
            code: '{\n  "id": "feature_carousel",\n  "name": "Feature Carousel",\n  "description": "Animated feature card carousel.",\n  "category": "display",\n  "tags": ["display", "carousel"],\n  "dependencies": {\n    "pubspec": {},\n    "shared": ["theme"],\n    "components": []\n  }\n}',
            mode: 'json',
          ),
          const DocsParagraph(
            text:
                'The main Dart file should match the component ID, and any helper classes go under _impl/. Use README.md for human docs and preview.dart for gallery previews.',
          ),
          const SizedBox(height: 20),
          DocsSectionTitle(title: 'Shared files', anchor: sharedKey),
          const SizedBox(height: 12),
          const DocsParagraph(
            text:
                'Shared helpers are declared once under shared[] in components.json and referenced by each component entry. This keeps installs lean and avoids duplicating primitives.',
          ),
          const DocsBulletList(
            items: [
              'Declare shared file mappings with source/destination entries.',
              'Reference shared IDs in component.shared.',
              'Keep shared files stable to avoid breaking downstream installs.',
            ],
          ),
          const SizedBox(height: 20),
          DocsSectionTitle(title: 'Publishing', anchor: publishKey),
          const SizedBox(height: 12),
          const DocsParagraph(
            text:
                'Host the registry folder in a public repo or CDN. Point flutter_shadcn_cli to that base URL or a local path during development.',
          ),
          const DocsCodeBlock(
            code:
                'flutter_shadcn add button --registry remote --registry-url https://raw.githubusercontent.com/mibrar-dev/shadcn_flutter_kit/main/flutter_shadcn_kit/lib/registry',
            mode: 'bash',
          ),
          const SizedBox(height: 12),
          const DocsParagraph(
            text:
                'For local development, pass a registry path on disk so the CLI can copy files directly.',
          ),
          const DocsCodeBlock(
            code:
                'flutter_shadcn add button --registry local --registry-path /absolute/path/to/registry',
            mode: 'bash',
          ),
        ],
      ),
    );
  }
}
